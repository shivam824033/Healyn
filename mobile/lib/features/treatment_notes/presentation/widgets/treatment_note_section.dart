import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/section_card.dart';
import '../../data/models/treatment_note_models.dart';
import '../treatment_notes_providers.dart';

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];
const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

/// Local when-line for the review date: `Wed, 10 Jun 2026 · 9:00 AM`.
String _formatReviewWhen(DateTime instant) {
  final d = instant.toLocal();
  final hour12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final minute = d.minute.toString().padLeft(2, '0');
  final period = d.hour < 12 ? 'AM' : 'PM';
  final date = '${_weekdays[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]} '
      '${d.year}';
  return '$date · $hour12:$minute $period';
}

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
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(HealynSpacing.s4),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
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
          data: (n) => n == null ? const _EmptyNote() : _NoteCard(note: n),
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

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note});

  final TreatmentNote note;

  @override
  Widget build(BuildContext context) {
    final blocks = <Widget>[
      if (_has(note.diagnosis)) _Field(label: 'Diagnosis', value: note.diagnosis!),
      if (_has(note.notes)) _Field(label: 'Notes', value: note.notes!),
      if (_has(note.recoveryInstructions))
        _Field(
          label: 'Recovery instructions',
          value: note.recoveryInstructions!,
        ),
      if (note.nextReviewAt != null)
        _Field(
          label: 'Next review',
          value: _formatReviewWhen(note.nextReviewAt!),
        ),
    ];

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < blocks.length; i++) ...[
            if (i > 0) const SizedBox(height: HealynSpacing.s5),
            blocks[i],
          ],
        ],
      ),
    );
  }

  static bool _has(String? s) => s != null && s.trim().isNotEmpty;
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: HealynTypography.overline),
        const SizedBox(height: HealynSpacing.s1),
        Text(value, style: HealynTypography.body),
      ],
    );
  }
}
