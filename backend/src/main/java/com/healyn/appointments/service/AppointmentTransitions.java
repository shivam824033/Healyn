package com.healyn.appointments.service;

import com.healyn.appointments.domain.AppointmentStatus;
import com.healyn.common.error.ConflictException;
import com.healyn.common.error.ErrorCode;

import java.util.EnumMap;
import java.util.EnumSet;
import java.util.Map;
import java.util.Set;

public final class AppointmentTransitions {

    private static final Map<AppointmentStatus, Set<AppointmentStatus>> ALLOWED =
            new EnumMap<>(AppointmentStatus.class);

    static {
        ALLOWED.put(AppointmentStatus.REQUESTED, EnumSet.of(
                AppointmentStatus.CONFIRMED,
                AppointmentStatus.CANCELLED,
                AppointmentStatus.RESCHEDULED));
        ALLOWED.put(AppointmentStatus.CONFIRMED, EnumSet.of(
                AppointmentStatus.IN_PROGRESS,
                AppointmentStatus.CANCELLED,
                AppointmentStatus.RESCHEDULED,
                AppointmentStatus.NO_SHOW));
        ALLOWED.put(AppointmentStatus.IN_PROGRESS, EnumSet.of(
                AppointmentStatus.COMPLETED,
                AppointmentStatus.CANCELLED));
        ALLOWED.put(AppointmentStatus.COMPLETED, EnumSet.noneOf(AppointmentStatus.class));
        ALLOWED.put(AppointmentStatus.CANCELLED, EnumSet.noneOf(AppointmentStatus.class));
        ALLOWED.put(AppointmentStatus.NO_SHOW, EnumSet.noneOf(AppointmentStatus.class));
        ALLOWED.put(AppointmentStatus.RESCHEDULED, EnumSet.noneOf(AppointmentStatus.class));
    }

    private AppointmentTransitions() {}

    public static boolean isAllowed(AppointmentStatus from, AppointmentStatus to) {
        return ALLOWED.getOrDefault(from, EnumSet.noneOf(AppointmentStatus.class)).contains(to);
    }

    public static void requireAllowed(AppointmentStatus from, AppointmentStatus to) {
        if (!isAllowed(from, to)) {
            throw new ConflictException(
                    ErrorCode.APPOINTMENT_INVALID_TRANSITION,
                    "Cannot transition appointment from " + from + " to " + to);
        }
    }
}
