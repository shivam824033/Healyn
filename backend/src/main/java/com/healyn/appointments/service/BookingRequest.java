package com.healyn.appointments.service;

import java.time.Instant;
import java.util.UUID;

public record BookingRequest(
        UUID patientId,
        Instant scheduledAt,
        short durationMinutes,
        String reason) {
}
