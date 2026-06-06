import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../patients/presentation/patients_providers.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../data/models/appointment_models.dart';
import '../appointment_format.dart';
import '../appointments_providers.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: [
          IconButton(
            tooltip: 'Book appointment',
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/appointments/book'),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(appointmentsProvider);
            await ref.read(appointmentsProvider.future);
          },
          child: appointments.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => ListView(
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
              if (all.isEmpty) return const _EmptyAppointments();
              final upcoming = upcomingOf(all);
              final past = pastOf(all);
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
                      const _SectionTitle('Upcoming'),
                      const SizedBox(height: HealynSpacing.s3),
                      for (final a in upcoming) ...[
                        _AppointmentTile(appointment: a, patientName: names[a.patientId]),
                        const SizedBox(height: HealynSpacing.s3),
                      ],
                    ],
                    if (past.isNotEmpty) ...[
                      if (upcoming.isNotEmpty)
                        const SizedBox(height: HealynSpacing.s4),
                      const _SectionTitle('Past'),
                      const SizedBox(height: HealynSpacing.s3),
                      for (final a in past) ...[
                        _AppointmentTile(appointment: a, patientName: names[a.patientId]),
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
    );
  }
}

class _AppointmentTile extends StatelessWidget {
  const _AppointmentTile({required this.appointment, this.patientName});

  final Appointment appointment;
  final String? patientName;

  @override
  Widget build(BuildContext context) {
    final meta = [
      ?patientName,
      if (appointment.isScheduled) formatDuration(appointment.durationMinutes),
    ].join(' · ');
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
            '/appointments/${appointment.id}',
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
                        formatAppointmentWhenShort(appointment),
                        style: HealynTypography.bodyStrong,
                      ),
                      if (meta.isNotEmpty) ...[
                        const SizedBox(height: HealynSpacing.s1),
                        Text(meta, style: HealynTypography.caption),
                      ],
                      const SizedBox(height: HealynSpacing.s2),
                      AppointmentStatusChip(status: appointment.status),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text.toUpperCase(), style: HealynTypography.overline);
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
