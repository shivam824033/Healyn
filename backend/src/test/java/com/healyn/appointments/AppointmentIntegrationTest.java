package com.healyn.appointments;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.healyn.appointments.domain.Appointment;
import com.healyn.appointments.repository.AppointmentRepository;
import com.healyn.auth.adapter.OtpSender;
import com.healyn.auth.domain.Account;
import com.healyn.auth.domain.AccountRole;
import com.healyn.auth.domain.OtpChannel;
import com.healyn.auth.repository.AccountRepository;
import com.healyn.auth.service.AccessTokenIssuer;
import com.healyn.common.id.UuidV7;
import com.redis.testcontainers.RedisContainer;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;
import org.springframework.context.annotation.Primary;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.testcontainers.utility.DockerImageName;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Testcontainers
@Import(AppointmentIntegrationTest.CapturingConfig.class)
class AppointmentIntegrationTest {

    private static final ZoneId KOLKATA = ZoneId.of("Asia/Kolkata");

    @Container
    static final PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");

    @Container
    static final RedisContainer redis = new RedisContainer(DockerImageName.parse("redis:7-alpine"));

    @DynamicPropertySource
    static void props(DynamicPropertyRegistry r) {
        r.add("spring.datasource.url", postgres::getJdbcUrl);
        r.add("spring.datasource.username", postgres::getUsername);
        r.add("spring.datasource.password", postgres::getPassword);
        r.add("spring.data.redis.host", redis::getHost);
        r.add("spring.data.redis.port", () -> redis.getFirstMappedPort());
        r.add("healyn.password.pepper", () -> "test-pepper-not-a-real-secret");
    }

    @TestConfiguration
    static class CapturingConfig {
        @Bean @Primary CapturingOtpSender capturingOtpSender() { return new CapturingOtpSender(); }
    }

    static class CapturingOtpSender implements OtpSender {
        final Map<String, String> latestByTarget = new ConcurrentHashMap<>();
        @Override public void send(String target, OtpChannel channel, String code) {
            latestByTarget.put(target, code);
        }
    }

    @Autowired MockMvc mvc;
    @Autowired ObjectMapper json;
    @Autowired CapturingOtpSender otpSender;
    @Autowired AccountRepository accounts;
    @Autowired AppointmentRepository appointments;
    @Autowired AccessTokenIssuer tokenIssuer;

    @BeforeEach
    void reset() {
        otpSender.latestByTarget.clear();
    }

    @Test
    void books_slot_then_second_account_gets_409_on_same_instant() throws Exception {
        Session physio = seedPhysio();
        createMondayRule(physio);
        Session a = registerPatient("ann");
        Session b = registerPatient("ben");
        UUID patientA = primaryPatientId(a);
        UUID patientB = primaryPatientId(b);

        String slot = nextMondayAt(9, 0);

        bookOk(a, patientA, slot, "idem-a-1");

        mvc.perform(post("/appointments")
                        .header("Authorization", "Bearer " + b.access)
                        .header("Idempotency-Key", "idem-b-1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json.writeValueAsString(Map.of(
                                "patient_id", patientB.toString(),
                                "scheduled_at", slot,
                                "duration_minutes", 30))))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.error.code").value("appointments.slot_unavailable"));
    }

    @Test
    void booking_slot_outside_rule_window_returns_409() throws Exception {
        Session physio = seedPhysio();
        createMondayRule(physio);
        Session a = registerPatient("carl");
        UUID patientA = primaryPatientId(a);

        String offRule = nextMondayAt(20, 0);

        mvc.perform(post("/appointments")
                        .header("Authorization", "Bearer " + a.access)
                        .header("Idempotency-Key", "idem-c-1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json.writeValueAsString(Map.of(
                                "patient_id", patientA.toString(),
                                "scheduled_at", offRule,
                                "duration_minutes", 30))))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.error.code").value("appointments.slot_unavailable"));
    }

    @Test
    void patient_cannot_transition_to_completed() throws Exception {
        Session physio = seedPhysio();
        createMondayRule(physio);
        Session a = registerPatient("dora");
        UUID patientA = primaryPatientId(a);

        UUID apptId = bookOk(a, patientA, nextMondayAt(9, 30), "idem-d-1");

        mvc.perform(post("/appointments/" + apptId + "/transitions")
                        .header("Authorization", "Bearer " + a.access)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json.writeValueAsString(Map.of("to", "COMPLETED"))))
                .andExpect(status().isForbidden());
    }

    @Test
    void reschedule_marks_old_rescheduled_and_creates_new_requested() throws Exception {
        Session physio = seedPhysio();
        createMondayRule(physio);
        Session a = registerPatient("eve");
        UUID patientA = primaryPatientId(a);

        UUID oldId = bookOk(a, patientA, nextMondayAt(10, 0), "idem-e-1");

        MvcResult res = mvc.perform(post("/appointments/" + oldId + "/reschedule")
                        .header("Authorization", "Bearer " + a.access)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json.writeValueAsString(Map.of(
                                "scheduled_at", nextMondayAt(10, 30),
                                "duration_minutes", 30))))
                .andExpect(status().isCreated())
                .andReturn();
        JsonNode body = json.readTree(res.getResponse().getContentAsByteArray());
        assertThat(body.get("status").asText()).isEqualTo("REQUESTED");
        assertThat(body.get("rescheduled_from_id").asText()).isEqualTo(oldId.toString());

        mvc.perform(get("/appointments/" + oldId)
                        .header("Authorization", "Bearer " + a.access))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("RESCHEDULED"));
    }

    @Test
    void cancel_without_reason_returns_422() throws Exception {
        Session physio = seedPhysio();
        createMondayRule(physio);
        Session a = registerPatient("fay");
        UUID patientA = primaryPatientId(a);

        UUID apptId = bookOk(a, patientA, nextMondayAt(11, 0), "idem-f-1");

        mvc.perform(post("/appointments/" + apptId + "/transitions")
                        .header("Authorization", "Bearer " + a.access)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json.writeValueAsString(Map.of("to", "CANCELLED"))))
                .andExpect(status().isUnprocessableEntity())
                .andExpect(jsonPath("$.error.code").value("appointments.cancel_reason_required"));
    }

    @Test
    void idempotency_replay_returns_same_appointment_id() throws Exception {
        Session physio = seedPhysio();
        createMondayRule(physio);
        Session a = registerPatient("gus");
        UUID patientA = primaryPatientId(a);

        String slot = nextMondayAt(11, 30);
        String body = json.writeValueAsString(Map.of(
                "patient_id", patientA.toString(),
                "scheduled_at", slot,
                "duration_minutes", 30));

        MvcResult first = mvc.perform(post("/appointments")
                        .header("Authorization", "Bearer " + a.access)
                        .header("Idempotency-Key", "idem-g-1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isCreated())
                .andReturn();
        MvcResult replay = mvc.perform(post("/appointments")
                        .header("Authorization", "Bearer " + a.access)
                        .header("Idempotency-Key", "idem-g-1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isCreated())
                .andReturn();

        String firstId = json.readTree(first.getResponse().getContentAsByteArray()).get("id").asText();
        String replayId = json.readTree(replay.getResponse().getContentAsByteArray()).get("id").asText();
        assertThat(replayId).isEqualTo(firstId);
    }

    @Test
    void cursor_pagination_walks_all_pages() throws Exception {
        Session physio = seedPhysio();
        Session a = registerPatient("hal");
        UUID patientA = primaryPatientId(a);

        // Seed 25 appointments directly through the repository (bypassing slot validation).
        for (int i = 0; i < 25; i++) {
            Appointment appt = new Appointment(
                    UuidV7.generate(),
                    patientA,
                    a.id != null ? a.id : accountIdOf(a),
                    physio.id,
                    ZonedDateTime.now(KOLKATA).plusDays(1 + i).toInstant(),
                    (short) 30,
                    "seed-" + i,
                    null);
            appointments.save(appt);
        }

        int seen = 0;
        String cursor = null;
        for (int page = 0; page < 5 && (page == 0 || cursor != null); page++) {
            var req = get("/appointments")
                    .header("Authorization", "Bearer " + a.access)
                    .param("limit", "10");
            if (cursor != null) req = req.param("cursor", cursor);
            MvcResult res = mvc.perform(req).andExpect(status().isOk()).andReturn();
            JsonNode node = json.readTree(res.getResponse().getContentAsByteArray());
            seen += node.get("items").size();
            JsonNode cursorNode = node.get("next_cursor"); // omitted entirely on the last page
            cursor = (cursorNode == null || cursorNode.isNull()) ? null : cursorNode.asText();
            if (cursor == null) break;
        }
        assertThat(seen).isEqualTo(25);
        assertThat(cursor).isNull();
    }

    @Test
    void physio_list_filters_to_a_single_patient_via_patient_id_param() throws Exception {
        Session physio = seedPhysio();
        Session a = registerPatient("ida");
        Session b = registerPatient("ivy");
        UUID patientA = primaryPatientId(a);
        UUID patientB = primaryPatientId(b);

        seedAppointment(patientA, physio.id, accountIdOf(a), 1);
        seedAppointment(patientB, physio.id, accountIdOf(b), 2);

        MvcResult res = mvc.perform(get("/appointments")
                        .header("Authorization", "Bearer " + physio.access)
                        .param("patient_id", patientA.toString())
                        .param("limit", "50"))
                .andExpect(status().isOk())
                .andReturn();

        JsonNode items = json.readTree(res.getResponse().getContentAsByteArray()).get("items");
        assertThat(items.size()).isGreaterThan(0);
        for (JsonNode item : items) {
            assertThat(item.get("patient_id").asText()).isEqualTo(patientA.toString());
        }
    }

    // ---- helpers ----

    private void seedAppointment(UUID patientId, UUID physioId, UUID bookedBy, int dayOffset) {
        appointments.save(new Appointment(
                UuidV7.generate(),
                patientId,
                bookedBy,
                physioId,
                ZonedDateTime.now(KOLKATA).plusDays(dayOffset).toInstant(),
                (short) 30,
                "seed",
                null));
    }

    private UUID bookOk(Session actor, UUID patientId, String scheduledAt, String key) throws Exception {
        MvcResult res = mvc.perform(post("/appointments")
                        .header("Authorization", "Bearer " + actor.access)
                        .header("Idempotency-Key", key)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json.writeValueAsString(Map.of(
                                "patient_id", patientId.toString(),
                                "scheduled_at", scheduledAt,
                                "duration_minutes", 30))))
                .andExpect(status().isCreated())
                .andReturn();
        return UUID.fromString(json.readTree(res.getResponse().getContentAsByteArray()).get("id").asText());
    }

    private void createMondayRule(Session physio) throws Exception {
        String effectiveFrom = LocalDate.now().minusDays(30).toString();
        mvc.perform(post("/availability/rules")
                        .header("Authorization", "Bearer " + physio.access)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json.writeValueAsString(Map.of(
                                "day_of_week", 1,
                                "start_time", "09:00:00",
                                "end_time", "13:00:00",
                                "slot_minutes", 30,
                                "timezone", "Asia/Kolkata",
                                "effective_from", effectiveFrom))))
                .andExpect(status().isCreated());
    }

    private static String nextMondayAt(int hour, int minute) {
        LocalDate today = LocalDate.now(KOLKATA);
        int daysAhead = (DayOfWeek.MONDAY.getValue() - today.getDayOfWeek().getValue() + 7) % 7;
        if (daysAhead == 0) daysAhead = 7;
        LocalDate monday = today.plusDays(daysAhead);
        return ZonedDateTime.of(monday, java.time.LocalTime.of(hour, minute), KOLKATA)
                .toInstant()
                .toString();
    }

    private Session seedPhysio() {
        String email = "physio+" + UUID.randomUUID() + "@clinic.example.com";
        Account physio = new Account(
                UuidV7.generate(), email, null,
                "$argon2id$placeholder$noop", new byte[]{0},
                AccountRole.ROLE_PHYSIO);
        accounts.save(physio);
        String token = tokenIssuer.issue(physio).token();
        return new Session(physio.getId(), token);
    }

    private Session registerPatient(String tag) throws Exception {
        String email = tag + "+" + UUID.randomUUID() + "@example.com";
        MvcResult startRes = mvc.perform(post("/auth/register/start")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json.writeValueAsBytes(Map.of("target", Map.of("email", email)))))
                .andExpect(status().isAccepted())
                .andReturn();
        String challengeId = json.readTree(startRes.getResponse().getContentAsByteArray())
                .get("challenge_id").asText();
        String code = otpSender.latestByTarget.get(email);
        assertThat(code).isNotNull();

        Map<String, Object> body = new HashMap<>();
        body.put("challenge_id", challengeId);
        body.put("code", code);
        body.put("password", "valid-password-x");
        body.put("device", Map.of("device_id", "dev-" + UUID.randomUUID(), "device_label", "Phone"));
        body.put("profile", Map.of(
                "full_name", tag + " Person",
                "date_of_birth", "1991-05-20",
                "sex", "UNDISCLOSED"));

        MvcResult tokensRes = mvc.perform(post("/auth/register/complete")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json.writeValueAsBytes(body)))
                .andExpect(status().isOk())
                .andReturn();
        String access = json.readTree(tokensRes.getResponse().getContentAsByteArray())
                .get("access_token").asText();
        return new Session(null, access);
    }

    private UUID primaryPatientId(Session session) throws Exception {
        MvcResult res = mvc.perform(get("/patients")
                        .header("Authorization", "Bearer " + session.access))
                .andExpect(status().isOk())
                .andReturn();
        JsonNode list = json.readTree(res.getResponse().getContentAsByteArray()).get("patients");
        assertThat(list).isNotNull();
        assertThat(list.size()).isGreaterThan(0);
        return UUID.fromString(list.get(0).get("id").asText());
    }

    private UUID accountIdOf(Session session) {
        // Recover from the JWT — sub is the account UUID. Cheaper than decoding: use the access token's payload.
        String payload = new String(java.util.Base64.getUrlDecoder().decode(
                session.access.split("\\.")[1]));
        JsonNode node;
        try {
            node = json.readTree(payload);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return UUID.fromString(node.get("sub").asText());
    }

    private record Session(UUID id, String access) {}
}
