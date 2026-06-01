package com.healyn.discussion.service;

import com.healyn.appointments.domain.Appointment;
import com.healyn.appointments.repository.AppointmentRepository;
import com.healyn.auth.domain.AccountRole;
import com.healyn.common.error.ConflictException;
import com.healyn.common.error.ErrorCode;
import com.healyn.common.error.ForbiddenException;
import com.healyn.common.error.NotFoundException;
import com.healyn.common.error.UnprocessableException;
import com.healyn.common.id.UuidV7;
import com.healyn.common.pagination.Cursor;
import com.healyn.common.pagination.CursorPage;
import com.healyn.discussion.domain.DiscussionMessage;
import com.healyn.discussion.domain.DiscussionMessageType;
import com.healyn.discussion.domain.DiscussionReadMarker;
import com.healyn.discussion.domain.DiscussionSenderRole;
import com.healyn.discussion.policy.DiscussionAccessPolicy;
import com.healyn.discussion.repository.DiscussionMessageRepository;
import com.healyn.discussion.repository.DiscussionReadMarkerRepository;
import org.springframework.data.domain.Limit;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class DiscussionService {

    public static final int MAX_BODY_LENGTH = 2000;
    public static final Duration EDIT_WINDOW = Duration.ofMinutes(5);

    private final DiscussionMessageRepository messages;
    private final DiscussionReadMarkerRepository readMarkers;
    private final AppointmentRepository appointments;
    private final DiscussionAccessPolicy access;
    private final Clock clock;

    public DiscussionService(DiscussionMessageRepository messages,
                             DiscussionReadMarkerRepository readMarkers,
                             AppointmentRepository appointments,
                             DiscussionAccessPolicy access,
                             Clock clock) {
        this.messages = messages;
        this.readMarkers = readMarkers;
        this.appointments = appointments;
        this.access = access;
        this.clock = clock;
    }

    @Transactional
    public DiscussionMessage post(UUID actorId, AccountRole role, UUID appointmentId, PostMessageRequest req) {
        Appointment appt = loadAppointment(appointmentId);
        access.requireWrite(actorId, role, appt);

        DiscussionMessageType type = req.messageType() != null ? req.messageType() : DiscussionMessageType.REPLY;
        String body = req.body();
        validateBody(type, body);
        if (type == DiscussionMessageType.INSTRUCTION && role != AccountRole.ROLE_PHYSIO) {
            throw new ForbiddenException(ErrorCode.FORBIDDEN,
                    "Only the physiotherapist can post INSTRUCTION messages");
        }

        DiscussionSenderRole senderRole = role == AccountRole.ROLE_PHYSIO
                ? DiscussionSenderRole.PHYSIO
                : DiscussionSenderRole.PATIENT_SIDE;

        DiscussionMessage msg = new DiscussionMessage(
                UuidV7.generate(),
                appointmentId,
                actorId,
                senderRole,
                type,
                body);
        DiscussionMessage saved = messages.save(msg);
        // TODO outbox(DISCUSSION_NEW_MESSAGE) — wired in the notifications PR.
        return saved;
    }

    @Transactional
    public DiscussionMessage edit(UUID actorId, AccountRole role, UUID appointmentId,
                                  UUID messageId, EditMessageRequest req) {
        DiscussionMessage msg = loadActiveInThread(appointmentId, messageId);
        requireSender(actorId, msg);
        requireWithinEditWindow(msg);
        if (msg.getMessageType() == DiscussionMessageType.ATTACHMENT_ONLY) {
            throw new ConflictException(ErrorCode.DISCUSSION_EMPTY_MESSAGE,
                    "ATTACHMENT_ONLY messages cannot have a body");
        }
        String body = req.body();
        if (body == null || body.isBlank()) {
            throw new UnprocessableException(ErrorCode.DISCUSSION_EMPTY_MESSAGE,
                    "body is required");
        }
        if (body.length() > MAX_BODY_LENGTH) {
            throw new UnprocessableException(ErrorCode.DISCUSSION_BODY_TOO_LONG,
                    "body exceeds " + MAX_BODY_LENGTH + " characters");
        }
        msg.edit(body, Instant.now(clock));
        return msg;
    }

    @Transactional
    public void delete(UUID actorId, AccountRole role, UUID appointmentId, UUID messageId) {
        DiscussionMessage msg = loadActiveInThread(appointmentId, messageId);
        requireSender(actorId, msg);
        requireWithinEditWindow(msg);
        msg.softDelete(Instant.now(clock));
    }

    @Transactional(readOnly = true)
    public CursorPage<DiscussionMessage> list(UUID actorId, AccountRole role, UUID appointmentId,
                                              String cursorToken, int limit) {
        Appointment appt = loadAppointment(appointmentId);
        access.requireRead(actorId, role, appt);
        if (limit <= 0 || limit > 50) limit = 20;

        Limit lim = Limit.of(limit + 1);
        List<DiscussionMessage> rows;
        if (cursorToken == null || cursorToken.isBlank()) {
            rows = messages.listFirstPage(appointmentId, lim);
        } else {
            Cursor c = Cursor.decode(cursorToken);
            rows = messages.listAfterCursor(appointmentId, c.pivot(), c.id(), lim);
        }

        String nextCursor = null;
        if (rows.size() > limit) {
            DiscussionMessage pivot = rows.get(limit - 1);
            nextCursor = new Cursor(pivot.getCreatedAt(), pivot.getId()).encode();
            rows = rows.subList(0, limit);
        }
        return new CursorPage<>(new ArrayList<>(rows), nextCursor);
    }

    @Transactional
    public void markRead(UUID actorId, AccountRole role, UUID appointmentId, UUID messageId) {
        Appointment appt = loadAppointment(appointmentId);
        access.requireRead(actorId, role, appt);
        DiscussionMessage msg = messages.findById(messageId)
                .orElseThrow(() -> new NotFoundException(ErrorCode.DISCUSSION_MESSAGE_NOT_FOUND,
                        "Message not found"));
        if (!msg.getAppointmentId().equals(appointmentId)) {
            throw new NotFoundException(ErrorCode.DISCUSSION_MESSAGE_NOT_FOUND,
                    "Message not found in this appointment");
        }

        Optional<DiscussionReadMarker> existing = readMarkers.findFor(appointmentId, actorId);
        if (existing.isPresent()) {
            existing.get().advanceTo(messageId);
        } else {
            readMarkers.save(new DiscussionReadMarker(appointmentId, actorId, messageId));
        }
    }

    @Transactional(readOnly = true)
    public long unreadCount(UUID actorId, AccountRole role, UUID appointmentId) {
        Appointment appt = loadAppointment(appointmentId);
        access.requireRead(actorId, role, appt);

        Instant lastReadAt = null;
        UUID lastReadId = null;
        Optional<DiscussionReadMarker> marker = readMarkers.findFor(appointmentId, actorId);
        if (marker.isPresent()) {
            DiscussionMessage lastRead = messages.findById(marker.get().getLastReadMessageId()).orElse(null);
            if (lastRead != null) {
                lastReadAt = lastRead.getCreatedAt();
                lastReadId = lastRead.getId();
            }
        }
        return messages.countUnreadFor(appointmentId, actorId, lastReadAt, lastReadId);
    }

    // ---- helpers ----

    private Appointment loadAppointment(UUID id) {
        return appointments.findByIdAndDeletedAtIsNull(id)
                .orElseThrow(() -> new NotFoundException(ErrorCode.APPOINTMENT_NOT_FOUND,
                        "Appointment not found"));
    }

    private DiscussionMessage loadActiveInThread(UUID appointmentId, UUID messageId) {
        DiscussionMessage msg = messages.findByIdAndDeletedAtIsNull(messageId)
                .orElseThrow(() -> new NotFoundException(ErrorCode.DISCUSSION_MESSAGE_NOT_FOUND,
                        "Message not found"));
        if (!msg.getAppointmentId().equals(appointmentId)) {
            throw new NotFoundException(ErrorCode.DISCUSSION_MESSAGE_NOT_FOUND,
                    "Message not found in this appointment");
        }
        return msg;
    }

    private void requireSender(UUID actorId, DiscussionMessage msg) {
        if (!msg.getSenderAccountId().equals(actorId)) {
            throw new ForbiddenException(ErrorCode.DISCUSSION_NOT_SENDER,
                    "Only the original sender can edit or delete a message");
        }
    }

    private void requireWithinEditWindow(DiscussionMessage msg) {
        Instant now = Instant.now(clock);
        if (now.isAfter(msg.getCreatedAt().plus(EDIT_WINDOW))) {
            throw new ConflictException(ErrorCode.DISCUSSION_EDIT_WINDOW_EXPIRED,
                    "The 5-minute edit window has expired");
        }
    }

    private void validateBody(DiscussionMessageType type, String body) {
        boolean blank = body == null || body.isBlank();
        if (type == DiscussionMessageType.ATTACHMENT_ONLY) {
            if (!blank) {
                throw new UnprocessableException(ErrorCode.DISCUSSION_EMPTY_MESSAGE,
                        "ATTACHMENT_ONLY messages must not carry a body");
            }
            // Attachments are out of scope until the files module ships; reject ATTACHMENT_ONLY for now.
            throw new ConflictException(ErrorCode.DISCUSSION_EMPTY_MESSAGE,
                    "ATTACHMENT_ONLY messages require attachments — not yet supported");
        }
        if (blank) {
            throw new UnprocessableException(ErrorCode.DISCUSSION_EMPTY_MESSAGE,
                    "body is required");
        }
        if (body.length() > MAX_BODY_LENGTH) {
            throw new UnprocessableException(ErrorCode.DISCUSSION_BODY_TOO_LONG,
                    "body exceeds " + MAX_BODY_LENGTH + " characters");
        }
    }
}
