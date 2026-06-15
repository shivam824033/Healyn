# syntax=docker/dockerfile:1.7
# Reproducible production image for the Healyn backend (audit §11 item 1).
# Multi-stage: build the Spring Boot jar with the JDK, run it on a slim JRE as
# a non-root user. Spring Boot layered jars keep dependency layers cached across
# code-only rebuilds.

# ---- Build stage --------------------------------------------------------------
FROM eclipse-temurin:21-jdk-jammy AS build
WORKDIR /workspace

# Resolve the Gradle wrapper first so it caches independently of source changes.
COPY gradlew ./
COPY gradle ./gradle
COPY settings.gradle.kts build.gradle.kts ./
RUN chmod +x gradlew && ./gradlew --version --no-daemon

# Build the executable jar (tests run in CI, not during the image build), then
# explode it into layers from a stable filename so the runtime stage and the
# ENTRYPOINT don't depend on the project version. Uses the jarmode 'tools'
# extractor (the 'layertools' jarmode is deprecated as of Spring Boot 3.3).
COPY src ./src
RUN ./gradlew clean bootJar -x test --no-daemon \
 && cp build/libs/*.jar build/application.jar \
 && java -Djarmode=tools -jar build/application.jar extract --layers --destination build/extracted

# ---- Runtime stage ------------------------------------------------------------
FROM eclipse-temurin:21-jre-jammy AS runtime
WORKDIR /app

# Non-root runtime user.
RUN groupadd --system --gid 1001 healyn \
 && useradd  --system --uid 1001 --gid healyn --home /app healyn

# Merge the layer directories into the workdir, least- to most-frequently-changing
# for better build caching. The application jar's Class-Path resolves ./lib next to it.
COPY --from=build --chown=healyn:healyn /workspace/build/extracted/dependencies/ ./
COPY --from=build --chown=healyn:healyn /workspace/build/extracted/spring-boot-loader/ ./
COPY --from=build --chown=healyn:healyn /workspace/build/extracted/snapshot-dependencies/ ./
COPY --from=build --chown=healyn:healyn /workspace/build/extracted/application/ ./

USER healyn

# API port; in prod Actuator binds to a separate internal management port
# (HEALYN_MANAGEMENT_PORT, default 9090 — see application-prod.yml).
EXPOSE 8080 9090

# Liveness/readiness is owned by the orchestrator (k8s probes / compose), which
# targets the profile-appropriate Actuator port — see deployment checklist §08.
ENV JAVA_OPTS=""
ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -jar application.jar"]
