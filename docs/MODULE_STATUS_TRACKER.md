# MODULE_STATUS_TRACKER.md

> A living dashboard of where each Phase 1 module stands across every layer.
> Update this in the same PR that moves a square. A stale tracker is worse than no tracker.

---

## 1. Legend

| Symbol | Meaning |
|---|---|
| ⬜ | Not started |
| 🟦 | In progress |
| 🟨 | Code complete, not yet tested |
| 🟩 | Tested & merged |
| ✅ | Released to production |
| ⛔ | Blocked (see Notes column) |
| — | Not applicable to this module |

Layers tracked:

- **DB** — Flyway migrations defining the module's tables.
- **Backend** — Service, repository, and domain logic in Spring Boot.
- **API** — REST endpoints exposed and documented in [API_STANDARDS.md](./API_STANDARDS.md).
- **Mobile** — Feature implementation in Flutter (data/domain/presentation).
- **Tests** — Unit + integration tests meeting [DEVELOPMENT_RULES.md §7](./DEVELOPMENT_RULES.md#7-testing-expectations) targets.

---

## 2. Status Matrix — Phase 1

| Module | DB | Backend | API | Mobile | Tests | Notes |
|---|---|---|---|---|---|---|
| **auth**                       | 🟩 | 🟩 | 🟩 | 🟨 | 🟩 | V3 migration; register/login/refresh/sessions/password-reset; integration + unit tests. **Mobile (Flutter):** patient app scaffolded under `mobile/` — two-step register (OTP), login, session bootstrap + logout. Riverpod 2.x (manual providers, no codegen) + Dio (snake_case, RS256 bearer, single-flight 401 refresh) + `flutter_secure_storage` token store + go_router auth redirect; UI from design tokens. `flutter analyze` clean; widget + network unit tests green. **Not yet device-tested or merged.** |
| **patients**                   | 🟩 | 🟩 | 🟩 | 🟨 | 🟩 | V4 migration; primary patient auto-created at registration; `PatientAccessPolicy` exposed for other modules. **Mobile (Flutter):** patient app shell — 4-tab bottom nav (Home/Appointments/Family/Profile via `StatefulShellRoute.indexedStack`, per-tab back stacks per UI_UX §8.1) + read-only **Profile** (the primary patient from `GET /patients`: identity, DOB/age, sex, contact, blood group, allergies, plus signed-in devices + sign out) and **Family** list (managed family members with empty state). Home greets by first name and shows an appointments placeholder. Now **interactive**: a reusable `PatientFormScreen` adds a family member (`POST /patients`, relationship required ≠ SELF), edits any patient (`PATCH /patients/{id}` — WYSIWYG: blank clears, null leaves unchanged), and removes a family member (`DELETE`, soft; primary patient can't be removed), reached from a Family "+" action / tappable tiles and a Profile "Edit" action; form routes live outside the shell (`/patients/new`, `/patients/:id/edit`). Shared `AppTextField` gained `readOnly`+`onTap` (tappable date-of-birth picker) and `maxLines`. `PatientSex`/`LocalDateConverter` in `shared/`. `flutter analyze` clean; patient-model (incl. request DTO serialization) + Family/Form widget tests green. Device testing deferred. Not merged. |
| **availability**               | 🟩 | 🟩 | 🟩 | ⬜ | 🟩 | V5 migration; rules + blackouts CRUD; `SlotExpansionService` pure function; blackout EXCLUDE-GIST overlap guard. |
| **appointments**               | 🟩 | 🟩 | 🟩 | 🟨 | 🟩 | V6 migration; booking validates via `SlotExpansionService`; state machine + cursor list + reschedule + idempotency; EXCLUDE constraint enforced + asserted. **Mobile (Flutter):** Appointments tab is now interactive — a timeline of upcoming (Requested/Confirmed/In progress) vs past appointments with status chips, pull-to-refresh, and tappable rows. **Book** flow (`POST /appointments` with a generated `Idempotency-Key`): pick patient (primary or a family member) → date → a live slot from `GET /availability` → optional reason, so only real slots are bookable. **Detail** view with the patient's write actions while still open (Requested/Confirmed): **cancel** (`POST /appointments/{id}/transitions` → CANCELLED/PATIENT_CANCELLED) and **reschedule** (`POST /appointments/{id}/reschedule` — same patient/physio kept server-side, so the form is the book form minus the patient picker, with the current date + reason prefilled and live slots; returns a *new* appointment, so the detail replaces itself with the new one's detail). Home's "upcoming" card wired to the next appointment. The shared `SlotPicker` widget is used by both book and reschedule. Booking/detail/reschedule routes live outside the shell (`/appointments/book`, `/appointments/:id`, `/appointments/:id/reschedule`); instants handled UTC→local. Slot models live in the `appointments` feature (booking is the only mobile consumer of availability). `flutter analyze` clean; appointment-model serialization + list/booking-guard/detail/reschedule-guard widget tests green. **Cursor "load more" deferred; device testing deferred. Not merged.** |
| **discussion**                 | 🟨 | 🟨 | 🟨 | 🟨 | 🟨 | V7 + V10 migrations; text messages (read markers, 5-min edit/delete window, cursor list, physio-only INSTRUCTION, CANCELLED/NO_SHOW read-only for patient side); V10 adds `discussion_message_attachments` — `ATTACHMENT_ONLY`/`fileIds[]` wired to `file_objects` with per-patient + `AVAILABLE` + ≤10 checks. Body-only paths 🟩; attachment paths code-complete, integration test (`DiscussionAttachmentIntegrationTest`) pending Docker. **Mobile (Flutter):** appointment-scoped discussion thread (F1.14), opened from the appointment detail screen. Chat-style timeline (newest at the bottom) with day separators — physiotherapist messages incoming/left, patient messages outgoing/right, `INSTRUCTION` as an emphasised accent card; cursor "Load earlier messages" pages older history. Composer posts a patient text as `QUESTION` (`POST .../messages`); the sender can edit/delete *their own* text within the 5-min window (long-press → sheet → `PATCH`/`DELETE`), gated client-side on `senderAccountId == sub` (decoded from the access token via the new `shared/auth/currentAccountIdProvider`) so it never offers a doomed action. The read marker advances to the newest message on open and after posting (`POST .../read`). Composer is hidden behind a read-only notice on CANCELLED/NO_SHOW, mirroring `DiscussionAccessPolicy`. Attachments render as read-only chips (name/type/size); the upload/download bytes flow stays with `files` (F1.15). `flutter analyze` clean; message-serialization + thread (incoming/outgoing/empty/read-only) widget tests green. Home "unread" aggregate (DISCUSSION_SYSTEM_DESIGN §9) + device testing deferred. Not merged. |
| **files**                      | 🟨 | 🟨 | 🟨 | ⬜ | 🟨 | V9 migration; presigned PUT/GET via `FileStorePort` (MinIO adapter, `io.minio` 8.5.14); presign→complete flow with server-side magic-byte + size verification (QUARANTINE on fail); per-mime size caps; daily cap; soft delete blocked while referenced (`FileReferenceGuard` port, implemented by discussion). Storage edge behind a port (tests use in-memory fake). `FileValidationTest` green; integration tests + real MinIO adapter test pending Docker. |
| **treatment_notes**            | 🟨 | 🟨 | 🟨 | 🟨 | 🟨 | V8 migration; one note per appointment (UNIQUE `appointment_id`); PUT-upsert gated on `COMPLETED`; physio-only write, patient read; cursor patient-timeline. Integration tests written; run pending Docker (unavailable in authoring session). **Mobile (Flutter):** patient read view (F1.17) — the physiotherapist's note surfaces read-only on the appointment **detail** screen for `COMPLETED` appointments (`GET /appointments/{id}/treatment_note`) as diagnosis / notes / recovery-instructions / next-review blocks, with an empty state until the physio writes one (the backend `treatment_notes.not_found` 404 maps to a null note in the repository) and an inline retry on load failure. Data layer mirrors `discussion` (api → repository → autoDispose family provider → freezed model). `flutter analyze` clean; model-serialization + section (data/empty/error) widget tests green. Patient-timeline list (`GET /patients/{id}/treatment_notes`) + all physio-side write UI deferred. Device testing deferred. Not merged. |
| **notifications**              | 🟩 | 🟨 | 🟨 | ⬜ | 🟨 | V11 `notification_outbox` (transactional outbox, one row per recipient, payload = IDs only per Hard Rule #4). `NotificationPublisher` writes rows in the caller's tx; wired into booking (REQUESTED/CONFIRMED/CANCELLED), discussion (NEW_MESSAGE), treatment notes (NOTE_ADDED). V13 `fcm_tokens` + `FcmToken`/`FcmTokenService` + `POST /auth/fcm_tokens` (idempotent re-registration keyed on token — read-then-upsert, not race-safe under concurrent same-token POSTs; controller in `notifications/web` to keep `auth` dependency-free). Dispatch runs **claim → send (no tx) → record**: `OutboxTransactions.claimDue` locks due rows SKIP-LOCKED and leases them (`lease-seconds`, default 60) so the FCM call in `OutboxDispatcher` holds no row lock or DB connection; `recordOutcome` finalises each row in its own short tx (SENT / exp-backoff reschedule / DEAD at `maxAttempts`) and retires invalid tokens. A throwing send is isolated per-row — no batch rollback or head-of-line block. `OutboxPoller` (`@Scheduled`, disabled in tests) drives it. Delivery behind `FcmSenderPort`: `FirebaseFcmSender` (firebase-admin) when `HEALYN_FCM_CREDENTIALS_PATH` set, else `LoggingFcmSender`. **Unit tests green** (`NotificationPublisherTest`, `FcmTokenServiceTest`, `OutboxDispatcherTest`, `FirebaseFcmSenderTest`); **integration tests Docker-gated / not yet run** (`FcmTokenIntegrationTest`, `OutboxDispatcherIntegrationTest`). On `feat/auth-module` — **not yet merged to main**. **Remaining**: notification-preferences endpoints (API_STANDARDS §9.8); mobile FCM wiring; run integration suite in CI; prod guard so a missing `HEALYN_FCM_CREDENTIALS_PATH` can't silently fall back to the logging sender. |
| **audit**                      | 🟨 | 🟨 | — | — | 🟨 | V12 `audit.audit_log` (separate schema, append-only; INSERT/SELECT grant role-guarded so it's a no-op in CI). `AuditLogger.record` runs in `REQUIRES_NEW` so it persists from read-only contexts (e.g. file download). Wired write/DOWNLOAD seams: file DOWNLOAD + SOFT_DELETE, discussion CREATE/UPDATE/SOFT_DELETE, treatment-note CREATE/UPDATE, appointment CREATE/UPDATE (+ reschedule). Metadata = IDs only. `AuditLoggerTest` green. **READ-path auditing deferred** to a follow-up (likely a web interceptor) — highest volume, separate pass. API not exposed; service-level only. |
| **common (infra)**             | — | 🟩 | — | ⬜ | 🟩 | Error envelope, validation, logging, ID gen, base entity, JWT security in place. |

---

## 3. Cross-Cutting Tasks

| Task | Status | Notes |
|---|---|---|
| CI pipeline (backend test, mobile test, lint) | ⬜ |  |
| Dockerized local dev (PG + Redis + MinIO) | 🟨 | `docker-compose.yml` committed (postgres:16, redis:7, minio + bucket init). Not brought up this session — dev reused an existing external `pc-*` stack on the same ports. |
| Flyway baseline migrations V1–V13 | 🟦 | V1 extensions, V2 enums, V3 auth, V4 patients, V5 availability, V6 appointments, V7 discussion (messages + read markers), V8 treatment_notes, V9 file_objects, V10 discussion_message_attachments, V11 notification_outbox, V12 audit.audit_log, V13 fcm_tokens applied. No further Phase 1 notification migrations expected (dispatcher is app code). |
| Design tokens implemented in Flutter | 🟨 | `lib/features/shared/design/` — colors, typography, spacing, radii, motion + `HealynTheme` (now incl. `NavigationBarTheme`) from [UI_UX_GUIDELINES.md §12](./UI_UX_GUIDELINES.md#12-implementation-notes-flutter--riverpod). Shared `SectionCard` widget added. Inter font not yet bundled (system default); golden tests pending. |
| Network layer (Dio + interceptors) | 🟨 | `lib/features/shared/network/` — Dio client + `AuthInterceptor` (RS256 bearer, single-flight 401 refresh) + `ApiException` envelope mapping. Unit-tested. |
| Auth token storage (`flutter_secure_storage`) | 🟨 | `TokenStore` + `DeviceIdentity` over `flutter_secure_storage` (Keychain/Keystore); tokens never in plain storage (CLAUDE.md §11). |
| FCM SDK wired in mobile app | 🟨 | `lib/features/shared/push/` — `firebase_core`/`firebase_messaging` (BSD-3-Clause). `PushService` registers the token via `POST /auth/fcm_tokens` after login + on bootstrap, re-registers `onTokenRefresh`, deletes it on logout, and deep-links a tapped data-only push to the appointment by id (`routeForPush`, IDs only per Hard Rule #4). `FcmMessaging` seam keeps it unit-tested; init is guarded so the app runs push-disabled without native config. **Native Firebase project config (google-services.json / APNs / backend service-account) is a per-environment setup step — see README §5.1.** Not merged. |
| Outbox poller + retry policy | 🟩 | `OutboxPoller` (`@Scheduled` fixed-delay) drives a **claim → send-outside-tx → record** sweep (`OutboxTransactions` + `OutboxDispatcher`): SKIP-LOCKED claim with a visibility lease (`lease-seconds`), per-row error isolation, exp backoff (base 2s ×2^n, max 5 → DEAD). Delivery behind `FcmSenderPort`. Unit-tested; integration test Docker-gated. |
| Real FCM adapter (`firebase-admin`) | 🟩 | `FirebaseFcmSender` (data-only messages, IDs only per Hard Rule #4; FCM error→outcome mapping unit-tested). Dependency `com.google.firebase:firebase-admin:9.4.3` (Apache 2.0) added. Activates when `HEALYN_FCM_CREDENTIALS_PATH` is set; otherwise `LoggingFcmSender` is the fallback (`@ConditionalOnProperty`/`@ConditionalOnMissingBean`). Credentials provisioned in dev env. |
| OWASP dependency-check integrated | ⬜ |  |
| ADR set written (5 starting ADRs) | ⬜ |  |
| Onboarding `README.md` setup verified by a new dev | ⬜ |  |

---

## 4. Phase 1 Release Readiness Checklist

Phase 1 ships when **every box in §2 is at least 🟩** for the layers it applies to, **and** every cross-cutting task in §3 is 🟩 or ✅, **and**:

- [ ] All P0 features in [FEATURE_ROADMAP.md §2.1](./FEATURE_ROADMAP.md#21-phase-1-feature-inventory) are 🟩 or ✅.
- [ ] Security review per [SECURITY_GUIDELINES.md §14](./SECURITY_GUIDELINES.md#14-security-review-checklist-per-pr) passed on the release branch.
- [ ] Smoke test: a new account can register → add a family patient → book → message + attach → physio confirms → physio completes + adds note — end-to-end on staging.
- [ ] p95 API latency under 250 ms on staging under simulated 30 concurrent users.
- [ ] Backup + restore drill executed successfully on staging.
- [ ] Runbook for incident response written.

---

## 5. How to Update This File

1. Move squares in the same PR that ships the work. Don't batch.
2. If a square moves to ⛔, fill the Notes column with the blocker and link to the issue.
3. Don't invent new modules here without adding them to [SYSTEM_ARCHITECTURE.md §3](./SYSTEM_ARCHITECTURE.md#3-module-breakdown) first.
4. When a module reaches ✅ in production, leave the row and add it to a "Released" section once §2 is full.

---

## 6. Related Documents

- [FEATURE_ROADMAP.md](./FEATURE_ROADMAP.md) — feature-level scope
- [SYSTEM_ARCHITECTURE.md](./SYSTEM_ARCHITECTURE.md) — module breakdown
- [DEVELOPMENT_RULES.md](./DEVELOPMENT_RULES.md) — what "done" means
