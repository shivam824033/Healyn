package com.healyn.notifications.service;

import com.healyn.notifications.config.NotificationProperties;
import com.healyn.notifications.domain.FcmToken;
import com.healyn.notifications.domain.NotificationOutbox;
import com.healyn.notifications.domain.NotificationStatus;
import com.healyn.notifications.port.FcmSendOutcome;
import com.healyn.notifications.port.FcmSenderPort;
import com.healyn.notifications.repository.FcmTokenRepository;
import com.healyn.notifications.repository.NotificationOutboxRepository;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Clock;
import java.time.Instant;
import java.util.List;

/**
 * Drains due {@code notification_outbox} rows: resolve the recipient's live FCM tokens,
 * push to each, then mark the row SENT / rescheduled / DEAD. Tokens FCM rejects are retired.
 * Rows with no live tokens are terminal SENT (nothing to deliver to). The poller calls
 * {@link #dispatchDue()} on a fixed delay; the sweep is transactional and the due query
 * locks rows SKIP LOCKED so multiple instances don't double-send.
 */
@Service
public class OutboxDispatcher {

    private final NotificationOutboxRepository outbox;
    private final FcmTokenRepository tokens;
    private final FcmSenderPort sender;
    private final NotificationProperties props;
    private final Clock clock;

    public OutboxDispatcher(NotificationOutboxRepository outbox,
                            FcmTokenRepository tokens,
                            FcmSenderPort sender,
                            NotificationProperties props,
                            Clock clock) {
        this.outbox = outbox;
        this.tokens = tokens;
        this.sender = sender;
        this.props = props;
        this.clock = clock;
    }

    /** Process one batch of due rows. Returns the number of rows handled. */
    @Transactional
    public int dispatchDue() {
        Instant now = Instant.now(clock);
        List<NotificationOutbox> due = outbox.findDueForDispatch(
                NotificationStatus.PENDING, now, PageRequest.of(0, props.batchSize()));
        for (NotificationOutbox row : due) {
            dispatchOne(row, now);
        }
        return due.size();
    }

    private void dispatchOne(NotificationOutbox row, Instant now) {
        List<FcmToken> liveTokens = tokens.findByAccountIdAndDeletedAtIsNull(row.getTargetAccountId());
        if (liveTokens.isEmpty()) {
            row.markSent(now, null);
            return;
        }

        boolean delivered = false;
        boolean transientFailure = false;
        String resolvedToken = null;
        String lastError = null;
        for (FcmToken token : liveTokens) {
            FcmSendOutcome outcome = sender.send(token.getToken(), row.getKind(), row.getPayload());
            switch (outcome) {
                case DELIVERED -> {
                    delivered = true;
                    resolvedToken = token.getToken();
                }
                case TOKEN_INVALID -> token.retire();
                case TRANSIENT_ERROR -> {
                    transientFailure = true;
                    lastError = "transient_fcm_error";
                }
            }
        }

        if (delivered) {
            row.markSent(now, resolvedToken);
        } else if (transientFailure) {
            int attemptNo = row.getAttempts() + 1;
            if (attemptNo >= props.maxAttempts()) {
                row.markDead(lastError);
            } else {
                row.reschedule(now.plusSeconds(backoffSeconds(attemptNo)), lastError);
            }
        } else {
            // Every token was invalid (now retired): nothing deliverable, nothing to retry.
            row.markSent(now, null);
        }
    }

    private long backoffSeconds(int attemptNo) {
        return props.backoffBaseSeconds() * (1L << (attemptNo - 1));
    }
}
