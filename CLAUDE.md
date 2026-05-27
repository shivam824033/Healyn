# CLAUDE.md

> Project-specific instructions for Claude Code (and any AI coding assistant) working in this repository.
> These rules **override** general defaults and complement the engineering standards in [docs/DEVELOPMENT_RULES.md](./docs/DEVELOPMENT_RULES.md).

---

## 1. Read This First

Healyn is a **production healthcare application** handling Protected Health Information.
Treat every change with the care you would give a real medical device's software.

Before making any change, you must have read or be willing to consult:

1. [docs/PROJECT_CONTEXT.md](./docs/PROJECT_CONTEXT.md) — vocabulary and scope boundaries.
2. [docs/SYSTEM_ARCHITECTURE.md](./docs/SYSTEM_ARCHITECTURE.md) — module structure.
3. [docs/SECURITY_GUIDELINES.md](./docs/SECURITY_GUIDELINES.md) — the security floor.
4. [docs/DEVELOPMENT_RULES.md](./docs/DEVELOPMENT_RULES.md) — coding & PR rules.

If your task touches a domain area, also read the relevant deep-dive doc (`APPOINTMENT_FLOW.md`, `DISCUSSION_SYSTEM_DESIGN.md`, `PATIENT_RELATIONSHIP_MODEL.md`, `FILE_STORAGE_GUIDELINES.md`).

---

## 2. Hard Rules (do not violate)

| # | Rule |
|---|---|
| 1 | **Never** add a feature outside [FEATURE_ROADMAP.md](./docs/FEATURE_ROADMAP.md) Phase 1 P0/P1/P2 unless explicitly instructed. Items marked OUT or P3 are forbidden. |
| 2 | **Never** add authentication / authorization logic in controllers. Use the policy classes (`PatientAccessPolicy`) called from services. |
| 3 | **Never** log passwords, OTP codes, JWTs, refresh tokens, patient names, message bodies, or file contents. |
| 4 | **Never** put PHI in FCM notification payloads. Payloads carry IDs only. |
| 5 | **Never** make S3 objects public. Always presigned URLs with TTL ≤ 5 minutes. |
| 6 | **Never** allow `appointment_id` on discussion messages to be nullable. |
| 7 | **Never** hard-delete clinical data (`appointments`, `discussion_messages`, `treatment_notes`, `file_objects`). Soft-delete only. |
| 8 | **Never** drop a column or table in a Flyway migration without explicit human approval in the PR. |
| 9 | **Never** introduce a new dependency without checking license (Apache 2.0 / MIT / BSD only) and CVE history. |
| 10 | **Never** check in a real secret. Use `.env.example` placeholders. |
| 11 | **Never** skip the PR checklist in [docs/DEVELOPMENT_RULES.md §5](./docs/DEVELOPMENT_RULES.md#5-pull-request-checklist). |
| 12 | **Never** invent a new module / top-level package without first updating [docs/SYSTEM_ARCHITECTURE.md §3](./docs/SYSTEM_ARCHITECTURE.md#3-module-breakdown). |

---

## 3. Vocabulary (use exactly these terms)

When generating code, docs, or messages, use the canonical vocabulary from [docs/PROJECT_CONTEXT.md §9](./docs/PROJECT_CONTEXT.md#9-vocabulary-canonical-terms):

| Use | Don't use |
|---|---|
| Account | User, Customer |
| Patient | Profile, Person |
| Primary Patient | Self, Owner |
| Family Member Patient | Dependent, Sub-user |
| Physiotherapist | Doctor, Clinician, Provider |
| Appointment | Booking, Visit, Slot (a Slot is the time atom, not the appointment) |
| Discussion | Chat, Conversation, Thread (a thread *is* an appointment) |
| Treatment Note | Diagnosis, Report, Chart |
| Attachment | File (attachment is the relation; File is the stored bytes) |

---

## 4. Where to Put New Code

| If you're adding... | Put it in... |
|---|---|
| A new REST endpoint | `backend/src/main/java/com/healyn/<module>/web/` |
| A new service method | `backend/src/main/java/com/healyn/<module>/service/` |
| A new domain entity / VO | `backend/src/main/java/com/healyn/<module>/domain/` |
| A new repository / JPA query | `backend/src/main/java/com/healyn/<module>/repository/` |
| A new access policy | `backend/src/main/java/com/healyn/<module>/policy/` |
| An external adapter | `backend/src/main/java/com/healyn/<module>/adapter/` |
| A DB change | `backend/src/main/resources/db/migration/V<n>__<name>.sql` |
| A Flutter feature | `mobile/lib/features/<feature>/{data,domain,presentation}/` |
| A shared widget | `mobile/lib/features/shared/widgets/` |
| A design token | `mobile/lib/features/shared/design/` |
| A doc update | `docs/<EXISTING>.md` (don't create new top-level docs without asking) |

---

## 5. Code Style Conventions

- **Java**: records for DTOs, sealed interfaces for closed type families, constructor injection only, no field injection, no `null` outside repositories (use `Optional`).
- **Dart / Flutter**: Riverpod 2.x; `freezed` for models; `dio` for HTTP; feature-first layout; `analysis_options.yaml` is the law.
- **SQL**: `snake_case`, lowercase keywords, every FK has an index, every PHI table has `deleted_at`.
- **Naming**: see [docs/DEVELOPMENT_RULES.md §2](./docs/DEVELOPMENT_RULES.md#2-coding-standards) for full details.

---

## 6. Default Output Style

- Be terse. State the change, then make it.
- Don't produce essay-length explanations for routine edits.
- When implementing from a spec, **link** to the relevant doc section in commit messages.
- Don't add inline comments restating what code already says. Comment **why**, not **what**.

---

## 7. When to Ask vs. Decide

Decide unilaterally:
- File placement (per §4).
- Naming within established conventions.
- Test additions for changed behavior.
- Doc updates that reflect what you just changed.

Ask first:
- Anything that drops a column or table.
- Adding a new top-level module or package.
- Adding a new third-party dependency.
- Anything that changes the security model.
- Anything that affects Phase 2/3 enablers.
- A pattern that conflicts with an existing one elsewhere in the repo.

---

## 8. Commit & PR Conventions

- **Conventional Commits** — `feat(scope): subject` / `fix(scope): subject` / etc. Full grammar in [docs/DEVELOPMENT_RULES.md §4](./docs/DEVELOPMENT_RULES.md#4-commit-conventions).
- Each PR fills the checklist in [docs/DEVELOPMENT_RULES.md §5](./docs/DEVELOPMENT_RULES.md#5-pull-request-checklist).
- One logical change per PR. Sprawling PRs are split.

---

## 9. Testing Defaults

If a change is non-trivial, **add tests**:

- New service method → unit test for happy path + a meaningful failure path.
- New endpoint → integration test for 2xx and at least one 4xx response.
- New widget → widget test; if it has visual states, a golden test.
- New migration → migration-test runs against a fresh PG container in CI.

Coverage targets and tools: [docs/DEVELOPMENT_RULES.md §7](./docs/DEVELOPMENT_RULES.md#7-testing-expectations).

---

## 10. Running Things Locally

```
docker compose up -d           # PG + Redis + MinIO
cd backend && ./gradlew bootRun
cd mobile && flutter run
```

Full setup: [README.md §5](./README.md#5-first-time-setup).

If a command needs interactive auth (e.g., `gcloud auth login`), don't run it — suggest the user run it via `! <command>` in the prompt.

---

## 11. Things That Are Easy to Get Wrong

These are the historical foot-guns of healthcare apps. Don't:

- Treat an Account as a Patient. They are different. See [docs/PATIENT_RELATIONSHIP_MODEL.md](./docs/PATIENT_RELATIONSHIP_MODEL.md).
- Allow a global "chat" between patient and physio. There is no chat outside an appointment.
- Use offset pagination. Always cursor-based.
- Use HS256 JWTs. Always RS256.
- Cache PHI in `SharedPreferences` / unencrypted local storage. Use `flutter_secure_storage` for tokens; Hive for non-PHI UI cache only.
- Make a notification carry a patient name or message body. IDs only.
- Trust the client's `mime_type` claim. Always magic-byte verify server-side.
- Build slots as a stored table. Slots are computed; rules + blackouts + appointments are stored.

---

## 12. When You Find Drift Between Docs and Code

In the same PR, fix one of them — preferably the code so it matches the doc, unless the doc was wrong. Drift is a bug.

---

## 13. Out of Scope for Claude in This Repo

Don't:

- Generate frontend mockups in Figma format.
- Generate marketing copy or App Store listings.
- Make architectural decisions that contradict existing ADRs.
- Add CI workflows without coordinating with the existing pipeline definitions.

---

## 14. Related

- [README.md](./README.md) — public entry point
- [docs/](./docs/) — the full architecture library
