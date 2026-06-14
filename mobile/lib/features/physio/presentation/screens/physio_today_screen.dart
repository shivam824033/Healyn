import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../appointments/data/models/appointment_models.dart';
import '../../../appointments/presentation/appointment_format.dart';
import '../../../appointments/presentation/widgets/appointment_status_chip.dart';
import '../../../patients/data/models/patient_models.dart';
import '../../../patients/presentation/patients_providers.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/widgets/healyn_state_switcher.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/healyn_hero.dart';
import '../../../shared/widgets/healyn_info_banner.dart';
import '../../../shared/widgets/healyn_list_row.dart';
import '../../../shared/widgets/healyn_reveal.dart';
import '../../../shared/widgets/healyn_section_header.dart';
import '../../../shared/widgets/healyn_shimmer.dart';
import '../../../shared/widgets/healyn_skeletons.dart';
import '../../../shared/widgets/healyn_stat_card.dart';
import '../../../shared/widgets/healyn_time_block.dart';
import '../../../shared/widgets/healyn_tonal_icon.dart';
import '../../../shared/widgets/healyn_week_strip.dart';
import '../month_grid.dart';
import '../physio_calendar_providers.dart';
import '../physio_requests_providers.dart';
import '../physio_schedule_providers.dart';
import '../physio_unread_providers.dart';
import '../widgets/month_calendar.dart';
import '../widgets/patient_avatar_button.dart';

/// The physiotherapist's schedule (F1.12), in the *Refined Indigo* direction: a
/// gradient hero greeting, three floating stat cards, a compact week strip over
/// the selected day's roster, a requests banner, and rich appointment rows. The
/// full month grid stays reachable from the hero's calendar action. Picking a
/// day moves the roster; tapping a row opens the appointment detail.
class PhysioTodayScreen extends ConsumerStatefulWidget {
  const PhysioTodayScreen({super.key});

  @override
  ConsumerState<PhysioTodayScreen> createState() => _PhysioTodayScreenState();
}

class _PhysioTodayScreenState extends ConsumerState<PhysioTodayScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Returning to the foreground can reveal new bookings, status changes, or
    // patient messages that arrived while away — refetch so the schedule, its
    // activity badges, the calendar marks, and the requests banner aren't stale
    // (mirrors the pull-to-refresh below).
    if (state == AppLifecycleState.resumed) {
      ref
        ..invalidate(physioScheduleProvider)
        ..invalidate(physioScheduleActivityProvider)
        ..invalidate(calendarMarkedDaysProvider)
        ..invalidate(physioRequestsProvider)
        ..invalidate(physioUnreadSummaryProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final day = ref.watch(scheduleDayProvider);
    final month = ref.watch(calendarMonthProvider);
    final markedDays =
        ref.watch(calendarMarkedDaysProvider).valueOrNull ??
        const <DateTime>{};
    final schedule = ref.watch(physioScheduleProvider);
    final patients = ref.watch(patientsProvider).valueOrNull ?? const [];
    final byId = {for (final p in patients) p.id: p};
    final activityAsync = ref.watch(physioScheduleActivityProvider);
    final activity =
        activityAsync.valueOrNull ?? const <String, ScheduleActivity>{};
    final requestsCount =
        ref.watch(physioRequestsProvider).valueOrNull?.length ?? 0;

    final todayCount = schedule.valueOrNull?.length;
    // Account-wide unread total across every live thread (not just the selected
    // day), tappable through to the Unread Discussions screen.
    final unreadTotal = ref.watch(physioUnreadSummaryProvider).valueOrNull?.total;

    void selectDay(DateTime picked) {
      final d = DateTime(picked.year, picked.month, picked.day);
      ref.read(scheduleDayProvider.notifier).state = d;
      // Picking a day in another month flips the grid to that month too.
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

    // The full month grid, reachable from the hero — preserves every bit of the
    // original navigation (month paging, arbitrary day pick, jump-to-today).
    void openMonth() {
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: HealynColors.surfaceBase,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(HealynRadii.xl),
          ),
        ),
        builder: (_) => Consumer(
          builder: (sheetContext, sheetRef, _) {
            final sheetMonth = sheetRef.watch(calendarMonthProvider);
            final sheetDay = sheetRef.watch(scheduleDayProvider);
            final sheetMarked =
                sheetRef.watch(calendarMarkedDaysProvider).valueOrNull ??
                const <DateTime>{};
            final now = DateTime.now();
            final onToday =
                (isSameDay(sheetDay, now) &&
                    sheetMonth.year == now.year &&
                    sheetMonth.month == now.month)
                ? null
                : () {
                    jumpToToday();
                    Navigator.of(sheetContext).pop();
                  };
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: HealynSpacing.s4),
                child: MonthCalendar(
                  month: sheetMonth,
                  selectedDay: sheetDay,
                  markedDays: sheetMarked,
                  onSelectDay: (d) {
                    selectDay(d);
                    Navigator.of(sheetContext).pop();
                  },
                  onPrevMonth: () => stepMonth(-1),
                  onNextMonth: () => stepMonth(1),
                  onToday: onToday,
                ),
              ),
            );
          },
        ),
      );
    }

    final onToday = isToday(day);

    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      body: RefreshIndicator(
        onRefresh: () async {
          ref
            ..invalidate(physioScheduleProvider)
            ..invalidate(physioScheduleActivityProvider)
            ..invalidate(calendarMarkedDaysProvider)
            ..invalidate(physioRequestsProvider)
            ..invalidate(physioUnreadSummaryProvider);
          await ref.read(physioScheduleProvider.future);
        },
        child: ListView(
          padding: EdgeInsets.zero,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            HealynHero(
              eyebrow: _greeting(DateTime.now()),
              title: 'Your schedule',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // _HeroAction(
                  //   icon: Icons.calendar_month_outlined,
                  //   tooltip: 'Open calendar',
                  //   onTap: openMonth,
                  // ),
                  const SizedBox(width: HealynSpacing.s2),
                  _HeroAction(
                    icon: Icons.schedule_outlined,
                    tooltip: 'Availability',
                    onTap: () => context.push('/physio/availability'),
                  ),
                ],
              ),
              pill: HealynHeroPill(
                icon: Icons.calendar_today_outlined,
                label: formatDateLong(day),
              ),
            ),
            HealynStatRow(
              cards: [
                HealynStatCard(
                  icon: Icons.calendar_month_outlined,
                  tint: HealynColors.brandPrimary,
                  value: _stat(todayCount),
                  label: 'Appointments',
                  onTap: openMonth,
                ),
                HealynStatCard(
                  icon: Icons.inbox_outlined,
                  tint: HealynColors.statusWarning,
                  value: '$requestsCount',
                  label: 'Requests',
                  onTap: () => context.push('/physio/requests'),
                ),
                HealynStatCard(
                  icon: Icons.mark_email_unread_outlined,
                  tint: HealynColors.statusInfo,
                  value: _stat(unreadTotal),
                  label: 'Unread',
                  onTap: () => context.push('/physio/discussions/unread'),
                ),
              ],
            ),
            HealynWeekStrip(
              weekOf: day,
              selected: day,
              markedDays: markedDays,
              onSelect: selectDay,
            ),
            const SizedBox(height: HealynSpacing.s5),
            if (requestsCount > 0) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: HealynSpacing.screenEdge,
                ),
                child: HealynInfoBanner(
                  icon: Icons.inbox_outlined,
                  title: requestsCount == 1
                      ? '1 new booking request'
                      : '$requestsCount new booking requests',
                  subtitle: 'Tap to review & confirm',
                  onTap: () => context.push('/physio/requests'),
                ),
              ),
              const SizedBox(height: HealynSpacing.s5),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: HealynSpacing.screenEdge,
              ),
              child: HealynSectionHeader(
                title: onToday ? "Today's schedule" : 'Schedule',
                countLabel: _apptCountLabel(todayCount),
                trailing: onToday
                    ? null
                    : _TextAction(label: 'Today', onTap: jumpToToday),
              ),
            ),
            const SizedBox(height: HealynSpacing.s3),
            HealynStateSwitcher(
              child: schedule.when(
                loading: () => const HealynShimmer(
                  key: ValueKey('schedule-loading'),
                  child: Column(
                    children: [
                      _RosterRowSkeleton(),
                      _RosterRowSkeleton(),
                      _RosterRowSkeleton(),
                    ],
                  ),
                ),
                error: (_, _) => const Padding(
                  key: ValueKey('schedule-error'),
                  padding: EdgeInsets.symmetric(
                    horizontal: HealynSpacing.screenEdge,
                  ),
                  child: ErrorBanner(
                    message:
                        'Could not load the schedule. Pull down to retry.',
                  ),
                ),
                data: (appointments) {
                  if (appointments.isEmpty) {
                    return const _EmptyDay(key: ValueKey('schedule-empty'));
                  }
                  // Capped running index so the first rows reveal in a gentle
                  // bottom-up stagger; later rows arrive without delay.
                  var revealIndex = 0;
                  int nextReveal() => revealIndex < 6 ? revealIndex++ : 6;
                  return Column(
                    key: const ValueKey('schedule-data'),
                    children: [
                      for (final a in appointments)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            HealynSpacing.screenEdge,
                            0,
                            HealynSpacing.screenEdge,
                            HealynSpacing.s3,
                          ),
                          child: HealynReveal.staggered(
                            index: nextReveal(),
                            child: _ScheduleTile(
                              appointment: a,
                              patient: byId[a.patientId],
                              activity: activity[a.id],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: HealynSpacing.s8),
          ],
        ),
      ),
    );
  }

  /// A real, clock-derived greeting — no fabricated name (none is available).
  static String _greeting(DateTime now) {
    final h = now.hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  /// A stat value, or an en-dash while its source is still loading.
  static String _stat(int? value) => value?.toString() ?? '–';

  /// "5 appts" / "1 appt", or null while the roster is loading.
  static String? _apptCountLabel(int? count) {
    if (count == null) return null;
    return count == 1 ? '1 appt' : '$count appts';
  }
}

/// A circular icon action that reads cleanly on the gradient hero.
class _HeroAction extends StatelessWidget {
  const _HeroAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HealynColors.textInverse.withValues(alpha: 0.16),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Tooltip(
          message: tooltip,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(icon, color: HealynColors.textInverse, size: 20),
          ),
        ),
      ),
    );
  }
}

/// A compact, low-emphasis text action (e.g. "Today") for a section header.
class _TextAction extends StatelessWidget {
  const _TextAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: HealynRadii.brSm,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: HealynSpacing.s2,
            vertical: HealynSpacing.s1,
          ),
          child: Text(
            label,
            style: HealynTypography.caption.copyWith(
              color: HealynColors.brandPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// One appointment in the day's roster: a tappable patient monogram (quick jump
/// to the patient) beside a time block (or a fallback when somehow unscheduled),
/// the patient's name, the patient-given reason when present, and the status +
/// activity badges. Tapping the row opens the appointment detail.
class _ScheduleTile extends StatelessWidget {
  const _ScheduleTile({
    required this.appointment,
    this.patient,
    this.activity,
  });

  final Appointment appointment;
  final Patient? patient;
  final ScheduleActivity? activity;

  @override
  Widget build(BuildContext context) {
    final act = activity;
    final patientName = patient?.fullName;
    final reason = appointment.reason?.trim();
    final startsAt = appointment.scheduledAt;

    return HealynListRow(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PatientAvatarButton(
            patientId: appointment.patientId,
            name: patientName,
            patient: patient,
            radius: 18,
          ),
          const SizedBox(width: HealynSpacing.s2),
          if (startsAt != null)
            HealynTimeBlock(start: startsAt, end: appointment.scheduledEndAt)
          else
            const HealynTonalIcon(
              icon: Icons.schedule_outlined,
              color: HealynColors.textMuted,
            ),
        ],
      ),
      title: patientName ?? 'Patient',
      subtitle: (reason != null && reason.isNotEmpty) ? reason : null,
      footer: Wrap(
        spacing: HealynSpacing.s2,
        runSpacing: HealynSpacing.s2,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          AppointmentStatusChip(status: appointment.status),
          if (act != null && act.hasUnread) _UnreadBadge(act.unreadCount),
          if (act != null && act.hasPendingFiles)
            _PendingFilesBadge(act.pendingFileCount),
        ],
      ),
      onTap: () => context.push(
        '/physio/appointments/${appointment.id}',
        extra: appointment,
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
          borderRadius: BorderRadius.circular(HealynRadii.full),
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
          borderRadius: BorderRadius.circular(HealynRadii.full),
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

/// One shimmering placeholder row for the day's roster while it loads — a
/// leading avatar + time block and two text lines, in the same card footprint as
/// [_ScheduleTile], inset to match and spaced like the real rows.
class _RosterRowSkeleton extends StatelessWidget {
  const _RosterRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        HealynSpacing.screenEdge,
        0,
        HealynSpacing.screenEdge,
        HealynSpacing.s3,
      ),
      child: HealynListRowSkeleton(hasLeading: true),
    );
  }
}

class _EmptyDay extends StatelessWidget {
  const _EmptyDay({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        HealynSpacing.s8,
        HealynSpacing.s8,
        HealynSpacing.s8,
        HealynSpacing.s8,
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: HealynColors.surfaceAlt,
              borderRadius: HealynRadii.brLg,
            ),
            child: const Icon(
              Icons.event_available_outlined,
              size: 30,
              color: HealynColors.textMuted,
            ),
          ),
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
      ),
    );
  }
}
