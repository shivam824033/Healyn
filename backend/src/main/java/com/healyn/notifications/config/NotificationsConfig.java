package com.healyn.notifications.config;

import com.healyn.notifications.adapter.LoggingFcmSender;
import com.healyn.notifications.port.FcmSenderPort;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;

@Configuration
@EnableScheduling
@EnableConfigurationProperties(NotificationProperties.class)
public class NotificationsConfig {

    /** Default push sender until the real firebase-admin adapter is approved + wired. */
    @Bean
    @ConditionalOnMissingBean(FcmSenderPort.class)
    public FcmSenderPort loggingFcmSender() {
        return new LoggingFcmSender();
    }
}
