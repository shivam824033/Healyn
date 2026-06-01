package com.healyn.discussion.repository;

import com.healyn.discussion.domain.DiscussionMessage;
import org.springframework.data.domain.Limit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface DiscussionMessageRepository extends JpaRepository<DiscussionMessage, UUID> {

    Optional<DiscussionMessage> findByIdAndDeletedAtIsNull(UUID id);

    @Query("""
            select m
            from DiscussionMessage m
            where m.appointmentId = :appointmentId
              and m.deletedAt is null
            order by m.createdAt desc, m.id desc
            """)
    List<DiscussionMessage> listFirstPage(
            @Param("appointmentId") UUID appointmentId,
            Limit limit);

    @Query("""
            select m
            from DiscussionMessage m
            where m.appointmentId = :appointmentId
              and m.deletedAt is null
              and (m.createdAt < :pivotTime
                   or (m.createdAt = :pivotTime and m.id < :pivotId))
            order by m.createdAt desc, m.id desc
            """)
    List<DiscussionMessage> listAfterCursor(
            @Param("appointmentId") UUID appointmentId,
            @Param("pivotTime") Instant pivotTime,
            @Param("pivotId") UUID pivotId,
            Limit limit);

    @Query("""
            select count(m)
            from DiscussionMessage m
            where m.appointmentId = :appointmentId
              and m.deletedAt is null
              and m.senderAccountId <> :accountId
              and (:lastReadCreatedAt is null
                   or m.createdAt > :lastReadCreatedAt
                   or (m.createdAt = :lastReadCreatedAt and m.id > :lastReadId))
            """)
    long countUnreadFor(
            @Param("appointmentId") UUID appointmentId,
            @Param("accountId") UUID accountId,
            @Param("lastReadCreatedAt") Instant lastReadCreatedAt,
            @Param("lastReadId") UUID lastReadId);
}
