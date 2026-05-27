# PATIENT_RELATIONSHIP_MODEL.md

> How an Account, a Patient, and the people they care for fit together.
> This is the single most misunderstood domain area in healthcare apps. Read it before touching `patients`, `account_patients`, or any access-control code.

---

## 1. Mental Model

> **An Account *logs in*. A Patient *receives care*. They are not the same thing.**

- An **Account** is an authentication identity. It owns credentials, a JWT, a device session list. It is *not* a clinical record.
- A **Patient** is a clinical entity. It has a name, date of birth, allergies, appointments, files, treatment notes. It *can* exist without an Account (e.g., an infant managed by a parent).
- An **Account holds one or more Patients** via `account_patients` join rows.

This separation is what makes "one app, whole family" possible without hacky duplicate logins.

---

## 2. Canonical Shapes

```
            ┌────────────────────────┐
            │       Account          │   logs in, owns JWT
            │  (email/phone + pwd)   │
            └───────────┬────────────┘
                        │
                        │  account_patients
                        │  (relationship, is_primary, can_manage)
                        │
            ┌───────────┼─────────────────────────┐
            ▼           ▼                         ▼
        ┌──────┐    ┌──────┐                  ┌──────┐
        │  P1  │    │  P2  │   ...            │  Pn  │   each a Patient
        │ self │    │parent│                  │child │
        └──────┘    └──────┘                  └──────┘
```

- Every Account has **exactly one** Patient marked `is_primary = TRUE` — this is the Account holder themselves.
- An Account may link to **any number** of additional Patients (family members).
- A single Patient **may be linked to multiple Accounts** (e.g., both parents managing the same child).

---

## 3. Lifecycle Rules

### 3.1 Account Registration

1. User submits email or phone + password.
2. OTP verifies the channel (see [SECURITY_GUIDELINES.md](./SECURITY_GUIDELINES.md)).
3. Backend creates `accounts` row (status `ACTIVE`, role `ROLE_ACCOUNT`).
4. Backend creates `patients` row with the user-supplied profile (name, DOB, sex).
5. Backend creates `account_patients(account_id, patient_id, relationship='SELF', is_primary=TRUE, can_manage=TRUE)`.

These four steps happen inside **one DB transaction**. If any step fails, the Account does not exist.

### 3.2 Adding a Family Member Patient

1. Account holder submits the new Patient's profile + relationship.
2. Backend creates a new `patients` row.
3. Backend creates `account_patients(account_id, patient_id, relationship=<chosen>, is_primary=FALSE, can_manage=TRUE)`.

The `is_primary = TRUE` slot is **immutable**. There is no API to change which Patient is the Account's primary. (Rationale: the primary patient is the legal "this is me" anchor for the Account.)

### 3.3 Linking an Existing Patient to a Second Account

Use case: a child Patient is currently managed by Parent A. Parent B wants access.

1. Parent A initiates a *share invite* (Phase 1: API-only; no full UI required).
2. Parent B accepts via a tokenized link.
3. Backend creates `account_patients(account_id=B, patient_id=child, relationship='PARENT', is_primary=FALSE, can_manage=TRUE)`.

The child Patient row is **not** duplicated. The same `patient_id` is referenced by both accounts. All appointments and files remain attached to the single Patient row.

### 3.4 Archiving / Removing a Family Member Patient

- "Remove from my account": deletes the `account_patients` join row only. The Patient row persists if any other Account still links to it; otherwise the Patient is **soft-deleted** (`deleted_at = NOW()`).
- The Account holder cannot remove their own primary patient (would leave the Account orphaned).

### 3.5 Account Closure

- Setting `accounts.deleted_at` does **not** delete linked Patients automatically.
- Each linked Patient is evaluated: if no other live Account links to it, the Patient is also soft-deleted.
- Clinical data (appointments, notes, files) is **never** hard-deleted in Phase 1.

---

## 4. Access Control Rules

Every clinical resource (appointment, file, message, note) belongs to a Patient.
Authorization is the question: **"Does the current Account have access to this Patient?"**

### 4.1 The Policy Function

```
canAccessPatient(account, patientId, mode) :=
    exists row in account_patients
    where account_patients.account_id = account.id
      and account_patients.patient_id = patientId
      and (mode == READ or account_patients.can_manage = TRUE)
    OR
    account.role = 'ROLE_PHYSIO'
```

The physiotherapist has implicit access to every Patient (they are the clinic owner; that is the entire product).

### 4.2 Applied per Resource

| Resource | Read | Write |
|---|---|---|
| Patient profile | `canAccessPatient(account, p.id, READ)` | `canAccessPatient(account, p.id, WRITE)` |
| Appointment | `canAccessPatient(account, appt.patient_id, READ)` | Patient-side: only if `can_manage`. Physio: always. |
| Discussion message (read) | `canAccessPatient(account, appt.patient_id, READ)` | — |
| Discussion message (write) | — | Patient-side: `can_manage`. Physio: always. |
| File | Same as the resource that references it (appointment / treatment note) | Same as above |
| Treatment note | All linked accounts can READ. | Physio only. |

### 4.3 Where It Lives

Authorization is **never** enforced in controllers. It is enforced in the service layer via a `PatientAccessPolicy` class:

```java
@Component
public class PatientAccessPolicy {
    public void requireAccess(AccountId actor, AccountRole role,
                              PatientId patientId, AccessMode mode) {
        if (role == ROLE_PHYSIO) return;
        if (!accountPatientRepo.hasLink(actor, patientId, mode)) {
            throw new ForbiddenException(...);
        }
    }
}
```

Every service method that touches a patient-scoped resource calls `requireAccess` as its first line.

### 4.4 The Audit Pair

Every successful access call (`READ`, `CREATE`, `UPDATE`, `SOFT_DELETE`, `DOWNLOAD`) on a clinical resource emits an `audit.audit_log` row. The decision *and* the action are auditable.

---

## 5. Edge Cases

| Case | Resolution |
|---|---|
| Two accounts both try to edit the same Patient simultaneously | Optimistic concurrency on `patients` via `updated_at` versioning. Second writer gets `409 Conflict`. |
| An account is locked / disabled | All `canAccessPatient` checks fail because the JWT validator rejects the token at the gateway before service code runs. |
| A Patient is soft-deleted but has live appointments | Cannot happen — soft-delete is blocked by an active-appointments check at the service layer. |
| Account holder wants to take ownership of a Patient currently managed by someone else | Requires the current `can_manage` holder to invite + the new owner to accept. No silent ownership grab. |
| Physiotherapist deletes an account | Forbidden. Only the Account holder can soft-delete their own Account. Physio can only mark an Account as `LOCKED`. |
| Account holder is a minor's only manager and the manager dies | Out of Phase 1 scope. Document a manual process (clinic contacts next of kin) and revisit in Phase 3. |

---

## 6. Anti-Patterns (do not do)

- **Do not** model "self" as an Account-without-a-Patient. Every clinical action requires a Patient row, including the user's own.
- **Do not** add a `patient_id` directly on `accounts`. Accounts are not 1:1 with Patients.
- **Do not** allow more than one `is_primary = TRUE` per Account. Enforced by the partial unique index in [DATABASE_SCHEMA.md §3.5](./DATABASE_SCHEMA.md).
- **Do not** let the mobile app pass a Patient ID in the URL without server-side `requireAccess`. Path parameters are user-controlled input.
- **Do not** treat the physiotherapist as a Patient. The physio role is for the *provider*, not a recipient of care.

---

## 7. UI Implications

- The mobile app maintains an **active Patient context** in Riverpod. Every patient-scoped screen reads from this context.
- The home screen surfaces a Patient switcher at the top. Switching changes the context and refetches feeds.
- New patients are added from a "Family" tab. Adding a new patient is a single-screen form with name, DOB, sex, relationship.
- Discussion threads, files, and notes are always presented with a clear "for [Patient name]" header to prevent context confusion.

---

## 8. Related Documents

- [DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md) — exact table definitions
- [APPOINTMENT_FLOW.md](./APPOINTMENT_FLOW.md) — how Patient context flows into bookings
- [SECURITY_GUIDELINES.md](./SECURITY_GUIDELINES.md) — JWT + authorization layering
- [API_STANDARDS.md](./API_STANDARDS.md) — endpoints and their access rules
