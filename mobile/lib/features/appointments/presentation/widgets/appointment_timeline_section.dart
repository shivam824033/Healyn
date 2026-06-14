import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/auth/account_role.dart';
import '../../../shared/auth/current_account.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/healyn_skeletons.dart';
import '../../../shared/widgets/healyn_tonal_icon.dart';
import '../../../shared/widgets/section_card.dart';
import '../../data/models/appointment_models.dart';
import '../appointment_format.dart';
import '../appointments_providers.dart';

/// The unified history of an appointment's whole lineage — every lifecycle
/// event (created, time confirmed, started, rescheduled, …) of every
/// appointment sharing its root, oldest first, as one vertical timeline.
/// Renders the full section: its own "History" heading plus the card. Used by
/// both the patient and the physiotherapist detail screens; the event data is
/// identifiers + enums only, so nothing here can leak free text.
class AppointmentTimelineSection extends ConsumerWidget {
  const AppointmentTimelineSection({required this.appointmentId, super.key});

  /// The appointment being viewed. The backend expands the timeline to its
  /// whole lineage, so any member id yields the same story.
  final String appointmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeline = ref.watch(appointmentTimelineProvider(appointmentId));
    final selfId = ref.watch(currentAccountIdProvider).valueOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('History'.toUpperCase(), style: HealynTypography.overline),
        const SizedBox(height: HealynSpacing.s3),
        timeline.when(
          loading: () => const SectionCard(
            child: HealynSkeletonGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HealynSkeletonLine(widthFactor: 0.55, height: 12),
                  SizedBox(height: HealynSpacing.s2),
                  HealynSkeletonLine(widthFactor: 0.8, height: 12),
                  SizedBox(height: HealynSpacing.s2),
                  HealynSkeletonLine(widthFactor: 0.65, height: 12),
                ],
              ),
            ),
          ),
          error: (_, _) => SectionCard(
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Couldn't load the appointment history.",
                    style: HealynTypography.body,
                  ),
                ),
                TextButton(
                  onPressed: () => ref.invalidate(
                    appointmentTimelineProvider(appointmentId),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (events) => events.isEmpty
              ? SectionCard(
                  child: Text(
                    'No history recorded yet.',
                    style: HealynTypography.body.copyWith(
                      color: HealynColors.textSecondary,
                    ),
                  ),
                )
              : SectionCard(
                  child: _Timeline(events: events, selfAccountId: selfId),
                ),
        ),
      ],
    );
  }
}

/// The vertical event list: a tonal icon rail joined by hairline connectors,
/// with the event text beside it.
class _Timeline extends StatelessWidget {
  const _Timeline({required this.events, required this.selfAccountId});

  final List<TimelineEvent> events;
  final String? selfAccountId;

  @override
  Widget build(BuildContext context) {
    // Numbers only disambiguate when the lineage spans several appointments —
    // a single-appointment history would just repeat the header's number.
    final showNumbers =
        events.map((e) => e.appointmentId).toSet().length > 1;
    // The lineage carries each member's number on its own events, so a
    // RESCHEDULED entry can name the replacement it points at.
    final numbersById = <String, String>{
      for (final e in events)
        if (e.appointmentNumber != null) e.appointmentId: e.appointmentNumber!,
    };
    return Column(
      children: [
        for (var i = 0; i < events.length; i++)
          _TimelineRow(
            event: events[i],
            isLast: i == events.length - 1,
            selfAccountId: selfAccountId,
            showNumber: showNumbers,
            numbersById: numbersById,
          ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.event,
    required this.isLast,
    required this.selfAccountId,
    required this.showNumber,
    required this.numbersById,
  });

  final TimelineEvent event;
  final bool isLast;
  final String? selfAccountId;
  final bool showNumber;
  final Map<String, String> numbersById;

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(event.eventType);
    final detail = _detailFor(event, numbersById);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              HealynTonalIcon(
                icon: _iconFor(event),
                color: color,
                size: 30,
              ),
              if (!isLast)
                const Expanded(
                  child: VerticalDivider(
                    width: 2,
                    thickness: 2,
                    color: HealynColors.borderSubtle,
                  ),
                ),
            ],
          ),
          const SizedBox(width: HealynSpacing.s3),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : HealynSpacing.s4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _titleFor(event),
                          style: HealynTypography.bodyStrong,
                        ),
                      ),
                      if (showNumber && event.appointmentNumber != null)
                        Text(
                          event.appointmentNumber!,
                          style: HealynTypography.caption.copyWith(
                            color: HealynColors.textMuted,
                          ),
                        ),
                    ],
                  ),
                  if (detail != null)
                    Text(detail, style: HealynTypography.caption),
                  const SizedBox(height: 2),
                  Text(
                    _metaFor(event),
                    style: HealynTypography.caption.copyWith(
                      color: HealynColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// When + who. The actor reads "you" when it is the signed-in account, the
  /// role's canonical name otherwise, and is omitted for system/backfilled
  /// events with no recorded actor.
  String _metaFor(TimelineEvent e) {
    final when = formatWhen(e.occurredAt);
    final actor = e.actorAccountId != null && e.actorAccountId == selfAccountId
        ? 'you'
        : switch (e.actorRole) {
            AccountRole.account => 'patient',
            AccountRole.physio => 'physiotherapist',
            null => null,
          };
    return actor == null ? when : '$when · by $actor';
  }

  static String _titleFor(TimelineEvent e) => switch (e.eventType) {
    AppointmentEventType.created => switch (e.childKind) {
      null => 'Appointment created',
      AppointmentChildKind.reschedule => 'New appointment created',
      AppointmentChildKind.followUp => 'Follow-up booked',
      AppointmentChildKind.review => 'Review booked',
      AppointmentChildKind.reopen => 'Appointment reopened',
    },
    AppointmentEventType.scheduled => 'Time confirmed',
    AppointmentEventType.started => 'Session started',
    AppointmentEventType.completed => 'Completed',
    AppointmentEventType.cancelled => 'Cancelled',
    AppointmentEventType.noShow => 'Marked as no-show',
    AppointmentEventType.rescheduled => 'Rescheduled',
    AppointmentEventType.rejected => 'Request rejected',
  };

  /// A second line only where an enum adds something: the cancel reason, or
  /// which appointment a reschedule moved to / derived from.
  static String? _detailFor(TimelineEvent e, Map<String, String> numbersById) {
    if (e.eventType == AppointmentEventType.cancelled) {
      return e.cancelReason?.label;
    }
    final related =
        e.relatedAppointmentId == null ? null : numbersById[e.relatedAppointmentId];
    if (related == null) return null;
    return switch (e.eventType) {
      AppointmentEventType.rescheduled => 'Moved to $related',
      AppointmentEventType.created => 'From $related',
      _ => null,
    };
  }

  static IconData _iconFor(TimelineEvent e) => switch (e.eventType) {
    AppointmentEventType.created =>
      e.childKind == AppointmentChildKind.followUp ||
              e.childKind == AppointmentChildKind.review
          ? Icons.event_repeat_outlined
          : Icons.event_outlined,
    AppointmentEventType.scheduled => Icons.event_available_outlined,
    AppointmentEventType.started => Icons.play_arrow_outlined,
    AppointmentEventType.completed => Icons.task_alt_outlined,
    AppointmentEventType.cancelled => Icons.event_busy_outlined,
    AppointmentEventType.noShow => Icons.person_off_outlined,
    AppointmentEventType.rescheduled => Icons.event_repeat_outlined,
    AppointmentEventType.rejected => Icons.cancel_outlined,
  };

  /// Hues follow [AppointmentStatusChip]'s status mapping so the timeline and
  /// the status pill tell one consistent color story.
  static Color _colorFor(AppointmentEventType type) => switch (type) {
    AppointmentEventType.created => HealynColors.brandPrimary,
    AppointmentEventType.scheduled => HealynColors.statusSuccess,
    AppointmentEventType.started => HealynColors.statusInfo,
    AppointmentEventType.completed => HealynColors.textSecondary,
    AppointmentEventType.cancelled => HealynColors.statusDanger,
    AppointmentEventType.noShow => HealynColors.statusDanger,
    AppointmentEventType.rescheduled => HealynColors.textMuted,
    AppointmentEventType.rejected => HealynColors.statusDanger,
  };
}
