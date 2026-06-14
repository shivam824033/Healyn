import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/healyn_skeletons.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../treatment_notes/data/models/treatment_note_models.dart';
import '../../../treatment_notes/presentation/treatment_notes_providers.dart';
import '../../../treatment_notes/presentation/widgets/treatment_note_card.dart';

/// The physiotherapist's view of a COMPLETED appointment's treatment note, with
/// the write affordance the patient side lacks: an "Add"/"Edit" button that opens
/// the editor (C5). Reads the same provider as the patient section and reuses
/// [TreatmentNoteCard] for rendering; only the empty-state copy and the button
/// differ. Mounted only when the appointment is COMPLETED (the caller's gate).
class PhysioTreatmentNoteSection extends ConsumerWidget {
  const PhysioTreatmentNoteSection({required this.appointmentId, super.key});

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
          data: (n) {
            if (n == null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionCard(
                    child: Text(
                      'No treatment note for this visit yet.',
                      style: HealynTypography.body.copyWith(
                        color: HealynColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: HealynSpacing.s3),
                  ElevatedButton.icon(
                    onPressed: () => _openEditor(context, null),
                    icon: const Icon(Icons.note_add_outlined),
                    label: const Text('Add treatment note'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TreatmentNoteCard(note: n),
                const SizedBox(height: HealynSpacing.s3),
                OutlinedButton.icon(
                  onPressed: () => _openEditor(context, n),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit treatment note'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: HealynColors.textPrimary,
                    minimumSize: const Size.fromHeight(48),
                    side: const BorderSide(color: HealynColors.borderSubtle),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// Opens the editor, passing the already-loaded [note] as `extra` so an edit
  /// prefills without a refetch (null for a first write). The editor invalidates
  /// the provider on save, so this section re-reads it on return.
  void _openEditor(BuildContext context, TreatmentNote? note) {
    context.push(
      '/physio/appointments/$appointmentId/treatment_note',
      extra: note,
    );
  }
}
