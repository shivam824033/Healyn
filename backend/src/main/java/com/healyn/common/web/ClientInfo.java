package com.healyn.common.web;

import jakarta.servlet.http.HttpServletRequest;

/// Extracts client network metadata (IP, user agent) from a request, honouring a
/// reverse-proxy {@code X-Forwarded-For} header. Shared by modules that persist this
/// metadata on consent and session records.
public final class ClientInfo {

    private static final int USER_AGENT_MAX = 512;

    private ClientInfo() {}

    public static String clientIp(HttpServletRequest http) {
        String forwarded = http.getHeader("X-Forwarded-For");
        if (forwarded != null && !forwarded.isBlank()) {
            int comma = forwarded.indexOf(',');
            return (comma > 0 ? forwarded.substring(0, comma) : forwarded).trim();
        }
        return http.getRemoteAddr();
    }

    public static String userAgent(HttpServletRequest http) {
        return truncate(http.getHeader("User-Agent"), USER_AGENT_MAX);
    }

    private static String truncate(String s, int max) {
        if (s == null) return null;
        return s.length() <= max ? s : s.substring(0, max);
    }
}
