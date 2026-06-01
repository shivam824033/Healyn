package com.healyn;

import com.healyn.auth.repository.AccountRepository;
import com.healyn.auth.repository.DeviceSessionRepository;
import com.healyn.auth.repository.OtpChallengeRepository;
import com.healyn.appointments.repository.AppointmentRepository;
import com.healyn.availability.repository.AvailabilityRuleRepository;
import com.healyn.availability.repository.BlackoutWindowRepository;
import com.healyn.patients.repository.AccountPatientRepository;
import com.healyn.patients.repository.PatientRepository;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest(properties = {
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

    @MockBean AccountRepository accountRepository;
    @MockBean DeviceSessionRepository deviceSessionRepository;
    @MockBean OtpChallengeRepository otpChallengeRepository;
    @MockBean PatientRepository patientRepository;
    @MockBean AccountPatientRepository accountPatientRepository;
    @MockBean AvailabilityRuleRepository availabilityRuleRepository;
    @MockBean BlackoutWindowRepository blackoutWindowRepository;
    @MockBean AppointmentRepository appointmentRepository;
    @MockBean StringRedisTemplate stringRedisTemplate;

    @Test
    void contextLoads() {
    }
}
