import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../appointments/data/models/appointment_models.dart';
import '../../../appointments/presentation/appointment_format.dart';
import '../../../appointments/presentation/widgets/appointment_status_chip.dart';
import '../../../patients/presentation/patients_providers.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/elevation.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/error_banner.dart';
import '../month_grid.dart';
import '../physio_calendar_providers.dart';
import '../physio_requests_providers.dart';
import '../physio_schedule_providers.dart';
import '../widgets/month_calendar.dart';

/// The physiotherapist's schedule (F1.12): a month calendar that marks the days
/// holding appointments, over the selected day's roster (by start time, with
/// status and patient name). Picking a day in the grid moves the roster; the
/// month arrows page the grid without moving it. An app-bar action opens the
/// pushed Upcoming list. Tapping a row opens the appointment detail.
class PhysioTodayScreen extends ConsumerWidget {
  const PhysioTodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(scheduleDayProvider);
    final month = ref.watch(calendarMonthProvider);
    final markedDays =
        ref.watch(calendarMarkedDaysProvider).valueOrNull ??
        const <DateTime>{};
    final schedule = ref.watch(physioScheduleProvider);
    final patients = ref.watch(patientsProvider).valueOrNull ?? const [];
    final names = {for (final p in patients) p.id: p.fullName};
    final activity =
        ref.watch(physioScheduleActivityProvider).valueOrNull ??
        const <String, ScheduleActivity>{};

    void selectDay(DateTime picked) {
      final d = DateTime(picked.year, picked.month, picked.day);
      ref.read(scheduleDayProvider.notifier).state = d;
      // Tapping a leading/trailing cell flips the grid to that month.
      if (picked.year != month.year || picked.month != month.month) {
        ref.read(calendarMonthProvider.notifier).state = DateTime(
          picked.year,
          picked.month,
        );
      }
    }

    void stepMonth(int delta) {
      ref.read(calendarMonthProvider.notifier).state = DateTime(
        month.year,
        month.month + delta,
      );
    }

    void jumpToToday() {
      final now = DateTime.now();
      ref.read(scheduleDayProvider.notifier).state = DateTime(
        now.year,
        now.month,
        now.day,
      );
      ref.read(calendarMonthProvider.notifier).state = DateTime(
        now.year,
        now.month,
      );
    }

    final now = DateTime.now();
    final onToday =
        (isSameDay(day, now) && month.year == now.year && month.month == now.month)
        ? null
        : jumpToToday;

    return Scaffold(
      appBar: HealynAppBar(
        title: 'Schedule',
        actions: [
          IconButton(
            tooltip: 'Upcoming',
            icon: const Icon(Icons.upcoming_outlined),
            onPressed: () => context.push('/physio/upcoming'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const _RequestsBanner(),
            MonthCalendar(
              month: month,
              selectedDay: day,
              markedDays: markedDays,
              onSelectDay: selectDay,
              onPrevMonth: () => stepMonth(-1),
              onNextMonth: () => stepMonth(1),
              onToday: onToday,
            ),
            _SelectedDayHeader(day: day),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref
                    ..invalidate(physioScheduleProvider)
                    ..invalidate(physioScheduleActivityProvider)
                    ..invalidate(calendarMarkedDaysProvider)
                    ..invalidate(physioRequestsProvider);
                  await ref.read(physioScheduleProvider.future);
                },
                child: schedule.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, _) => ListView(
                    padding: const EdgeInsets.all(HealynSpacing.screenEdge),
                    children: const [
                      ErrorBanner(
                        message:
                            'Could not load the schedule. Pull down to retry.',
                      ),
                    ],
                  ),
                  data: (appointments) {
                    if (appointments.isEmpty) return const _EmptyDay();
                    return ListView.separated(
                      padding: const EdgeInsets.all(HealynSpacing.screenEdge),
                      itemCount: appointments.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: HealynSpacing.s3),
                      itemBuilder: (_, i) => _ScheduleTile(
                        appointment: appointments[i],
                        patientName: names[appointments[i].patientId],
                        activity: activity[appointments[i].id],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "N new requests" banner above the schedule (D2). Watches the pending-requests
/// queue and taps through to the dedicated requests screen. Renders nothing while
/// loading/failed or when there is nothing pending, so Today stays calm.
class _RequestsBanner extends ConsumerWidget {
  const _RequestsBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(physioRequestsProvider).valueOrNull?.length ?? 0;
    if (count == 0) return const SizedBox.shrink();

    return Material(
      color: HealynColors.brandPrimarySubtle,
      child: InkWell(
        onTap: () => context.push('/physio/requests'),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: HealynSpacing.screenEdge,
            vertical: HealynSpacing.s3,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.inbox_outlined,
                size: 20,
                color: HealynColors.brandPrimary,
              ),
              const SizedBox(width: HealynSpacing.s3),
              Expanded(
                child: Text(
                  count == 1 ? '1 new request' : '$count new requests',
                  style: HealynTypography.bodyStrong.copyWith(
                    color: HealynColors.brandPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: HealynColors.brandPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The selected day's label above its roster. "Today" is called out so the
/// roster reads clearly once the calendar selection scrolls out of mind.
class _SelectedDayHeader extends StatelessWidget {
  const _SelectedDayHeader({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        HealynSpacing.screenEdge,
        HealynSpacing.s3,
        HealynSpacing.screenEdge,
        HealynSpacing.s2,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(formatDateLong(day), style: HealynTypography.bodyStrong),
          ),
          if (isToday(day))
            Text(
              'Today',
              style: HealynTypography.caption.copyWith(
                color: HealynColors.textMuted,
              ),
            ),
        ],
      ),
    );
  }
}

class _ScheduleTile extends StatelessWidget {
  const _ScheduleTile({
    required this.appointment,
    this.patientName,
    this.activity,
  });

  final Appointment appointment;
  final String? patientName;
  final ScheduleActivity? activity;

  @override
  Widget build(BuildContext context) {
    final act = activity;
    return Container(
      decoration: BoxDecoration(
        color: HealynColors.surfaceBase,
        borderRadius: HealynRadii.brLg,
        border: Border.all(color: HealynColors.borderSubtle),
        boxShadow: HealynElevation.e1,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: HealynRadii.brLg,
          onTap: () => context.push(
            '/physio/appointments/${appointment.id}',
            extra: appointment,
          ),
          child: Padding(
            padding: const EdgeInsets.all(HealynSpacing.s4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _timeRange(appointment),
                        style: HealynTypography.bodyStrong,
                      ),
                      const SizedBox(height: HealynSpacing.s1),
                      Text(
                        patientName ?? 'Patient',
                        style: HealynTypography.body,
                      ),
                      const SizedBox(height: HealynSpacing.s2),
                      Wrap(
                        spacing: HealynSpacing.s2,
                        runSpacing: HealynSpacing.s2,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          AppointmentStatusChip(status: appointment.status),
                          if (act != null && act.hasUnread)
                            _UnreadBadge(act.unreadCount),
                          if (act != null && act.hasPendingFiles)
                            _PendingFilesBadge(act.pendingFileCount),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: HealynColors.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// The start–end time for a scheduled row. An unscheduled request has no time
  /// (it never reaches this day list, which filters on `scheduled_at`), so it
  /// falls back to a safe label rather than rendering a null instant.
  static String _timeRange(Appointment a) {
    final startsAt = a.scheduledAt;
    final endsAt = a.scheduledEndAt;
    if (startsAt == null) return 'Time to be confirmed';
    if (endsAt == null) return formatTimeOfDay(startsAt);
    return '${formatTimeOfDay(startsAt)} – ${formatTimeOfDay(endsAt)}';
  }
}

/// Compact count of unread patient messages on a schedule row (C8).
class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge(this.count);

  final int count;

  @override
  Widget build(BuildContext context) {
    final label = count > 99 ? '99+' : '$count';
    return Semantics(
      label: count == 1 ? '1 unread message' : '$count unread messages',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: HealynSpacing.s2,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: HealynColors.brandPrimary,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.mark_email_unread_outlined,
              size: 13,
              color: HealynColors.textInverse,
            ),
            const SizedBox(width: HealynSpacing.s1),
            Text(
              label,
              style: HealynTypography.caption.copyWith(
                color: HealynColors.textInverse,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Count of files attached to the unread messages — the ones the physio still
/// needs to open (C8). Subtle, so it reads as a hint, not an alarm.
class _PendingFilesBadge extends StatelessWidget {
  const _PendingFilesBadge(this.count);

  final int count;

  @override
  Widget build(BuildContext context) {
    final label = count > 99 ? '99+' : '$count';
    return Semantics(
      label: count == 1 ? '1 file to review' : '$count files to review',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: HealynSpacing.s2,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: HealynColors.brandPrimarySubtle,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.attach_file,
              size: 13,
              color: HealynColors.brandPrimary,
            ),
            const SizedBox(width: HealynSpacing.s1),
            Text(
              label,
              style: HealynTypography.caption.copyWith(
                color: HealynColors.brandPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyDay extends StatelessWidget {
  const _EmptyDay();

  @override
  Widget build(BuildContext context) {
    // Inside a scrollable so pull-to-refresh still works on an empty day.
    return ListView(
      padding: const EdgeInsets.all(HealynSpacing.s8),
      children: [
        const SizedBox(height: HealynSpacing.s8),
        const Icon(Icons.event_available_outlined, size: 48, color: HealynColors.textMuted),
        const SizedBox(height: HealynSpacing.s4),
        const Text(
          'Nothing scheduled',
          style: HealynTypography.h3,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: HealynSpacing.s2),
        Text(
          'No appointments for this day.',
          style: HealynTypography.body.copyWith(
            color: HealynColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
