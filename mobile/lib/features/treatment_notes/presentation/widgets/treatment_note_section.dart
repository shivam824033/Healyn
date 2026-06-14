import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/healyn_skeletons.dart';
import '../../../shared/widgets/section_card.dart';
import '../treatment_notes_providers.dart';
import 'treatment_note_card.dart';

/// The physiotherapist's note for a COMPLETED appointment, surfaced read-only on
/// the appointment detail screen. Shows an empty state until the physio writes
/// one (the backend 404 maps to null in the repository). Renders the full
/// section — its own "Treatment note" heading plus the card.
class TreatmentNoteSection extends ConsumerWidget {
  const TreatmentNoteSection({required this.appointmentId, super.key});

  final String appointmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final note = ref.watch(treatmentNoteForAppointmentProvider(appointmentId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Treatment note'.toUpperCase(), style: HealynTypography.overline),
        const SizedBox(height: HealynSpacing.s3),
        note.when(
          loading: () => const SectionCard(
            child: HealynSkeletonGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HealynSkeletonLine(widthFactor: 0.5, height: 14),
                  SizedBox(height: HealynSpacing.s2),
                  HealynSkeletonLine(widthFactor: 0.9, height: 12),
                  SizedBox(height: HealynSpacing.s1),
                  HealynSkeletonLine(widthFactor: 0.75, height: 12),
                ],
              ),
            ),
          ),
          error: (_, _) => SectionCard(
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Couldn't load the treatment note.",
                    style: HealynTypography.body,
                  ),
                ),
                TextButton(
                  onPressed: () => ref.invalidate(
                    treatmentNoteForAppointmentProvider(appointmentId),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (n) =>
              n == null ? const _EmptyNote() : TreatmentNoteCard(note: n),
        ),
      ],
    );
  }
}

class _EmptyNote extends StatelessWidget {
  const _EmptyNote();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Text(
        'Your physiotherapist hasn’t added a note for this visit yet.',
        style: HealynTypography.body.copyWith(color: HealynColors.textSecondary),
      ),
    );
  }
}

