package com.healyn.discussion.web;

import com.healyn.discussion.domain.DiscussionMessage;

public final class DiscussionMapper {

    private DiscussionMapper() {}

    public static DiscussionDtos.MessageView toView(DiscussionMessage m) {
        return new DiscussionDtos.MessageView(
                m.getId(),
                m.getAppointmentId(),
                m.getSenderAccountId(),
                m.getSenderRole(),
                m.getMessageType(),
                m.getBody(),
                m.getCreatedAt(),
                m.getEditedAt());
    }
}
