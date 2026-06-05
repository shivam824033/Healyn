import 'package:flutter/material.dart';

import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/section_card.dart';
import '../../data/models/treatment_note_models.dart';
import '../treatment_notes_format.dart';

/// Read-only rendering of a [TreatmentNote] — its non-blank fields as labelled
/// blocks inside a [SectionCard]. Shared by the patient's appointment detail and
/// the physiotherapist's detail/edit flow so both render a note identically.
class TreatmentNoteCard extends StatelessWidget {
  const TreatmentNoteCard({required this.note, super.key});

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
          value: formatReviewWhen(note.nextReviewAt!),
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
