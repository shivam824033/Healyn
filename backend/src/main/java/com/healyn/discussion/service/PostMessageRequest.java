package com.healyn.discussion.service;

import com.healyn.discussion.domain.DiscussionMessageType;

public record PostMessageRequest(DiscussionMessageType messageType, String body) {}
