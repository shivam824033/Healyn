package com.healyn.notifications.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.messaging.FirebaseMessaging;
import com.healyn.notifications.adapter.FirebaseFcmSender;
import com.healyn.notifications.adapter.LoggingFcmSender;
import com.healyn.notifications.port.FcmSenderPort;
import org.springframework.boot.autoconfigure.condition.ConditionalOnBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
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

    /**
     * Initialises the Firebase Admin SDK when a credentials file is configured
     * ({@code healyn.fcm.credentials-path}). Absent in tests / credential-less local dev,
     * so the {@link #loggingFcmSender()} fallback is used instead.
     */
    @Bean
    @ConditionalOnProperty(prefix = "healyn.fcm", name = "credentials-path")
    public FirebaseApp firebaseApp(FcmProperties props) throws IOException {
        try (InputStream credentials = Files.newInputStream(Path.of(props.credentialsPath()))) {
            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(credentials))
                    .build();
            return FirebaseApp.getApps().isEmpty()
                    ? FirebaseApp.initializeApp(options)
                    : FirebaseApp.getInstance();
        }
    }

    @Bean
    @ConditionalOnBean(FirebaseApp.class)
    public FcmSenderPort firebaseFcmSender(FirebaseApp app) {
        return new FirebaseFcmSender(FirebaseMessaging.getInstance(app));
    }

    /** Default push sender when FCM credentials are not configured. */
    @Bean
    @ConditionalOnMissingBean(FcmSenderPort.class)
    public FcmSenderPort loggingFcmSender() {
        return new LoggingFcmSender();
    }
}
