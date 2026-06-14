import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../appointments/data/models/appointment_models.dart';
import '../../../appointments/presentation/appointment_format.dart';
import '../../../appointments/presentation/appointments_providers.dart';
import '../../../appointments/presentation/widgets/appointment_filter_bar.dart';
import '../../../appointments/presentation/widgets/appointment_search_delegate.dart';
import '../../../appointments/presentation/widgets/appointment_status_chip.dart';
import '../../../patients/data/models/patient_models.dart';
import '../../../patients/presentation/patients_providers.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/motion.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/healyn_list_row.dart';
import '../../../shared/widgets/healyn_reveal.dart';
import '../../../shared/widgets/healyn_skeletons.dart';
import '../physio_upcoming_providers.dart';
import '../widgets/patient_avatar_button.dart';

/// The physiotherapist's Appointments list (F1.12), pushed from Today. Defaults
/// to the next live scheduled appointments, but the status filter widens it to
/// completed / cancelled / rejected work, and the header search jumps to any
/// appointment by number or patient. Tapping a row opens the appointment detail;
/// scheduling happens there.
class PhysioUpcomingScreen extends ConsumerWidget {
  const PhysioUpcomingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointments = ref.watch(physioAppointmentsProvider);
    final filter = ref.watch(physioAppointmentFilterProvider);
    final patients = ref.watch(patientsProvider).valueOrNull ?? const [];
    final byId = {for (final p in patients) p.id: p};
    // Which completed appointments already have a treatment note. Null while it
    // loads (or on error) — the tile then omits the chip rather than mislabel.
    final noteStatus = ref.watch(physioNoteStatusProvider).valueOrNull;

    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: HealynAppBar(
        title: 'Appointments',
        actions: [
          IconButton(
            tooltip: 'Search appointments',
            icon: const Icon(Icons.search),
            onPressed: () => _openSearch(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            AppointmentFilterBar(
              filterProvider: physioAppointmentFilterProvider,
              showNeedsNote: true,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(physioAppointmentsProvider);
                  await ref.read(physioAppointmentsProvider.future);
                },
                child: AnimatedSwitcher(
                  duration: HealynMotion.slow,
                  switchInCurve: HealynMotion.standardCurve,
                  switchOutCurve: HealynMotion.standardCurve,
                  child: appointments.when(
                  loading: () => const HealynListSkeleton(
                    key: ValueKey('upcoming-loading'),
                    showHeader: true,
                    hasFooter: true,
                  ),
                  error: (_, _) => ListView(
                    key: const ValueKey('upcoming-error'),
                    padding: const EdgeInsets.all(HealynSpacing.screenEdge),
                    children: const [
                      ErrorBanner(
                        message: 'Could not load appointments. '
                            'Pull down to retry.',
                      ),
                    ],
                  ),
                  data: (state) {
                    final all = state.items;
                    if (all.isEmpty) {
                      return _isUpcomingDefault(filter)
                          ? const _NothingUpcoming(
                              key: ValueKey('upcoming-empty'),
                            )
                          : const _NoMatchingAppointments(
                              key: ValueKey('upcoming-nomatch'),
                            );
                    }
                    final upcoming = upcomingOf(all);
                    var past = pastOf(all);
                    // "Needs note": keep only completed appointments still missing
                    // a note. While the status is loading (noteStatus == null) show
                    // all completed so the list doesn't flash empty.
                    if (filter.needsNoteOnly && noteStatus != null) {
                      past = past
                          .where(
                            (a) =>
                                a.status == AppointmentStatus.completed &&
                                !noteStatus.contains(a.id),
                          )
                          .toList();
                    }
                    if (past.isEmpty && upcoming.isEmpty) {
                      return const _NoMatchingAppointments(
                        key: ValueKey('upcoming-nomatch'),
                      );
                    }
                    // Capped running stagger so the first rows reveal in sequence;
                    // later (and paged-in) rows arrive without delay.
                    var revealIndex = 0;
                    int nextReveal() => revealIndex < 6 ? revealIndex++ : 6;
                    // Auto-load the next cursor page as the list nears its bottom.
                    return NotificationListener<ScrollNotification>(
                      key: const ValueKey('upcoming-data'),
                      onNotification: (n) {
                        if (state.hasMore &&
                            !state.isLoadingMore &&
                            n.metrics.pixels >=
                                n.metrics.maxScrollExtent - 200) {
                          ref
                              .read(physioAppointmentsProvider.notifier)
                              .loadMore();
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
                              HealynReveal.staggered(
                                index: nextReveal(),
                                child: _AppointmentTile(
                                  appointment: a,
                                  patient: byId[a.patientId],
                                ),
                              ),
                              const SizedBox(height: HealynSpacing.s3),
                            ],
                          ],
                          if (past.isNotEmpty) ...[
                            if (upcoming.isNotEmpty)
                              const SizedBox(height: HealynSpacing.s4),
                            const _SectionTitle('Past'),
                            const SizedBox(height: HealynSpacing.s3),
                            for (final a in past) ...[
                              HealynReveal.staggered(
                                index: nextReveal(),
                                child: _AppointmentTile(
                                  appointment: a,
                                  patient: byId[a.patientId],
                                  hasNote:
                                      a.status == AppointmentStatus.completed &&
                                          noteStatus != null
                                      ? noteStatus.contains(a.id)
                                      : null,
                                ),
                              ),
                              const SizedBox(height: HealynSpacing.s3),
                            ],
                          ],
                          if (state.hasMore)
                            _LoadMoreFooter(
                              isLoading: state.isLoadingMore,
                              onLoadMore: () => ref
                                  .read(physioAppointmentsProvider.notifier)
                                  .loadMore(),
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

  /// Opens the header search overlay; on a chosen suggestion, navigates to that
  /// appointment's physio detail (the detail route resolves it by id).
  Future<void> _openSearch(BuildContext context) async {
    final selected = await showSearch<AppointmentSuggestion?>(
      context: context,
      delegate: AppointmentSearchDelegate(),
    );
    if (selected != null && context.mounted) {
      unawaited(
        context.push('/physio/appointments/${selected.appointmentId}'),
      );
    }
  }

  /// The screen's at-rest view: the default Upcoming filter with no follow-up
  /// narrowing. Used to pick the "Nothing upcoming" empty state over the
  /// generic "no match" one.
  static bool _isUpcomingDefault(AppointmentListFilter filter) =>
      filter.status == AppointmentStatusFilter.upcoming && !filter.followUpOnly;
}

class _AppointmentTile extends StatelessWidget {
  const _AppointmentTile({
    required this.appointment,
    this.patient,
    this.hasNote,
  });

  final Appointment appointment;
  final Patient? patient;

  /// Treatment-note state for a completed appointment: true = note written,
  /// false = still pending, null = not applicable or not yet known (no chip).
  final bool? hasNote;

  @override
  Widget build(BuildContext context) {
    final patientName = patient?.fullName;
    final number = appointment.appointmentNumber;
    // Lead with the appointment's when; the patient (and its human-friendly
    // number when present) reads on the subtitle line.
    final subtitle = [
      patientName ?? 'Patient',
      ?number,
    ].join(' · ');
    return HealynListRow(
      leading: PatientAvatarButton(
        patientId: appointment.patientId,
        name: patientName,
        patient: patient,
      ),
      title: formatAppointmentWhenShort(appointment),
      subtitle: subtitle,
      footer: Wrap(
        spacing: HealynSpacing.s2,
        runSpacing: HealynSpacing.s2,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          AppointmentStatusChip(status: appointment.status),
          if (appointment.isFollowUp) const _FollowUpChip(),
          if (hasNote != null) _NoteStatusChip(hasNote: hasNote!),
        ],
      ),
      onTap: () => context.push(
        '/physio/appointments/${appointment.id}',
        extra: appointment,
      ),
    );
  }
}

/// Whether a completed appointment has a treatment note yet (F1.12 / issue 5):
/// a calm "Note added" once written, an amber "Note pending" to prompt the
/// physiotherapist while it's still missing.
class _NoteStatusChip extends StatelessWidget {
  const _NoteStatusChip({required this.hasNote});

  final bool hasNote;

  @override
  Widget build(BuildContext context) {
    final color = hasNote
        ? HealynColors.statusSuccess
        : HealynColors.statusWarning;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HealynSpacing.s2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: HealynRadii.brSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasNote ? Icons.event_note : Icons.note_alt_outlined,
            size: 13,
            color: color,
          ),
          const SizedBox(width: HealynSpacing.s1),
          Text(
            hasNote ? 'Note added' : 'Note pending',
            style: HealynTypography.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Marks a follow-up review so it reads distinctly from a first booking (F1.12).
class _FollowUpChip extends StatelessWidget {
  const _FollowUpChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HealynSpacing.s2,
        vertical: 2,
      ),
      decoration: const BoxDecoration(
        color: HealynColors.brandPrimarySubtle,
        borderRadius: HealynRadii.brSm,
      ),
      child: Text(
        'Follow-up',
        style: HealynTypography.caption.copyWith(
          color: HealynColors.brandPrimary,
          fontWeight: FontWeight.w600,
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

/// Shown when a non-default filter matches nothing — distinct from the at-rest
/// [_NothingUpcoming] state.
class _NoMatchingAppointments extends StatelessWidget {
  const _NoMatchingAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    // Inside a scrollable so pull-to-refresh still works with no matches.
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

class _NothingUpcoming extends StatelessWidget {
  const _NothingUpcoming({super.key});

  @override
  Widget build(BuildContext context) {
    // Inside a scrollable so pull-to-refresh still works when empty.
    return ListView(
      padding: const EdgeInsets.all(HealynSpacing.s8),
      children: [
        const SizedBox(height: HealynSpacing.s8),
        const Icon(
          Icons.event_available_outlined,
          size: 48,
          color: HealynColors.textMuted,
        ),
        const SizedBox(height: HealynSpacing.s4),
        const Text(
          'Nothing upcoming',
          style: HealynTypography.h3,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: HealynSpacing.s2),
        Text(
          'Confirmed appointments will appear here as they are scheduled.',
          style: HealynTypography.body.copyWith(
            color: HealynColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
