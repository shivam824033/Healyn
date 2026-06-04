# DISCUSSION_SYSTEM_DESIGN.md

> The appointment-scoped messaging subsystem.
> Healyn's discussion is **not a chat product**. It is a clinical communication channel anchored to a specific appointment. Read this before adding any messaging feature.

---

## 1. What Discussion Is — and Is Not

| Discussion **is** | Discussion **is not** |
|---|---|
| Tied to exactly one appointment | Free-form DM between patient and physio |
| Scoped to participants of that appointment | A group chat or social wall |
| Used for questions, replies, instructions, and attachments | A real-time presence system (typing indicators, online dots) |
| Asynchronous; messages arrive when they arrive | A live call replacement |
| Audited like any other clinical resource | A general support inbox |

> **Rule**: a message with no `appointment_id` is invalid. There is no DMing the physio outside an appointment.

---

## 2. Data Model

See [DATABASE_SCHEMA.md §3.10 and §3.11](./DATABASE_SCHEMA.md) for the SQL. Key facts:

- `discussion_messages.appointment_id` is `NOT NULL FK` to `appointments`.
- `sender_role` is one of:
  - `PATIENT_SIDE` — sender is an `Account` with `can_manage` on the appointment's Patient.
  - `PHYSIO` — sender is the physiotherapist.
- `message_type` is one of:
  - `QUESTION` — patient-side asks something.
  - `REPLY` — either party answers (most messages).
  - `INSTRUCTION` — physio gives prescriptive guidance (e.g., "do these stretches twice daily").
  - `ATTACHMENT_ONLY` — message body is empty; only attachments carry content.
- Attachments are joined via `discussion_message_attachments(message_id, file_id)` to `file_objects`. See [FILE_STORAGE_GUIDELINES.md](./FILE_STORAGE_GUIDELINES.md).

There is **no `discussion_thread` table**. A thread *is* the appointment. The set of messages for an appointment is the thread.

---

## 3. Access Rules

```
canReadDiscussion(account, appointmentId) :=
    canAccessPatient(account, appointment.patient_id, READ)
    OR account.role = ROLE_PHYSIO

canWriteDiscussion(account, appointmentId) :=
    (canAccessPatient(account, appointment.patient_id, WRITE)
       AND appointment.status NOT IN ('CANCELLED','NO_SHOW'))
    OR account.role = ROLE_PHYSIO
```

- Cancelled or no-show appointments are **read-only** for the patient side.
- The physiotherapist retains write access regardless of status (for adding instructions retroactively).
- A `RESCHEDULED` appointment's discussion remains accessible on both old and new rows (the new row starts a fresh thread).

Access enforcement lives in `DiscussionService` — controllers don't make policy.

---

## 4. Message Lifecycle

```
                ┌──────────────┐
                │   (none)     │
                └──────┬───────┘
                       │ POST /appointments/{id}/messages
                       ▼
                ┌──────────────┐    edited within 5 min   ┌──────────────┐
                │   CREATED    │ ──────────────────────▶  │   EDITED     │
                └──────┬───────┘                          └──────┬───────┘
                       │ DELETE within 5 min                     │
                       ▼                                         │
                ┌──────────────┐                                 │
                │  SOFT-DELETED│ ◀───────────────────────────────┘
                └──────────────┘
```

- A message may be **edited within 5 minutes** of creation, by the original sender only. `edited_at` is set. Body is replaced; the original body is **not** preserved (Phase 1).
- A message may be **soft-deleted within 5 minutes** of creation, by the original sender only. `deleted_at` is set. UI renders "Message deleted".
- After 5 minutes a message is **immutable**. (Rationale: clinical context. We don't allow the physio to silently rewrite an instruction yesterday.)

Edits/deletes by either party are recorded in `audit.audit_log`.

---

## 5. API Surface

All discussion endpoints are nested under the parent appointment. Schemas in [API_STANDARDS.md](./API_STANDARDS.md).

| Method | Path | Purpose |
|---|---|---|
| `GET`    | `/api/v1/appointments/{id}/messages?cursor=...&limit=50` | List messages, newest-first, cursor-paginated |
| `POST`   | `/api/v1/appointments/{id}/messages`                     | Create a message (with optional `file_ids[]`) |
| `PATCH`  | `/api/v1/appointments/{id}/messages/{msgId}`             | Edit (within 5 min, original sender) |
| `DELETE` | `/api/v1/appointments/{id}/messages/{msgId}`             | Soft-delete (within 5 min, original sender) |
| `POST`   | `/api/v1/appointments/{id}/messages/read`                | Mark read up to a `message_id` |
| `GET`    | `/api/v1/appointments/{id}/messages/unread-count`        | Count of unread messages |

Read receipts (Phase 1): a single `last_read_message_id` per `(appointment_id, account_id)`. Not per-message. Stored as a small `discussion_read_markers` table or in Redis.

---

## 6. Attachment Flow

Attachments are **pre-uploaded** to S3 before the message is created.

```
1. Patient/Physio picks PDF/JPG/PNG in mobile UI.
2. App POST /api/v1/files/presign
       body: { kind: 'REPORT', mime_type: 'image/jpeg', size_bytes, patient_id }
3. Backend returns presignedUrl + fileId. file_objects row is PENDING_UPLOAD.
4. App PUTs bytes directly to S3 via presigned URL.
5. App POST /api/v1/appointments/{id}/messages
       body: { message_type: 'ATTACHMENT_ONLY' OR 'REPLY', body, file_ids: [...] }
6. Backend:
   a. Verify each file_id is owned by an account that can_access the appointment's patient
   b. Verify each file is now AVAILABLE in S3 (HEAD object) — promote status
   c. Insert message + discussion_message_attachments rows
   d. Emit DISCUSSION_NEW_MESSAGE → notification_outbox
```

Why two steps? The mobile app uploads the big bytes directly to S3 (fast, doesn't tie up the API). The API call to create the message is small and atomic.

A message may carry **0–10 attachments**. A message with no body and no attachments is invalid.

---

## 7. Notifications

Every successful message creation produces exactly one notification event per *other* participant:

| Sender | Recipient(s) | Channel | Title |
|---|---|---|---|
| `PATIENT_SIDE` | Physio | FCM | "[Patient name]: new message" |
| `PHYSIO` | All accounts linked to the appointment's patient with `can_manage = TRUE` | FCM | "Dr. [name]: new message" |

Payload contains the appointment ID and message ID so the app can deep-link into the thread.

Throttling: if the same recipient gets > 3 messages from the same thread within 60 seconds, the dispatcher coalesces them into one "[N] new messages" notification. Implemented in the outbox poller, not at the call site.

---

## 8. Read State

A simple `discussion_read_markers` table:

```sql
CREATE TABLE discussion_read_markers (
    appointment_id        UUID NOT NULL REFERENCES appointments(id) ON DELETE CASCADE,
    account_id            UUID NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    last_read_message_id  UUID NOT NULL REFERENCES discussion_messages(id),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (appointment_id, account_id)
);
```

Unread count = `COUNT(*) WHERE appointment_id = ? AND id > last_read_message_id`. With the `idx_dmsg_appt_created` index this is a cheap range scan.

(Per-message read-by-whom receipts are deferred to Phase 2.)

---

## 9. UI Implications

- Discussion is a tab inside the appointment detail screen, not a separate top-level inbox.
- The home screen surfaces a single "Unread messages" count aggregated across all the patient's appointments — tapping it opens an *index* of appointments with unread, **not** a merged feed.
  - *Phase 1 implementation note*: there is no server-side aggregate endpoint. The mobile app computes the roll-up by fanning out the per-appointment `unread-count` calls in parallel over the account's **live** appointments (cancelled / no-show / rescheduled threads are skipped to bound the fan-out; a failed count counts as 0). For a patient account this set is small. A server-side aggregate endpoint is the enabler to add when the physiotherapist inbox (many appointments) needs it.
- Composer supports: text (up to 2,000 chars), attach files (up to 10), tag `INSTRUCTION` (physio-side only).
- A `RESCHEDULED` appointment's discussion is read-only and visually marked.
- Cancelled/no-show appointments show their discussion in a faded, read-only state.

---

## 10. Anti-Patterns

- **Do not** create a generic `Inbox` or `Chat` abstraction. The thread *is* the appointment.
- **Do not** allow `appointment_id` to be nullable. PHI without context is a liability.
- **Do not** add typing indicators, presence, or "online now" dots in Phase 1.
- **Do not** make messages mutable after the 5-minute window. Clinical instructions must not silently change.
- **Do not** store any message body in `notification_outbox.payload`. PHI in push payloads is forbidden; payloads carry IDs only, app fetches content after open.

---

## 11. Edge Cases

| Case | Resolution |
|---|---|
| Patient sends a message while the appointment is `CANCELLED` | API returns `403 Forbidden` with `code = "discussion.appointment_terminal"`. |
| Physio sends `INSTRUCTION` to a cancelled appointment | Allowed (physio retains write access for clinical reasons). |
| Sender deletes a message that has been read by recipient | Allowed within 5 min. Recipient's app polls or sockets re-render. |
| File referenced in `file_ids` belongs to a different patient | Service rejects with `403 Forbidden`. |
| File still `PENDING_UPLOAD` when message is created | Service rejects with `409 Conflict`, asking client to retry after the PUT completes. |
| FCM token missing for recipient | Outbox marks the row `DEAD` after 5 retries; no in-app effect (next login refreshes token). |

---

## 12. Related Documents

- [DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md) — `discussion_messages`, attachments, read markers
- [APPOINTMENT_FLOW.md](./APPOINTMENT_FLOW.md) — the appointment lifecycle thread lives on
- [FILE_STORAGE_GUIDELINES.md](./FILE_STORAGE_GUIDELINES.md) — presigned uploads
- [PATIENT_RELATIONSHIP_MODEL.md](./PATIENT_RELATIONSHIP_MODEL.md) — access policy
- [API_STANDARDS.md](./API_STANDARDS.md) — endpoint shapes
