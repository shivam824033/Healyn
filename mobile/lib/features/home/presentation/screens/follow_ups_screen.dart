import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../appointments/data/models/appointment_models.dart';
import '../../../appointments/presentation/appointments_providers.dart';
import '../../../appointments/presentation/screens/book_appointment_screen.dart';
import '../../../patients/data/models/patient_models.dart';
import '../../../patients/presentation/patient_format.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/motion.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/healyn_reveal.dart';
import '../../../shared/widgets/healyn_skeletons.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../treatment_notes/presentation/treatment_notes_format.dart';
import '../next_review_provider.dart';

/// "Follow-ups due" (issue 4): every managed patient's pending next-review,
/// grouped one card per patient and showing the appointment it came from, so the
/// account holder can tell which review belongs to whom across the family. Each
/// card deep-links into the normal booking flow with the date prefilled — a
/// follow-up is advisory, never auto-booked (CLAUDE.md §11). A patient who already
/// has an upcoming appointment is marked rather than nudged.
class FollowUpsScreen extends ConsumerWidget {
  const FollowUpsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(pendingReviewsProvider);
    // Patients with an open appointment already — they get a marker, not a nudge.
    final bookedPatientIds = ref.watch(appointmentsProvider).maybeWhen(
      data: (state) => {
        for (final a in state.items)
          if (a.status.isActive) a.patientId,
      },
      orElse: () => const <String>{},
    );

    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: const HealynAppBar(title: 'Follow-ups due'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(pendingReviewsProvider);
            await ref.read(pendingReviewsProvider.future);
          },
          child: AnimatedSwitcher(
            duration: HealynMotion.slow,
            switchInCurve: HealynMotion.standardCurve,
            switchOutCurve: HealynMotion.standardCurve,
            child: reviews.when(
              loading: () => const HealynListSkeleton(
                key: ValueKey('followups-loading'),
                hasLeading: true,
                hasFooter: true,
                count: 4,
              ),
              error: (_, _) => ListView(
                key: const ValueKey('followups-error'),
                padding: const EdgeInsets.all(HealynSpacing.screenEdge),
                children: const [
                  ErrorBanner(
                    message:
                        'Could not load your follow-ups. Pull down to retry.',
                  ),
                ],
              ),
              data: (items) {
                if (items.isEmpty) {
                  return const _NoFollowUps(key: ValueKey('followups-empty'));
                }
                return ListView.separated(
                  key: const ValueKey('followups-data'),
                  padding: const EdgeInsets.all(HealynSpacing.screenEdge),
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: HealynSpacing.s4),
                  itemBuilder: (_, i) {
                    final r = items[i];
                    return HealynReveal.staggered(
                      index: i < 6 ? i : 6,
                      child: _FollowUpCard(
                        suggestion: r,
                        alreadyBooked: bookedPatientIds.contains(r.patient.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _FollowUpCard extends StatelessWidget {
  const _FollowUpCard({required this.suggestion, required this.alreadyBooked});

  final NextReviewSuggestion suggestion;
  final bool alreadyBooked;

  @override
  Widget build(BuildContext context) {
    final patient = suggestion.patient;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Avatar(name: patient.fullName),
              const SizedBox(width: HealynSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(patient.fullName, style: HealynTypography.bodyStrong),
                    Text(_subtitle(patient), style: HealynTypography.caption),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: HealynSpacing.s3),
          if (suggestion.appointmentNumber != null)
            _DetailLine(
              icon: Icons.confirmation_number_outlined,
              text: 'Appointment ${suggestion.appointmentNumber}',
            ),
          _DetailLine(
            icon: Icons.event_outlined,
            text: 'Review ${formatReviewWhen(suggestion.reviewAt)}',
          ),
          const SizedBox(height: HealynSpacing.s3),
          if (alreadyBooked)
            Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 16,
                  color: HealynColors.statusSuccess,
                ),
                const SizedBox(width: HealynSpacing.s2),
                Text(
                  'Upcoming appointment already booked',
                  style: HealynTypography.caption.copyWith(
                    color: HealynColors.textSecondary,
                  ),
                ),
              ],
            )
          else
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => context.push(
                  '/appointments/book',
                  extra: BookAppointmentArgs(
                    patientId: patient.id,
                    day: suggestion.reviewAt.toLocal(),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Book appointment'),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
              ),
            ),
        ],
      ),
    );
  }

  static String _subtitle(Patient p) {
    if (p.primary) return 'You';
    final rel = p.relationship?.label;
    final age = '${patientAgeInYears(p.dateOfBirth)} yrs';
    return rel == null ? age : '$rel · $age';
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: HealynSpacing.s1),
      child: Row(
        children: [
          Icon(icon, size: 16, color: HealynColors.textSecondary),
          const SizedBox(width: HealynSpacing.s2),
          Expanded(child: Text(text, style: HealynTypography.body)),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: HealynColors.brandPrimarySubtle,
      child: Text(
        patientInitials(name),
        style: HealynTypography.bodyStrong.copyWith(
          color: HealynColors.brandPrimaryHover,
        ),
      ),
    );
  }
}

class _NoFollowUps extends StatelessWidget {
  const _NoFollowUps({super.key});

  @override
  Widget build(BuildContext context) {
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
          'No follow-ups due',
          style: HealynTypography.h3,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: HealynSpacing.s2),
        Text(
          'When a physiotherapist suggests a next review, it will appear here.',
          style: HealynTypography.body.copyWith(
            color: HealynColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
