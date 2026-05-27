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

    private ErrorCode() {}
}
