# SYSTEM_ARCHITECTURE.md

> The structural blueprint of Healyn. Read this once before writing any code.
> Every module, boundary, and integration described here is a contract.

---

## 1. Architectural Principles

1. **Layered, not entangled.** Mobile → API gateway → service layer → repository → DB. No layer skips downward; no layer reaches sideways.
2. **Feature-first on mobile.** Each feature is a self-contained Flutter folder with its own data/domain/presentation layers.
3. **Domain-driven on backend.** Each bounded context (`auth`, `patients`, `availability`, `appointments`, `discussion`, `files`, `notifications`, `treatment-notes`, `audit`) is a top-level package with its own controller / service / repository / domain model.
4. **Ports & adapters at the edges.** External systems (S3, FCM, SMS/email OTP) are accessed through interfaces. The implementation is swappable; the call site is not.
5. **Stateless application servers.** All state lives in PostgreSQL, S3, or Redis (cache + token blacklist). Any application instance can serve any request.
6. **Single source of truth for time.** All timestamps are stored as `TIMESTAMPTZ` in UTC. Clients render in the user's local timezone.
7. **Fail loudly, recover gracefully.** A booking that hits a conflict returns `409` immediately. A failed FCM dispatch is queued and retried via the outbox.
8. **Idempotency at write boundaries.** Booking, payment (Phase 2), and external dispatch operations accept an `Idempotency-Key` header.

---

## 2. High-Level Topology

```
                          ┌─────────────────────────────────┐
                          │       Mobile (Flutter)          │
                          │   Patient + Physio in one app   │
                          │   Riverpod · Dio · Hive cache   │
                          └────────────────┬────────────────┘
                                           │ HTTPS (TLS 1.2+)
                                           │ JWT access token
                                           ▼
                          ┌─────────────────────────────────┐
                          │   API Gateway (NGINX / ALB)     │
                          │   TLS termination · rate limit  │
                          └────────────────┬────────────────┘
                                           │
                       ┌───────────────────┴───────────────────┐
                       │                                       │
              ┌────────▼────────┐                     ┌────────▼────────┐
              │ Spring Boot App │   (horizontally     │ Spring Boot App │
              │     (stateless) │    scalable)        │    (stateless)  │
              └────────┬────────┘                     └────────┬────────┘
                       │                                       │
                       └───────────────────┬───────────────────┘
                                           │
            ┌──────────────────┬───────────┴────────────┬────────────────────┐
            ▼                  ▼                        ▼                    ▼
   ┌────────────────┐ ┌────────────────┐ ┌────────────────────┐ ┌────────────────────┐
   │ PostgreSQL 16  │ │ Redis 7        │ │  S3-compatible     │ │  Firebase Cloud    │
   │ Primary + RO   │ │ Cache + tokens │ │  Object Storage    │ │  Messaging (FCM)   │
   │ Replica        │ │ Rate limiter   │ │  Presigned URLs    │ │                    │
   └────────────────┘ └────────────────┘ └────────────────────┘ └────────────────────┘
```

For Phase 1's load profile (~30 concurrent users, ~50 bookings/day) a **single Spring Boot instance** behind NGINX is sufficient. The diagram shows the production target, which is reachable by changing replica count — no code change required.

---

## 3. Module Breakdown

### 3.1 Backend Modules (Spring Boot packages)

Each module is a top-level Java package: `com.healyn.<module>`.

| Module | Responsibility | Key Entities | Talks To |
|---|---|---|---|
| `auth` | Registration, login, OTP, JWT issue/refresh, device sessions | `Account`, `DeviceSession`, `OtpChallenge` | Redis (token blacklist), SMS/email OTP adapter |
| `patients` | Patient CRUD, account↔patient links, relationships | `Patient`, `AccountPatient` | `auth` (account context) |
| `availability` | Physiotherapist availability rules, blackout windows, slot expansion (pure-function `SlotExpansionService` consumed by `appointments`) | `AvailabilityRule`, `BlackoutWindow` | `auth` (physio account) |
| `appointments` | Booking, state-machine transitions, reschedule, cursor-paginated listing, idempotency on book | `Appointment` | `patients` (access policy), `availability` (slot validation), `discussion`, `notifications`, `treatment-notes` |
| `discussion` | Appointment-scoped messages, 5-min edit/delete window, cursor list, per-account read markers, unread count | `DiscussionMessage`, `DiscussionReadMarker` | `appointments`, `patients` (access policy), `files` (attachments — deferred), `notifications` |
| `files` | Presigned upload/download URLs, file validation | `FileObject` | S3 adapter, `discussion`, `treatment-notes` |
| `treatment-notes` | Physiotherapist's clinical notes per appointment | `TreatmentNote` | `appointments`, `files` |
| `notifications` | Outbound notification dispatch (FCM in Phase 1) | `NotificationOutbox`, `FcmToken` | FCM adapter, all modules (via events) |
| `audit` | Clinical access audit log (append-only) | `AuditLogEntry` | Called explicitly by modules via `AuditLogger` (REQUIRES_NEW); a web interceptor for READ paths is a later add |
| `common` | Shared types, exception mapper, JSON config, validation | (cross-cutting) | — |

### 3.2 Mobile Modules (Flutter features)

Each feature folder under `lib/features/<feature>/` has the same internal layout:

```
features/
  auth/
    data/        # API client, DTOs, local storage
    domain/      # Entities, use cases, repository interfaces
    presentation/ # Screens, widgets, Riverpod providers
  patients/
  appointments/
  discussion/
  files/
  notifications/
  treatment_notes/
  home/          # Patient landing (greeting, upcoming, unread roll-up)
  patient_shell/ # Patient 4-tab bottom-nav frame
  physio/        # Physiotherapist app: shell + Today/Patients/Availability/Profile
  shared/        # Design system, network, auth/JWT, error handling
```

The app is **role-aware**: the access token's `role` claim selects the patient
experience (`patient_shell` over the domain features) or the physiotherapist
experience (`physio/`). The router enforces the partition (see `shared/router`).

The Riverpod provider graph is the only cross-feature communication channel. Features do not import each other's `data/` or `presentation/`; they may import the other's `domain/` interfaces (rare).

---

## 4. Service Interactions

### 4.1 Booking Sequence (happy path)

```
Patient App         API              appointments     discussion     notifications     FCM
   │                 │                    │                │              │             │
   │ POST /bookings  │                    │                │              │             │
   ├────────────────▶│                    │                │              │             │
   │                 │ create(req)        │                │              │             │
   │                 ├───────────────────▶│                │              │             │
   │                 │                    │ verify slot    │              │             │
   │                 │                    │ INSERT row     │              │             │
   │                 │                    │ emit event     │              │             │
   │                 │                    ├───────────────▶│              │             │
   │                 │                    │                │ seed thread  │             │
   │                 │                    ├───────────────────────────────▶│            │
   │                 │                    │                │              │ enqueue     │
   │                 │ 201 Created        │                │              │             │
   │◀────────────────┤                    │                │              │             │
   │                 │                    │                │              │  send push  │
   │                 │                    │                │              ├────────────▶│
   │                 │                    │                │              │             │
   │  push notif     │                    │                │              │             │
   │◀──────────────────────────────────────────────────────────────────────────────────│
```

Details and edge cases live in [APPOINTMENT_FLOW.md](./APPOINTMENT_FLOW.md).

### 4.2 File Upload Sequence

```
Mobile         API           files        S3
  │             │              │           │
  │ POST /files/presign        │           │
  ├────────────▶│              │           │
  │             │ validate     │           │
  │             ├─────────────▶│           │
  │             │              │ sign PUT  │
  │             │              ├──────────▶│
  │             │              │◀──────────┤
  │ presignedUrl + fileId      │           │
  │◀────────────┤              │           │
  │             │              │           │
  │ PUT bytes directly to S3                                          │
  ├──────────────────────────────────────────▶│
  │◀──────────────────────────────────────────┤
  │             │              │           │
  │ POST /discussions/{id}/messages          │
  │ (attach fileId)                          │
  ├────────────▶│              │           │
  │             │ verify file exists in S3 │
  │             ├─────────────▶│           │
  │             │              ├──────────▶│
  │             │              │◀──────────┤
  │ 201 Created │              │           │
  │◀────────────┤              │           │
```

Details: [FILE_STORAGE_GUIDELINES.md](./FILE_STORAGE_GUIDELINES.md).

### 4.3 Notification Dispatch (Outbox Pattern)

```
Domain action ──▶ INSERT notification_outbox row ──▶ same DB tx
                                                       │
                                       ┌───────────────┘
                                       ▼
                            Outbox poller (every 2s)
                                       │
                                       ▼
                              dispatch via FCM adapter
                                       │
                          success ──▶ UPDATE status=SENT
                          failure ──▶ retry with backoff (max 5)
```

This guarantees: **no event is lost, no event is sent twice, and the domain transaction is never coupled to FCM availability.**

---

## 5. Scalability Design

### 5.1 Phase 1 Sizing

| Resource | Phase 1 Spec | Headroom |
|---|---|---|
| App instance | 1× (2 vCPU, 4 GB RAM) | Vertical to 4 vCPU before horizontal scale |
| PostgreSQL | 1× managed (2 vCPU, 8 GB RAM, 100 GB SSD) | Add read replica before partitioning |
| Redis | 1× managed (1 GB) | Sufficient through Phase 2 |
| S3 bucket | 1× region | Lifecycle to cold storage after 24 months |

### 5.2 Scaling Triggers

| Signal | Action |
|---|---|
| App p95 latency > 250ms sustained | Add second app instance behind NGINX |
| DB CPU > 60% sustained | Add read replica; route read-only endpoints |
| `appointments` table > 1M rows | Partition by `scheduled_at` month (see [DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md)) |
| `discussion_messages` > 5M rows | Partition by `created_at` month |
| FCM dispatch backlog > 1 min | Scale outbox poller; split topic per priority |

### 5.3 What Phase 1 Does *Not* Need

- Message queues (Kafka / RabbitMQ): the DB-backed outbox is sufficient.
- Service mesh / multi-service split: one Spring Boot binary is the right size.
- CDN: only mobile assets benefit; presigned S3 URLs are direct.
- Search engine: PostgreSQL `pg_trgm` handles the few text-search needs (patient name lookup).

These are documented as *enablers*: when triggered, they slot in cleanly.

---

## 6. Security Architecture (overview)

Full details in [SECURITY_GUIDELINES.md](./SECURITY_GUIDELINES.md). Architecture-level facts:

- **All ingress is TLS 1.2+.** HTTP redirects to HTTPS at the gateway; HSTS enforced.
- **JWT (RS256)** for stateless auth. Public key cached by app instances; private key in a secret manager.
- **Refresh tokens** are opaque, stored hashed in Redis, single-use (rotate on every refresh).
- **Authorization** is enforced at the service layer (`@PreAuthorize` + a policy class per resource type). Controllers never make policy decisions.
- **File access** is mediated by short-lived presigned URLs (5-minute TTL). S3 buckets are private.
- **Secrets** (DB password, JWT private key, pepper, FCM service account) live in the cloud secret manager. They are never in source, never in env files committed to git.
- **Audit log** is append-only and stored in a separate schema (`audit.*`). Application role has `INSERT` only on this schema.

---

## 7. Deployment Topology

### 7.1 Environments

| Env | Purpose | Data |
|---|---|---|
| `local` | Developer laptop | Docker Compose: PG, Redis, MinIO. Seeded fake data. |
| `dev` | Shared dev environment | Real cloud infra, seeded fake data. Auto-deploys from `develop`. |
| `staging` | Pre-prod | Mirrors prod sizing. Anonymized prod snapshot weekly. |
| `prod` | Live clinic | Real PHI. Manual approval gate before deploy. |

### 7.2 CI/CD Outline

```
push → build (gradle test, flutter test)
     → static analysis (spotbugs, dart analyze, owasp dep-check)
     → container image (backend)
     → Flutter Android build (.aab signed)
     → deploy backend to env
     → run migration (Flyway) with --validate-on-migrate
     → smoke tests
     → distribute mobile build (Play Console / TestFlight)
```

Specifics in [DEVELOPMENT_RULES.md](./DEVELOPMENT_RULES.md).

---

## 8. Data Stores

| Store | What lives there | Why |
|---|---|---|
| **PostgreSQL** | All structured domain data, outbox, audit log | ACID, mature, JSON support for flexible fields |
| **Redis** | JWT refresh token hash, OTP challenges, rate-limit counters, presence flags | Fast TTL-based storage |
| **S3-compatible** | All file blobs (PDF, JPG, PNG) | Cheap, scalable, presigned-URL native |
| **Mobile local (Hive)** | Read-only cache: today's schedule, last appointments, design tokens | Offline tolerance |

Nothing else. No DynamoDB, no Mongo, no Elastic in Phase 1.

---

## 9. External Integrations

| Integration | Phase 1 Use | Adapter Location | Failure Behavior |
|---|---|---|---|
| **FCM** | Push notifications | `notifications/adapter/FcmDispatcher` | Outbox retries up to 5× with exp backoff |
| **S3-compatible** | File storage | `files/adapter/S3FileStore` | 5xx surfaces to client; upload retried by app |
| **SMS provider** (e.g., Twilio / MSG91) | OTP delivery | `auth/adapter/SmsOtpSender` | Falls back to email if both channels enrolled |
| **Email provider** (e.g., SES / Postmark) | OTP delivery, password reset | `auth/adapter/EmailOtpSender` | Same as SMS |

Each integration sits behind a Java interface in `<module>/port/` with the implementation in `<module>/adapter/`. Tests use in-memory fakes.

---

## 10. Cross-Cutting Concerns

| Concern | Implementation |
|---|---|
| **Logging** | SLF4J + Logback JSON encoder; `traceId` per request via MDC |
| **Tracing** | OpenTelemetry instrumentation; OTLP export to vendor of choice |
| **Metrics** | Micrometer → Prometheus endpoint at `/actuator/prometheus` |
| **Health** | `/actuator/health` (liveness + readiness probes) |
| **Configuration** | Spring profiles per env; secrets from secret manager via Spring Cloud Config or env mounts |
| **Error handling** | One `@ControllerAdvice` translates exceptions to the standard error envelope ([API_STANDARDS.md](./API_STANDARDS.md)) |
| **Validation** | Bean Validation (`jakarta.validation`) on request DTOs |
| **Migrations** | Flyway with versioned SQL in `src/main/resources/db/migration/V<n>__<name>.sql` |

---

## 11. Related Documents

- [DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md) — the data model these modules operate on
- [API_STANDARDS.md](./API_STANDARDS.md) — how modules are exposed to mobile
- [SECURITY_GUIDELINES.md](./SECURITY_GUIDELINES.md) — depth on the security architecture
- [APPOINTMENT_FLOW.md](./APPOINTMENT_FLOW.md), [DISCUSSION_SYSTEM_DESIGN.md](./DISCUSSION_SYSTEM_DESIGN.md), [PATIENT_RELATIONSHIP_MODEL.md](./PATIENT_RELATIONSHIP_MODEL.md) — domain-specific deep dives
