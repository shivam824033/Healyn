# DATABASE_SCHEMA.md

> The authoritative PostgreSQL 16 schema for Healyn.
> Every column, type, constraint, and index decision is intentional. Changes go through a Flyway migration and require sign-off.

---

## 1. Conventions

| Rule | Detail |
|---|---|
| **Naming** | `snake_case` for tables and columns. Tables are plural nouns (`accounts`, `appointments`). |
| **Primary keys** | `UUID` (v7 where supported, else v4) generated app-side. Never auto-increment integers — they leak volume and order. |
| **Timestamps** | `created_at`, `updated_at`, `deleted_at` are `TIMESTAMPTZ NOT NULL DEFAULT NOW()` (except `deleted_at` which is nullable). All in UTC. |
| **Soft delete** | Clinical tables use `deleted_at IS NULL` to mean "live". Queries use the `live_*` views. |
| **Enums** | PostgreSQL native `CREATE TYPE ... AS ENUM`. New values appended; never reordered. |
| **Foreign keys** | All FKs explicit. `ON DELETE` is `RESTRICT` for clinical data; `CASCADE` only where the parent owns the child entirely. |
| **Indexes** | Every FK has an index. Composite indexes documented inline. |
| **Schemas** | `public` for operational data, `audit` for the audit log (separate role permissions). |

---

## 2. Enum Types

```sql
CREATE TYPE account_status AS ENUM ('ACTIVE', 'LOCKED', 'DISABLED');
CREATE TYPE account_role   AS ENUM ('ROLE_ACCOUNT', 'ROLE_PHYSIO');

CREATE TYPE otp_channel    AS ENUM ('SMS', 'EMAIL');
CREATE TYPE otp_purpose    AS ENUM ('REGISTRATION', 'LOGIN', 'PASSWORD_RESET');

CREATE TYPE patient_sex    AS ENUM ('MALE', 'FEMALE', 'OTHER', 'UNDISCLOSED');
CREATE TYPE patient_relationship AS ENUM (
    'SELF', 'SPOUSE', 'PARENT', 'CHILD', 'SIBLING', 'GUARDIAN_OF', 'OTHER'
);

CREATE TYPE appointment_status AS ENUM (
    'REQUESTED', 'CONFIRMED', 'IN_PROGRESS',
    'COMPLETED', 'CANCELLED', 'NO_SHOW', 'RESCHEDULED',
    'REJECTED'  -- V20: physio declines a request (REQUESTED → REJECTED)
);
CREATE TYPE appointment_cancel_reason AS ENUM (
    'PATIENT_CANCELLED', 'PHYSIO_CANCELLED', 'CLINIC_CLOSED', 'OTHER'
);
CREATE TYPE appointment_child_kind AS ENUM (         -- V18: how a child row derived from its lineage
    'RESCHEDULE', 'FOLLOW_UP', 'REVIEW', 'REOPEN'
);

CREATE TYPE discussion_message_type AS ENUM (
    'QUESTION', 'REPLY', 'INSTRUCTION', 'ATTACHMENT_ONLY'
);
CREATE TYPE discussion_sender_role AS ENUM ('PATIENT_SIDE', 'PHYSIO');

CREATE TYPE file_kind     AS ENUM ('REPORT', 'MRI', 'XRAY', 'PRESCRIPTION', 'EXERCISE_PLAN', 'OTHER');
CREATE TYPE file_mime     AS ENUM ('application/pdf', 'image/jpeg', 'image/png');
CREATE TYPE file_status   AS ENUM ('PENDING_UPLOAD', 'AVAILABLE', 'QUARANTINED', 'DELETED');
CREATE TYPE file_context  AS ENUM ('DISCUSSION', 'LIBRARY');  -- chat attachment vs document-library upload (V24)

CREATE TYPE notification_channel AS ENUM ('FCM');  -- email/APNs added Phase 2
CREATE TYPE notification_status  AS ENUM ('PENDING', 'SENT', 'FAILED', 'DEAD');
CREATE TYPE notification_kind    AS ENUM (
    'BOOKING_REQUESTED', 'BOOKING_CONFIRMED', 'BOOKING_CANCELLED',
    'APPOINTMENT_REMINDER', 'DISCUSSION_NEW_MESSAGE', 'TREATMENT_NOTE_ADDED'
);

CREATE TYPE audit_action AS ENUM (
    'READ', 'CREATE', 'UPDATE', 'SOFT_DELETE', 'DOWNLOAD', 'EXPORT'
);
```

---

## 3. Core Tables

### 3.1 `accounts` — auth identities

```sql
CREATE TABLE accounts (
    id                 UUID PRIMARY KEY,
    email              CITEXT UNIQUE,                       -- nullable: account may be phone-only
    phone_e164         VARCHAR(20) UNIQUE,                  -- nullable: account may be email-only
    password_hash      TEXT NOT NULL,                       -- Argon2id encoded string
    password_salt      BYTEA NOT NULL,                      -- per-user salt; pepper is env-side
    role               account_role NOT NULL DEFAULT 'ROLE_ACCOUNT',
    status             account_status NOT NULL DEFAULT 'ACTIVE',
    failed_login_count INT NOT NULL DEFAULT 0,
    locked_until       TIMESTAMPTZ,
    last_login_at      TIMESTAMPTZ,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at         TIMESTAMPTZ,
    CHECK (email IS NOT NULL OR phone_e164 IS NOT NULL)
);

CREATE INDEX idx_accounts_status ON accounts(status) WHERE deleted_at IS NULL;
```

Notes:
- `CITEXT` for case-insensitive email uniqueness.
- Exactly one row will have `role = 'ROLE_PHYSIO'` in Phase 1, provisioned via a startup task.

### 3.2 `device_sessions` — refresh-token-backed sessions

```sql
CREATE TABLE device_sessions (
    id                  UUID PRIMARY KEY,
    account_id          UUID NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    refresh_token_hash  TEXT NOT NULL,                     -- SHA-256 hex of the opaque token
    device_label        VARCHAR(120),                       -- "Pixel 8 · Android 15"
    device_id           VARCHAR(128),                       -- stable device fingerprint
    fcm_token           TEXT,                               -- nullable; updated per-session
    ip_address          INET,
    user_agent          TEXT,
    issued_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_seen_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at          TIMESTAMPTZ NOT NULL,
    revoked_at          TIMESTAMPTZ
);

CREATE INDEX idx_device_sessions_account ON device_sessions(account_id) WHERE revoked_at IS NULL;
CREATE UNIQUE INDEX idx_device_sessions_token_hash ON device_sessions(refresh_token_hash);
```

### 3.3 `otp_challenges` — OTP issuance and verification

```sql
CREATE TABLE otp_challenges (
    id                  UUID PRIMARY KEY,
    account_id          UUID REFERENCES accounts(id) ON DELETE CASCADE, -- nullable for registration
    target              VARCHAR(120) NOT NULL,              -- email or phone E.164
    channel             otp_channel NOT NULL,
    purpose             otp_purpose NOT NULL,
    code_hash           TEXT NOT NULL,                      -- SHA-256 of 6-digit code
    attempts            SMALLINT NOT NULL DEFAULT 0,
    max_attempts        SMALLINT NOT NULL DEFAULT 5,
    expires_at          TIMESTAMPTZ NOT NULL,
    consumed_at         TIMESTAMPTZ,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_otp_target_purpose_open
    ON otp_challenges(target, purpose)
    WHERE consumed_at IS NULL;
```

### 3.4 `patients` — clinical entities

```sql
CREATE SEQUENCE patient_number_seq START WITH 100001;       -- V16: human-friendly id source

CREATE TABLE patients (
    id                  UUID PRIMARY KEY,
    patient_number      VARCHAR(20) NOT NULL UNIQUE          -- V16: business id, e.g. PAT-100001
                          DEFAULT 'PAT-' || nextval('patient_number_seq'),
    full_name           VARCHAR(160) NOT NULL,
    date_of_birth       DATE NOT NULL,
    sex                 patient_sex NOT NULL DEFAULT 'UNDISCLOSED',
    phone_e164          VARCHAR(20),                        -- optional, may differ from account
    email               CITEXT,
    blood_group         VARCHAR(3),                         -- 'A+', 'O-', etc. nullable
    allergies           TEXT,                               -- free text
    notes               TEXT,                               -- patient-side notes
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

CREATE INDEX idx_patients_name_trgm
    ON patients USING gin (full_name gin_trgm_ops)
    WHERE deleted_at IS NULL;
```

A `Patient` exists independent of any `Account`. It is **linked** via `account_patients`.

`patient_number` is a **business identifier** distinct from the UUID `id` (the technical
primary key, never shown to users). It is assigned once at insert from `patient_number_seq`
and never changes; the application maps it read-only via Hibernate `@Generated(INSERT)`.
See [FEATURE_ROADMAP.md](./FEATURE_ROADMAP.md) "Identifiers & lifecycle note".

### 3.5 `account_patients` — many-to-many link with ownership

```sql
CREATE TABLE account_patients (
    account_id          UUID NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    patient_id          UUID NOT NULL REFERENCES patients(id) ON DELETE RESTRICT,
    relationship        patient_relationship NOT NULL,
    is_primary          BOOLEAN NOT NULL DEFAULT FALSE,     -- the account holder themselves
    can_manage          BOOLEAN NOT NULL DEFAULT TRUE,      -- write access
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (account_id, patient_id)
);

-- Exactly one primary patient per account
CREATE UNIQUE INDEX idx_account_one_primary
    ON account_patients(account_id)
    WHERE is_primary = TRUE;

CREATE INDEX idx_account_patients_patient ON account_patients(patient_id);
```

See [PATIENT_RELATIONSHIP_MODEL.md](./PATIENT_RELATIONSHIP_MODEL.md) for ownership semantics.

### 3.5a `account_addresses` — one household postal address per account

```sql
CREATE TABLE account_addresses (
    account_id   UUID PRIMARY KEY REFERENCES accounts(id) ON DELETE CASCADE,
    line1        VARCHAR(160) NOT NULL,
    line2        VARCHAR(160),
    city         VARCHAR(80)  NOT NULL,
    state        VARCHAR(80)  NOT NULL,
    postal_code  VARCHAR(16)  NOT NULL,
    country      VARCHAR(60)  NOT NULL DEFAULT 'India',
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT now()
);
```

The address belongs to the **Account** (the household login), not to an individual
Patient: it is captured once at registration and shared across the account's primary
patient and every family member. `account_id` is the primary key, so the relation is
1:1 with `accounts` and a row exists only when an address is set — accounts created
before V23 simply have none, and the read layer tolerates its absence (the address is
required at *signup* only). The physiotherapist resolves a patient's address through
`account_patients` (preferring the link where the patient is that account's primary,
then by account id) for communication and records. Account contact data, not clinical
PHI in the audit sense (mirrors `notification_preferences`): no soft-delete column,
`ON DELETE CASCADE` with the account. Owned by the `patients` module (entity
`AccountAddress`). See [API_STANDARDS.md §9.2](./API_STANDARDS.md#92-patients).

### 3.6 `availability_rules` — physiotherapist's recurring schedule

```sql
CREATE TABLE availability_rules (
    id                  UUID PRIMARY KEY,
    physiotherapist_id  UUID NOT NULL REFERENCES accounts(id),
    day_of_week         SMALLINT NOT NULL CHECK (day_of_week BETWEEN 0 AND 6), -- 0=Sun
    start_time          TIME NOT NULL,
    end_time            TIME NOT NULL,
    slot_minutes        SMALLINT NOT NULL DEFAULT 30,
    timezone            VARCHAR(64) NOT NULL,               -- IANA, e.g., 'Asia/Kolkata'
    effective_from      DATE NOT NULL,
    effective_to        DATE,                               -- nullable = open-ended
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CHECK (end_time > start_time)
);

CREATE INDEX idx_availability_physio_dow
    ON availability_rules(physiotherapist_id, day_of_week);
```

### 3.7 `blackout_windows` — explicit unavailable periods (leave, holidays)

```sql
CREATE TABLE blackout_windows (
    id                  UUID PRIMARY KEY,
    physiotherapist_id  UUID NOT NULL REFERENCES accounts(id),
    starts_at           TIMESTAMPTZ NOT NULL,
    ends_at             TIMESTAMPTZ NOT NULL,
    reason              VARCHAR(200),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CHECK (ends_at > starts_at),
    EXCLUDE USING gist (
        physiotherapist_id WITH =,
        tstzrange(starts_at, ends_at, '[)') WITH &&
    )
);
```

### 3.8 `appointments`

```sql
-- V17: per clinic-local day counter backing the human-friendly Appointment Number.
CREATE TABLE appointment_daily_counters (
    day                 DATE PRIMARY KEY,
    last_seq            INTEGER NOT NULL
);

CREATE TABLE appointments (
    id                  UUID PRIMARY KEY,
    appointment_number  VARCHAR(32) NOT NULL UNIQUE,          -- V17: business id, e.g. PHY-20260610-0001
    patient_id          UUID NOT NULL REFERENCES patients(id) ON DELETE RESTRICT,
    booked_by_account_id UUID NOT NULL REFERENCES accounts(id) ON DELETE RESTRICT,
    physiotherapist_id  UUID NOT NULL REFERENCES accounts(id) ON DELETE RESTRICT,
    requested_date      DATE NOT NULL,                       -- the date the patient asked for (mandatory at request time)
    preferred_time      TIME,                                -- optional non-binding time-of-day hint from the patient
    scheduled_at        TIMESTAMPTZ,                         -- NULL until the physiotherapist schedules; they set the final time
    scheduled_end_at    TIMESTAMPTZ,                         -- stored, = scheduled_at + duration; keeps the EXCLUDE index expression IMMUTABLE
    duration_minutes    SMALLINT NOT NULL DEFAULT 30,
    status              appointment_status NOT NULL DEFAULT 'REQUESTED',
    is_follow_up        BOOLEAN NOT NULL DEFAULT FALSE,      -- true when the physiotherapist created this as a follow-up
    reason              VARCHAR(280),                       -- "Lower back pain", etc.
    cancel_reason       appointment_cancel_reason,
    cancel_note         TEXT,
    rescheduled_from_id UUID REFERENCES appointments(id),
    root_appointment_id   UUID NOT NULL REFERENCES appointments(id),  -- V18: lineage origin (a root is its own root)
    source_appointment_id UUID REFERENCES appointments(id),           -- V18: immediate parent (NULL on a root)
    child_kind            appointment_child_kind,                     -- V18: how it derived (NULL on a root)
    confirmed_at        TIMESTAMPTZ,
    started_at          TIMESTAMPTZ,
    completed_at        TIMESTAMPTZ,
    cancelled_at        TIMESTAMPTZ,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ,

    CHECK (duration_minutes BETWEEN 5 AND 240),
    -- NULL-tolerant: holds only when both endpoints are present (an unscheduled request has neither).
    CONSTRAINT appointments_end_after_start CHECK (scheduled_end_at > scheduled_at),
    -- A confirmed/active appointment must carry a concrete time; this also keeps the
    -- EXCLUDE index safe — only rows with a real time enter its WHERE set.
    CONSTRAINT appointments_scheduled_when_active CHECK (
        status NOT IN ('CONFIRMED', 'IN_PROGRESS', 'COMPLETED', 'NO_SHOW')
        OR scheduled_at IS NOT NULL
    )
);

-- Conflict prevention: no two confirmed/in-progress appointments overlap for the same physio.
-- The range is built from the two stored columns (both plain references are IMMUTABLE);
-- timestamptz arithmetic is only STABLE and cannot appear directly in an index/EXCLUDE expression.
CREATE EXTENSION IF NOT EXISTS btree_gist;
ALTER TABLE appointments
    ADD CONSTRAINT appointments_no_physio_overlap
    EXCLUDE USING gist (
        physiotherapist_id WITH =,
        tstzrange(scheduled_at, scheduled_end_at, '[)') WITH &&
    )
    WHERE (status IN ('CONFIRMED', 'IN_PROGRESS'));

CREATE INDEX idx_appt_physio_scheduled
    ON appointments(physiotherapist_id, scheduled_at)
    WHERE deleted_at IS NULL;
CREATE INDEX idx_appt_patient_scheduled
    ON appointments(patient_id, scheduled_at DESC)
    WHERE deleted_at IS NULL;
CREATE INDEX idx_appt_status_scheduled
    ON appointments(status, scheduled_at)
    WHERE status IN ('REQUESTED', 'CONFIRMED', 'IN_PROGRESS');

-- The physiotherapist's pending request queue, ordered by the date the patient asked for.
CREATE INDEX idx_appt_requested_date
    ON appointments(physiotherapist_id, requested_date)
    WHERE status = 'REQUESTED' AND deleted_at IS NULL;

-- Lineage lookups: every row in a chain, and reverse "what derived from this".
CREATE INDEX idx_appointments_root
    ON appointments(root_appointment_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_appointments_source
    ON appointments(source_appointment_id) WHERE deleted_at IS NULL;

-- V21: prefix scans for the global-search autocomplete. text_pattern_ops makes
-- `appointment_number LIKE 'PHY-2026%'` index-backed regardless of server collation
-- (the collation-aware UNIQUE btree cannot serve a prefix LIKE). Same for PAT-….
CREATE INDEX idx_appointments_number_pattern
    ON appointments(appointment_number text_pattern_ops) WHERE deleted_at IS NULL;
CREATE INDEX idx_patients_number_pattern
    ON patients(patient_number text_pattern_ops) WHERE deleted_at IS NULL;
```

`requested_date`, `preferred_time`, nullable `scheduled_at`/`scheduled_end_at`, and `is_follow_up` are added by `V15__appointments_request_first.sql`. State transitions and conflict rules: [APPOINTMENT_FLOW.md](./APPOINTMENT_FLOW.md).

`appointment_number` (V17) is a **business identifier** distinct from the UUID `id` (never shown to users): `PHY-YYYYMMDD-NNNN`, where the `YYYYMMDD` stem is the row's creation date in the **clinic timezone** (`healyn.clinic.timezone`) and `NNNN` is a per-day counter held in `appointment_daily_counters` and advanced with an atomic `INSERT … ON CONFLICT … RETURNING` upsert. Generation is application-side (`AppointmentNumberGenerator`) so the stem uses the configured zone and child rows can derive `-R1`/`-F1` suffixes. See [FEATURE_ROADMAP.md](./FEATURE_ROADMAP.md) "Identifiers & lifecycle note".

**Lineage** (V18) links only rows that spawn a *new bookable row* — a reschedule replacement or a follow-up tied to a prior appointment. `root_appointment_id` is the origin of the chain (a root is its own root, `= id`); `source_appointment_id` is the immediate appointment a child derived from; `child_kind` is how (`RESCHEDULE`/`FOLLOW_UP`/`REVIEW`/`REOPEN`, `NULL` on a root). A child's number is its root's stem plus a per-kind suffix and 1-based ordinal (`PHY-20260610-0001-R1`, `-F2`); the count of same-kind children in the lineage (including soft-deleted) decides the ordinal, so numbers are never reused. `rescheduled_from_id` is retained for backward compatibility and equals `source_appointment_id` where `child_kind = 'RESCHEDULE'`. In-place lifecycle changes (confirm/start/complete/cancel) are **not** lineage — they are rows on the `appointment_events` timeline (§3.8a). See [APPOINTMENT_FLOW.md](./APPOINTMENT_FLOW.md) §6, §6a.

### 3.8a `appointment_events` — append-only lifecycle timeline

```sql
-- V19. One row per lifecycle action on an appointment; never updated or deleted.
CREATE TYPE appointment_event_type AS ENUM (
    'CREATED', 'SCHEDULED', 'STARTED', 'COMPLETED',
    'CANCELLED', 'NO_SHOW', 'RESCHEDULED', 'REJECTED');  -- REJECTED emitted since V20

CREATE TABLE appointment_events (
    id                      BIGSERIAL PRIMARY KEY,
    appointment_id          UUID NOT NULL REFERENCES appointments(id) ON DELETE RESTRICT,
    event_type              appointment_event_type NOT NULL,
    occurred_at             TIMESTAMPTZ NOT NULL DEFAULT now(),
    actor_account_id        UUID REFERENCES accounts(id) ON DELETE RESTRICT,  -- NULL when unknowable (backfill)
    actor_role              account_role,
    related_appointment_id  UUID REFERENCES appointments(id) ON DELETE RESTRICT,  -- reschedule child / creation source
    child_kind              appointment_child_kind,
    cancel_reason           appointment_cancel_reason
);

CREATE INDEX idx_appointment_events_appointment
    ON appointment_events(appointment_id, occurred_at, id);
CREATE INDEX idx_appointment_events_actor
    ON appointment_events(actor_account_id) WHERE actor_account_id IS NOT NULL;
CREATE INDEX idx_appointment_events_related
    ON appointment_events(related_appointment_id) WHERE related_appointment_id IS NOT NULL;
```

The realization of the Phase-3 enabler *"all clinical writes already produce a domain event"* ([FEATURE_ROADMAP.md](./FEATURE_ROADMAP.md) §4) for the appointments module. Written by `AppointmentEventRecorder` inside the same transaction as the action it describes; the only writer, and nothing updates or deletes a row. **PHI-free by construction**: IDs, enums and timestamps only — free text (reason, cancel note) stays on `appointments`. There is no `deleted_at`: events are history, and their visibility follows the (soft-deletable) appointments row. `GET /appointments/{id}/timeline` returns the events of every live appointment sharing the row's `root_appointment_id`, oldest first — the unified lineage timeline. V19 backfills events for pre-existing appointments from their lifecycle timestamps (best-effort actors; `NO_SHOW` uses `updated_at`).

### 3.9 `treatment_notes`

```sql
CREATE TABLE treatment_notes (
    id                  UUID PRIMARY KEY,
    appointment_id      UUID NOT NULL UNIQUE REFERENCES appointments(id) ON DELETE RESTRICT,
    patient_id          UUID NOT NULL REFERENCES patients(id),    -- denormalized for fast patient timeline
    author_account_id   UUID NOT NULL REFERENCES accounts(id),
    diagnosis           TEXT,
    notes               TEXT,
    recovery_instructions TEXT,
    next_review_at      TIMESTAMPTZ,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at          TIMESTAMPTZ
);

CREATE INDEX idx_tnotes_patient ON treatment_notes(patient_id) WHERE deleted_at IS NULL;
```

One treatment note per appointment (enforced by `UNIQUE` on `appointment_id`).

### 3.10 `discussion_messages`

```sql
CREATE TABLE discussion_messages (
    id                  UUID PRIMARY KEY,
    appointment_id      UUID NOT NULL REFERENCES appointments(id) ON DELETE RESTRICT,
    sender_account_id   UUID NOT NULL REFERENCES accounts(id),
    sender_role         discussion_sender_role NOT NULL,
    message_type        discussion_message_type NOT NULL,
    body                TEXT,                                -- nullable when ATTACHMENT_ONLY
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    edited_at           TIMESTAMPTZ,
    deleted_at          TIMESTAMPTZ,

    CHECK (body IS NOT NULL OR message_type = 'ATTACHMENT_ONLY')
);

CREATE INDEX idx_dmsg_appt_created
    ON discussion_messages(appointment_id, created_at)
    WHERE deleted_at IS NULL;
```

See [DISCUSSION_SYSTEM_DESIGN.md](./DISCUSSION_SYSTEM_DESIGN.md).

### 3.11 `discussion_message_attachments`

```sql
CREATE TABLE discussion_message_attachments (
    message_id          UUID NOT NULL REFERENCES discussion_messages(id) ON DELETE CASCADE,
    file_id             UUID NOT NULL REFERENCES file_objects(id) ON DELETE RESTRICT,
    PRIMARY KEY (message_id, file_id)
);

CREATE INDEX idx_dmsg_att_file ON discussion_message_attachments(file_id);
```

### 3.12 `file_objects`

```sql
CREATE TABLE file_objects (
    id                  UUID PRIMARY KEY,
    owner_account_id    UUID NOT NULL REFERENCES accounts(id),
    patient_id          UUID NOT NULL REFERENCES patients(id),
    appointment_id      UUID REFERENCES appointments(id),     -- V24: optional; null = standalone library document
    kind                file_kind NOT NULL,
    uploaded_by_role    account_role NOT NULL,                -- V24: drives the patient/physio split in the library
    upload_context      file_context NOT NULL DEFAULT 'LIBRARY',  -- V24: DISCUSSION (chat attachment) vs LIBRARY (document)
    upload_source       VARCHAR(16),                          -- V24: optional client hint (CAMERA/GALLERY/FILE/CONVERTED_PDF)
    mime_type           VARCHAR(64) NOT NULL,                 -- value set mirrors the file_mime enum (see note)
    original_filename   VARCHAR(255) NOT NULL,
    storage_key         VARCHAR(512) NOT NULL UNIQUE,         -- S3 key
    size_bytes          BIGINT NOT NULL,
    sha256_hex          CHAR(64),                             -- set after server-side validation
    status              file_status NOT NULL DEFAULT 'PENDING_UPLOAD',
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    available_at        TIMESTAMPTZ,
    deleted_at          TIMESTAMPTZ,

    CHECK (size_bytes > 0 AND size_bytes <= 20 * 1024 * 1024),
    CONSTRAINT file_mime_whitelist
        CHECK (mime_type IN ('application/pdf', 'image/jpeg', 'image/png')),
    CONSTRAINT file_upload_source_whitelist
        CHECK (upload_source IS NULL OR upload_source IN ('CAMERA', 'GALLERY', 'FILE', 'CONVERTED_PDF'))
);

CREATE INDEX idx_file_patient ON file_objects(patient_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_file_status ON file_objects(status) WHERE status = 'PENDING_UPLOAD';
CREATE INDEX idx_file_owner_created ON file_objects(owner_account_id, created_at);  -- daily upload-cap count
CREATE INDEX idx_file_appointment ON file_objects(appointment_id) WHERE appointment_id IS NOT NULL AND deleted_at IS NULL;
-- Per-patient, per-uploader, newest-first listing of library documents (V24).
CREATE INDEX idx_file_library ON file_objects(patient_id, uploaded_by_role, created_at DESC, id DESC)
    WHERE deleted_at IS NULL AND upload_context = 'LIBRARY';
```

> **`mime_type` storage note (V9).** The `file_mime` enum's labels contain `/`
> (`application/pdf`, …), which cannot map to a Hibernate `@JdbcTypeCode(NAMED_ENUM)`
> Java enum the way every other enum in this schema does. Rather than add a global
> `stringtype=unspecified` JDBC setting for one column, `mime_type` is `VARCHAR(64)`
> constrained by `file_mime_whitelist` to exactly the `file_mime` value set, which
> remains the documented source of truth for allowed types.

See [FILE_STORAGE_GUIDELINES.md](./FILE_STORAGE_GUIDELINES.md).

### 3.13 `notification_outbox`

```sql
CREATE TABLE notification_outbox (
    id                  UUID PRIMARY KEY,
    kind                notification_kind NOT NULL,
    channel             notification_channel NOT NULL DEFAULT 'FCM',
    target_account_id   UUID NOT NULL REFERENCES accounts(id),
    target_fcm_token    TEXT,                                  -- resolved at dispatch
    payload             JSONB NOT NULL,                        -- title, body, deep link
    status              notification_status NOT NULL DEFAULT 'PENDING',
    attempts            SMALLINT NOT NULL DEFAULT 0,
    next_attempt_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    sent_at             TIMESTAMPTZ,
    last_error          TEXT,
    correlation_id      UUID,                                  -- ties events to source domain row
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_notif_due
    ON notification_outbox(next_attempt_at)
    WHERE status = 'PENDING';
```

### 3.13a `fcm_tokens` — device push registration tokens

```sql
CREATE TABLE fcm_tokens (
    id            UUID PRIMARY KEY,
    account_id    UUID NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    token         TEXT NOT NULL,
    platform      VARCHAR(16) NOT NULL DEFAULT 'android',     -- 'ios' added Phase 2
    device_id     VARCHAR(128),
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_seen_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at    TIMESTAMPTZ
);

CREATE UNIQUE INDEX idx_fcm_tokens_token   ON fcm_tokens(token)      WHERE deleted_at IS NULL;
CREATE INDEX        idx_fcm_tokens_account ON fcm_tokens(account_id) WHERE deleted_at IS NULL;
```

Owned by the notifications module (the entity is `FcmToken`). One row per app install;
a token is unique while live. Re-registering a known token rebinds it to the current
account (device re-login / handover). The outbox dispatcher resolves an account's live
tokens at send time and retires any that FCM reports as unregistered (soft-delete).

> The legacy `device_sessions.fcm_token` column (V3) predates this table and is not the
> dispatch source of truth; `fcm_tokens` is. The column is retained (dropping it needs
> approval per the migration rules) and may be removed in a later cleanup.

### 3.13b `notification_preferences` — per-account push opt-outs

```sql
CREATE TABLE notification_preferences (
    account_id              UUID PRIMARY KEY REFERENCES accounts(id) ON DELETE CASCADE,
    appointment_updates     BOOLEAN NOT NULL DEFAULT TRUE,
    appointment_reminders   BOOLEAN NOT NULL DEFAULT TRUE,
    messages                BOOLEAN NOT NULL DEFAULT TRUE,
    treatment_notes         BOOLEAN NOT NULL DEFAULT TRUE,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

Owned by the notifications module (the entity is `NotificationPreferences`). One row per
account; every column is a user-facing **category** (each maps to one or more
`notification_kind` values via `NotificationCategory`). The default is opted-in to
everything, so a **missing row means all-enabled** — `GET /notifications/preferences`
synthesises defaults rather than persisting on read, and a row is created lazily the first
time the account changes a default (`PATCH`). `NotificationPublisher` consults this at enqueue
time and skips writing an outbox row for a recipient who has opted out of that kind's category.
Config rather than clinical data, so there is no `deleted_at` (Hard Rule #7 does not apply).
See [API_STANDARDS.md §9.8](./API_STANDARDS.md#98-notifications).

### 3.14 `audit.audit_log` — separate schema, append-only

```sql
CREATE SCHEMA IF NOT EXISTS audit;

CREATE TABLE audit.audit_log (
    id              BIGSERIAL PRIMARY KEY,
    occurred_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    actor_account_id UUID,
    actor_role      account_role,
    action          audit_action NOT NULL,
    resource_type   VARCHAR(64) NOT NULL,                      -- 'appointment', 'file', etc.
    resource_id     UUID,
    request_id      UUID,
    ip_address      INET,
    metadata        JSONB
);

CREATE INDEX idx_audit_actor_time ON audit.audit_log(actor_account_id, occurred_at DESC);
CREATE INDEX idx_audit_resource ON audit.audit_log(resource_type, resource_id);
```

DB role `healyn_app` is granted `INSERT, SELECT` on `audit.*`. There is no `UPDATE` or `DELETE` grant.

---

## 4. Relationship Diagram

```
              accounts ────┐
                  │        │
                  │        └── account_patients ── patients ─┐
                  │                                          │
                  ├── device_sessions                        │
                  │                                          │
                  ├── account_addresses (1:1 household)      │
                  │                                          │
                  ├── otp_challenges                         │
                  │                                          │
                  ├── availability_rules (physio only)       │
                  ├── blackout_windows   (physio only)       │
                  │                                          │
                  └── appointments (booked_by, physio) ──────┤
                              │                              │
                              ├── treatment_notes ───────────┤
                              │                              │
                              └── discussion_messages        │
                                          │                  │
                                          └── attachments ──▶ file_objects ◀── patients
```

---

## 5. Indexing Strategy Summary

| Query | Supporting Index |
|---|---|
| List appointments for physio on a day | `idx_appt_physio_scheduled` |
| Patient history newest-first | `idx_appt_patient_scheduled` |
| Pending bookings sweeper | `idx_appt_status_scheduled` |
| Patient name autocomplete | `idx_patients_name_trgm` (GIN trigram) |
| Appointment / patient number prefix search | `idx_appointments_number_pattern`, `idx_patients_number_pattern` (`text_pattern_ops`, partial) |
| Outbox poller | `idx_notif_due` (partial) |
| Active sessions for account | `idx_device_sessions_account` (partial) |
| Open OTP per target | `idx_otp_target_purpose_open` (partial) |

Partial indexes are used aggressively because most queries are over "live" (`deleted_at IS NULL`) or "open" (`status = ...`) subsets.

---

## 6. Partitioning Plan (deferred until trigger met)

| Table | Trigger | Strategy |
|---|---|---|
| `appointments` | > 1M rows | Range partition by `scheduled_at` month; retain last 24 months on hot storage. |
| `discussion_messages` | > 5M rows | Range partition by `created_at` month. |
| `audit.audit_log` | > 50M rows | Range partition by `occurred_at` month; archive >12 months to cold storage. |

Phase 1 ships as plain tables. Migrations to partitioned layout are scripted but not applied.

---

## 7. Migration Workflow

- Tool: **Flyway**.
- Location: `backend/src/main/resources/db/migration/V<n>__<snake_name>.sql`.
- One logical change per file. Never edit an applied migration; write a follow-up.
- Every migration must be **idempotent** where possible (`CREATE TABLE IF NOT EXISTS`, `ALTER TABLE ... ADD COLUMN IF NOT EXISTS`).
- Destructive changes (`DROP COLUMN`, `DROP TABLE`) are forbidden in Phase 1.

Bootstrap migrations as applied (one bounded context per file; the early plan's
combined files were split as modules landed):

```
V1__enable_extensions.sql        -- citext, btree_gist, pg_trgm, pgcrypto
V2__create_enums.sql
V3__auth_schema.sql
V4__patients_schema.sql
V5__availability_schema.sql
V6__appointments_schema.sql
V7__discussion_schema.sql        -- messages + read markers (attachments deferred)
V8__treatment_notes_schema.sql
V9__file_objects_schema.sql      -- file metadata (bytes in S3)
V10__discussion_message_attachments.sql  -- wires file_objects into discussion
V11__notification_outbox.sql      -- transactional outbox (enqueue side)
V12__audit_log.sql                -- audit schema + append-only audit_log
V13__fcm_tokens.sql               -- device push tokens (dispatch side, registration API)
V14__notification_preferences.sql -- per-account push opt-outs (API_STANDARDS §9.8)
V15__appointments_request_first.sql -- request-first booking: nullable scheduled_at, requested_date, preferred_time, is_follow_up
```

Migrations V16–V24 landed as features were added (human-friendly ids, appointment
lineage/events, search indexes, device-session revoke reason, household address). The most recent:

```
V23__account_addresses.sql        -- one household postal address per account (§3.5a)
V24__file_documents.sql           -- standalone document library: file_objects gains appointment_id,
                                  -- uploaded_by_role, upload_context, upload_source (§3.12, FILE_STORAGE_GUIDELINES §3)
```

Still pending: nothing schema-side remaining for Phase 1 notifications. The outbox poller +
FCM adapter are application code (no migration), and per-account opt-outs landed in V14.

---

## 8. Scalability Considerations

- **Connection pool**: HikariCP, `maximumPoolSize = 20` per app instance. PG `max_connections = 200` accommodates 8 instances + admin.
- **Read/write split**: All write-paths and read-after-write paths go to primary. Heavy read-only paths (patient history, audit queries) tagged with `@Transactional(readOnly = true)` and routed to a read replica when present.
- **Bulk inserts**: Treatment notes and discussion messages are single-row inserts — no bulk path required.
- **Vacuuming**: Autovacuum tuned for the high-update tables (`appointments`, `device_sessions`).
- **JSONB usage**: Restricted to `notification_outbox.payload` and `audit.audit_log.metadata`. Never use JSONB for domain-essential fields.

---

## 9. Data Retention

| Data | Retention | Mechanism |
|---|---|---|
| Active clinical data | Indefinite | — |
| Soft-deleted clinical data | 7 years from `deleted_at` | Quarterly purge job, archived to cold storage first |
| `otp_challenges` | 24 hours | Hourly cleanup of `expires_at < now() - interval '24 hours'` |
| `notification_outbox` (SENT) | 30 days | Daily archive job |
| `audit.audit_log` | 7 years | Monthly archive of partitions older than 12 months |
| Files in S3 | Mirrors `file_objects.deleted_at` | Lifecycle rule + tombstoning |

---

## 10. Related Documents

- [SYSTEM_ARCHITECTURE.md](./SYSTEM_ARCHITECTURE.md) — module-to-table mapping
- [PATIENT_RELATIONSHIP_MODEL.md](./PATIENT_RELATIONSHIP_MODEL.md) — accounts/patients semantics
- [APPOINTMENT_FLOW.md](./APPOINTMENT_FLOW.md) — state transitions over `appointments`
- [DISCUSSION_SYSTEM_DESIGN.md](./DISCUSSION_SYSTEM_DESIGN.md) — messaging access rules
- [SECURITY_GUIDELINES.md](./SECURITY_GUIDELINES.md) — password hashing, audit guarantees
