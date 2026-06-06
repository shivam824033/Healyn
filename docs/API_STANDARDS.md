# API_STANDARDS.md

> The contract between the Spring Boot backend and the Flutter mobile app.
> If it isn't here, it isn't standard. New endpoints conform; legacy patterns are corrected, not propagated.

---

## 1. Foundation

| Aspect | Decision |
|---|---|
| Transport | HTTPS only (TLS 1.2+) |
| Style | REST + JSON |
| Versioning | URL-based: `/api/v1/...` |
| Encoding | UTF-8 |
| Content type | `application/json; charset=utf-8` |
| Date/time | ISO 8601 with offset, e.g., `2026-05-27T09:30:00+05:30` |
| IDs | UUID v4/v7 as strings |
| Case | `snake_case` in JSON bodies; `kebab-case` in URLs is **not** used — URLs use `snake_case` for path segments, e.g., `/api/v1/treatment_notes` |

> Why `snake_case` in URLs? Consistency with payloads. Mixed casing in a single contract is friction.

---

## 2. Standard Headers

### 2.1 Request

| Header | Required? | Notes |
|---|---|---|
| `Authorization: Bearer <jwt>` | All except auth endpoints | Access token only |
| `Content-Type: application/json` | All bodies | |
| `Accept: application/json` | All requests | |
| `X-Request-Id` | Recommended | UUID; echoed in response and logged. Server generates one if absent. |
| `Idempotency-Key` | Required for booking & payment writes | UUID; 24h TTL |
| `X-App-Version` | Recommended | `android-1.2.3` format |
| `X-Client-TZ` | Recommended | IANA timezone, e.g., `Asia/Kolkata` |

### 2.2 Response

| Header | Notes |
|---|---|
| `X-Request-Id` | Echo of the request ID |
| `X-Trace-Id` | Server-side trace ID for support |
| `Cache-Control` | `no-store` for all PHI responses |

---

## 3. Resource Naming Conventions

| Rule | Example |
|---|---|
| Plural nouns | `/patients`, `/appointments` |
| Identifier in path | `/patients/{patient_id}` |
| Sub-resources nested | `/appointments/{appointment_id}/messages` |
| Actions on a resource via a sub-route, not a verb | `POST /appointments/{id}/transitions` not `POST /confirm-appointment` |
| No mixed-resource paths | Avoid `/me/family/patients`; use `/patients?relation=family` |

---

## 4. HTTP Methods

| Method | Use | Idempotent? | Body? |
|---|---|---|---|
| `GET` | Retrieve | Yes | No |
| `POST` | Create or non-idempotent action | No (unless `Idempotency-Key`) | Yes |
| `PATCH` | Partial update | Yes (per JSON Merge Patch semantics) | Yes |
| `PUT` | Full replace (rare in Healyn) | Yes | Yes |
| `DELETE` | Soft-delete | Yes | Optional |

We prefer `PATCH` over `PUT`. Full replace is reserved for resources whose entire state is owned by one call.

---

## 5. HTTP Status Codes (canonical use)

| Code | When |
|---|---|
| `200 OK` | Successful GET / PATCH / non-creating POST |
| `201 Created` | Resource created. `Location` header points to it. |
| `202 Accepted` | Async work queued (e.g., scheduled cancellation) |
| `204 No Content` | Successful DELETE or no-payload response |
| `400 Bad Request` | Syntactic / schema validation failure |
| `401 Unauthorized` | Missing / invalid / expired token |
| `403 Forbidden` | Authenticated but not allowed |
| `404 Not Found` | Resource does not exist for this account |
| `409 Conflict` | State conflict (booking overlap, invalid transition, idempotency replay mismatch) |
| `410 Gone` | Resource intentionally retired |
| `422 Unprocessable Entity` | Business rule violation (validated input fails domain rules) |
| `429 Too Many Requests` | Rate limit exceeded; `Retry-After` header set |
| `500 Internal Server Error` | Unexpected server error; never includes stack trace |
| `503 Service Unavailable` | Dependency down or maintenance |

> **Important**: `404` is used for both "doesn't exist" and "you can't see it." This prevents user enumeration. The distinction is internal to logs.

---

## 6. Error Response Envelope

Every non-2xx response uses this shape:

```json
{
  "error": {
    "code": "appointments.invalid_transition",
    "message": "Cannot transition appointment from CONFIRMED to REQUESTED.",
    "details": [
      { "field": "to", "issue": "INVALID_VALUE" }
    ],
    "trace_id": "5b91a0e9-32f6-4e8e-9c1f-3e1d5a8b6f10"
  }
}
```

| Field | Meaning |
|---|---|
| `code` | Stable machine identifier. `<domain>.<reason>`. Never changes once shipped. |
| `message` | Human-readable English. Localized client-side, not server-side. |
| `details` | Optional array of structured per-field issues. |
| `trace_id` | The server-side trace ID. Shown to user only for support. |

### 6.1 Standard Error Codes

| Code | Status | Meaning |
|---|---|---|
| `common.validation_failed` | 400 | One or more fields failed schema validation |
| `common.unauthorized` | 401 | No valid token |
| `common.forbidden` | 403 | Auth OK, access denied |
| `common.not_found` | 404 | Resource not found (or access denied) |
| `common.rate_limited` | 429 | Slow down |
| `common.internal` | 500 | Generic server error |
| `auth.invalid_credentials` | 401 | Login failed |
| `auth.account_locked` | 401 | Too many failures |
| `auth.token_expired` | 401 | Access or refresh token expired |
| `auth.refresh_replay` | 401 | Refresh token reused; session revoked |
| `auth.otp_invalid` | 422 | OTP wrong or expired |
| `auth.otp_attempts_exceeded` | 429 | OTP attempt cap hit |
| `patients.primary_required` | 422 | Cannot remove the account's primary patient |
| `patients.relationship_exists` | 409 | Same patient already linked to this account |
| `appointments.slot_unavailable` | 409 | Slot taken or outside availability |
| `appointments.invalid_transition` | 409 | Status transition not allowed |
| `appointments.in_past` | 422 | Cannot book in the past |
| `discussion.appointment_terminal` | 403 | Appointment is cancelled/no-show — patient side may not write |
| `discussion.edit_window_expired` | 409 | 5-minute edit window passed |
| `discussion.not_sender` | 403 | Only the original sender may edit/delete |
| `discussion.message_not_found` | 404 | Message not found in this appointment |
| `discussion.empty_message` | 422 | Body required, or `ATTACHMENT_ONLY` with no attachment |
| `discussion.body_too_long` | 422 | Body exceeds 2,000 characters |
| `discussion.too_many_attachments` | 422 | More than 10 attachments |
| `discussion.attachment_not_found` | 404 | Referenced file does not exist |
| `discussion.attachment_patient_mismatch` | 403 | File belongs to a different patient |
| `discussion.attachment_not_ready` | 409 | File is not `AVAILABLE` yet |
| `files.unsupported_mime` | 422 | MIME type not supported |
| `files.too_large` | 422 | File exceeds the per-type size cap |
| `files.invalid_state` | 409 | File not in the required status |
| `files.referenced` | 409 | File referenced by a message; cannot delete |

---

## 7. Pagination

Cursor-based, **not** offset-based. Offset pagination breaks under concurrent writes.

### 7.1 Request

```
GET /api/v1/appointments?cursor=eyJpZCI6Ii4uLiJ9&limit=20
```

| Param | Default | Max |
|---|---|---|
| `limit` | 20 | 100 |
| `cursor` | (none — start from newest) | opaque base64 |
| `order` | `created_at_desc` | whitelisted set per endpoint |

### 7.2 Response Envelope

```json
{
  "data": [ { "id": "...", ... }, ... ],
  "page": {
    "limit": 20,
    "next_cursor": "eyJpZCI6Ii4uLiJ9",
    "has_more": true
  }
}
```

- `next_cursor` is `null` when `has_more` is `false`.
- The cursor encodes the order key + last value (e.g., `{ "k": "created_at", "v": "2026-05-27T09:30:00Z", "id": "..." }`).
- Cursors are opaque to clients. Never parse them.

---

## 8. Standard Response Envelope

### 8.1 Single Resource

```json
{
  "data": { "id": "...", ... }
}
```

### 8.2 Collection

```json
{
  "data": [ {...}, {...} ],
  "page": { "limit": 20, "next_cursor": null, "has_more": false }
}
```

### 8.3 Action with No Resource Returned

`204 No Content`. No body.

---

## 9. Phase 1 Endpoint Catalogue

> A complete-by-design list. Adding an endpoint is adding a row here.

### 9.1 Auth

| Method | Path | Purpose |
|---|---|---|
| `POST` | `/api/v1/auth/register/start` | Begin registration, send OTP |
| `POST` | `/api/v1/auth/register/verify` | Verify OTP, create account + primary patient |
| `POST` | `/api/v1/auth/login` | Email/phone + password, returns tokens |
| `POST` | `/api/v1/auth/refresh` | Single-use refresh, rotates tokens |
| `POST` | `/api/v1/auth/logout` | Revoke current session |
| `POST` | `/api/v1/auth/password_reset/start` | Send reset OTP |
| `POST` | `/api/v1/auth/password_reset/verify` | Verify OTP + set new password |
| `GET`  | `/api/v1/auth/sessions` | List active device sessions |
| `DELETE` | `/api/v1/auth/sessions/{id}` | Revoke a session |
| `POST` | `/api/v1/auth/fcm_tokens` | Register / update FCM token (auth required) |

> `POST /auth/fcm_tokens` body: `{ token (required), platform? ("android", default), device_id? }`.
> Idempotent upsert keyed on `token`: re-posting a known token rebinds it to the caller's
> account and refreshes metadata. Returns `200` with `{ "id": "<fcm_token_uuid>" }`. The
> resource is owned by the notifications module; the controller lives there but serves the
> `/auth/fcm_tokens` path (served unprefixed by the running backend — see §9.4 note).

### 9.2 Patients

| Method | Path | Purpose |
|---|---|---|
| `GET`  | `/api/v1/patients` | List patients linked to me |
| `POST` | `/api/v1/patients` | Add a family member patient |
| `GET`  | `/api/v1/patients/{id}` | Get a patient |
| `PATCH` | `/api/v1/patients/{id}` | Update a patient |
| `DELETE` | `/api/v1/patients/{id}` | Remove link (and soft-delete if last link) |

### 9.3 Availability

| Method | Path | Purpose |
|---|---|---|
| `GET` | `/api/v1/availability?physiotherapistId=...&from=YYYY-MM-DD&to=YYYY-MM-DD` | Computed bookable slots. `physiotherapistId` is optional in Phase 1 (resolves to the lone `ROLE_PHYSIO` account); `to - from` must be < 31 days. Open to any authenticated account. |
| `GET` | `/api/v1/availability/rules` | (Physio) List own rules |
| `POST` | `/api/v1/availability/rules` | (Physio) Create rule. Body: `{day_of_week (0–6, 0=Sun), start_time, end_time, slot_minutes (5–240), timezone (IANA), effective_from, effective_to?}`. `start_time`/`end_time` must align on `slot_minutes` boundaries from `00:00`. |
| `PATCH` | `/api/v1/availability/rules/{id}` | (Physio) Update rule (partial) |
| `DELETE` | `/api/v1/availability/rules/{id}` | (Physio) Archive rule — sets `effective_to = today` in the rule's own timezone. |
| `GET` | `/api/v1/availability/blackouts` | (Physio) List own blackouts |
| `POST` | `/api/v1/availability/blackouts` | (Physio) Add blackout. Body: `{starts_at (TIMESTAMPTZ), ends_at (TIMESTAMPTZ), reason?}`. Overlapping windows for the same physio → 409 `availability.blackout_overlap`. |
| `DELETE` | `/api/v1/availability/blackouts/{id}` | (Physio) Remove blackout (hard delete) |

> **Note** — the `/api/v1` URL prefix is documented here for the eventual production deployment. Spring Boot controllers in the repo currently use the bare paths (e.g. `/availability`, `/availability/rules`). The mismatch will be reconciled either by introducing `server.servlet.context-path=/api/v1` or by dropping the prefix from the docs; tracked in `MODULE_STATUS_TRACKER.md` cross-cutting tasks.

### 9.4 Appointments

> Note: paths below are written with the `/api/v1` prefix for forward-compatibility, but the running
> backend currently serves them unprefixed (`/appointments`) to match `/auth`, `/patients`, `/availability`.
> A project-wide `server.servlet.context-path` decision is an open follow-up.

| Method | Path | Purpose |
|---|---|---|
| `GET`  | `/appointments?patientId=&status=&from=&to=&cursor=&limit=` | List (cursor pagination, `limit ≤ 50`, default 20) |
| `GET`  | `/appointments/upcoming?limit=` | Next live scheduled appointments ascending from now (`CONFIRMED`/`IN_PROGRESS`, `limit ≤ 50`, default 30). Role-scoped. Returns `{items}` (no cursor) |
| `GET`  | `/appointments/calendar?from=&to=` | All scheduled appointments in an instant window, ascending (month grid). `from`/`to` are ISO date-times; range ≤ 62 days. Role-scoped. Returns `{items}` |
| `POST` | `/appointments` | Request an appointment for a date — patient-side, no time (requires `Idempotency-Key` header) |
| `GET`  | `/appointments/{id}` | Get |
| `POST` | `/appointments/{id}/schedule` | **Physio only** — assign the final time to a `REQUESTED` request → `CONFIRMED`. Body: `{scheduledAt, durationMinutes}` |
| `POST` | `/appointments/follow-ups` | **Physio only** — create a follow-up at a time the physio sets (`is_follow_up = true`). Body: `{patientId, scheduledAt, durationMinutes, reason?}` |
| `POST` | `/appointments/{id}/transitions` | Move status — body: `{to, cancelReason?, cancelNote?}`. Does **not** accept `REQUESTED → CONFIRMED` (use `/schedule`). See [APPOINTMENT_FLOW.md](./APPOINTMENT_FLOW.md) |
| `POST` | `/appointments/{id}/reschedule` | Reschedule, old → `RESCHEDULED`. Physio body: `{scheduledAt, durationMinutes, reason?}` → new `CONFIRMED`. Patient body: `{requestedDate, preferredTime?, reason?}` → new unscheduled `REQUESTED` |

`POST /appointments` body (patient request — date is mandatory, time is the physiotherapist's to set):

```json
{
  "patientId": "uuid",
  "requestedDate": "2026-06-15",
  "preferredTime": "09:00",
  "reason": "Lower-back follow-up"
}
```

`POST /appointments/{id}/schedule` body (physiotherapist assigns the time):

```json
{
  "scheduledAt": "2026-06-15T09:00:00+05:30",
  "durationMinutes": 30
}
```

`GET /appointments` response envelope:

```json
{
  "items": [ { "...AppointmentView" } ],
  "nextCursor": "opaque-base64-or-null"
}
```

Status values: `REQUESTED`, `CONFIRMED`, `IN_PROGRESS`, `COMPLETED`, `CANCELLED`, `NO_SHOW`, `RESCHEDULED`.
Cancel reasons: `PATIENT_CANCELLED`, `PHYSIO_CANCELLED`, `CLINIC_CLOSED`, `OTHER`.

### 9.5 Discussion

> Paths are unprefixed (no `/api/v1`) — see the open follow-up in §9.4.

| Method | Path | Purpose | Body |
|---|---|---|---|
| `GET`    | `/appointments/{id}/messages?cursor=&limit=` | List messages (cursor, default 20, max 50) | — |
| `POST`   | `/appointments/{id}/messages` | Create | `{ messageType: "QUESTION"\|"REPLY"\|"INSTRUCTION"\|"ATTACHMENT_ONLY", body: string, fileIds?: uuid[] }` |
| `PATCH`  | `/appointments/{id}/messages/{msgId}` | Edit (≤ 5 min, original sender only) | `{ body: string }` |
| `DELETE` | `/appointments/{id}/messages/{msgId}` | Soft-delete (≤ 5 min, original sender only) | — |
| `POST`   | `/appointments/{id}/messages/read` | Advance the caller's last-read marker | `{ messageId: uuid }` |
| `GET`    | `/appointments/{id}/messages/unread-count` | Count unread (excludes own messages) | — |

List response envelope:
```json
{ "items": [ { "id": "…", "appointmentId": "…", "senderAccountId": "…",
               "senderRole": "PATIENT_SIDE", "messageType": "REPLY",
               "body": "…",
               "attachments": [ { "fileId": "…", "kind": "REPORT",
                                  "mimeType": "application/pdf",
                                  "originalFilename": "spine-mri.pdf", "sizeBytes": 1843204 } ],
               "createdAt": "…", "editedAt": null } ],
  "nextCursor": "…or null" }
```

Rules:
- `INSTRUCTION` is rejected for non-physio callers.
- For patient-side callers, write is rejected on `CANCELLED` / `NO_SHOW` appointments (`discussion.appointment_terminal`).
- Body is required for `QUESTION` / `REPLY` / `INSTRUCTION` (max 2,000 chars). `ATTACHMENT_ONLY` must carry no body and at least one attachment.
- `fileIds` carries 0–10 file ids (>10 → `discussion.too_many_attachments`). Each must exist (`discussion.attachment_not_found`), belong to the appointment's patient (`discussion.attachment_patient_mismatch`, 403), and be `AVAILABLE` (`discussion.attachment_not_ready`, 409). Files are pre-uploaded via §9.6.
- Edit/delete beyond 5 minutes returns `discussion.edit_window_expired`. Non-sender returns `discussion.not_sender`.

### 9.6 Files

| Method | Path | Purpose | Body |
|---|---|---|---|
| `POST` | `/api/v1/files/presign` | Create a `PENDING_UPLOAD` record + presigned PUT URL | `{ patientId, appointmentId, kind, mimeType, sizeBytes, originalFilename }` |
| `POST` | `/api/v1/files/{id}/complete` | Client signals upload done; server verifies size + magic bytes, promotes to `AVAILABLE` | — |
| `GET`  | `/api/v1/files/{id}/download` | Short-lived presigned GET URL (TTL ≤ 5 min, `Content-Disposition` set) | — |
| `GET`  | `/api/v1/files/{id}` | File metadata | — |
| `DELETE` | `/api/v1/files/{id}` | Soft-delete (only if not referenced) | — |

Presign response (bare, consistent with the rest of the API):
```json
{ "fileId": "…",
  "upload": { "method": "PUT", "url": "https://…", "headers": { "Content-Type": "application/pdf" }, "expiresInSeconds": 300 } }
```

Rules:
- `mimeType` whitelist: `application/pdf`, `image/jpeg`, `image/png` (`files.unsupported_mime`, 422). Per-type size caps: PDF 20 MB, JPEG/PNG 10 MB (`files.too_large`, 422).
- Write (presign / complete / delete) needs write access to `patientId`; `appointmentId` is required in Phase 1 and must belong to that patient (`files.appointment_required` / `files.patient_mismatch`, 422). Per-account cap 100 files/day (`files.daily_cap_exceeded`, 409).
- `complete` requires `PENDING_UPLOAD` (`files.invalid_state`, 409) and the uploaded object present (`files.object_missing`, 409). Size/magic-byte mismatch moves the file to `QUARANTINED` and returns `files.magic_byte_mismatch` (422). Download requires `AVAILABLE`.
- The server never streams bytes: upload is direct-to-S3 via the presigned PUT, download via the presigned GET. Keys are UUID-based; user filenames are display-only.
- `DELETE` is blocked while any discussion message references the file (`files.referenced`, 409); detach/soft-delete the message first.

### 9.7 Treatment Notes

| Method | Path | Purpose | Body |
|---|---|---|---|
| `GET`  | `/api/v1/appointments/{id}/treatment_note` | Get the note for an appointment | — |
| `PUT`  | `/api/v1/appointments/{id}/treatment_note` | Create / replace (physio only) | `{ diagnosis?, notes?, recoveryInstructions?, nextReviewAt? }` |
| `GET`  | `/api/v1/patients/{id}/treatment_notes?cursor=&limit=` | Patient timeline (cursor, default 20, max 50) | — |

Rules:
- Exactly one note per appointment (`PUT` is an idempotent upsert; replacing keeps the same `id`).
- Write is physio-only and is gated on the appointment being `COMPLETED` (`treatment_notes.appointment_not_completed`, 409). Completing the appointment unlocks the note — see [APPOINTMENT_FLOW.md §3.1](./APPOINTMENT_FLOW.md#31-allowed-transitions).
- At least one of `diagnosis` / `notes` / `recoveryInstructions` must be non-blank (`treatment_notes.empty`, 422); each field ≤ 8,000 chars (`treatment_notes.field_too_long`, 422).
- Read is allowed to the physio and to patient-side accounts with read access to the patient; `GET` on an appointment with no note returns `treatment_notes.not_found` (404).

### 9.8 Notifications

| Method | Path | Purpose |
|---|---|---|
| `GET`  | `/api/v1/notifications/preferences` | View the account's push opt-outs |
| `PATCH` | `/api/v1/notifications/preferences` | Update the account's push opt-outs |

Preferences are account-scoped (the subject claim is the only identity needed). They are
expressed as user-facing **categories**, each a boolean that is `true` when the account wants
push for it:

| Field | Covers (`notification_kind`) |
|---|---|
| `appointment_updates` | `BOOKING_REQUESTED`, `BOOKING_CONFIRMED`, `BOOKING_CANCELLED` |
| `appointment_reminders` | `APPOINTMENT_REMINDER` |
| `messages` | `DISCUSSION_NEW_MESSAGE` |
| `treatment_notes` | `TREATMENT_NOTE_ADDED` |

```http
PATCH /api/v1/notifications/preferences HTTP/1.1
Authorization: Bearer eyJhbGciOiJSUzI1NiIs...
Content-Type: application/json

{ "messages": false }
```

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "appointment_updates": true,
  "appointment_reminders": true,
  "messages": false,
  "treatment_notes": true
}
```

Rules:
- The default is **opted-in to everything**. An account with no stored row gets all-`true`
  from `GET`; the row is created lazily on the first `PATCH`.
- `PATCH` is partial — an **omitted** field leaves that category unchanged. The response is the
  full resulting snapshot (every field present).
- Enforcement is at enqueue: `NotificationPublisher` skips writing an outbox row for a recipient
  who has opted out of that kind's category, so an opt-out is honoured before dispatch and never
  produces a suppressed row.

### 9.9 Health

| Method | Path | Purpose |
|---|---|---|
| `GET`  | `/api/v1/health/live` | Liveness probe |
| `GET`  | `/api/v1/health/ready` | Readiness probe |

---

## 10. Request / Response Examples

### 10.1 Request an Appointment

```http
POST /api/v1/appointments HTTP/1.1
Authorization: Bearer eyJhbGciOiJSUzI1NiIs...
Content-Type: application/json
Idempotency-Key: 6f3a91ab-1d7c-44e0-bf2c-5e6d9c1b2a37
X-Request-Id: 0f3e22ad-9b6e-4f8e-8b2f-3e1d5a8b6f10

{
  "patient_id": "8a7b6c5d-1e2f-3a4b-5c6d-7e8f9a0b1c2d",
  "requested_date": "2026-05-30",
  "preferred_time": "10:30",
  "reason": "Lower back pain — follow up"
}
```

```http
HTTP/1.1 201 Created
Location: /api/v1/appointments/3d2c1b0a-9f8e-7d6c-5b4a-3c2d1e0f9a8b
Content-Type: application/json
X-Request-Id: 0f3e22ad-9b6e-4f8e-8b2f-3e1d5a8b6f10
X-Trace-Id: t-2bc7f4e1

{
  "data": {
    "id": "3d2c1b0a-9f8e-7d6c-5b4a-3c2d1e0f9a8b",
    "patient_id": "8a7b6c5d-1e2f-3a4b-5c6d-7e8f9a0b1c2d",
    "physiotherapist_id": "...",
    "requested_date": "2026-05-30",
    "preferred_time": "10:30:00",
    "scheduled_at": null,
    "duration_minutes": 30,
    "status": "REQUESTED",
    "is_follow_up": false,
    "reason": "Lower back pain — follow up",
    "created_at": "2026-05-27T13:45:12Z"
  }
}
```

The physiotherapist later assigns the time with `POST /appointments/{id}/schedule`, which sets `scheduled_at` and moves the status to `CONFIRMED`.

### 10.2 Conflict Example

```http
HTTP/1.1 409 Conflict
Content-Type: application/json

{
  "error": {
    "code": "appointments.slot_unavailable",
    "message": "The selected slot is no longer available.",
    "details": [],
    "trace_id": "t-2bc7f4e1"
  }
}
```

### 10.3 Validation Error

```http
HTTP/1.1 400 Bad Request
Content-Type: application/json

{
  "error": {
    "code": "common.validation_failed",
    "message": "One or more fields are invalid.",
    "details": [
      { "field": "scheduled_at", "issue": "MUST_BE_FUTURE" },
      { "field": "duration_minutes", "issue": "OUT_OF_RANGE" }
    ],
    "trace_id": "t-2bc7f4e1"
  }
}
```

---

## 11. Idempotency

For unsafe operations where a client retry could double-act:

- Client generates a UUID and sends it as `Idempotency-Key`.
- Server stores `(key, account_id, request_hash, response_snapshot)` in Redis with a 24-hour TTL.
- A replayed key with the **same** request hash returns the cached response (with original status code).
- A replayed key with a **different** request hash returns `409 Conflict` with `code = "common.idempotency_conflict"`.

Required for: `POST /appointments`, `POST /appointments/{id}/transitions`, `POST /files/presign`.

---

## 12. Rate Limiting

Implemented via Redis-backed token bucket at the API gateway and / or app filter.

| Bucket | Limit |
|---|---|
| Per IP, unauthenticated | 30 req/min |
| Per account, authenticated | 120 req/min |
| Per account, `/auth/login` | 10 req/min |
| Per account, `/auth/refresh` | 30 req/min |
| Per account, `/files/presign` | 30 req/min |
| Per account, all writes | 60 req/min |

Exceeded → `429 Too Many Requests` with `Retry-After: <seconds>`.

---

## 13. Deprecation Policy

- A deprecated endpoint sends `Deprecation: true` and a `Sunset: <date>` header.
- Minimum 90-day grace period before removal.
- The deprecation is announced in `CHANGELOG.md` and to the mobile team.

---

## 14. Versioning

- URL versioning (`/api/v1/...`).
- Within `v1`, additive changes only (new fields, new endpoints).
- Breaking changes ship as `v2` parallel routes.
- The mobile app sends `X-App-Version`; the server may force-upgrade older clients via a `426 Upgrade Required` response.

---

## 15. Related Documents

- [SECURITY_GUIDELINES.md](./SECURITY_GUIDELINES.md) — authn/authz behind the endpoints
- [APPOINTMENT_FLOW.md](./APPOINTMENT_FLOW.md) — what `/transitions` accepts
- [DISCUSSION_SYSTEM_DESIGN.md](./DISCUSSION_SYSTEM_DESIGN.md) — message endpoints
- [FILE_STORAGE_GUIDELINES.md](./FILE_STORAGE_GUIDELINES.md) — file upload flow
- [DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md) — underlying entities
