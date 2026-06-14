# Healyn

> A premium, mobile-first patient management application for a single physiotherapist running a single clinic.

Healyn replaces the WhatsApp + paper + memory workflow of a busy clinic with a calm, secure, healthcare-grade application that patients and the physiotherapist both find easy to use. The patient books an appointment in under 30 seconds. The physiotherapist starts each workday knowing exactly who is coming, why, and what was discussed last time — without opening five tools.

This repository contains:

- The **Spring Boot** backend (Java 21).
- The **Flutter** mobile application (Android-first, Riverpod 2.x).
- The PostgreSQL schema, migrations, infrastructure scripts, and all architecture documentation.

---

## 1. Quick Links

| | |
|---|---|
| Product vision & scope | [docs/PROJECT_CONTEXT.md](./docs/PROJECT_CONTEXT.md) |
| What ships when | [docs/FEATURE_ROADMAP.md](./docs/FEATURE_ROADMAP.md) |
| System architecture | [docs/SYSTEM_ARCHITECTURE.md](./docs/SYSTEM_ARCHITECTURE.md) |
| Database schema | [docs/DATABASE_SCHEMA.md](./docs/DATABASE_SCHEMA.md) |
| API contract | [docs/API_STANDARDS.md](./docs/API_STANDARDS.md) |
| Security posture | [docs/SECURITY_GUIDELINES.md](./docs/SECURITY_GUIDELINES.md) |
| UI / UX system | [docs/UI_UX_GUIDELINES.md](./docs/UI_UX_GUIDELINES.md) |
| Engineering rules | [docs/DEVELOPMENT_RULES.md](./docs/DEVELOPMENT_RULES.md) |
| Live module status | [docs/MODULE_STATUS_TRACKER.md](./docs/MODULE_STATUS_TRACKER.md) |
| Claude Code conventions for this repo | [CLAUDE.md](./CLAUDE.md) |

A complete list of architecture documents lives in [docs/](./docs/).

---

## 2. Tech Stack

| Layer | Choice |
|---|---|
| Mobile | Flutter (Android first, web/iOS later), **Riverpod 2.x**, Dio, Hive |
| Backend | Spring Boot 3.x on **Java 21** |
| Database | **PostgreSQL 16** with btree_gist, pg_trgm, citext |
| Cache / sessions | Redis 7 |
| File storage | **S3-compatible** (AWS S3 / Cloudflare R2 / MinIO) with presigned URLs |
| Auth | JWT (RS256) + refresh rotation, Argon2id passwords |
| Push notifications | Firebase Cloud Messaging |
| Migrations | Flyway |
| CI | GitHub Actions |

See [docs/SYSTEM_ARCHITECTURE.md](./docs/SYSTEM_ARCHITECTURE.md) for the full topology.

---

## 3. Repository Layout

```
Healyn/
├── README.md                ← this file
├── CLAUDE.md                ← Claude Code conventions for this repo
├── docs/                    ← architecture documentation (15 files)
├── backend/                 ← Spring Boot service
│   ├── src/main/java/com/healyn/
│   ├── src/main/resources/db/migration/
│   ├── src/test/
│   └── build.gradle.kts
├── mobile/                  ← Flutter app
│   ├── lib/
│   │   ├── app/
│   │   ├── features/
│   │   └── main.dart
│   ├── test/
│   ├── integration_test/
│   └── pubspec.yaml
├── infra/                   ← IaC + deploy scripts
└── .github/workflows/       ← CI definitions
```

Module breakdown: [docs/SYSTEM_ARCHITECTURE.md §3](./docs/SYSTEM_ARCHITECTURE.md#3-module-breakdown).

---

## 4. Prerequisites

| Tool | Version |
|---|---|
| JDK | **21** |
| Gradle | Provided via wrapper |
| Docker + Docker Compose | latest |
| Flutter | latest stable |
| PostgreSQL client | 16 (`psql`) |
| Node.js | 20+ (tooling only) |

---

## 5. First-Time Setup

Healyn expects you already run PostgreSQL 16, Redis 7, and MinIO locally (any container or native install works). The defaults below match the standard dev stack — override via `.env` if your setup differs.

```bash
# 1. Clone
git clone <repo-url>
cd Healyn

# 2. Configure environment
cp .env.example .env
# Edit .env if your local PG/Redis/MinIO ports or credentials differ from the defaults.
# At minimum set HEALYN_PASSWORD_PEPPER and the JWT key paths before Phase B (auth).

# 3. Make sure your local services are reachable
#    Expected defaults (override via .env):
#      PostgreSQL : localhost:5432   user=postgres   pass=postgres
#      Redis      : localhost:6379   (no auth)
#      MinIO      : localhost:9000   minioadmin / minioadmin

# 4. Create the Healyn database and MinIO bucket (one-time)
psql -h localhost -U postgres -c "CREATE DATABASE healyn"
mc alias set local http://localhost:9000 minioadmin minioadmin
mc mb --ignore-existing local/healyn-files-dev

# 5. Build & run the backend
cd backend
./gradlew bootRun
#  ↳ Flyway runs migrations automatically on startup.
#  ↳ API on http://localhost:8080  ·  Health: http://localhost:8080/actuator/health

# 6. (Later) Run the mobile app
cd mobile
flutter pub get
flutter run
#  ↳ requires an Android emulator or connected device
```

Once running, the backend exposes `/actuator/health` and the API is documented per [docs/API_STANDARDS.md](./docs/API_STANDARDS.md).

### 5.1 Push notifications (FCM) — optional, for real delivery

The mobile app and backend are fully wired for push, but delivery is **dormant until you supply
Firebase config** — the app degrades to push-disabled when it is absent, so the steps below are only
needed to receive real notifications on a device. Config files are per-environment and **gitignored**
(`google-services.json`, `GoogleService-Info.plist`, the backend service-account JSON) — never commit them.

```text
A. Firebase project
   console.firebase.google.com → Add project (e.g. "Healyn").

B. Android app (easiest: FlutterFire CLI — it places config + patches Gradle)
   npm i -g firebase-tools && firebase login
   dart pub global activate flutterfire_cli
   cd mobile && flutterfire configure      # pick the project; package = com.healyn.healyn
   # ↳ downloads android/app/google-services.json, generates lib/firebase_options.dart,
   #   and adds the com.google.gms.google-services Gradle plugin.
   # If a build complains about SDK level, set minSdk = 23 in android/app/build.gradle.kts.

C. iOS (needs a Mac + Apple Developer account)
   - Add the iOS app in Firebase; drop GoogleService-Info.plist into the ios/Runner target.
   - Create an APNs Auth Key (.p8) in the Apple Developer portal → upload under
     Firebase → Project settings → Cloud Messaging → APNs.
   - Xcode → Signing & Capabilities → add Push Notifications + Background Modes (Remote notifications).

D. Backend sender credential (so the server can SEND)
   Firebase → Project settings → Service accounts → Generate new private key.
   Save to backend/secrets/fcm-service-account.json (gitignored) and set in .env:
     HEALYN_FCM_CREDENTIALS_PATH=./secrets/fcm-service-account.json
   Restart the backend → FirebaseFcmSender activates (else it logs only).

E. Verify end-to-end
   Run the backend (credential set) and `flutter run --dart-define=HEALYN_API_BASE_URL=...`
   on a REAL device or a Google-APIs emulator (FCM needs Google Play services; the iOS
   simulator can't receive push). Log in → grant the permission → a row lands in fcm_tokens.
   Book/confirm an appointment → the device receives a data-only push → tapping it opens
   that appointment (payloads carry IDs only, per the PHI rule).
```

### 5.2 Physiotherapist account

There is **no physiotherapist self-registration** — the clinic owner is the single `ROLE_PHYSIO`
account (PROJECT_CONTEXT §5.2). In `local`/`dev` profiles the backend seeds one automatically on
startup (`DevPhysioSeeder`) so the physio app is reachable; sign in with:

```text
email:    physio@healyn.local           (override: HEALYN_DEV_PHYSIO_EMAIL)
password: Physio!Dev123                 (override: HEALYN_DEV_PHYSIO_PASSWORD)
```

The seed is idempotent and **never runs in prod**. The dev password above is a placeholder, not a
real secret.

In prod the physiotherapist is provisioned by an operator via the one-off `PhysioBootstrapRunner`.
You cannot hand-write the `accounts` row: `PasswordHasher` mixes a server-side pepper
(`HEALYN_PASSWORD_PEPPER`) into every hash, so an offline-generated Argon2id hash will never match
at login. The account must be created in-process with the live hasher. To provision:

1. Set in your secret manager (alongside the existing `HEALYN_PASSWORD_PEPPER`):

   ```text
   HEALYN_BOOTSTRAP_PHYSIO_ENABLED=true
   HEALYN_BOOTSTRAP_PHYSIO_EMAIL=<owner email>
   HEALYN_BOOTSTRAP_PHYSIO_PASSWORD=<strong temporary password>
   ```

2. Deploy / restart once. The runner creates the `ROLE_PHYSIO` account (idempotent — it skips if
   the email already exists) without logging the password.
3. Log in and **rotate the temporary password** via the password-reset flow.
4. Set `HEALYN_BOOTSTRAP_PHYSIO_ENABLED=false` and delete the `HEALYN_BOOTSTRAP_PHYSIO_PASSWORD`
   secret.

### 5.3 File uploads from a device (presigned-URL host)

Attachments upload **directly to storage** using a presigned URL the backend mints. The host in
that URL must be one the **device** can reach — not the backend's view of MinIO. With the default
`HEALYN_S3_ENDPOINT=http://localhost:9000`, a phone or emulator signs requests to *its own*
`localhost`, so the PUT fails and the app shows an upload error even though the API call succeeded.

Set `HEALYN_S3_PUBLIC_ENDPOINT` to a host the device reaches (leave blank only when the client runs
on the same host as MinIO):

```bash
# Physical device on your LAN — your machine's IP (must match where MinIO is bound):
HEALYN_S3_PUBLIC_ENDPOINT=http://192.168.1.20:9000
# Android emulator — the host loopback alias:
HEALYN_S3_PUBLIC_ENDPOINT=http://10.0.2.2:9000
```

The backend keeps using `HEALYN_S3_ENDPOINT` for its own object operations (stat/read/delete), so
the two can differ (e.g. `minio:9000` inside Docker vs. a LAN IP for devices). Restart the backend
after changing it. This is the same host the mobile `--dart-define=HEALYN_API_BASE_URL` should point
the API at — keep them consistent.

---

## 6. Day-to-Day Development

| Action | Command |
|---|---|
| Run backend with hot reload | `cd backend && ./gradlew bootRun --continuous` |
| Run backend tests | `cd backend && ./gradlew test` |
| Run mobile app | `cd mobile && flutter run` |
| Run mobile tests | `cd mobile && flutter test` |
| Run integration tests (mobile) | `cd mobile && flutter test integration_test` |
| Generate freezed / json models | `cd mobile && dart run build_runner build --delete-conflicting-outputs` |
| Apply DB migrations | `cd backend && ./gradlew flywayMigrate` |
| Reset local DB | `docker compose down -v && docker compose up -d` |
| Lint backend | `cd backend && ./gradlew spotlessCheck` |
| Lint mobile | `cd mobile && dart analyze` |
| Format backend | `cd backend && ./gradlew spotlessApply` |
| Format mobile | `cd mobile && dart format .` |

---

## 7. Development Workflow

1. Pick a task from [docs/MODULE_STATUS_TRACKER.md](./docs/MODULE_STATUS_TRACKER.md) or an issue.
2. Branch from `develop`: `feat/<short-slug>`, `fix/<short-slug>`, etc. — see [docs/DEVELOPMENT_RULES.md §3](./docs/DEVELOPMENT_RULES.md#3-branching-strategy).
3. Implement + test locally. Conform to [docs/DEVELOPMENT_RULES.md §2](./docs/DEVELOPMENT_RULES.md#2-coding-standards) and [docs/UI_UX_GUIDELINES.md](./docs/UI_UX_GUIDELINES.md).
4. Update relevant docs in the same PR (drift is bug).
5. Open a PR against `develop`. Fill the [PR checklist](./docs/DEVELOPMENT_RULES.md#5-pull-request-checklist).
6. After review and green CI, squash-merge.
7. Move your row in [docs/MODULE_STATUS_TRACKER.md](./docs/MODULE_STATUS_TRACKER.md).

---

## 8. Testing

Coverage targets and tooling: [docs/DEVELOPMENT_RULES.md §7](./docs/DEVELOPMENT_RULES.md#7-testing-expectations).

Quick reference:

| Layer | Tool |
|---|---|
| Backend unit | JUnit 5 + AssertJ + Mockito |
| Backend integration | Spring Boot Test + Testcontainers (PG, Redis, MinIO) |
| Mobile unit / widget | `flutter_test` |
| Mobile golden | `golden_toolkit` |
| Mobile integration | `integration_test` |

---

## 9. Environments

| Env | Purpose | Data |
|---|---|---|
| `local` | Developer laptop | Docker Compose, seeded fakes |
| `dev` | Shared dev | Real cloud infra, fake data |
| `staging` | Pre-prod | Mirrors prod sizing; anonymized prod snapshot weekly |
| `prod` | Live clinic | Real PHI; manual approval gate before deploy |

CI / deploy pipeline: [docs/DEVELOPMENT_RULES.md §8](./docs/DEVELOPMENT_RULES.md#8-ci--cd).

---

## 10. Security

Healyn handles Protected Health Information. The security posture is non-negotiable:

- Argon2id passwords with per-user salt and environment-side pepper.
- RS256 JWTs (15-minute access) + single-use refresh rotation.
- Presigned S3 URLs with 5-minute TTL; buckets are private.
- All PHI access audited to an append-only schema.

Full standard: [docs/SECURITY_GUIDELINES.md](./docs/SECURITY_GUIDELINES.md). Every PR runs through the security checklist there.

---

## 11. Documentation Index

All documents are in [docs/](./docs/):

1. [PROJECT_CONTEXT.md](./docs/PROJECT_CONTEXT.md) — vision, scope, vocabulary
2. [SYSTEM_ARCHITECTURE.md](./docs/SYSTEM_ARCHITECTURE.md) — modules and topology
3. [FEATURE_ROADMAP.md](./docs/FEATURE_ROADMAP.md) — phases and priorities
4. [MODULE_STATUS_TRACKER.md](./docs/MODULE_STATUS_TRACKER.md) — live status matrix
5. [DATABASE_SCHEMA.md](./docs/DATABASE_SCHEMA.md) — PostgreSQL schema
6. [SECURITY_GUIDELINES.md](./docs/SECURITY_GUIDELINES.md) — security posture
7. [API_STANDARDS.md](./docs/API_STANDARDS.md) — REST conventions + endpoint catalogue
8. [UI_UX_GUIDELINES.md](./docs/UI_UX_GUIDELINES.md) — design system
9. [DEVELOPMENT_RULES.md](./docs/DEVELOPMENT_RULES.md) — engineering process
10. [FILE_STORAGE_GUIDELINES.md](./docs/FILE_STORAGE_GUIDELINES.md) — file handling
11. [APPOINTMENT_FLOW.md](./docs/APPOINTMENT_FLOW.md) — booking lifecycle
12. [PATIENT_RELATIONSHIP_MODEL.md](./docs/PATIENT_RELATIONSHIP_MODEL.md) — account / patient model
13. [DISCUSSION_SYSTEM_DESIGN.md](./docs/DISCUSSION_SYSTEM_DESIGN.md) — appointment-scoped messaging

Plus [CLAUDE.md](./CLAUDE.md) at the repo root: conventions for AI-assisted contributions.

---

## 12. Contributing

This is a single-tenant production product, not an open-source project. Contributions are limited to the project team.

When you contribute:

- Read [docs/DEVELOPMENT_RULES.md](./docs/DEVELOPMENT_RULES.md) before your first PR.
- Read [docs/SECURITY_GUIDELINES.md](./docs/SECURITY_GUIDELINES.md) before touching anything in `auth/`, `patients/`, `files/`, or anything that handles PHI.
- Update [docs/MODULE_STATUS_TRACKER.md](./docs/MODULE_STATUS_TRACKER.md) when your work changes module status.

---

## 13. License

Proprietary. All rights reserved.
