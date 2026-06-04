import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../appointments/data/models/appointment_models.dart';
import '../../../appointments/presentation/appointment_format.dart';
import '../../../appointments/presentation/widgets/appointment_status_chip.dart';
import '../../../patients/presentation/patients_providers.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/error_banner.dart';
import '../physio_schedule_providers.dart';

/// The physiotherapist's schedule (F1.12, read-only in C2): a day of
/// appointments by start time, with status and patient name, plus a
/// prev/today/next day stepper. Tapping a row opens the read-only detail.
class PhysioTodayScreen extends ConsumerWidget {
  const PhysioTodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(scheduleDayProvider);
    final schedule = ref.watch(physioScheduleProvider);
    final patients = ref.watch(patientsProvider).valueOrNull ?? const [];
    final names = {for (final p in patients) p.id: p.fullName};
    final activity =
        ref.watch(physioScheduleActivityProvider).valueOrNull ??
        const <String, ScheduleActivity>{};

    void stepDays(int delta) {
      final d = ref.read(scheduleDayProvider);
      ref.read(scheduleDayProvider.notifier).state = DateTime(
        d.year,
        d.month,
        d.day + delta,
      );
    }

    void jumpToToday() {
      final now = DateTime.now();
      ref.read(scheduleDayProvider.notifier).state = DateTime(
        now.year,
        now.month,
        now.day,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Schedule')),
      body: SafeArea(
        child: Column(
          children: [
            _DayStepper(
              day: day,
              onPrev: () => stepDays(-1),
              onNext: () => stepDays(1),
              onToday: jumpToToday,
            ),
            const Divider(height: 1),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref
                    ..invalidate(physioScheduleProvider)
                    ..invalidate(physioScheduleActivityProvider);
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

/// The prev / today / next day controls above the schedule list.
class _DayStepper extends StatelessWidget {
  const _DayStepper({
    required this.day,
    required this.onPrev,
    required this.onNext,
    required this.onToday,
  });

  final DateTime day;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final today = isToday(day);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: HealynSpacing.s2,
        vertical: HealynSpacing.s2,
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Previous day',
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrev,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  formatDateLong(day),
                  style: HealynTypography.bodyStrong,
                  textAlign: TextAlign.center,
                ),
                if (today)
                  Text(
                    'Today',
                    style: HealynTypography.caption.copyWith(
                      color: HealynColors.textMuted,
                    ),
                  )
                else
                  GestureDetector(
                    onTap: onToday,
                    child: Text(
                      'Jump to today',
                      style: HealynTypography.caption.copyWith(
                        color: HealynColors.brandPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Next day',
            icon: const Icon(Icons.chevron_right),
            onPressed: onNext,
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
                        '${formatTimeOfDay(appointment.scheduledAt)} – '
                        '${formatTimeOfDay(appointment.scheduledEndAt)}',
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
