package com.healyn.notifications.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.messaging.FirebaseMessaging;
import com.healyn.notifications.adapter.FirebaseFcmSender;
import com.healyn.notifications.adapter.LoggingFcmSender;
import com.healyn.notifications.port.FcmSenderPort;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;

@Configuration
@EnableScheduling
@EnableConfigurationProperties({NotificationProperties.class, FcmProperties.class})
public class NotificationsConfig {

    private static final Logger log = LoggerFactory.getLogger(NotificationsConfig.class);

    /**
     * Real FCM delivery when {@code healyn.fcm.credentials-path} points at a service-account
     * file; otherwise the logging sender (no push leaves the system). A blank value counts as
     * "not configured" — the dev {@code .env} carries {@code HEALYN_FCM_CREDENTIALS_PATH=} to
     * mean exactly that, mirroring how {@code JwtKeyProvider} treats blank key paths.
     *
     * <p>Note: this fails open to logging if creds are missing. A prod profile should add a
     * fail-fast guard so a misconfigured deploy can't silently stop delivering push.
     */
    @Bean
    @ConditionalOnMissingBean(FcmSenderPort.class)
    public FcmSenderPort fcmSenderPort(FcmProperties props) throws IOException {
        String credentialsPath = props.credentialsPath();
        if (credentialsPath == null || credentialsPath.isBlank()) {
            log.info("FCM credentials-path not configured — using logging sender (no push delivery).");
            return new LoggingFcmSender();
        }
        try (InputStream credentials = Files.newInputStream(Path.of(credentialsPath))) {
            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(credentials))
                    .build();
            FirebaseApp app = FirebaseApp.getApps().isEmpty()
                    ? FirebaseApp.initializeApp(options)
                    : FirebaseApp.getInstance();
            log.info("FCM credentials loaded from {} — using firebase-admin sender.", credentialsPath);
            return new FirebaseFcmSender(FirebaseMessaging.getInstance(app));
        }
    }
}
