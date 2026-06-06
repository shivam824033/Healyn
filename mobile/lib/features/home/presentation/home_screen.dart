import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../appointments/data/models/appointment_models.dart';
import '../../appointments/presentation/appointment_format.dart';
import '../../appointments/presentation/appointments_providers.dart';
import '../../appointments/presentation/screens/book_appointment_screen.dart';
import '../../appointments/presentation/widgets/appointment_status_chip.dart';
import '../../discussion/presentation/unread_providers.dart';
import '../../patients/presentation/active_patient_provider.dart';
import '../../patients/presentation/patients_providers.dart';
import '../../patients/presentation/widgets/patient_switcher.dart';
import '../../shared/design/colors.dart';
import '../../shared/design/spacing.dart';
import '../../shared/design/typography.dart';
import '../../shared/widgets/section_card.dart';
import '../../treatment_notes/presentation/treatment_notes_format.dart';
import 'next_review_provider.dart';

/// Home tab — the signed-in landing. Greets the primary patient by first name
/// and surfaces the next upcoming appointment (or an invitation to book one).
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
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
    // Returning to the foreground can reveal a physio-side confirm/cancel or a
    // freshly written treatment note made while we were away — refetch so the
    // upcoming card and the next-review suggestion aren't stale (D1, D6).
    if (state == AppLifecycleState.resumed) {
      ref
        ..invalidate(appointmentsProvider)
        ..invalidate(nextReviewSuggestionProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstName = ref.watch(patientsProvider).maybeWhen(
      data: (patients) {
        final me = primaryPatientOf(patients);
        final name = me?.fullName.trim() ?? '';
        return name.isEmpty ? null : name.split(RegExp(r'\s+')).first;
      },
      orElse: () => null,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Healyn')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(HealynSpacing.screenEdge),
          children: [
            Text(
              firstName == null ? 'Welcome back' : 'Hi, $firstName',
              style: HealynTypography.h1,
            ),
            const SizedBox(height: HealynSpacing.s2),
            const Text(
              'Manage your appointments, family, and care in one place.',
              style: HealynTypography.body,
            ),
            const SizedBox(height: HealynSpacing.s5),
            const PatientSwitcher(),
            const SizedBox(height: HealynSpacing.s5),
            const _UnreadMessagesCard(),
            const _UpcomingSummary(),
            const _NextReviewCard(),
          ],
        ),
      ),
    );
  }
}

/// Account-wide unread roll-up (DISCUSSION_SYSTEM_DESIGN §9): a single count
/// that opens an index of appointments with unread messages. Renders nothing
/// while loading/failed or when there is nothing unread, so Home stays calm.
class _UnreadMessagesCard extends ConsumerWidget {
  const _UnreadMessagesCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(unreadSummaryProvider).valueOrNull;
    if (summary == null || summary.total == 0) return const SizedBox.shrink();

    final count = summary.total;
    final threads = summary.threads.length;
    return Padding(
      padding: const EdgeInsets.only(bottom: HealynSpacing.s5),
      child: SectionCard(
        child: InkWell(
          onTap: () => context.push('/discussions/unread'),
          child: Row(
            children: [
              const Icon(
                Icons.mark_email_unread_outlined,
                size: 20,
                color: HealynColors.brandPrimary,
              ),
              const SizedBox(width: HealynSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      count == 1 ? '1 unread message' : '$count unread messages',
                      style: HealynTypography.bodyStrong,
                    ),
                    const SizedBox(height: HealynSpacing.s1),
                    Text(
                      threads == 1
                          ? 'In 1 appointment'
                          : 'Across $threads appointments',
                      style: HealynTypography.caption,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: HealynColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

/// The "Upcoming appointments" card: shows the soonest open appointment, or an
/// invitation to book when there's nothing scheduled.
class _UpcomingSummary extends ConsumerWidget {
  const _UpcomingSummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointments = ref.watch(appointmentsProvider);
    final active = ref.watch(activePatientProvider);
    final patientNames = ref.watch(patientsProvider).maybeWhen(
      data: (patients) => {for (final p in patients) p.id: p.fullName},
      orElse: () => const <String, String>{},
    );
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.event_outlined,
                size: 20,
                color: HealynColors.brandPrimary,
              ),
              SizedBox(width: HealynSpacing.s2),
              Text(
                'Upcoming appointments',
                style: HealynTypography.bodyStrong,
              ),
            ],
          ),
          const SizedBox(height: HealynSpacing.s3),
          appointments.when(
            loading: () => Text(
              'Checking your schedule…',
              style: HealynTypography.body.copyWith(
                color: HealynColors.textSecondary,
              ),
            ),
            error: (_, _) => Text(
              'Could not load your appointments.',
              style: HealynTypography.body.copyWith(
                color: HealynColors.textSecondary,
              ),
            ),
            // Account-wide (PATIENT_RELATIONSHIP_MODEL §7): the soonest open
            // appointment across every managed patient, so a booking for a
            // family member surfaces even when the primary is active. Active-
            // patient scoping stays in the booking flow's pre-selection only.
            data: (state) {
              final next = nextUpcomingOf(state.items);
              if (next == null) return const _NothingScheduled();
              // Label the patient when it isn't the active one, so a family
              // member's appointment is recognisable at a glance.
              final forName = next.patientId == active?.id
                  ? null
                  : patientNames[next.patientId];
              return _NextAppointment(next: next, forName: forName);
            },
          ),
        ],
      ),
    );
  }
}

class _NextAppointment extends StatelessWidget {
  const _NextAppointment({required this.next, this.forName});

  final Appointment next;

  /// The patient's name, shown only when the appointment isn't for the active
  /// patient. Null suppresses the label.
  final String? forName;

  @override
  Widget build(BuildContext context) {
    final name = forName;
    return InkWell(
      onTap: () => context.push('/appointments/${next.id}', extra: next),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatAppointmentWhenShort(next),
                  style: HealynTypography.bodyStrong,
                ),
                if (name != null) ...[
                  const SizedBox(height: HealynSpacing.s1),
                  Text(
                    'for $name',
                    style: HealynTypography.caption.copyWith(
                      color: HealynColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: HealynSpacing.s2),
                AppointmentStatusChip(status: next.status),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: HealynColors.textMuted),
        ],
      ),
    );
  }
}

/// "Suggested next review" card (D6): when a physiotherapist set a next-review
/// date on a treatment note and the patient hasn't already booked, nudge a
/// booking with the date prefilled. Advisory — it deep-links into the normal
/// slot flow, never auto-books. Renders nothing while loading/failed or when
/// there's nothing pending, so Home stays calm.
class _NextReviewCard extends ConsumerWidget {
  const _NextReviewCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestion = ref.watch(nextReviewSuggestionProvider).valueOrNull;
    if (suggestion == null) return const SizedBox.shrink();
    final active = ref.watch(activePatientProvider);
    final forName = suggestion.patient.id == active?.id
        ? null
        : suggestion.patient.fullName;

    return Padding(
      padding: const EdgeInsets.only(top: HealynSpacing.s5),
      child: SectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.event_repeat_outlined,
                  size: 20,
                  color: HealynColors.brandPrimary,
                ),
                SizedBox(width: HealynSpacing.s2),
                Text(
                  'Suggested next review',
                  style: HealynTypography.bodyStrong,
                ),
              ],
            ),
            const SizedBox(height: HealynSpacing.s3),
            Text(
              formatReviewWhen(suggestion.reviewAt),
              style: HealynTypography.body,
            ),
            if (forName != null) ...[
              const SizedBox(height: HealynSpacing.s1),
              Text(
                'for $forName',
                style: HealynTypography.caption.copyWith(
                  color: HealynColors.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: HealynSpacing.s2),
            TextButton.icon(
              onPressed: () => context.push(
                '/appointments/book',
                extra: BookAppointmentArgs(
                  patientId: suggestion.patient.id,
                  day: suggestion.reviewAt.toLocal(),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Book appointment'),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
            ),
          ],
        ),
      ),
    );
  }
}

class _NothingScheduled extends StatelessWidget {
  const _NothingScheduled();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nothing scheduled yet.',
          style: HealynTypography.body.copyWith(
            color: HealynColors.textSecondary,
          ),
        ),
        const SizedBox(height: HealynSpacing.s2),
        TextButton.icon(
          onPressed: () => context.push('/appointments/book'),
          icon: const Icon(Icons.add),
          label: const Text('Book appointment'),
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
        ),
      ],
    );
  }
}
