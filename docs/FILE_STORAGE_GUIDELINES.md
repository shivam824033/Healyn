# FILE_STORAGE_GUIDELINES.md

> How Healyn handles patient medical files: reports, MRIs, X-rays, prescriptions, exercise plans.
> Files are PHI. The rules below apply with no exceptions.

---

## 1. Supported Types & Limits

| MIME | Extension | Max size | Use cases |
|---|---|---|---|
| `application/pdf` | `.pdf` | 20 MB | Reports, prescriptions, lab results |
| `image/jpeg` | `.jpg` / `.jpeg` | 10 MB | Photos of reports, X-ray captures |
| `image/png` | `.png` | 10 MB | Screenshots, exercise plans |

Anything else is rejected at presign time. No `.docx`, no `.zip`, no `.heic`, no `.dcm` in Phase 1.

Per-message attachment cap: **10 files**. Per-day cap per account: **100 files**.

---

## 2. Storage Backend

- **S3-compatible object storage**: AWS S3 in prod, Cloudflare R2 or MinIO acceptable.
- **One bucket per environment**: `healyn-files-prod`, `healyn-files-staging`, `healyn-files-dev`.
- **Region**: same region as the database for latency and data-residency compliance.
- **Versioning**: enabled. Lifecycle rule retires non-current versions after 30 days.
- **Encryption at rest**: SSE-KMS with a customer-managed key. Key rotation annual.
- **Public access**: blocked at the account / bucket level. Public read is impossible by config.
- **Logging**: S3 access logs to a separate audit bucket.

---

## 3. Key Layout

Object keys follow a strict structure:

```
patients/{patient_id}/appointments/{appointment_id}/{file_id}.{ext}
patients/{patient_id}/standalone/{file_id}.{ext}        ← not used in Phase 1
```

| Segment | Notes |
|---|---|
| `patients/` | Fixed prefix; namespaces all patient-scoped files |
| `{patient_id}` | UUID, the owning patient |
| `appointments/{appointment_id}` | UUID, the appointment context |
| `{file_id}.{ext}` | UUID + canonical extension |

Why this layout?

- Patient deletion can be enacted by lifecycle rule on a prefix.
- Per-appointment exports (Phase 2) are trivial.
- Auditing by patient or appointment is by key prefix.

Filenames provided by users are **never** used as keys. The user's filename is stored in `file_objects.original_filename` only for display.

---

## 4. Upload Architecture (Presigned PUT)

```
Mobile                  API                       S3
  │                      │                         │
  │ 1. POST /files/presign                         │
  │    { mime, size, patient_id, kind }            │
  ├─────────────────────▶│                         │
  │                      │ validate inputs         │
  │                      │ requireAccess(WRITE)    │
  │                      │ INSERT file_objects     │
  │                      │   status=PENDING_UPLOAD │
  │                      │ sign PUT URL (TTL 5min) │
  │ 2. { file_id, url }  │                         │
  │◀─────────────────────┤                         │
  │                                                │
  │ 3. PUT bytes (Content-Type matches)            │
  ├───────────────────────────────────────────────▶│
  │◀───────────────────────────────────────────────┤
  │                                                │
  │ 4. (Validator promotes status async)           │
```

### 4.1 Presign Request

```json
POST /api/v1/files/presign
{
  "patient_id": "8a7b6c5d-...",
  "appointment_id": "3d2c1b0a-...",
  "kind": "REPORT",
  "mime_type": "application/pdf",
  "size_bytes": 1843204,
  "original_filename": "spine-mri-2026-05.pdf"
}
```

### 4.2 Presign Response

```json
{
  "data": {
    "file_id": "c1d2e3f4-...",
    "upload": {
      "method": "PUT",
      "url": "https://healyn-files-prod.s3.../patients/...?X-Amz-Signature=...",
      "headers": {
        "Content-Type": "application/pdf"
      },
      "expires_in_seconds": 300
    }
  }
}
```

The client must send the exact headers listed. Header mismatch causes the S3 PUT to fail.

### 4.3 Async Validation

After the client signals upload completion (or via S3 event), an async validator:

1. `HEAD` the object — confirm presence and size match.
2. Read the first 8 KB — verify **magic bytes** against the claimed MIME:
   - PDF: `%PDF-` at offset 0.
   - JPEG: `FF D8 FF` at offset 0.
   - PNG: `89 50 4E 47 0D 0A 1A 0A` at offset 0.
3. (When integrated) submit to ClamAV / vendor AV scan.
4. Compute SHA-256 of the bytes; store in `file_objects.sha256_hex`.
5. On pass → `status = AVAILABLE`, `available_at = NOW()`.
6. On fail → `status = QUARANTINED`, file is unreachable via the API.

A file in `QUARANTINED` is moved to a separate `healyn-files-quarantine` bucket after 24 hours for offline review, then deleted after 30 days.

---

## 5. Download Architecture (Presigned GET)

```
Mobile             API                S3
  │                 │                  │
  │ GET /files/{id}/download           │
  ├────────────────▶│                  │
  │                 │ requireAccess(READ on patient)
  │                 │ AUDIT_LOG DOWNLOAD
  │                 │ sign GET URL (TTL 5min)
  │ presignedUrl    │                  │
  │◀────────────────┤                  │
  │                                    │
  │ GET bytes (browser/native download)
  ├──────────────────────────────────▶│
  │◀──────────────────────────────────┤
```

- TTL is **5 minutes**. Never more.
- The signed URL is single-use in spirit; clients should not cache it.
- `Content-Disposition: attachment; filename="<original_filename>"` is set via response-header signing so downloads land with a sensible name.
- Every signing emits a `DOWNLOAD` audit log row.

---

## 6. Validation Chain Summary

| Stage | What | On failure |
|---|---|---|
| Presign request | MIME whitelist, size cap, claim against `patient_id` access | 400 / 403 |
| S3 PUT | Header match, size match (S3 enforces) | Client retry |
| Async validator | Magic bytes, AV scan, hash | Move to `QUARANTINED` |
| Link to message | Status must be `AVAILABLE` | 409 |
| Download presign | Resource access via `canAccessPatient(READ)` | 403 |

Defense in depth: even if a check is bypassed, the next catches.

---

## 7. Lifecycle & Retention

| State | Where | After |
|---|---|---|
| `PENDING_UPLOAD` > 1 hour with no S3 object | Cleanup job DELETEs the `file_objects` row | 1 hour |
| `AVAILABLE` referenced by clinical resource | Retain | indefinitely |
| `AVAILABLE` orphaned (no references) for 30 days | Soft-delete | 30 days |
| `DELETED` (soft) | Move S3 object to glacier-class storage; metadata row retained for audit | At delete time |
| `QUARANTINED` | Move to `healyn-files-quarantine` bucket | 24 hours |
| `QUARANTINED` aged | Hard-deleted | 30 days |

A nightly job reconciles the DB and S3: any S3 key not in `file_objects` is a leak — alert and investigate.

---

## 8. Naming Conventions

- DB key: `storage_key` (S3 key path).
- Display key: `original_filename` (what the user uploaded as).
- Never trust `original_filename` for routing or storage. Use it only for display, escape on render.

Filename sanitization rules for display:

- Strip path components (`../`, `/`).
- Strip control characters.
- Truncate to 255 chars.
- Forbid leading dots (no hidden files).

---

## 9. Mobile-Side Behavior

- Selection via `image_picker` (camera + gallery) and `file_picker` (PDFs).
- Pre-flight size check before requesting a presign.
- HEIC photos (from iOS users in Phase 2) are converted to JPEG on-device.
- Uploads happen in foreground with a progress bar; background upload is Phase 2.
- Failed uploads retry up to 3× with exponential backoff at 2/4/8 seconds.
- Files never cached longer than the active appointment view; cleared on logout.

---

## 10. Edge Cases

| Case | Resolution |
|---|---|
| User uploads a .pdf renamed to .jpg | Magic-byte validator catches; quarantined. |
| User uploads a benign PDF that contains JavaScript | Phase 1: accepted. Phase 2: JS-stripping render service. |
| Two messages reference the same file | Allowed. The file is shared; deleting the file is forbidden while any message references it. |
| File row exists, S3 object missing (data drift) | Reconciliation job alerts; mark row `PENDING_UPLOAD` and ask client to re-upload. |
| Presign issued but mobile app crashes before PUT | `PENDING_UPLOAD` row is cleaned up after 1 hour. |
| Patient is soft-deleted | All linked files become inaccessible to the patient side; physio retains read access for clinical record-keeping. |

---

## 11. Anti-Patterns

- **Do not** stream upload bytes through the Spring Boot API. Presigned PUT direct-to-S3 is the only path.
- **Do not** return file bytes from any API endpoint. Always return a presigned URL.
- **Do not** make the S3 bucket public, even briefly, for any reason.
- **Do not** put PHI in the S3 object key. Keys are UUIDs only; user-supplied names live in DB metadata.
- **Do not** allow client-supplied content-type without server-side magic-byte verification.

---

## 12. Related Documents

- [DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md) — `file_objects`, `discussion_message_attachments`
- [DISCUSSION_SYSTEM_DESIGN.md](./DISCUSSION_SYSTEM_DESIGN.md) — how files attach to messages
- [SECURITY_GUIDELINES.md](./SECURITY_GUIDELINES.md) — upload validation, audit
- [API_STANDARDS.md](./API_STANDARDS.md) — `/files/presign`, `/files/{id}/download`
