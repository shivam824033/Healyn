# SECURITY_GUIDELINES.md

> Healyn handles Protected Health Information (PHI). The threat model is **assume hostile network, assume curious insiders, assume lost devices**.
> Every rule in this document is a hard requirement. Deviations require a written exception in the PR description.

---

## 1. Threat Model (in one page)

| Asset | Threats | Mitigations |
|---|---|---|
| Account credentials | Phishing, credential stuffing, leaked DBs | OTP, Argon2id with pepper, rate limits |
| JWT access tokens | Token theft via XSS/MITM/log leakage | HTTPS-only, short TTL, never logged, RS256 verified |
| Refresh tokens | Replay, theft from device | Hashed at rest, single-use rotation, device-bound |
| PHI in DB | Insider access, accidental dump | Encrypted at rest (provider-level), audit log, least-privilege roles |
| PHI in S3 | Public bucket misconfiguration | Buckets are private by default; presigned URLs only |
| PHI in transit | Wifi sniffing, captive portals | TLS 1.2+ everywhere, HSTS, certificate pinning on mobile (Phase 2) |
| Push notifications | Visible on lock screens | Payloads carry IDs, never PHI |
| Mobile device | Theft, jailbreak/root | Biometric re-auth, no PHI cached longer than 30 min, OS-level secure storage for tokens |

---

## 2. Password Storage (Argon2id)

### 2.1 Parameters

```
Algorithm:     Argon2id
Memory cost:   65536 KiB (64 MiB)
Time cost:     3 iterations
Parallelism:   1
Salt:          16 random bytes, per-user, stored in accounts.password_salt
Pepper:        32 bytes from env HEALYN_PASSWORD_PEPPER, never in DB
Output length: 32 bytes
```

### 2.2 Hash Construction

```
hash_input  = password_bytes || pepper
hash_output = Argon2id(hash_input, salt, mem=64MiB, t=3, p=1, len=32)
stored      = "$argon2id$v=19$m=65536,t=3,p=1$<salt-b64>$<hash-b64>"
```

The encoded string is stored in `accounts.password_hash`; the raw salt is *also* stored in `password_salt` (for migration safety). Pepper is **never** persisted — leaking the DB without the pepper does not yield offline-crackable hashes.

### 2.3 Pepper Rotation

The pepper is rotated annually. Rotation strategy:

- New pepper version is added as `HEALYN_PASSWORD_PEPPER_V2`.
- On next successful login, the hash is recomputed with V2 and `password_hash` is updated.
- After 12 months, V1 access is disabled and any still-V1 accounts must reset via OTP.

A `pepper_version` column on `accounts` tracks which version is currently in use per account.

### 2.4 Password Policy

- Minimum 10 characters.
- Must not be in the top-100k common-password list (compiled at build time).
- No periodic forced rotation (per NIST 800-63B).
- Compromised-password check via HaveIBeenPwned k-anonymity API at registration and password reset.

### 2.5 Failed Login Handling

- Per account: lock for 15 minutes after 5 consecutive failures (`accounts.failed_login_count`, `accounts.locked_until`).
- Per IP: rate-limit `/auth/login` to 10/minute via Redis.
- Lockout messages do not distinguish "wrong password" from "no such account" (no user enumeration).

---

## 3. JWT Strategy

### 3.1 Tokens

| Token | TTL | Format | Storage | Use |
|---|---|---|---|---|
| **Access** | 15 minutes | JWT (RS256) | Mobile: secure storage (Keychain / Keystore). Never in plain Hive/SharedPreferences. | Authenticate every API call |
| **Refresh** | 30 days, single-use | Opaque random 32-byte token, base64url-encoded | Hashed (SHA-256) in `device_sessions.refresh_token_hash`; client holds the plaintext in secure storage. | Exchange for new access + refresh |

### 3.2 Access Token Claims

```json
{
  "iss":  "healyn",
  "sub":  "<account_id>",
  "aud":  "healyn-mobile",
  "iat":  1716800000,
  "exp":  1716800900,
  "jti":  "<unique-token-id>",
  "role": "ROLE_ACCOUNT",
  "ver":  1
}
```

- `jti` lets us blacklist a specific token via Redis if compromised.
- `ver` is the **token schema version**. Bumping it invalidates all in-flight tokens.
- Custom claims are kept minimal — **no PHI, no patient IDs, no email**. Server resolves authorization from the DB per request.

### 3.3 Signature

- Algorithm: **RS256**. Symmetric HS256 is forbidden (sharing the secret across services is a foot-gun).
- Private key in the cloud secret manager. Mounted as a file at app startup; never logged.
- Public key cached in-app; rotation supported via JWK Set endpoint `/.well-known/jwks.json` (Phase 2 microservice split).
- Key rotation: annually, or immediately on compromise.

### 3.4 Refresh Rotation

```
1. Mobile sends refresh_token in POST /auth/refresh.
2. Server SHA-256 hashes it and looks up the device_sessions row.
3. If found AND not revoked AND not expired AND last_seen_at within sliding window:
       - Generate new access + new refresh.
       - Update row: refresh_token_hash = sha256(new), last_seen_at = NOW().
       - Return both tokens.
4. If the same refresh is presented twice (replay): mark session revoked, force re-login.
```

This is the standard sliding-window single-use rotation. Replay = compromise signal.

### 3.5 Device Sessions

Every login produces a `device_sessions` row. The user can:

- List active sessions (`GET /auth/sessions`).
- Revoke an individual session (`DELETE /auth/sessions/{id}`).
- Revoke all sessions ("sign out everywhere" — Phase 2 UI; API ready in Phase 1).

A revoked session's refresh token is unusable; the access token is rejected via `jti` blacklist (Redis) until its natural expiry (≤ 15 min).

---

## 4. OTP & Phone/Email Verification

- 6-digit numeric OTPs.
- Stored as SHA-256 in `otp_challenges.code_hash` — never plaintext.
- TTL: 5 minutes.
- Max 5 verification attempts; 6th invalidates the challenge.
- Rate limit: max 3 OTP requests per `target` per hour.
- OTP delivery via SMS / email adapter; provider failures retried once.

---

## 5. Authorization

### 5.1 Layering

```
Request ──▶ Gateway (TLS, rate limit) ──▶ Spring Security filter (JWT verify)
        ──▶ Controller (no policy)
        ──▶ Service (calls *AccessPolicy.requireAccess(...) first)
        ──▶ Repository (no policy)
```

- Controllers must not contain authorization logic — they translate HTTP and validate payload.
- Services must call the appropriate policy class **on the first line** of any patient-scoped method.
- The `@PreAuthorize` annotation is used only for coarse role checks (`hasRole('ROLE_PHYSIO')`).

### 5.2 Patient Access

Defined in [PATIENT_RELATIONSHIP_MODEL.md §4](./PATIENT_RELATIONSHIP_MODEL.md). Summary:

```
canAccessPatient(account, patientId, mode)
   ↳ TRUE if account has account_patients row for patientId
                 AND (mode == READ OR can_manage == TRUE)
   ↳ TRUE if account.role == ROLE_PHYSIO
   ↳ FALSE otherwise
```

### 5.3 Resource Ownership

For every clinical resource, the policy traces ownership up to a Patient and then checks `canAccessPatient`:

| Resource | Owning Patient |
|---|---|
| `appointments.id` | `appointments.patient_id` |
| `discussion_messages.id` | `appointments.patient_id` of parent appointment |
| `file_objects.id` | `file_objects.patient_id` |
| `treatment_notes.id` | `treatment_notes.patient_id` |

No resource is reachable through a path that skips the patient.

---

## 6. Input Validation

### 6.1 Layer Coverage

- **DTO layer** (`jakarta.validation`): type, length, regex, range. Rejected with `400 Bad Request`.
- **Service layer**: business invariants (e.g., booking not in past). Rejected with `422 Unprocessable Entity`.
- **DB layer**: `CHECK` constraints, exclusion constraints. Last-line defense.

### 6.2 Common Validations

| Field | Rule |
|---|---|
| `email` | RFC 5322 simplified, max 255 chars, lowercased |
| `phone_e164` | E.164 regex `^\+[1-9]\d{1,14}$` |
| `password` | 10–128 chars, no NUL byte |
| `full_name` | 1–160 chars, Unicode letters + space + `'.-` only |
| `scheduled_at` | ISO 8601 with offset, parseable as `OffsetDateTime` |
| `mime_type` | One of `application/pdf`, `image/jpeg`, `image/png` |
| Any free-text PHI | HTML-escaped on output, never on input |

### 6.3 No SQL Injection Surface

- All DB access via JPA / parameterized JDBC. String concatenation in SQL is forbidden.
- Dynamic sort/order fields are whitelisted from a fixed enum.

---

## 7. File Upload Security

Details in [FILE_STORAGE_GUIDELINES.md](./FILE_STORAGE_GUIDELINES.md). Security essentials:

| Check | Where | Action on failure |
|---|---|---|
| MIME claimed by client matches whitelist | API presign request | Reject 400 |
| Size within bounds | API presign request | Reject 400 |
| Object exists in S3 before linking to a message | Message create | Reject 409 |
| **Magic byte / content-type sniffing** of S3 object | Async validator after PUT | Mark `QUARANTINED`, refuse to expose |
| Antivirus scan hook | Async validator after PUT | Mark `QUARANTINED` on positive |
| Filename sanitization on download | Download presign | Use UUID name, set `Content-Disposition` filename safely |

S3 buckets are **private**. The only way to read a file is a presigned GET URL with TTL ≤ 5 minutes, generated by the API after `canAccessPatient(READ)`.

---

## 8. Transport Security

- **TLS 1.2 minimum**, prefer 1.3. SSL/TLS 1.0/1.1 disabled at the gateway.
- **HSTS** enabled with `max-age=63072000; includeSubDomains; preload` on the API domain.
- **Mobile certificate pinning**: deferred to Phase 2 (operational cost in Phase 1 outweighs benefit at this scale; revisit before public app store launch).
- **Cookies**: not used. Auth is `Authorization: Bearer <jwt>` only.

---

## 9. OWASP Top 10 Mapping

| OWASP (2021) | Healyn Mitigation |
|---|---|
| **A01 Broken Access Control** | Centralized `PatientAccessPolicy`; no controller-level checks; tests assert 403 for every cross-account path |
| **A02 Cryptographic Failures** | Argon2id with pepper; RS256 JWTs; TLS 1.2+; S3 SSE-KMS |
| **A03 Injection** | Parameterized queries; Bean Validation; output encoding |
| **A04 Insecure Design** | Threat model in §1; security review on every PR per [DEVELOPMENT_RULES.md](./DEVELOPMENT_RULES.md) |
| **A05 Security Misconfiguration** | Spotbugs / dependency-check / OWASP ZAP in CI; secrets via secret manager only |
| **A06 Vulnerable Components** | Renovate bot; weekly `gradle dependencyUpdates`; CVE alerts gate releases |
| **A07 Identification & Auth Failures** | Argon2id; OTP; account lockout; single-use refresh; session revocation |
| **A08 Software & Data Integrity Failures** | Signed mobile builds; reproducible backend Docker images; Flyway migration validation |
| **A09 Logging & Monitoring Failures** | JSON logs with traceId; audit log on every clinical read/write; alerts on 5xx + auth-failure spikes |
| **A10 SSRF** | No user-controlled URL fetches in Phase 1 |

---

## 10. Logging & PII Hygiene

- **Never** log: passwords, OTP codes, JWTs (any part), refresh tokens, full request bodies on auth endpoints.
- **Never** log: patient names, DOB, file contents, message bodies.
- **Always** log: request ID, account ID, route, status, latency, sanitized error class.
- Body logging in dev only, with an explicit `HEALYN_DEV_LOG_BODIES=true` env flag.

---

## 11. Audit Log

Every clinical resource access produces an `audit.audit_log` row (see [DATABASE_SCHEMA.md §3.14](./DATABASE_SCHEMA.md)).

| Action | Triggered by |
|---|---|
| `READ` | Viewing patient details, appointment list, files, messages, treatment notes |
| `CREATE` | Creating any of the above |
| `UPDATE` | Edits within the allowed window |
| `SOFT_DELETE` | Soft deletes |
| `DOWNLOAD` | Presigned URL minted for a file |
| `EXPORT` | (Phase 2) bulk data export |

The audit log lives in the `audit` schema with `INSERT, SELECT` grants only. There is no `UPDATE` or `DELETE` privilege for the application role.

---

## 12. Secret Management

| Secret | Storage |
|---|---|
| DB credentials | Cloud secret manager; mounted as env at startup |
| JWT private key | Cloud secret manager; mounted as file |
| `HEALYN_PASSWORD_PEPPER` | Cloud secret manager; env at startup |
| FCM service account JSON | Cloud secret manager; mounted as file |
| S3 access key (if used) | Cloud secret manager. Prefer IAM role on the host. |
| OTP provider API key | Cloud secret manager |

`.env.example` lists keys with placeholder values for local dev. The real `.env` file is gitignored. No `.env.production` is ever committed.

---

## 13. Mobile Security Specifics

- Auth tokens in **OS secure storage** (Android Keystore via `flutter_secure_storage`). Never in `SharedPreferences`.
- App lock: optional biometric re-auth on app open (Phase 1: setting; default off. Phase 2: default on).
- Screen capture: blocked on patient profile and treatment note screens (Android `FLAG_SECURE`).
- Background blur: app shows a neutral placeholder when sent to background; PHI is not visible in the app switcher.
- Logout: wipes secure storage, Hive cache, and revokes refresh token server-side.

---

## 14. Security Review Checklist (per PR)

The reviewer must answer **YES** to all that apply, or the PR is blocked:

- [ ] No new endpoint without authentication or with `@PreAuthorize("permitAll")`.
- [ ] Every new endpoint that touches PHI calls `PatientAccessPolicy.requireAccess(...)`.
- [ ] No new column stores plaintext PHI in `notification_outbox.payload` or any cache.
- [ ] No new logging statement includes a password, token, OTP, or message body.
- [ ] No new third-party dependency without a license check and a CVE check.
- [ ] No new env var without an entry in `.env.example`.
- [ ] If a new file type is accepted, the magic-byte validator is updated.
- [ ] New SQL is parameterized; new dynamic sort fields are whitelisted.

---

## 15. Related Documents

- [DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md) — auth tables, audit schema
- [PATIENT_RELATIONSHIP_MODEL.md](./PATIENT_RELATIONSHIP_MODEL.md) — access policy details
- [FILE_STORAGE_GUIDELINES.md](./FILE_STORAGE_GUIDELINES.md) — upload validation chain
- [API_STANDARDS.md](./API_STANDARDS.md) — error envelope, headers
- [DEVELOPMENT_RULES.md](./DEVELOPMENT_RULES.md) — PR security review process
