package com.healyn.files.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "healyn.s3")
public record HealynS3Properties(
        String endpoint,
        String region,
        String accessKey,
        String secretKey,
        String bucket,
        long presignTtlSeconds) {
}
