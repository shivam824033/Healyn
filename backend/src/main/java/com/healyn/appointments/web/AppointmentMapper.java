package com.healyn.appointments.web;

import com.healyn.appointments.domain.Appointment;
import com.healyn.appointments.domain.AppointmentEvent;
import com.healyn.appointments.service.TimelineEntry;

import java.util.List;

final class AppointmentMapper {

    private AppointmentMapper() {}

    static AppointmentDtos.TimelineView toTimelineView(List<TimelineEntry> entries) {
        return new AppointmentDtos.TimelineView(entries.stream()
                .map(AppointmentMapper::toTimelineEventView)
                .toList());
    }

    private static AppointmentDtos.TimelineEventView toTimelineEventView(TimelineEntry entry) {
        AppointmentEvent e = entry.event();
        return new AppointmentDtos.TimelineEventView(
                e.getAppointmentId(),
                entry.appointmentNumber(),
                e.getEventType(),
                e.getActorAccountId(),
                e.getActorRole(),
                e.getRelatedAppointmentId(),
                e.getChildKind(),
                e.getCancelReason(),
                e.getOccurredAt());
    }

    static AppointmentDtos.AppointmentView toView(Appointment a) {
        return new AppointmentDtos.AppointmentView(
                a.getId(),
                a.getAppointmentNumber(),
                a.getPatientId(),
                a.getBookedByAccountId(),
                a.getPhysiotherapistId(),
                a.getRequestedDate(),
                a.getPreferredTime(),
                a.getScheduledAt(),
                a.getScheduledEndAt(),
                a.getDurationMinutes(),
                a.getStatus(),
                a.isFollowUp(),
                a.getReason(),
                a.getCancelReason(),
                a.getCancelNote(),
                a.getRescheduledFromId(),
                a.getRootAppointmentId(),
                a.getSourceAppointmentId(),
                a.getChildKind(),
                a.getConfirmedAt(),
                a.getStartedAt(),
                a.getCompletedAt(),
                a.getCancelledAt(),
                a.getCreatedAt(),
                a.getUpdatedAt());
    }
}
