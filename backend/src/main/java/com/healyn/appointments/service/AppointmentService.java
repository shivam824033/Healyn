package com.healyn.appointments.service;

import com.healyn.appointments.domain.Appointment;
import com.healyn.appointments.domain.AppointmentStatus;
import com.healyn.appointments.policy.AppointmentAccessPolicy;
import com.healyn.appointments.repository.AppointmentRepository;
import com.healyn.auth.domain.AccountRole;
import com.healyn.auth.repository.AccountRepository;
import com.healyn.availability.service.Slot;
import com.healyn.availability.service.SlotExpansionService;
import com.healyn.availability.service.TimeRange;
import com.healyn.common.error.ConflictException;
import com.healyn.common.error.ErrorCode;
import com.healyn.common.error.NotFoundException;
import com.healyn.common.error.UnprocessableException;
import com.healyn.common.id.UuidV7;
import com.healyn.common.pagination.Cursor;
import com.healyn.common.pagination.CursorPage;
import com.healyn.patients.repository.AccountPatientRepository;
import org.postgresql.util.PSQLException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Limit;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Collection;
import java.util.EnumSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class AppointmentService {

    private static final String PG_EXCLUSION_VIOLATION = "23P01";
    private static final Duration BOOKING_CLOCK_SKEW = Duration.ofMinutes(5);
    private static final Duration BOOKING_MAX_HORIZON = Duration.ofDays(90);
    private static final short MIN_DURATION = 5;
    private static final short MAX_DURATION = 240;
    private static final Set<AppointmentStatus> BLOCKING_STATUSES = EnumSet.of(
            AppointmentStatus.REQUESTED,
            AppointmentStatus.CONFIRMED,
            AppointmentStatus.IN_PROGRESS);

    private final AppointmentRepository appointments;
    private final AccountRepository accounts;
    private final AccountPatientRepository accountPatients;
    private final SlotExpansionService slots;
    private final AppointmentAccessPolicy access;
    private final IdempotencyGuard idempotency;
    private final Clock clock;

    public AppointmentService(AppointmentRepository appointments,
                              AccountRepository accounts,
                              AccountPatientRepository accountPatients,
                              SlotExpansionService slots,
                              AppointmentAccessPolicy access,
                              IdempotencyGuard idempotency,
                              Clock clock) {
        this.appointments = appointments;
        this.accounts = accounts;
        this.accountPatients = accountPatients;
        this.slots = slots;
        this.access = access;
        this.idempotency = idempotency;
        this.clock = clock;
    }

    @Transactional
    public Appointment book(UUID actorId, AccountRole role, BookingRequest req, String idempotencyKey) {
        if (idempotencyKey == null || idempotencyKey.isBlank()) {
            throw new UnprocessableException(ErrorCode.COMMON_IDEMPOTENCY_KEY_REQUIRED,
                    "Idempotency-Key header is required");
        }
        Optional<UUID> replay = idempotency.lookup(actorId, idempotencyKey);
        if (replay.isPresent()) {
            return appointments.findByIdAndDeletedAtIsNull(replay.get())
                    .orElseThrow(() -> new NotFoundException(ErrorCode.APPOINTMENT_NOT_FOUND,
                            "Appointment not found"));
        }

        access.requireBook(actorId, role, req.patientId());
        UUID physioId = resolvePhysioId();
        validateSchedule(req.scheduledAt(), req.durationMinutes());
        requireSlotExists(physioId, req.scheduledAt(), req.durationMinutes());

        Appointment appt = new Appointment(
                UuidV7.generate(),
                req.patientId(),
                actorId,
                physioId,
                req.scheduledAt(),
                req.durationMinutes(),
                req.reason(),
                null);
        Appointment saved = appointments.save(appt);
        idempotency.store(actorId, idempotencyKey, saved.getId());
        // TODO outbox(BOOKING_REQUESTED) — wired in the notifications PR.
        return saved;
    }

    @Transactional(readOnly = true)
    public Appointment get(UUID actorId, AccountRole role, UUID appointmentId) {
        Appointment appt = loadActive(appointmentId);
        access.requireRead(actorId, role, appt);
        return appt;
    }

    @Transactional(readOnly = true)
    public CursorPage<Appointment> list(UUID actorId, AccountRole role,
                                        UUID patientIdFilter,
                                        Collection<AppointmentStatus> statuses,
                                        Instant from, Instant to,
                                        String cursorToken, int limit) {
        if (limit <= 0 || limit > 50) limit = 20;
        Collection<UUID> patientIds = resolvePatientIdScope(actorId, role, patientIdFilter);
        // empty collection means "no patient visible" => empty page.
        if (patientIds != null && patientIds.isEmpty()) {
            return new CursorPage<>(List.of(), null);
        }
        Collection<AppointmentStatus> statusFilter =
                (statuses == null || statuses.isEmpty()) ? null : statuses;

        Limit lim = Limit.of(limit + 1);
        List<Appointment> rows;
        if (cursorToken == null || cursorToken.isBlank()) {
            rows = appointments.listFirstPage(patientIds, statusFilter, from, to, lim);
        } else {
            Cursor c = Cursor.decode(cursorToken);
            rows = appointments.listAfterCursor(patientIds, statusFilter, from, to, c.pivot(), c.id(), lim);
        }

        String nextCursor = null;
        if (rows.size() > limit) {
            Appointment pivot = rows.get(limit - 1);
            nextCursor = new Cursor(pivot.getScheduledAt(), pivot.getId()).encode();
            rows = rows.subList(0, limit);
        }
        return new CursorPage<>(new ArrayList<>(rows), nextCursor);
    }

    @Transactional
    public Appointment transition(UUID actorId, AccountRole role, UUID appointmentId, TransitionRequest req) {
        Appointment appt = loadActive(appointmentId);
        access.requireTransition(actorId, role, appt, req.to());
        AppointmentTransitions.requireAllowed(appt.getStatus(), req.to());

        Instant now = Instant.now(clock);
        switch (req.to()) {
            case CONFIRMED -> appt.confirm(now);
            case IN_PROGRESS -> appt.start(now);
            case COMPLETED -> appt.complete(now);
            case CANCELLED -> {
                if (req.cancelReason() == null) {
                    throw new UnprocessableException(ErrorCode.APPOINTMENT_CANCEL_REASON_REQUIRED,
                            "cancelReason is required when cancelling");
                }
                appt.cancel(now, req.cancelReason(), req.cancelNote());
            }
            case NO_SHOW -> appt.markNoShow();
            default -> throw new ConflictException(ErrorCode.APPOINTMENT_INVALID_TRANSITION,
                    "Cannot transition to " + req.to() + " via this endpoint");
        }

        try {
            return appointments.saveAndFlush(appt);
        } catch (DataIntegrityViolationException e) {
            if (isExclusionViolation(e)) {
                throw new ConflictException(ErrorCode.APPOINTMENT_SLOT_UNAVAILABLE,
                        "Slot is no longer available for the physiotherapist");
            }
            throw e;
        }
        // TODO outbox(BOOKING_CONFIRMED / BOOKING_CANCELLED) — wired in the notifications PR.
    }

    @Transactional
    public Appointment reschedule(UUID actorId, AccountRole role, UUID appointmentId, RescheduleRequest req) {
        Appointment old = loadActive(appointmentId);
        access.requireReschedule(actorId, role, old);
        if (old.getStatus() != AppointmentStatus.REQUESTED && old.getStatus() != AppointmentStatus.CONFIRMED) {
            throw new ConflictException(ErrorCode.APPOINTMENT_INVALID_TRANSITION,
                    "Only REQUESTED or CONFIRMED appointments can be rescheduled");
        }
        validateSchedule(req.scheduledAt(), req.durationMinutes());
        requireSlotExists(old.getPhysiotherapistId(), req.scheduledAt(), req.durationMinutes());

        Appointment fresh = new Appointment(
                UuidV7.generate(),
                old.getPatientId(),
                actorId,
                old.getPhysiotherapistId(),
                req.scheduledAt(),
                req.durationMinutes(),
                req.reason() != null ? req.reason() : old.getReason(),
                old.getId());
        Appointment saved = appointments.save(fresh);
        old.markRescheduled();
        return saved;
    }

    // ---- helpers ----

    private Appointment loadActive(UUID id) {
        return appointments.findByIdAndDeletedAtIsNull(id)
                .orElseThrow(() -> new NotFoundException(ErrorCode.APPOINTMENT_NOT_FOUND,
                        "Appointment not found"));
    }

    private UUID resolvePhysioId() {
        return accounts.findFirstByRoleAndDeletedAtIsNullOrderByCreatedAtAsc(AccountRole.ROLE_PHYSIO)
                .orElseThrow(() -> new NotFoundException(ErrorCode.APPOINTMENT_SLOT_UNAVAILABLE,
                        "No physiotherapist is configured"))
                .getId();
    }

    private void validateSchedule(Instant scheduledAt, short durationMinutes) {
        if (scheduledAt == null) {
            throw new UnprocessableException(ErrorCode.APPOINTMENT_INVALID_SCHEDULE,
                    "scheduledAt is required");
        }
        if (durationMinutes < MIN_DURATION || durationMinutes > MAX_DURATION) {
            throw new UnprocessableException(ErrorCode.APPOINTMENT_INVALID_SCHEDULE,
                    "durationMinutes must be between " + MIN_DURATION + " and " + MAX_DURATION);
        }
        Instant now = Instant.now(clock);
        if (scheduledAt.isBefore(now.minus(BOOKING_CLOCK_SKEW))) {
            throw new UnprocessableException(ErrorCode.APPOINTMENT_INVALID_SCHEDULE,
                    "scheduledAt cannot be in the past");
        }
        if (scheduledAt.isAfter(now.plus(BOOKING_MAX_HORIZON))) {
            throw new UnprocessableException(ErrorCode.APPOINTMENT_INVALID_SCHEDULE,
                    "scheduledAt is more than 90 days in the future");
        }
    }

    private void requireSlotExists(UUID physioId, Instant scheduledAt, short durationMinutes) {
        LocalDate day = scheduledAt.atZone(ZoneOffset.UTC).toLocalDate();
        Instant dayStart = day.atStartOfDay(ZoneOffset.UTC).toInstant();
        Instant dayEnd = day.plusDays(1).atStartOfDay(ZoneOffset.UTC).toInstant();

        List<TimeRange> bookedRanges = appointments
                .findByPhysioAndScheduledBetween(physioId, dayStart, dayEnd)
                .stream()
                .filter(a -> BLOCKING_STATUSES.contains(a.getStatus()))
                .map(a -> new TimeRange(a.getScheduledAt(),
                        a.getScheduledAt().plus(a.getDurationMinutes(), ChronoUnit.MINUTES)))
                .toList();

        List<Slot> candidates = slots.expandSlots(physioId, day, day, bookedRanges);
        boolean exists = candidates.stream()
                .anyMatch(s -> s.startsAt().equals(scheduledAt) && s.durationMinutes() == durationMinutes);
        if (!exists) {
            throw new ConflictException(ErrorCode.APPOINTMENT_SLOT_UNAVAILABLE,
                    "Requested slot is not available");
        }
    }

    private Collection<UUID> resolvePatientIdScope(UUID actorId, AccountRole role, UUID patientIdFilter) {
        if (role == AccountRole.ROLE_PHYSIO) {
            return patientIdFilter == null ? null : List.of(patientIdFilter);
        }
        Set<UUID> linked = accountPatients.findActivePatientsForAccount(actorId).stream()
                .map(p -> p.getId())
                .collect(Collectors.toCollection(java.util.LinkedHashSet::new));
        if (patientIdFilter != null) {
            if (!linked.contains(patientIdFilter)) {
                return List.of(); // unauthorized filter -> empty page (avoid leaking existence).
            }
            return List.of(patientIdFilter);
        }
        return linked;
    }

    private static boolean isExclusionViolation(DataIntegrityViolationException e) {
        Throwable cause = e.getCause();
        while (cause != null) {
            if (cause instanceof PSQLException psql && PG_EXCLUSION_VIOLATION.equals(psql.getSQLState())) {
                return true;
            }
            cause = cause.getCause();
        }
        return false;
    }

}
