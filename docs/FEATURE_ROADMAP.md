# FEATURE_ROADMAP.md

> What ships when, why, and what is deliberately out of scope.
> If a feature is not listed under Phase 1, it must not appear in Phase 1 code, Phase 1 schema, or Phase 1 UI.

---

## 1. Phasing Philosophy

Healyn ships in three phases. Each phase is a **complete, releasable product** — not a half-built foundation for the next.

| Phase | Goal | Ship Criteria |
|---|---|---|
| **Phase 1 — Clinical Core** | Replace WhatsApp + paper workflow. | A patient can book, message, attach files; the physiotherapist can run their day. |
| **Phase 2 — Revenue & Reach** | Make Healyn revenue-generating and remotely accessible. | Online payments + video consultation work end-to-end. |
| **Phase 3 — Intelligence & Scale** | Make Healyn smarter and multi-physiotherapist-capable. | Analytics, exercise tracking, AI assistant, multi-physio orgs. |

Architecture in Phase 1 must **enable** Phase 2 and Phase 3 without rewrites. It must **not implement** them.

---

## 2. Phase 1 — Clinical Core (MVP)

**Target ship: production-ready for live single-clinic operation.**

### 2.1 Phase 1 Feature Inventory

| # | Feature | Priority | Owner Module |
|---|---|---|---|
| F1.1 | Account registration (email / mobile + OTP) | P0 | `auth` |
| F1.2 | Login with JWT (access + refresh) | P0 | `auth` |
| F1.3 | Password reset via OTP | P0 | `auth` |
| F1.4 | Device session management (list & revoke) | P1 | `auth` |
| F1.5 | Primary Patient profile (auto-created with Account) | P0 | `patients` |
| F1.6 | Add / edit / archive Family Member Patients | P0 | `patients` |
| F1.7 | Switch active Patient context in mobile app | P0 | `patients` |
| F1.8 | View physiotherapist availability (slots) | P0 | `appointments` |
| F1.9 | Book appointment for a selected Patient | P0 | `appointments` |
| F1.10 | Reschedule / cancel appointment (patient-side) | P0 | `appointments` |
| F1.11 | Physiotherapist confirms / rejects / completes appointments | P0 | `appointments` |
| F1.12 | Today's schedule view (physiotherapist) | P0 | `appointments` |
| F1.13 | Appointment history (per Patient) | P0 | `appointments` |
| F1.14 | Appointment-scoped discussion thread | P0 | `discussion` |
| F1.15 | File attachments on discussion messages (PDF / JPG / PNG) | P0 | `discussion` + `files` |
| F1.16 | Physiotherapist instructions message type | P0 | `discussion` |
| F1.17 | Treatment notes per appointment | P0 | `treatment-notes` |
| F1.18 | Push notifications via FCM (confirmations, reminders, new replies) | P0 | `notifications` |
| F1.19 | Audit log for clinical data access | P1 | `audit` |
| F1.20 | Mobile app offline read cache (today's schedule, last 5 appointments) | P2 | `mobile-core` |
| F1.21 | Unified appointment + treatment timeline (physiotherapist & patient) | P1 | `appointments` |
| F1.22 | Global appointment search (by Appointment Number) | P2 | `appointments` |

**Priority legend:** P0 = must ship to release Phase 1. P1 = strongly desired but releasable without. P2 = nice to have.

> **Booking model note (F1.8–F1.13):** booking is **request-first** — the patient requests a date (no self-assigned time) and the physiotherapist assigns/confirms the final date and time, reschedules, and creates follow-ups. This refines the listed features; it does not add new scope. See [APPOINTMENT_FLOW.md](./APPOINTMENT_FLOW.md).
>
> **Household address note (F1.5–F1.6):** the account captures one **household postal
> address** at registration (`account_addresses`, keyed by account), shared across the
> primary patient and every family member and surfaced to the physiotherapist for
> communication and records. This refines the existing profile-capture P0 features
> (F1.5 primary profile, F1.6 family members); it adds a field, **not** new scope. See
> [DATABASE_SCHEMA.md §3.5a](./DATABASE_SCHEMA.md) and [API_STANDARDS.md §9.2](./API_STANDARDS.md#92-patients).
>
> **Identifiers & lifecycle note (F1.5–F1.6, F1.9–F1.13, F1.21–F1.22):** appointments and patients carry human-readable **business IDs** (Appointment Number `PHY-YYYYMMDD-NNNN`, Patient ID `PAT-NNNNNN`) alongside their UUID primary keys; the UUID is never exposed to users. Appointments gain **parent-child lineage** (reschedules / follow-ups / reviews link to a lineage root) and an append-only **`appointment_events`** timeline. The ID and lineage work refines existing P0 features; the events table is the realization of the §4 Phase-3 enabler *"all clinical writes already produce a domain event"* (pulled forward, **not** new scope). The unified timeline (F1.21) and Appointment-Number search (F1.22) are new P1/P2 surfaces over that data. See [APPOINTMENT_FLOW.md](./APPOINTMENT_FLOW.md).

### 2.2 Phase 1 Acceptance Criteria

Phase 1 is **done** when **all P0 features** are:

- Implemented end-to-end (DB, backend, API, mobile, tests).
- Covered by automated tests at the levels defined in [DEVELOPMENT_RULES.md](./DEVELOPMENT_RULES.md).
- Passing a security review per [SECURITY_GUIDELINES.md](./SECURITY_GUIDELINES.md).
- Documented in [API_STANDARDS.md](./API_STANDARDS.md) (every endpoint listed).
- Demonstrably meeting the success metrics in [PROJECT_CONTEXT.md §8](./PROJECT_CONTEXT.md#8-success-metrics).

### 2.3 Out of Phase 1 (explicit)

These are **forbidden** in Phase 1 code:

- Video / audio calls of any kind.
- Online payments, invoices, GST, insurance.
- In-app chat outside an appointment.
- Exercise libraries, video tutorials, gamified streaks.
- Multi-physiotherapist support (the schema must allow it; the UI and APIs must not).
- Patient-to-patient messaging.
- Public reviews, ratings, referrals.
- Web/desktop builds (Flutter web/desktop targets are deferred).
- Admin dashboard. (Backend admin tasks are run via CLI / migration.)
- Analytics SDKs that touch PHI.

---

## 3. Phase 2 — Revenue & Reach

**Target: 3–6 months after Phase 1 GA.**

| # | Feature | Notes |
|---|---|---|
| F2.1 | Online payments at booking time | Payment gateway integration; idempotent booking + payment flow. |
| F2.2 | Refunds and partial refunds | Tied to cancellation policy. |
| F2.3 | Video consultation (1:1) | WebRTC or vendor SDK; sessions tied to appointments. |
| F2.4 | Web build of patient app | Same Flutter codebase; responsive layout. |
| F2.5 | iOS build | Same Flutter codebase; APNs in addition to FCM. |
| F2.6 | Email notifications (in addition to FCM) | For receipts, reminders. |
| F2.7 | Calendar export (ICS) | For patient calendars. |
| F2.8 | Configurable cancellation / no-show policy | Replaces hard-coded rules. |

**Phase 1 architectural enablers required:**

- Payment status field exists on `appointments` but is always `NOT_REQUIRED` in Phase 1.
- Storage interface abstracts S3 so video recordings can land in the same bucket structure.
- Notification dispatcher is channel-agnostic (FCM is the only channel in Phase 1; email/APNs slot in).
- API versioning (`/api/v1/...`) is in place from day one — see [API_STANDARDS.md](./API_STANDARDS.md).

---

## 4. Phase 3 — Intelligence & Scale

**Target: 9–18 months after Phase 1 GA. Subject to product-market validation.**

| # | Feature | Notes |
|---|---|---|
| F3.1 | Analytics dashboard for the physiotherapist | Aggregates on anonymized data; no PHI in event streams. |
| F3.2 | Exercise tracking + adherence reminders | Patient logs reps/sets; reminders via FCM. |
| F3.3 | AI assistant (treatment-note draft, summary) | Server-side LLM call; PHI redacted before send if vendor is external. |
| F3.4 | Multi-physiotherapist support | Schema gains `clinic_id` and `physiotherapist_id` (already nullable-ready in Phase 1). |
| F3.5 | Patient referrals / sharing of profiles between physiotherapists | Requires consent flow. |
| F3.6 | Wearable integration (Fitbit / Apple Health) | Adds `wearable_data` ingestion service. |

**Phase 1 architectural enablers required:**

- `physiotherapist_id` column exists on `appointments` and `treatment_notes` (defaulted to the single physio in Phase 1).
- Event bus / outbox table exists from Phase 1 (used in Phase 1 only for FCM dispatch and audit).
- All clinical writes already produce a domain event — analytics in Phase 3 reads from the event stream, not from operational tables.

---

## 5. Priority Classification Matrix

How to decide whether to do something *now* vs. *later*.

| Priority | Definition | Examples |
|---|---|---|
| **P0** | Must ship in the current phase. Removal breaks the value proposition. | Booking, discussion, files |
| **P1** | Strongly desired in current phase. Releasable without it if blocked. | Device session list, audit log |
| **P2** | Nice to have in current phase. First to be cut if scope slips. | Offline read cache |
| **P3** | Belongs in a later phase. Not implemented now even if "easy". | Payments, video |
| **OUT** | Forbidden in current phase. Architecture should not even hint at it. | Reviews, chat, admin UI |

---

## 6. Scope-Drift Guardrails

These are the questions to ask **before** accepting a new feature into Phase 1:

1. Is it a P0 in §2.1? → If yes, build it.
2. Does it block ship of an existing P0? → If yes, build it; promote to P0.
3. Is it a P1/P2 in §2.1? → Build only if all P0 are code-complete.
4. Is it in Phase 2 or Phase 3? → **Reject for Phase 1.** Add an architectural enabler if needed (see §3 / §4) but do not build the feature.
5. Is it not listed anywhere? → **Reject.** Open a discussion to add it to the roadmap before writing code.

---

## 7. Related Documents

- [PROJECT_CONTEXT.md](./PROJECT_CONTEXT.md) — why the product exists
- [SYSTEM_ARCHITECTURE.md](./SYSTEM_ARCHITECTURE.md) — how modules map to features
- [MODULE_STATUS_TRACKER.md](./MODULE_STATUS_TRACKER.md) — live status per module
