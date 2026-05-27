# PROJECT_CONTEXT.md

> The canonical source of truth for **what Healyn is, why it exists, and what it must never become**.
> Every architecture decision in the rest of the docs flows from this file.

---

## 1. Product One-Liner

**Healyn is a premium, mobile-first patient management application for a single physiotherapist running a single clinic.**

It is the digital front door for patients to book appointments, share medical files, and communicate with their physiotherapist — and the operational backbone for the physiotherapist to manage their schedule, patient records, and treatment notes.

---

## 2. Vision

> A patient should be able to book an appointment in under **30 seconds** and never wonder whether the clinic received it.
> The physiotherapist should start every workday knowing exactly who is coming, why, and what was discussed last time — without opening five tools.

Healyn replaces the WhatsApp + paper + memory workflow with a calm, secure, premium application that feels like a healthcare product, not a CRUD form.

---

## 3. Goals

### Primary Goals (Phase 1)

1. **Frictionless booking.** Patient opens the app → sees available slots → confirms → done. No call-backs, no double-booking.
2. **One account, many patients.** A single login can manage the user's own appointments and those of family members (parents, spouse, children, dependents).
3. **Secure clinical communication.** Every appointment carries a private discussion thread for questions, instructions, and file exchange. Files are encrypted in transit and at rest.
4. **Operational clarity for the physiotherapist.** A single screen shows today's schedule, urgent unread discussions, and pending pre-visit files.
5. **Healthcare-grade security.** Argon2id passwords, RS256 JWTs, presigned S3 uploads, audit logs on clinical data access. See [SECURITY_GUIDELINES.md](./SECURITY_GUIDELINES.md).

### Secondary Goals (still Phase 1)

- Push notifications for confirmations, reminders, and new discussion replies via Firebase Cloud Messaging.
- Treatment notes and recovery instructions attached to each appointment.
- An offline-tolerant mobile experience for read paths (today's schedule, past notes).

### Explicit Non-Goals

| Non-Goal | Rationale |
|---|---|
| Multi-clinic / multi-tenant SaaS | Healyn is a **single-tenant** product. Any multi-clinic ambition is a different product. |
| Practo / Lybrate clone | Healyn is not a marketplace. No discovery, no reviews, no inter-clinic search. |
| Hospital ERP, billing, insurance claims | Out of scope forever (until proven otherwise). |
| General chat / messaging | Discussion is **appointment-scoped only**. See [DISCUSSION_SYSTEM_DESIGN.md](./DISCUSSION_SYSTEM_DESIGN.md). |
| Telehealth video calls (Phase 1) | Deferred to Phase 2. Architecture must not block it. See [FEATURE_ROADMAP.md](./FEATURE_ROADMAP.md). |
| Payments / online checkout (Phase 1) | Deferred to Phase 2. |

---

## 4. Scope Boundaries

```
┌─────────────────────────────────────────────────────────────┐
│                      HEALYN PHASE 1                         │
│                                                             │
│   ┌─────────────┐     ┌───────────────────────────────┐     │
│   │  Mobile App │ ◀──▶│   Spring Boot REST API        │     │
│   │  (Flutter)  │     │   PostgreSQL · S3 · FCM       │     │
│   └─────────────┘     └───────────────────────────────┘     │
│                                                             │
│   Auth · Patients · Appointments · Discussion · Files       │
│   Treatment Notes · Notifications                           │
└─────────────────────────────────────────────────────────────┘
```

**In scope:** the boxes above. **Out of scope:** anything not listed in §3 primary/secondary goals.

---

## 5. Users & Roles

Healyn has exactly **two role types**. There is no admin role, no super-user, no marketplace operator.

### 5.1 Patient Account Holder (`ROLE_ACCOUNT`)

A login-bearing user who manages one or more **Patient** records.

- The account itself is **not** a clinical entity. It is an authentication identity.
- An account always has at least one Patient (themselves, the "primary patient").
- An account may also manage additional Patients: parents, spouse, children, dependents.
- Each Patient has independent appointments, files, and discussion threads. The account holder sees all of them in a single inbox.

See [PATIENT_RELATIONSHIP_MODEL.md](./PATIENT_RELATIONSHIP_MODEL.md) for the data model and access rules.

### 5.2 Physiotherapist (`ROLE_PHYSIO`)

A single user — the clinic owner. There is exactly **one** physiotherapist account in the system in Phase 1.

- Sees every patient, every appointment, every discussion.
- Manages availability, confirms/rejects bookings, writes treatment notes.
- Cannot be self-registered. Provisioned via a backend admin task on first deployment.

---

## 6. Core Business Logic (canonical rules)

These rules are non-negotiable. They are the constitution of the system.

1. **Identity ≠ Patient.** An `account` row authenticates; a `patient` row receives care. They are linked via `account_patients`.
2. **Every appointment belongs to exactly one Patient.** Never to an Account directly.
3. **A Patient may have at most one `CONFIRMED` or `IN_PROGRESS` appointment in any time window** that overlaps the physiotherapist's schedule. The DB enforces this. See [APPOINTMENT_FLOW.md](./APPOINTMENT_FLOW.md).
4. **The physiotherapist owns their calendar.** Bookings start as `REQUESTED` and require an explicit `CONFIRMED` transition (manual or via auto-confirm rules). No appointment is binding until confirmed.
5. **Discussion is appointment-scoped.** A discussion message without an `appointment_id` is invalid. There is no DMing the physiotherapist outside an appointment.
6. **Files attach to a discussion message, never standalone.** This guarantees every file has a clinical context.
7. **Audit everything clinical.** Reads and writes of treatment notes, files, and discussion messages are logged with `actor_account_id`, `timestamp`, `action`, `resource_id`.
8. **Soft-delete clinical data.** `deleted_at` columns; never `DELETE` rows containing PHI in Phase 1.

---

## 7. Constraints

### 7.1 Scale Targets

| Dimension | Target |
|---|---|
| Total patients (lifetime) | 10,000+ |
| Concurrent active users | ~30 |
| Peak bookings / day | ~50 |
| Discussion messages / day | ~300 |
| File uploads / day | ~80 |
| p95 API latency | < 250 ms |
| Mobile cold-start to interactive | < 2.0 s |

These numbers shape choices: a single PostgreSQL instance is sufficient (no sharding), but indexes and query plans matter. See [DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md).

### 7.2 Compliance & Privacy

- Clinical data is **PHI** (Protected Health Information). Treat it as such even if the jurisdiction does not strictly require HIPAA/GDPR-grade controls.
- All clinical reads are auditable.
- File URLs are **always** short-lived presigned URLs. No public bucket access.
- No third-party analytics SDK touches PHI. Analytics, if added, runs on anonymized event streams.

### 7.3 Operational

- Android-first. iOS and web are future deliverables, but architecture must not assume a single platform.
- Non-technical clinic staff must be able to operate the physiotherapist app. No CLI, no SQL, no logs in the UI.
- The clinic may have intermittent connectivity. Read paths degrade gracefully; write paths fail loudly and retry.

### 7.4 Tech Stack (locked)

| Layer | Choice |
|---|---|
| Mobile | Flutter (Android first), Riverpod 2.x for state |
| Backend | Spring Boot 3.x (Java 21) |
| Database | PostgreSQL 16 |
| Auth | JWT (RS256), refresh tokens, Argon2id passwords |
| File storage | S3-compatible (AWS S3 / MinIO / Cloudflare R2) with presigned URLs |
| Push notifications | Firebase Cloud Messaging |
| Transport | HTTPS only, TLS 1.2+ |

See [SYSTEM_ARCHITECTURE.md](./SYSTEM_ARCHITECTURE.md) for how these fit together.

---

## 8. Success Metrics

Healyn is successful when, in steady-state operation:

| Metric | Target |
|---|---|
| Median time from app-open to confirmed booking | < 30 s |
| % of appointments with at least one discussion message | > 60% |
| % of patients with file attached before first visit | > 40% |
| % of bookings that result in a no-show | < 5% |
| Physiotherapist daily app sessions | 2+ (morning + end-of-day) |
| App store rating | ≥ 4.6 |
| Critical security incidents | 0 |

---

## 9. Vocabulary (canonical terms)

Used consistently across all documentation and code. Any divergence is a bug.

| Term | Meaning |
|---|---|
| **Account** | Auth-bearing login identity. Has email/phone, password, JWT. |
| **Patient** | A person who receives care. May or may not have a login. |
| **Primary Patient** | The Patient associated with the Account holder themselves. |
| **Family Member Patient** | A Patient managed by an Account on someone else's behalf. |
| **Physiotherapist** | The single clinic owner. Role = `ROLE_PHYSIO`. |
| **Appointment** | A scheduled session between a Patient and the Physiotherapist. |
| **Slot** | A unit of the physiotherapist's available time (e.g., 30-minute block). |
| **Discussion** | The thread of messages attached to an Appointment. |
| **Treatment Note** | The physiotherapist's clinical record attached to an Appointment. |
| **Attachment** | A file (PDF/JPG/PNG) attached to a Discussion message. |

---

## 10. Related Documents

- [FEATURE_ROADMAP.md](./FEATURE_ROADMAP.md) — what ships when
- [SYSTEM_ARCHITECTURE.md](./SYSTEM_ARCHITECTURE.md) — how it's built
- [DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md) — the data model
- [PATIENT_RELATIONSHIP_MODEL.md](./PATIENT_RELATIONSHIP_MODEL.md) — accounts ↔ patients
- [APPOINTMENT_FLOW.md](./APPOINTMENT_FLOW.md) — booking lifecycle
- [DISCUSSION_SYSTEM_DESIGN.md](./DISCUSSION_SYSTEM_DESIGN.md) — appointment-scoped messaging
- [SECURITY_GUIDELINES.md](./SECURITY_GUIDELINES.md) — security posture
