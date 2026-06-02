package com.healyn.notifications.repository;

import com.healyn.notifications.domain.NotificationOutbox;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface NotificationOutboxRepository extends JpaRepository<NotificationOutbox, UUID> {

    List<NotificationOutbox> findByCorrelationIdOrderByCreatedAtAsc(UUID correlationId);
}
