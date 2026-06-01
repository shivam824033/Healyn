package com.healyn.common.error;

public final class ErrorCode {

    public static final String VALIDATION_FAILED = "common.validation_failed";
    public static final String UNAUTHORIZED = "common.unauthorized";
    public static final String FORBIDDEN = "common.forbidden";
    public static final String NOT_FOUND = "common.not_found";
    public static final String CONFLICT = "common.conflict";
    public static final String UNPROCESSABLE = "common.unprocessable";
    public static final String RATE_LIMITED = "common.rate_limited";
    public static final String INTERNAL = "common.internal";
    public static final String IDEMPOTENCY_CONFLICT = "common.idempotency_conflict";

    public static final String PATIENTS_PRIMARY_REQUIRED = "patients.primary_required";
    public static final String PATIENTS_RELATIONSHIP_EXISTS = "patients.relationship_exists";
    public static final String PATIENTS_NOT_FOUND = "patients.not_found";

    public static final String AVAILABILITY_RULE_NOT_FOUND = "availability.rule_not_found";
    public static final String AVAILABILITY_BLACKOUT_NOT_FOUND = "availability.blackout_not_found";
    public static final String AVAILABILITY_INVALID_TIMEZONE = "availability.invalid_timezone";
    public static final String AVAILABILITY_INVALID_RANGE = "availability.invalid_range";
    public static final String AVAILABILITY_BLACKOUT_OVERLAP = "availability.blackout_overlap";

    public static final String APPOINTMENT_NOT_FOUND = "appointments.not_found";
    public static final String APPOINTMENT_INVALID_TRANSITION = "appointments.invalid_transition";
    public static final String APPOINTMENT_SLOT_UNAVAILABLE = "appointments.slot_unavailable";
    public static final String APPOINTMENT_INVALID_SCHEDULE = "appointments.invalid_schedule";
    public static final String APPOINTMENT_CANCEL_REASON_REQUIRED = "appointments.cancel_reason_required";

    public static final String COMMON_IDEMPOTENCY_KEY_REQUIRED = "common.idempotency_key_required";
    public static final String COMMON_INVALID_CURSOR = "common.invalid_cursor";

    private ErrorCode() {}
}
