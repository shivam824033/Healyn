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
import '../../shared/widgets/healyn_hero.dart';
import '../../shared/widgets/healyn_info_banner.dart';
import '../../shared/widgets/healyn_list_row.dart';
import '../../shared/widgets/healyn_section_header.dart';
import '../../treatment_notes/presentation/treatment_notes_format.dart';
import 'next_review_provider.dart';

/// Horizontal inset for the content below the full-bleed hero.
const _edge = EdgeInsets.symmetric(horizontal: HealynSpacing.screenEdge);

/// Home tab — the signed-in landing, in the *Refined Indigo* direction: a
/// gradient hero greeting over the active-patient switcher, a calm unread
/// roll-up banner, and the next upcoming appointment (or an invitation to book
/// one). Greets the primary patient by first name.
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
      backgroundColor: HealynColors.surfaceAlt,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          HealynHero(
            eyebrow: _greeting(DateTime.now()),
            title: firstName == null ? 'Welcome back' : 'Hi, $firstName',
            subtitle: 'Manage your appointments, family, and care in one place.',
            bottomOverlap: HealynSpacing.s6,
          ),
          const SizedBox(height: HealynSpacing.s5),
          const Padding(padding: _edge, child: PatientSwitcher()),
          const SizedBox(height: HealynSpacing.s5),
          const _UnreadMessagesCard(),
          const _UpcomingSummary(),
          const _NextReviewCard(),
          const SizedBox(height: HealynSpacing.s8),
        ],
      ),
    );
  }

  /// A clock-derived greeting — no fabricated name (the title carries it).
  static String _greeting(DateTime now) {
    final h = now.hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
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
      padding: const EdgeInsets.fromLTRB(
        HealynSpacing.screenEdge,
        0,
        HealynSpacing.screenEdge,
        HealynSpacing.s5,
      ),
      child: HealynInfoBanner(
        tone: HealynBannerTone.info,
        icon: Icons.mark_email_unread_outlined,
        title: count == 1 ? '1 unread message' : '$count unread messages',
        subtitle: threads == 1
            ? 'In 1 appointment'
            : 'Across $threads appointments',
        onTap: () => context.push('/discussions/unread'),
      ),
    );
  }
}

/// The "Upcoming appointments" section: shows the soonest open appointment, or
/// an invitation to book when there's nothing scheduled.
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
    return Padding(
      padding: _edge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HealynSectionHeader(title: 'Upcoming appointments'),
          const SizedBox(height: HealynSpacing.s3),
          appointments.when(
            loading: () => const _MutedLine('Checking your schedule…'),
            error: (_, _) =>
                const _MutedLine('Could not load your appointments.'),
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
    return HealynListRow(
      title: formatAppointmentWhenShort(next),
      subtitle: name != null ? 'for $name' : null,
      footer: AppointmentStatusChip(status: next.status),
      onTap: () => context.push('/appointments/${next.id}', extra: next),
    );
  }
}

/// "Suggested next review" section (D6): when a physiotherapist set a
/// next-review date on a treatment note and the patient hasn't already booked,
/// nudge a booking with the date prefilled. Advisory — it deep-links into the
/// normal slot flow, never auto-books. Renders nothing while loading/failed or
/// when there's nothing pending, so Home stays calm.
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
      padding: const EdgeInsets.fromLTRB(
        HealynSpacing.screenEdge,
        HealynSpacing.s5,
        HealynSpacing.screenEdge,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HealynSectionHeader(title: 'Suggested next review'),
          const SizedBox(height: HealynSpacing.s3),
          Text(formatReviewWhen(suggestion.reviewAt), style: HealynTypography.body),
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

/// A single muted line for the upcoming section's loading / error states.
class _MutedLine extends StatelessWidget {
  const _MutedLine(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: HealynTypography.body.copyWith(color: HealynColors.textSecondary),
    );
  }
}
