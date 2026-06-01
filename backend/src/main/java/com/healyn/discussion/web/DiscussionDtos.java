package com.healyn.discussion.web;

import com.healyn.discussion.domain.DiscussionMessageType;
import com.healyn.discussion.domain.DiscussionSenderRole;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

public final class DiscussionDtos {

    private DiscussionDtos() {}

    public record PostMessageBody(DiscussionMessageType messageType, String body) {}

    public record EditMessageBody(String body) {}

    public record MarkReadBody(UUID messageId) {}

    public record MessageView(
            UUID id,
            UUID appointmentId,
            UUID senderAccountId,
            DiscussionSenderRole senderRole,
            DiscussionMessageType messageType,
            String body,
            Instant createdAt,
            Instant editedAt) {}

    public record MessagePage(List<MessageView> items, String nextCursor) {}

    public record UnreadCountView(long unreadCount) {}
}
