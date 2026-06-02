package com.healyn.notifications.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.bind.DefaultValue;

/**
 * Tuning for the outbox dispatcher. Bound from {@code healyn.notifications.*}.
 */
@ConfigurationProperties(prefix = "healyn.notifications")
public record NotificationProperties(
        @DefaultValue("true") boolean pollerEnabled,
        @DefaultValue("2000") long pollIntervalMs,
        @DefaultValue("50") int batchSize,
        @DefaultValue("5") int maxAttempts,
        @DefaultValue("2") long backoffBaseSeconds) {}
