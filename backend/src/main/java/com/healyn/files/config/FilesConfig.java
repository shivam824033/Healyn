package com.healyn.files.config;

import io.minio.MinioClient;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableConfigurationProperties(HealynS3Properties.class)
public class FilesConfig {

    @Bean
    public MinioClient minioClient(HealynS3Properties props) {
        MinioClient.Builder builder = MinioClient.builder()
                .endpoint(props.endpoint())
                .credentials(props.accessKey(), props.secretKey());
        if (props.region() != null && !props.region().isBlank()) {
            builder.region(props.region());
        }
        return builder.build();
    }
}
