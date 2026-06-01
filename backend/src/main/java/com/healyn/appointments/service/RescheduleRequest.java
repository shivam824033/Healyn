package com.healyn.appointments.service;

import java.time.Instant;

public record RescheduleRequest(
        Instant scheduledAt,
        short durationMinutes,
        String reason) {
}
