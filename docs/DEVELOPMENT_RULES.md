# DEVELOPMENT_RULES.md

> The engineering rules of engagement for Healyn.
> They apply to every commit, every PR, every reviewer. Disagreements are resolved by amending this document, not by ignoring it.

---

## 1. Repository Layout

```
Healyn/
├── README.md
├── CLAUDE.md
├── docs/                       # All architecture documentation
├── backend/                    # Spring Boot 3.x, Java 21
│   ├── src/main/java/com/healyn/
│   │   ├── auth/
│   │   ├── patients/
│   │   ├── appointments/
│   │   ├── discussion/
│   │   ├── files/
│   │   ├── notifications/
│   │   ├── treatment_notes/
│   │   ├── audit/
│   │   └── common/
│   ├── src/main/resources/
│   │   └── db/migration/
│   ├── src/test/
│   └── build.gradle.kts
├── mobile/                     # Flutter (Android-first), Riverpod 2.x
│   ├── lib/
│   │   ├── app/
│   │   ├── features/
│   │   │   ├── auth/
│   │   │   ├── patients/
│   │   │   ├── appointments/
│   │   │   ├── discussion/
│   │   │   ├── files/
│   │   │   ├── notifications/
│   │   │   ├── treatment_notes/
│   │   │   └── shared/
│   │   └── main.dart
│   ├── test/
│   ├── integration_test/
│   └── pubspec.yaml
├── infra/                      # IaC (Terraform), deploy scripts
├── .github/workflows/          # CI definitions
└── .gitignore
```

Backend and mobile share the repo (monorepo). Builds are independent; CI runs both.

---

## 2. Coding Standards

### 2.1 Java (backend)

- **Java 21**, language level 21 in Gradle.
- Use **records** for DTOs and value objects.
- Use **sealed interfaces** for closed type families (e.g., domain events).
- `Optional` for return types that can legitimately be absent; never for fields, never for parameters.
- No `null` in domain code outside repository return paths. Surface absence as `Optional`.
- Constructor injection only. Field injection is forbidden.
- One public type per file.
- Static analyzer: **Spotbugs** + **Error Prone** + **Checkstyle** with Google Java Style.
- Format: `spotless` enforced; PR build fails on unformatted code.

### 2.2 Dart / Flutter (mobile)

- Latest stable Flutter and Dart.
- **Riverpod 2.x** for state management. No `setState` outside trivial leaf widgets.
- `freezed` for immutable models + unions; `json_serializable` for DTOs.
- `dio` as HTTP client; one configured instance behind a `NetworkClient`.
- Feature folder layout: `data/`, `domain/`, `presentation/`.
- `analysis_options.yaml`: extends `package:flutter_lints/flutter.yaml` plus strict rules (`prefer_const_constructors`, `avoid_print`, `always_use_package_imports`, `prefer_single_quotes`).
- One widget per file unless tightly coupled.
- Public widget APIs documented in a one-line `///` doc.

### 2.3 SQL

- Lowercase keywords (`select`, `from`) optional — adopt one style and lint.
- Tables, columns, indexes lowercase `snake_case`.
- Every new migration runs `pg_format --check` in CI.

### 2.4 General

- Comments only for non-obvious **why**. Self-documenting code beats commentary.
- File length: aim < 400 lines. Refactor when a file owns multiple concerns.
- Function length: aim < 40 lines. Split when it can be tested in pieces.
- No commented-out code in main branch.

---

## 3. Branching Strategy

Git Flow Lite:

```
main          ← protected; always deployable to prod
develop       ← protected; always deployable to dev
  ├── feat/<short-slug>     ← new features
  ├── fix/<short-slug>      ← bug fixes
  ├── chore/<short-slug>    ← non-functional
  ├── refactor/<short-slug> ← internal restructuring
  └── docs/<short-slug>     ← docs only
hotfix/<short-slug>          ← branches off main, merges to main + develop
release/<version>            ← cut from develop when preparing a release
```

Rules:

- `main` and `develop` accept merges via PR only. No direct pushes. Linear history (squash or rebase merge).
- Feature branches live ≤ 5 working days. Long-lived branches are a smell.
- Force-pushes are allowed on feature branches; forbidden on `main` and `develop`.
- Tags are signed: `v1.0.0`, `v1.0.1-hotfix.1`, etc. Semver.

---

## 4. Commit Conventions

**Conventional Commits.** Every commit message:

```
<type>(<scope>): <subject>

<optional body>

<optional footer>
```

| Type | Use |
|---|---|
| `feat` | A user-visible feature |
| `fix` | A bug fix |
| `refactor` | Internal change without behavior change |
| `perf` | Performance improvement |
| `docs` | Documentation only |
| `test` | Tests only |
| `chore` | Build, deps, tooling |
| `style` | Whitespace / formatting only |
| `revert` | Revert of a prior commit |

Scope is the module: `auth`, `appointments`, `discussion`, `mobile-ui`, `db`, `ci`.

Subject: imperative, lowercase, no trailing period, ≤ 72 chars.

Example:

```
feat(appointments): enforce exclusion constraint for confirmed overlaps

Adds the btree_gist exclusion constraint on (physiotherapist_id, time range)
to guarantee at most one confirmed/in-progress appointment per overlapping
window. Service-layer check kept as a fast path for friendlier 409s.

Refs: APPOINTMENT_FLOW.md §4
```

Breaking changes: `feat!: ...` or footer `BREAKING CHANGE: ...`.

---

## 5. Pull Request Checklist

Every PR must answer **yes** to all that apply, in the description:

### Functional
- [ ] Linked to an issue or scope item from [FEATURE_ROADMAP.md](./FEATURE_ROADMAP.md).
- [ ] If it's a P3/OUT item, explicitly justified in description.
- [ ] Description explains the *why*, not just the *what*.

### Tests
- [ ] Unit tests added or updated for changed behavior.
- [ ] Integration tests cover at least the happy path of any new endpoint.
- [ ] No reduction in coverage below the targets in §7.

### API & Schema
- [ ] If endpoints changed, [API_STANDARDS.md](./API_STANDARDS.md) catalogue updated.
- [ ] If DB changed, a forward-only Flyway migration is added.
- [ ] No destructive migrations (`DROP COLUMN`, `DROP TABLE`) without explicit approval.

### Security
- [ ] PR passes the [SECURITY_GUIDELINES.md §14 checklist](./SECURITY_GUIDELINES.md#14-security-review-checklist-per-pr).
- [ ] No new secret committed. New env vars added to `.env.example`.

### UX
- [ ] Screens conform to [UI_UX_GUIDELINES.md](./UI_UX_GUIDELINES.md).
- [ ] Golden tests updated if visuals changed.

### Operational
- [ ] No new third-party dependency without license + CVE check.
- [ ] CI green: build, tests, static analysis.

PRs missing any of these get a single review comment pointing to this section, not a line-by-line review.

---

## 6. Code Review Rules

- One reviewer minimum; two for changes to `auth`, `patients`, `appointments` (clinical-critical).
- Reviewer responds within one working day or assigns a backup.
- Discussion is in the PR, not DMs.
- A reviewer who has **questions** asks them. A reviewer who has **opinions** writes them as suggestions, not blocks.
- "Approve with comments" is acceptable for non-blocking nits.
- The author owns merge. The author squashes or rebases per convention.

---

## 7. Testing Expectations

### 7.1 Backend

| Layer | Tool | Coverage target |
|---|---|---|
| Unit (services, policies) | JUnit 5 + AssertJ + Mockito | **80%+ line, 70%+ branch** on `service/` and `policy/` |
| Integration (controllers, repos) | Spring Boot Test + Testcontainers (PG, Redis, MinIO) | All endpoints have at least one 2xx and one 4xx test |
| Contract | RestAssured against the running app | All Phase 1 endpoints |
| Migration | Flyway dry-run against a fresh PG container | Every migration |

### 7.2 Mobile

| Layer | Tool | Coverage target |
|---|---|---|
| Unit (use cases, providers) | `flutter_test` | **70%+** on `domain/` |
| Widget | `flutter_test` | All shared components in `features/shared/widgets/` |
| Golden | `golden_toolkit` | Status pills, buttons, cards |
| Integration | `integration_test` | Login → book → cancel happy path |

### 7.3 What We Don't Test

- Framework internals.
- One-line getters / setters.
- Generated code (freezed, json_serializable).

Coverage is a floor, not a goal. A 100% covered function that asserts the wrong thing is worthless.

---

## 8. CI / CD

CI pipeline (`.github/workflows/`):

```
on push (any branch), on PR:
  - backend-lint        (spotless + checkstyle)
  - backend-test        (unit + integration with Testcontainers)
  - backend-security    (OWASP dep-check, spotbugs)
  - mobile-lint         (dart analyze)
  - mobile-test         (flutter test)
  - mobile-golden       (golden_toolkit)
  - migration-dry-run   (flyway validate against fresh PG)

on push to develop:
  - all above
  - build backend Docker image, push to registry
  - flutter build apk (debug), upload artifact
  - deploy backend to dev
  - run smoke tests

on tag v*:
  - all above
  - deploy backend to prod (manual approval gate)
  - flutter build appbundle (release, signed)
  - distribute to Play Console internal track
```

A red CI blocks merge. No exceptions for "I'll fix it after merge."

---

## 9. Dependency Management

- Renovate bot opens PRs for updates weekly.
- Major version bumps require a code-review and a test pass; not auto-merged.
- New dependency requires: a license check (Apache 2.0 / MIT / BSD only; LGPL on a case basis; GPL forbidden), a CVE history check, and the reviewer's blessing in the PR.
- Pin exact versions in `build.gradle.kts` and `pubspec.yaml`. No `^` or `+` wildcards on direct dependencies.

---

## 10. Local Development

### 10.1 Prerequisites

| Tool | Version |
|---|---|
| JDK | 21 |
| Gradle | (wrapper) |
| Docker | latest |
| Flutter | latest stable |
| PostgreSQL client | 16 |
| Node (for tooling) | 20+ |

### 10.2 First-Time Setup

```
git clone <repo>
cp .env.example .env          # fill in pepper, JWT key path, etc.
docker compose up -d           # starts PG, Redis, MinIO
cd backend && ./gradlew bootRun
cd mobile && flutter pub get && flutter run
```

### 10.3 Day-to-Day

- Backend hot reload via `./gradlew bootRun --continuous`.
- Mobile hot reload via Flutter's `r` / `R` keys.
- DB inspection via any client (pgAdmin, TablePlus, DBeaver).
- MinIO console at `http://localhost:9001`.

---

## 11. Documentation Discipline

- Each module owns a short `README.md` inside its source folder with: purpose, key types, externally-visible endpoints (link to `API_STANDARDS.md`).
- ADRs (Architecture Decision Records) live in `docs/adr/NNNN-title.md` when a decision deserves explanation. Phase 1 starting set: ADRs for "Riverpod over Bloc", "S3-compatible over Cloudinary", "Cursor pagination over offset", "Argon2id parameters", "Outbox pattern over message queue".
- When code drifts from docs, **fix one or the other** in the same PR. Drift is bug.

---

## 12. Release Process

1. Cut `release/<version>` from `develop`.
2. Bump versions: backend `gradle.properties`, mobile `pubspec.yaml` (semver).
3. Update `CHANGELOG.md`.
4. Open a PR: `release/<version>` → `main`.
5. After merge, tag `vX.Y.Z` and back-merge `main` → `develop`.
6. CI deploys backend to prod (manual approval). Mobile build is distributed to internal track first.
7. After 24 h of soak, promote mobile to production track.

Hotfix:

1. Branch `hotfix/<slug>` from `main`.
2. Fix + test.
3. PR to `main`. After merge, tag `vX.Y.(Z+1)`.
4. Back-merge `main` → `develop`.

---

## 13. Anti-Patterns

- **Do not** introduce a new dependency for a job a few lines of code would solve.
- **Do not** rename modules or top-level packages without an ADR.
- **Do not** disable lints with `// noinspection ...` or `// ignore:` without a comment explaining why.
- **Do not** push commits that leave the build red, even on feature branches in shared CI.
- **Do not** add a flag to skip tests "temporarily."

---

## 14. Related Documents

- [README.md](../README.md) — entry point for new contributors
- [API_STANDARDS.md](./API_STANDARDS.md) — what endpoints look like
- [SECURITY_GUIDELINES.md](./SECURITY_GUIDELINES.md) — PR security checklist
- [MODULE_STATUS_TRACKER.md](./MODULE_STATUS_TRACKER.md) — live module state
