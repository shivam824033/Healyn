# APPOINTMENT_FLOW.md

> The end-to-end lifecycle of a Healyn appointment: from "patient taps slot" to "physio marks completed".
> The state machine, the conflict-prevention math, and the timezone rules described here are **load-bearing**. Deviations cause double-bookings and missed visits.

---

## 1. Concepts

| Term | Meaning |
|---|---|
| **Availability rule** | A recurring weekly window (e.g., Mon–Fri 09:00–13:00) declared by the physio. |
| **Blackout window** | An explicit unavailable period (leave, holiday). Overrides availability rules. |
| **Slot** | A bookable atom derived from availability rules. Default `slot_minutes = 30`. |
| **Appointment** | A booked instance of a slot for one patient. |
| **Status** | The lifecycle position of an appointment (see §3). |

Slot derivation is **computed**, not stored. The DB stores rules + blackouts + appointments; slots are produced on demand by a service.

---

## 2. End-to-End Booking Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                        PATIENT-SIDE BOOKING                         │
└─────────────────────────────────────────────────────────────────────┘

1. Patient opens "Book Appointment"
2. App fetches GET /api/v1/availability?from=2026-05-27&to=2026-06-03
3. Backend computes available slots:
       slots = expand(availability_rules, [from, to])
             - intersect(blackout_windows)
             - intersect(existing appointments WHERE status IN
                         ('REQUESTED','CONFIRMED','IN_PROGRESS'))
4. Patient picks a slot + the Patient profile to book for
5. App POST /api/v1/appointments
   Headers: Idempotency-Key: <uuid>
   Body:    { patient_id, scheduled_at, duration_minutes, reason }
6. Backend:
   a. requireAccess(account, patient_id, WRITE)
   b. Verify slot still inside an availability rule, not in a blackout
   c. INSERT into appointments with status='REQUESTED'
       └─ DB-level EXCLUDE constraint enforces no overlap with CONFIRMED/IN_PROGRESS
   d. Emit BOOKING_REQUESTED event → notification_outbox (→ FCM to physio)
   e. Seed an empty discussion thread (no row; thread is implicit per appointment)
7. Response: 201 Created with the appointment representation
```

```
┌─────────────────────────────────────────────────────────────────────┐
│                       PHYSIO-SIDE CONFIRMATION                      │
└─────────────────────────────────────────────────────────────────────┘

1. Physio receives FCM push → opens app → sees REQUESTED list
2. Physio taps Confirm → POST /api/v1/appointments/{id}/transitions
   Body: { to: "CONFIRMED" }
3. Backend:
   a. Verify caller has ROLE_PHYSIO
   b. Verify current status is REQUESTED
   c. UPDATE row: status='CONFIRMED', confirmed_at=NOW()
       └─ EXCLUDE constraint now actively prevents future overlap
   d. Emit BOOKING_CONFIRMED → notification_outbox (→ FCM to patient account)
4. On the day:
   - Physio taps Start → transition to IN_PROGRESS, started_at=NOW()
   - Physio taps Complete → transition to COMPLETED, completed_at=NOW()
```

---

## 3. State Machine

```
                                    ┌───────────────────┐
                                    │   (no row yet)    │
                                    └─────────┬─────────┘
                                              │ patient books
                                              ▼
                                  ┌───────────────────┐
                          ┌──────▶│     REQUESTED     │
                          │       └─────────┬─────────┘
                          │                 │
              patient OR  │   physio rejects│        physio confirms
              physio      │                 │
              cancels     │   ▼ CANCELLED   ▼
                          │                 ┌───────────────────┐
                          │                 │     CONFIRMED     │
                          │                 └─────────┬─────────┘
                          │                           │
                          │   reschedule              │  physio starts
                          │  (creates new row,        │
              ┌───────────│   old → RESCHEDULED)      │
              │           │                           ▼
              │           │                 ┌───────────────────┐
              │           │                 │   IN_PROGRESS     │
              │           │                 └─────────┬─────────┘
              │           │                           │
              │           │     no-show               │  physio completes
              │           │  (auto/manual)            │
              │           ▼                           ▼
              │   ┌───────────────────┐   ┌───────────────────┐
              └──▶│     NO_SHOW       │   │     COMPLETED     │
                  └───────────────────┘   └───────────────────┘
```

### 3.1 Allowed Transitions

| From | To | Allowed actor | Side effects |
|---|---|---|---|
| (none) | `REQUESTED` | Patient-side (`can_manage`) | INSERT row; emit `BOOKING_REQUESTED` |
| `REQUESTED` | `CONFIRMED` | Physio | Set `confirmed_at`; emit `BOOKING_CONFIRMED` |
| `REQUESTED` | `CANCELLED` | Patient-side or Physio | Set `cancelled_at`, `cancel_reason`; emit `BOOKING_CANCELLED` |
| `REQUESTED` | `RESCHEDULED` | Patient-side or Physio | Set `rescheduled_from_id` on new row; emit `BOOKING_CANCELLED` (old) + `BOOKING_REQUESTED` (new) |
| `CONFIRMED` | `IN_PROGRESS` | Physio | Set `started_at` |
| `CONFIRMED` | `CANCELLED` | Patient-side or Physio | Per cancellation policy (Phase 1: no fee) |
| `CONFIRMED` | `RESCHEDULED` | Patient-side or Physio | Same as REQUESTED→RESCHEDULED |
| `CONFIRMED` | `NO_SHOW` | Physio (or scheduled job after grace period) | Auto-trigger 30 min after `scheduled_at + duration` if not started |
| `IN_PROGRESS` | `COMPLETED` | Physio | Set `completed_at`. Unlocks treatment-note write. |
| `IN_PROGRESS` | `CANCELLED` | Physio | Rare; e.g., emergency. `cancel_reason = OTHER`. |

Every other transition is illegal and returns `409 Conflict` with `code = "appointments.invalid_transition"`.

### 3.2 Terminal States

`COMPLETED`, `CANCELLED`, `NO_SHOW`, `RESCHEDULED` are terminal. They never transition again.

---

## 4. Conflict Prevention

The hard guarantee: **no two appointments for the same physiotherapist may overlap if either is `CONFIRMED` or `IN_PROGRESS`.**

### 4.1 The DB-Level Guard

The `appointments_no_physio_overlap` exclusion constraint on `appointments` (see [DATABASE_SCHEMA.md §3.8](./DATABASE_SCHEMA.md)) uses a GIST index over `tstzrange(scheduled_at, scheduled_end_at, '[)')` to reject any overlapping `CONFIRMED` / `IN_PROGRESS` row.

This means: even if two requests slip past the service layer simultaneously, **the database itself prevents the conflict**. The second one gets a `23P01` error which the service layer translates to `409 Conflict`.

### 4.2 The Service-Layer Guard

Before insert, the booking service:

1. Loads availability rules + blackouts covering the requested time.
2. Verifies the requested `(scheduled_at, duration_minutes)` falls **entirely** inside an availability window and **does not intersect** any blackout.
3. Verifies no `REQUESTED` row already exists for the same patient at overlapping time (a patient cannot double-request).

Step 3 uses an advisory transaction lock to serialize concurrent booking attempts for the same physio:

```sql
SELECT pg_advisory_xact_lock(hashtext('book:' || :physio_id));
```

This keeps the optimistic UX (fast no-conflict path) without sacrificing correctness under load.

### 4.3 What Counts as Overlap

Ranges are **half-open** `[scheduled_at, scheduled_at + duration)`. Back-to-back appointments (`09:00–09:30` then `09:30–10:00`) **do not** overlap and are allowed.

---

## 5. Timezone Handling

| Where | Rule |
|---|---|
| DB | Everything `TIMESTAMPTZ`. Stored in UTC. |
| Availability rules | `start_time` / `end_time` are local times (`TIME`) plus an explicit `timezone` (IANA). Expansion to UTC happens server-side. |
| Mobile UI | Always renders in the **clinic's** timezone, not the device timezone. The clinic timezone is fetched once and cached. |
| API request bodies | Clients send ISO 8601 with offset (e.g., `2026-05-27T09:30:00+05:30`). Server stores the UTC instant. |

Why clinic timezone, not device timezone? Because patients traveling can otherwise see slots shifted into the next day. The physio's clinic is the reference frame.

---

## 6. Rescheduling

Rescheduling is **not** an in-place edit. It is:

1. Create a new appointment row with new `scheduled_at`, status `REQUESTED`, and `rescheduled_from_id = <old id>`.
2. Transition the old row to `RESCHEDULED`.
3. Both transitions in a single transaction.
4. The discussion thread of the **old** appointment remains attached to the old row. The new appointment starts with an empty thread, with a system message: `"This appointment was rescheduled from <date/time>."`

This preserves audit history and avoids loss of clinical context.

---

## 7. Cancellation Policy (Phase 1)

| Cancel trigger | Effect |
|---|---|
| Patient cancels ≥ 24 h before | Free; status → `CANCELLED`, `cancel_reason = PATIENT_CANCELLED`. |
| Patient cancels < 24 h before | Free in Phase 1 (no fees). Flagged in UI for the physio. |
| Physio cancels any time | Free; mandatory `cancel_note`. |
| Auto no-show | 30 min after `scheduled_at + duration` without a `started_at`. |

The 24-hour boundary is policy, not enforced as a hard block, until Phase 2 payments make it meaningful.

---

## 8. Validation Logic Summary

A booking request is **rejected** (`422 Unprocessable Entity`) when:

- `scheduled_at` is in the past (allowing a 5-minute clock-skew tolerance).
- `scheduled_at` is more than 90 days in the future.
- `duration_minutes` is not a positive multiple of `slot_minutes` between 15 and 120.
- The patient does not belong to the caller's account (or caller is not physio).
- The patient has another `REQUESTED`/`CONFIRMED`/`IN_PROGRESS` appointment overlapping the requested window.
- The requested window is not entirely inside an availability rule.
- The requested window intersects a blackout window.

A booking is **rejected with `409 Conflict`** when:

- The exclusion constraint fires because another booking confirmed in parallel.

---

## 9. Notifications Triggered

| Event | Recipient | Channel | Payload |
|---|---|---|---|
| `BOOKING_REQUESTED` | Physio | FCM | "New booking from [Patient name] on [date/time]." |
| `BOOKING_CONFIRMED` | Patient account | FCM | "Your appointment on [date/time] is confirmed." |
| `BOOKING_CANCELLED` | Other party | FCM | "Appointment on [date/time] was cancelled. Reason: ..." |
| `APPOINTMENT_REMINDER` | Patient account | FCM | "Reminder: appointment in 1 hour." (sent by scheduled job 60 min before) |

Dispatch is via the outbox pattern — see [SYSTEM_ARCHITECTURE.md §4.3](./SYSTEM_ARCHITECTURE.md).

---

## 10. Edge Cases

| Case | Resolution |
|---|---|
| Patient books a slot that just got booked 50ms earlier by someone else | Service-layer check passes, EXCLUDE constraint fires → `409 Conflict` with retry-friendly response. |
| Physio confirms a booking that overlaps with one they just confirmed | EXCLUDE constraint fires → `409 Conflict`. Physio sees a re-render of the day with the new row. |
| Patient cancels then re-books the same slot | Allowed. Old row stays `CANCELLED`; new row is a fresh `REQUESTED`. |
| Idempotency-Key replayed | Service returns the original 201 response without inserting twice. Idempotency entries TTL 24 h in Redis. |
| Clock skew on patient device | Server validates against server time only. Client-side "you're booking the past" check is informational. |
| Physio deletes an availability rule that has future bookings | Rule deletion soft-archives by setting `effective_to = NOW()`. Existing bookings are untouched. |

---

## 11. Related Documents

- [DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md) — `appointments`, `availability_rules`, exclusion constraint
- [API_STANDARDS.md](./API_STANDARDS.md) — endpoint shapes for `/appointments`, `/availability`
- [DISCUSSION_SYSTEM_DESIGN.md](./DISCUSSION_SYSTEM_DESIGN.md) — discussion lifecycle tied to appointments
- [SECURITY_GUIDELINES.md](./SECURITY_GUIDELINES.md) — JWT + access control
