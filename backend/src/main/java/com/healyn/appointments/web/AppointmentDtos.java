package com.healyn.appointments.web;

import com.healyn.appointments.domain.AppointmentCancelReason;
import com.healyn.appointments.domain.AppointmentStatus;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.UUID;

public final class AppointmentDtos {

    private AppointmentDtos() {}

    /// A patient request: the date is mandatory, the time-of-day is an optional hint.
    /// The patient never sends a final time — the physiotherapist sets it via /schedule.
    public record BookRequest(
            @NotNull UUID patientId,
            @NotNull LocalDate requestedDate,
            LocalTime preferredTime,
            @Size(max = 280) String reason) {}

    public record TransitionRequestBody(
            @NotNull AppointmentStatus to,
            AppointmentCancelReason cancelReason,
            @Size(max = 2000) String cancelNote) {}

    public record RescheduleRequestBody(
            @NotNull Instant scheduledAt,
            @NotNull @Min(5) @Max(240) Short durationMinutes,
            @Size(max = 280) String reason) {}

    public record AppointmentView(
            UUID id,
            UUID patientId,
            UUID bookedByAccountId,
            UUID physiotherapistId,
            LocalDate requestedDate,
            LocalTime preferredTime,
            Instant scheduledAt,
            Instant scheduledEndAt,
            short durationMinutes,
            AppointmentStatus status,
            boolean isFollowUp,
            String reason,
            AppointmentCancelReason cancelReason,
            String cancelNote,
            UUID rescheduledFromId,
            Instant confirmedAt,
            Instant startedAt,
            Instant completedAt,
            Instant cancelledAt,
            Instant createdAt,
            Instant updatedAt) {}

    public record AppointmentPage(List<AppointmentView> items, String nextCursor) {}
}
