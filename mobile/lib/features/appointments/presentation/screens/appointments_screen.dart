import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../patients/presentation/patients_providers.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/motion.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/healyn_list_row.dart';
import '../../../shared/widgets/healyn_reveal.dart';
import '../../../shared/widgets/healyn_section_header.dart';
import '../../../shared/widgets/healyn_shimmer.dart';
import '../../../shared/widgets/healyn_skeletons.dart';
import '../../data/models/appointment_models.dart';
import '../appointment_format.dart';
import '../appointments_providers.dart';
import '../widgets/appointment_filter_bar.dart';
import '../widgets/appointment_status_chip.dart';

/// Appointments tab — the patient's timeline of upcoming and past
/// appointments, with a "Book" action. Tapping a row opens its detail.
class AppointmentsScreen extends ConsumerWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointments = ref.watch(appointmentsProvider);
    final patients = ref.watch(patientsProvider).valueOrNull ?? const [];
    final names = {for (final p in patients) p.id: p.fullName};
    final filter = ref.watch(appointmentFilterProvider);

    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: HealynAppBar(
        title: 'Appointments',
        actions: [
          IconButton(
            tooltip: 'Book appointment',
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/appointments/book'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            AppointmentFilterBar(filterProvider: appointmentFilterProvider),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(appointmentsProvider);
                  await ref.read(appointmentsProvider.future);
                },
                child: AnimatedSwitcher(
                  duration: HealynMotion.slow,
                  switchInCurve: HealynMotion.standardCurve,
                  switchOutCurve: HealynMotion.standardCurve,
                  child: appointments.when(
                  loading: () =>
                      const _AppointmentsSkeleton(key: ValueKey('appts-loading')),
                  error: (_, _) => ListView(
                    key: const ValueKey('appts-error'),
                    padding: const EdgeInsets.all(HealynSpacing.screenEdge),
                    children: const [
                      ErrorBanner(
                        message:
                            'Could not load your appointments. Pull down to retry.',
                      ),
                    ],
                  ),
                  data: (state) {
                    final all = state.items;
                    if (all.isEmpty) {
                      return filter.isDefault
                          ? const _EmptyAppointments()
                          : const _NoMatchingAppointments();
                    }
              final upcoming = upcomingOf(all);
              final past = pastOf(all);
              // A capped running index so the first rows reveal in a gentle
              // stagger; later rows (and paged-in ones) arrive without delay.
              var revealIndex = 0;
              int nextReveal() => revealIndex < 6 ? revealIndex++ : 6;
              // Auto-load the next cursor page as the list nears its bottom.
              return NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  if (state.hasMore &&
                      !state.isLoadingMore &&
                      n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
                    ref.read(appointmentsProvider.notifier).loadMore();
                  }
                  return false;
                },
                child: ListView(
                  padding: const EdgeInsets.all(HealynSpacing.screenEdge),
                  children: [
                    if (upcoming.isNotEmpty) ...[
                      const HealynSectionHeader(title: 'Upcoming'),
                      const SizedBox(height: HealynSpacing.s3),
                      for (final a in upcoming) ...[
                        HealynReveal.staggered(
                          index: nextReveal(),
                          child: _AppointmentTile(
                            appointment: a,
                            patientName: names[a.patientId],
                          ),
                        ),
                        const SizedBox(height: HealynSpacing.s3),
                      ],
                    ],
                    if (past.isNotEmpty) ...[
                      if (upcoming.isNotEmpty)
                        const SizedBox(height: HealynSpacing.s4),
                      const HealynSectionHeader(title: 'Past'),
                      const SizedBox(height: HealynSpacing.s3),
                      for (final a in past) ...[
                        HealynReveal.staggered(
                          index: nextReveal(),
                          child: _AppointmentTile(
                            appointment: a,
                            patientName: names[a.patientId],
                          ),
                        ),
                        const SizedBox(height: HealynSpacing.s3),
                      ],
                    ],
                    if (state.hasMore)
                      _LoadMoreFooter(
                        isLoading: state.isLoadingMore,
                        onLoadMore: () =>
                            ref.read(appointmentsProvider.notifier).loadMore(),
                      ),
                  ],
                ),
              );
                  },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// First-load placeholder for the timeline: a section title and a few shimmering
/// appointment rows in the same footprint as the real list, kept scrollable so
/// pull-to-refresh still works on a cold load.
class _AppointmentsSkeleton extends StatelessWidget {
  const _AppointmentsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return HealynShimmer(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(HealynSpacing.screenEdge),
        children: const [
          HealynSkeletonLine(widthFactor: 0.3, height: 20),
          SizedBox(height: HealynSpacing.s4),
          HealynListRowSkeleton(),
          SizedBox(height: HealynSpacing.s3),
          HealynListRowSkeleton(),
          SizedBox(height: HealynSpacing.s3),
          HealynListRowSkeleton(),
          SizedBox(height: HealynSpacing.s3),
          HealynListRowSkeleton(),
        ],
      ),
    );
  }
}

class _AppointmentTile extends StatelessWidget {
  const _AppointmentTile({required this.appointment, this.patientName});

  final Appointment appointment;
  final String? patientName;

  @override
  Widget build(BuildContext context) {
    final number = appointment.appointmentNumber;
    final subtitle = [
      ?patientName,
      if (appointment.isScheduled) formatDuration(appointment.durationMinutes),
      ?number,
    ].join(' · ');
    return HealynListRow(
      title: formatAppointmentWhenShort(appointment),
      subtitle: subtitle.isEmpty ? null : subtitle,
      footer: AppointmentStatusChip(status: appointment.status),
      onTap: () => context.push(
        '/appointments/${appointment.id}',
        extra: appointment,
      ),
    );
  }
}

/// Shown when a filter is active but nothing matches — distinct from the
/// first-run [_EmptyAppointments] onboarding (which invites a first booking).
class _NoMatchingAppointments extends StatelessWidget {
  const _NoMatchingAppointments();

  @override
  Widget build(BuildContext context) {
    // Inside a scrollable so pull-to-refresh still works with no matches.
    return ListView(
      padding: const EdgeInsets.all(HealynSpacing.s8),
      children: [
        const SizedBox(height: HealynSpacing.s8),
        const Icon(Icons.event_outlined, size: 48, color: HealynColors.textMuted),
        const SizedBox(height: HealynSpacing.s4),
        const Text(
          'No appointments match this filter',
          style: HealynTypography.h3,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: HealynSpacing.s2),
        Text(
          'Try a different filter above, or pull down to refresh.',
          style: HealynTypography.body.copyWith(
            color: HealynColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Footer shown when more appointments can be paged in. Auto-loading on scroll
/// drives most paging; the button is the fallback when the list is too short
/// to scroll.
class _LoadMoreFooter extends StatelessWidget {
  const _LoadMoreFooter({required this.isLoading, required this.onLoadMore});

  final bool isLoading;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: HealynSpacing.s3),
      child: Center(
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : TextButton(
                onPressed: onLoadMore,
                child: const Text('Load more'),
              ),
      ),
    );
  }
}

class _EmptyAppointments extends StatelessWidget {
  const _EmptyAppointments();

  @override
  Widget build(BuildContext context) {
    // Inside a scrollable so pull-to-refresh still works with no appointments.
    return ListView(
      padding: const EdgeInsets.all(HealynSpacing.s8),
      children: [
        const SizedBox(height: HealynSpacing.s8),
        const Icon(
          Icons.event_outlined,
          size: 48,
          color: HealynColors.textMuted,
        ),
        const SizedBox(height: HealynSpacing.s4),
        const Text(
          'No appointments yet',
          style: HealynTypography.h3,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: HealynSpacing.s2),
        Text(
          'Book an appointment with your physiotherapist and it will appear '
          'here.',
          style: HealynTypography.body.copyWith(
            color: HealynColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: HealynSpacing.s6),
        Center(
          child: OutlinedButton.icon(
            onPressed: () => context.push('/appointments/book'),
            icon: const Icon(Icons.add),
            label: const Text('Book appointment'),
          ),
        ),
      ],
    );
  }
}
