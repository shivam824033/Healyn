package com.healyn;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

/**
 * Phase A smoke test: the Spring application context wires together and starts.
 *
 * <p>Data-store-backed verification (Flyway applies V1+V2 against PostgreSQL,
 * Redis client connects, etc.) happens in Phase B's auth integration tests
 * via Testcontainers, where the auth module supplies the schema and Redis
 * usage that justify spinning up containers.
 */
@SpringBootTest(properties = {
        // Don't try to talk to PG, Redis, or load JPA in this smoke test.
        "spring.autoconfigure.exclude="
                + "org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration,"
                + "org.springframework.boot.autoconfigure.jdbc.DataSourceTransactionManagerAutoConfiguration,"
                + "org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration,"
                + "org.springframework.boot.autoconfigure.flyway.FlywayAutoConfiguration,"
                + "org.springframework.boot.autoconfigure.data.redis.RedisAutoConfiguration,"
                + "org.springframework.boot.autoconfigure.data.redis.RedisRepositoriesAutoConfiguration"
})
@ActiveProfiles("test")
class ApplicationBootSmokeTest {

    @Test
    void contextLoads() {
        // Asserting nothing — @SpringBootTest fails if the context can't start.
    }
}
