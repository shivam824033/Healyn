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
| **auth**                       | 🟩 | 🟩 | 🟩 | ⬜ | 🟩 | V3 migration; register/login/refresh/sessions/password-reset; integration + unit tests. |
| **patients**                   | 🟩 | 🟩 | 🟩 | ⬜ | 🟩 | V4 migration; primary patient auto-created at registration; `PatientAccessPolicy` exposed for other modules. |
| **availability**               | 🟩 | 🟩 | 🟩 | ⬜ | 🟩 | V5 migration; rules + blackouts CRUD; `SlotExpansionService` pure function; blackout EXCLUDE-GIST overlap guard. |
| **appointments**               | 🟩 | 🟩 | 🟩 | ⬜ | 🟩 | V6 migration; booking validates via `SlotExpansionService`; state machine + cursor list + reschedule + idempotency; EXCLUDE constraint enforced + asserted. |
| **discussion**                 | 🟨 | 🟨 | 🟨 | ⬜ | 🟨 | V7 + V10 migrations; text messages (read markers, 5-min edit/delete window, cursor list, physio-only INSTRUCTION, CANCELLED/NO_SHOW read-only for patient side); V10 adds `discussion_message_attachments` — `ATTACHMENT_ONLY`/`fileIds[]` wired to `file_objects` with per-patient + `AVAILABLE` + ≤10 checks. Body-only paths 🟩; attachment paths code-complete, integration test (`DiscussionAttachmentIntegrationTest`) pending Docker. |
| **files**                      | 🟨 | 🟨 | 🟨 | ⬜ | 🟨 | V9 migration; presigned PUT/GET via `FileStorePort` (MinIO adapter, `io.minio` 8.5.14); presign→complete flow with server-side magic-byte + size verification (QUARANTINE on fail); per-mime size caps; daily cap; soft delete blocked while referenced (`FileReferenceGuard` port, implemented by discussion). Storage edge behind a port (tests use in-memory fake). `FileValidationTest` green; integration tests + real MinIO adapter test pending Docker. |
| **treatment_notes**            | 🟨 | 🟨 | 🟨 | ⬜ | 🟨 | V8 migration; one note per appointment (UNIQUE `appointment_id`); PUT-upsert gated on `COMPLETED`; physio-only write, patient read; cursor patient-timeline. Integration tests written; run pending Docker (unavailable in authoring session). |
| **notifications**              | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | FCM credentials provisioned in dev env. |
| **audit**                      | ⬜ | ⬜ | — | — | ⬜ | API not exposed; service-level only. Future seam: `PatientAccessPolicy` already isolates access checks. |
| **common (infra)**             | — | 🟩 | — | ⬜ | 🟩 | Error envelope, validation, logging, ID gen, base entity, JWT security in place. |

---

## 3. Cross-Cutting Tasks

| Task | Status | Notes |
|---|---|---|
| CI pipeline (backend test, mobile test, lint) | ⬜ |  |
| Dockerized local dev (PG + Redis + MinIO) | ⬜ |  |
| Flyway baseline migrations V1–V10 | 🟦 | V1 extensions, V2 enums, V3 auth, V4 patients, V5 availability, V6 appointments, V7 discussion (messages + read markers), V8 treatment_notes, V9 file_objects, V10 discussion_message_attachments applied. `notification_outbox` and `audit.audit_log` still pending. |
| Design tokens implemented in Flutter | ⬜ | See [UI_UX_GUIDELINES.md §12](./UI_UX_GUIDELINES.md#12-implementation-notes-flutter--riverpod) |
| Network layer (Dio + interceptors) | ⬜ |  |
| Auth token storage (`flutter_secure_storage`) | ⬜ |  |
| FCM SDK wired in mobile app | ⬜ |  |
| Outbox poller + retry policy | ⬜ |  |
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
