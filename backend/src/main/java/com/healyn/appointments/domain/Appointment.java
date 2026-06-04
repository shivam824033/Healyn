package com.healyn.appointments.domain;

import com.healyn.common.persistence.BaseEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.UUID;

@Entity
@Table(name = "appointments")
public class Appointment extends BaseEntity {

    @Column(name = "patient_id", nullable = false, updatable = false)
    private UUID patientId;

    @Column(name = "booked_by_account_id", nullable = false, updatable = false)
    private UUID bookedByAccountId;

    @Column(name = "physiotherapist_id", nullable = false, updatable = false)
    private UUID physiotherapistId;

    @Column(name = "scheduled_at", nullable = false)
    private Instant scheduledAt;

    @Column(name = "scheduled_end_at", nullable = false)
    private Instant scheduledEndAt;

    @Column(name = "duration_minutes", nullable = false)
    private short durationMinutes;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "status", nullable = false, columnDefinition = "appointment_status")
    private AppointmentStatus status;

    @Column(name = "reason")
    private String reason;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "cancel_reason", columnDefinition = "appointment_cancel_reason")
    private AppointmentCancelReason cancelReason;

    @Column(name = "cancel_note")
    private String cancelNote;

    @Column(name = "rescheduled_from_id", updatable = false)
    private UUID rescheduledFromId;

    @Column(name = "confirmed_at")
    private Instant confirmedAt;

    @Column(name = "started_at")
    private Instant startedAt;

    @Column(name = "completed_at")
    private Instant completedAt;

    @Column(name = "cancelled_at")
    private Instant cancelledAt;

    @Column(name = "deleted_at")
    private Instant deletedAt;

    protected Appointment() {}

    public Appointment(UUID id,
                       UUID patientId,
                       UUID bookedByAccountId,
                       UUID physiotherapistId,
                       Instant scheduledAt,
                       short durationMinutes,
                       String reason,
                       UUID rescheduledFromId) {
        this.id = id;
        this.patientId = patientId;
        this.bookedByAccountId = bookedByAccountId;
        this.physiotherapistId = physiotherapistId;
        this.scheduledAt = scheduledAt;
        this.scheduledEndAt = scheduledAt.plus(durationMinutes, ChronoUnit.MINUTES);
        this.durationMinutes = durationMinutes;
        this.reason = reason;
        this.rescheduledFromId = rescheduledFromId;
        this.status = AppointmentStatus.REQUESTED;
    }

    public UUID getPatientId() { return patientId; }
    public UUID getBookedByAccountId() { return bookedByAccountId; }
    public UUID getPhysiotherapistId() { return physiotherapistId; }
    public Instant getScheduledAt() { return scheduledAt; }
    public Instant getScheduledEndAt() { return scheduledEndAt; }
    public short getDurationMinutes() { return durationMinutes; }
    public AppointmentStatus getStatus() { return status; }
    public String getReason() { return reason; }
    public AppointmentCancelReason getCancelReason() { return cancelReason; }
    public String getCancelNote() { return cancelNote; }
    public UUID getRescheduledFromId() { return rescheduledFromId; }
    public Instant getConfirmedAt() { return confirmedAt; }
    public Instant getStartedAt() { return startedAt; }
    public Instant getCompletedAt() { return completedAt; }
    public Instant getCancelledAt() { return cancelledAt; }
    public Instant getDeletedAt() { return deletedAt; }

    public void confirm(Instant now) {
        this.status = AppointmentStatus.CONFIRMED;
        this.confirmedAt = now;
    }

    public void start(Instant now) {
        this.status = AppointmentStatus.IN_PROGRESS;
        this.startedAt = now;
    }

    public void complete(Instant now) {
        this.status = AppointmentStatus.COMPLETED;
        this.completedAt = now;
    }

    public void cancel(Instant now, AppointmentCancelReason reason, String note) {
        this.status = AppointmentStatus.CANCELLED;
        this.cancelledAt = now;
        this.cancelReason = reason;
        this.cancelNote = note;
    }

    public void markNoShow() {
        this.status = AppointmentStatus.NO_SHOW;
    }

    public void markRescheduled() {
        this.status = AppointmentStatus.RESCHEDULED;
    }
}
