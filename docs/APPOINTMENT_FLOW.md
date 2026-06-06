# APPOINTMENT_FLOW.md

> The end-to-end lifecycle of a Healyn appointment: from "patient requests a date" to "physio marks completed".
> The state machine, the conflict-prevention math, and the timezone rules described here are **load-bearing**. Deviations cause double-bookings and missed visits.
>
> **Booking model (request-first).** A patient does **not** pick or finalize a time. They request care on a **mandatory date** with an **optional time-of-day hint**; the **physiotherapist** reviews the request and assigns the final date and time. Only the physiotherapist finalizes scheduling, reschedules, and creates follow-ups. Computed slots still exist — they inform the physiotherapist when assigning a time — but they are no longer what a patient books.

---

## 1. Concepts

| Term | Meaning |
|---|---|
| **Availability rule** | A recurring weekly window (e.g., Mon–Fri 09:00–13:00) declared by the physio. |
| **Blackout window** | An explicit unavailable period (leave, holiday). Overrides availability rules. |
| **Slot** | A candidate time atom derived from availability rules. Default `slot_minutes = 30`. Shown to the physiotherapist when assigning a time; not booked directly by patients. |
| **Appointment request** | A patient's ask for care on a chosen `requested_date`, before the physiotherapist has fixed a time. Status `REQUESTED`, `scheduled_at` is `NULL`, with an optional `preferred_time` hint. |
| **Appointment** | A request that the physiotherapist has scheduled (or a physiotherapist-created follow-up): it has a concrete `scheduled_at` for one patient. |
| **Follow-up** | An appointment the physiotherapist creates directly to review a patient again (`is_follow_up = true`). The physiotherapist sets its date and time. |
| **Status** | The lifecycle position of an appointment (see §3). |

Slot derivation is **computed**, not stored. The DB stores rules + blackouts + appointments; slots are produced on demand by a service. A `REQUESTED` appointment may carry no `scheduled_at` until the physiotherapist schedules it.

---

## 2. End-to-End Booking Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                        PATIENT-SIDE REQUEST                         │
└─────────────────────────────────────────────────────────────────────┘

1. Patient opens "Request Appointment"
2. Patient picks the Patient profile, a MANDATORY requested_date, an
   OPTIONAL preferred_time hint, and an optional reason. No slot is chosen
   and availability is NOT consulted — a request may be made regardless of
   whether slots on that date are already booked.
3. App POST /api/v1/appointments
   Headers: Idempotency-Key: <uuid>
   Body:    { patient_id, requested_date, preferred_time?, reason? }
4. Backend:
   a. requireAccess(account, patient_id, WRITE)
   b. INSERT into appointments with status='REQUESTED', scheduled_at=NULL
       └─ no slot/overlap check: an unscheduled request never enters the
          physio-overlap EXCLUDE set (its WHERE excludes non-CONFIRMED rows)
   c. Emit BOOKING_REQUESTED event → notification_outbox (→ FCM to physio)
   d. Seed an empty discussion thread (no row; thread is implicit per appointment)
5. Response: 201 Created with the appointment representation (no time yet)
```

```
┌─────────────────────────────────────────────────────────────────────┐
│                   PHYSIO-SIDE SCHEDULING (time set here)            │
└─────────────────────────────────────────────────────────────────────┘

1. Physio receives FCM push → opens app → sees REQUESTED list with each
   request's requested_date and preferred_time hint
2. Physio reviews availability (computed slots) and assigns the final time →
   POST /api/v1/appointments/{id}/schedule
   Body: { scheduled_at, duration_minutes }
3. Backend:
   a. Verify caller has ROLE_PHYSIO
   b. Verify current status is REQUESTED
   c. UPDATE row: status='CONFIRMED', scheduled_at, scheduled_end_at,
      duration_minutes, confirmed_at=NOW()
       └─ EXCLUDE constraint now actively prevents overlap; a clash with an
          already-CONFIRMED appointment returns 409 (the physio picks another time)
   d. Emit BOOKING_CONFIRMED → notification_outbox (→ FCM to patient account)
4. On the day:
   - Physio taps Start → transition to IN_PROGRESS, started_at=NOW()
   - Physio taps Complete → transition to COMPLETED, completed_at=NOW()
```

The patient cannot finalize a time at any point. Confirming a request **and**
setting its time are the same physiotherapist action (`/schedule`); the plain
`/transitions` route no longer accepts `REQUESTED → CONFIRMED`.

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

| From | To | Allowed actor | Route | Side effects |
|---|---|---|---|---|
| (none) | `REQUESTED` | Patient-side (`can_manage`) | `POST /appointments` | INSERT row, `scheduled_at = NULL`, `requested_date` set; emit `BOOKING_REQUESTED` |
| (none) | `CONFIRMED` (follow-up) | Physio | `POST /appointments/follow-ups` | INSERT row, `is_follow_up = true`, time set by physio, `confirmed_at`; emit `BOOKING_CONFIRMED` |
| `REQUESTED` | `CONFIRMED` | Physio | `POST /appointments/{id}/schedule` | Set `scheduled_at`, `scheduled_end_at`, `duration_minutes`, `confirmed_at`; emit `BOOKING_CONFIRMED` |
| `REQUESTED` | `CANCELLED` | Patient-side or Physio | `/transitions` | Set `cancelled_at`, `cancel_reason`; emit `BOOKING_CANCELLED` |
| `REQUESTED` | `RESCHEDULED` | Patient-side or Physio | `/reschedule` | New `REQUESTED` row (no time) with `rescheduled_from_id`; emit `BOOKING_REQUESTED` |
| `CONFIRMED` | `IN_PROGRESS` | Physio | `/transitions` | Set `started_at` |
| `CONFIRMED` | `CANCELLED` | Patient-side or Physio | `/transitions` | Per cancellation policy (Phase 1: no fee) |
| `CONFIRMED` | `RESCHEDULED` | Physio | `/reschedule` | New `CONFIRMED` row with the physio's new time and `rescheduled_from_id`; emit `BOOKING_CONFIRMED` |
| `CONFIRMED` | `NO_SHOW` | Physio (or scheduled job after grace period) | `/transitions` | Auto-trigger 30 min after `scheduled_at + duration` if not started |
| `IN_PROGRESS` | `COMPLETED` | Physio | `/transitions` | Set `completed_at`. Unlocks treatment-note write. |
| `IN_PROGRESS` | `CANCELLED` | Physio | `/transitions` | Rare; e.g., emergency. `cancel_reason = OTHER`. |

`REQUESTED → CONFIRMED` happens **only** via `/schedule` (the physiotherapist sets the time); `/transitions` rejects it. Patient-side reschedule produces a fresh **unscheduled** `REQUESTED` (the physiotherapist re-assigns the time); physio reschedule produces a `CONFIRMED` row at the time the physiotherapist sets. Every other transition is illegal and returns `409 Conflict` with `code = "appointments.invalid_transition"`.

### 3.2 Terminal States

`COMPLETED`, `CANCELLED`, `NO_SHOW`, `RESCHEDULED` are terminal. They never transition again.

---

## 4. Conflict Prevention

The hard guarantee: **no two appointments for the same physiotherapist may overlap if either is `CONFIRMED` or `IN_PROGRESS`.**

### 4.1 The DB-Level Guard

The `appointments_no_physio_overlap` exclusion constraint on `appointments` (see [DATABASE_SCHEMA.md §3.8](./DATABASE_SCHEMA.md)) uses a GIST index over `tstzrange(scheduled_at, scheduled_end_at, '[)')` to reject any overlapping `CONFIRMED` / `IN_PROGRESS` row.

This means: even if two requests slip past the service layer simultaneously, **the database itself prevents the conflict**. The second one gets a `23P01` error which the service layer translates to `409 Conflict`.

### 4.2 The Service-Layer Guard

The overlap guarantee is owned by the DB EXCLUDE constraint (§4.1), not by a service-layer
pre-check. Because only the physiotherapist sets a time — and they alone are responsible for
their own calendar — the service does **not** force a scheduled time to fall inside a computed
availability window. Availability and computed slots only *inform* the physiotherapist's UI when
they pick a time; they are not enforced server-side.

For every action that assigns a time (`/schedule`, `/follow-ups`, and a physiotherapist
`/reschedule`), the service validates only the time itself before writing:

1. `scheduled_at` is present, and `duration_minutes` is within 5–240.
2. `scheduled_at` is not in the past (5-minute clock-skew tolerance) and not more than 90 days out.

It then **flushes** the `CONFIRMED` row inside the transaction so the EXCLUDE constraint fires
synchronously: a clash with an already-`CONFIRMED`/`IN_PROGRESS` appointment surfaces as a
`23P01` violation, which the service translates to `409 Conflict` and the physiotherapist picks
another time. A patient **request** assigns no time, so it performs no overlap check at all.

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

Rescheduling is **not** an in-place edit. It always creates a new row and marks the old one `RESCHEDULED`, in a single transaction. Who reschedules determines the new row's shape:

| Initiator | New row | Time set by | Notification |
|---|---|---|---|
| **Physiotherapist** | `CONFIRMED`, `scheduled_at` set to the physio's new time | Physiotherapist | `BOOKING_CONFIRMED` to patient |
| **Patient-side** (`can_manage`) | `REQUESTED`, **no** `scheduled_at`, new `requested_date` (+ optional `preferred_time`) | Re-assigned later by the physiotherapist via `/schedule` | `BOOKING_REQUESTED` to physio |

In both cases the new row carries `rescheduled_from_id = <old id>`. The discussion thread of the **old** appointment stays on the old row; the new appointment starts with an empty thread and a system message: `"This appointment was rescheduled from <date/time>."` This preserves audit history and avoids loss of clinical context. A patient rescheduling is therefore a *re-request*, never a self-assigned time.

## 6a. Follow-ups

A follow-up is a brand-new appointment the **physiotherapist** creates to see a patient again — distinct from the advisory `next_review_at` hint on a treatment note (which only suggests a date). The physiotherapist sets the date and time directly:

1. `POST /api/v1/appointments/follow-ups` with `{ patient_id, scheduled_at, duration_minutes, reason? }`.
2. Backend inserts a row with `is_follow_up = true`, status `CONFIRMED`, `confirmed_at = NOW()`, subject to the same physio-overlap EXCLUDE guard.
3. Emit `BOOKING_CONFIRMED` to the patient account.

Only the physiotherapist may create follow-ups. They surface on the physiotherapist's calendar and upcoming list, visually distinct from patient-originated bookings.

### Read surfaces for the dashboard and calendar

Two ascending, time-ordered read endpoints back the physiotherapist's home:

- `GET /appointments/upcoming?limit=` — the next live scheduled appointments from now (`CONFIRMED`/`IN_PROGRESS`), ascending, capped (default 30, ≤ 50). Unscheduled `REQUESTED` rows have no time, so they never appear here — the physiotherapist works those off the `status=REQUESTED` list.
- `GET /appointments/calendar?from=&to=` — every scheduled appointment in an instant window (the caller computes the month's edges in its own timezone), ascending, including the past real events `COMPLETED`/`NO_SHOW` so a month grid shows history. The window is capped at 62 days. Dead states (`CANCELLED`, `RESCHEDULED`) are excluded.

Both are role-scoped: a physiotherapist sees every patient's appointments; a patient-side account sees only the patients it can access.

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

A patient **request** (`POST /appointments`) is **rejected** (`422 Unprocessable Entity`) when:

- `requested_date` is missing, in the past, or more than 90 days in the future.
- The patient does not belong to the caller's account (or caller is not physio).

A request is intentionally **not** rejected for availability reasons — a patient may request any date regardless of whether that date's slots are already booked. No `scheduled_at` is accepted from the patient.

A physiotherapist **schedule / follow-up / physio-reschedule** (which set `scheduled_at`) is **rejected** (`422 Unprocessable Entity`) when:

- `scheduled_at` is missing, in the past (5-minute clock-skew tolerance), or more than 90 days out.
- `duration_minutes` is outside the allowed range (5–240).

…and **rejected with `409 Conflict`** when:

- The physio-overlap exclusion constraint fires because the chosen time overlaps an already-`CONFIRMED`/`IN_PROGRESS` appointment (`appointments.slot_unavailable`). The physiotherapist picks another time.

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
