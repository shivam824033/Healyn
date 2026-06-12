import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/field_label.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../treatment_notes/data/models/treatment_note_models.dart';
import '../../../treatment_notes/data/treatment_notes_repository.dart';
import '../../../treatment_notes/presentation/treatment_notes_format.dart';
import '../../../treatment_notes/presentation/treatment_notes_providers.dart';

/// The physiotherapist writes or revises the treatment note for a COMPLETED
/// appointment (C5). One note per appointment — the backend upserts, so the same
/// form serves the first write and later edits. Diagnosis / notes / recovery
/// instructions are free text (at least one is required, mirroring the server);
/// next review is an optional reminder instant. On save the appointment's note
/// provider is invalidated so the detail re-reads it.
class PhysioTreatmentNoteScreen extends ConsumerStatefulWidget {
  const PhysioTreatmentNoteScreen({
    required this.appointmentId,
    this.existing,
    super.key,
  });

  final String appointmentId;

  /// The note being edited, or null for a first write. When present its fields
  /// prefill the form.
  final TreatmentNote? existing;

  @override
  ConsumerState<PhysioTreatmentNoteScreen> createState() =>
      _PhysioTreatmentNoteScreenState();
}

class _PhysioTreatmentNoteScreenState
    extends ConsumerState<PhysioTreatmentNoteScreen> {
  late final TextEditingController _diagnosis;
  late final TextEditingController _notes;
  late final TextEditingController _recovery;
  DateTime? _nextReviewAt;

  bool _submitting = false;
  String? _error;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _diagnosis = TextEditingController(text: e?.diagnosis ?? '');
    _notes = TextEditingController(text: e?.notes ?? '');
    _recovery = TextEditingController(text: e?.recoveryInstructions ?? '');
    _nextReviewAt = e?.nextReviewAt?.toLocal();
    // Re-evaluate the save button as the fields change.
    for (final c in [_diagnosis, _notes, _recovery]) {
      c.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    for (final c in [_diagnosis, _notes, _recovery]) {
      c
        ..removeListener(_onChanged)
        ..dispose();
    }
    super.dispose();
  }

  void _onChanged() => setState(() {});

  /// The server requires at least one of the three text fields; gate the button
  /// the same way so the physio gets immediate feedback instead of a 422.
  bool get _hasContent =>
      _diagnosis.text.trim().isNotEmpty ||
      _notes.text.trim().isNotEmpty ||
      _recovery.text.trim().isNotEmpty;

  Future<void> _pickReview() async {
    final now = DateTime.now();
    final base = _nextReviewAt ?? now.add(const Duration(days: 7));
    final date = await showDatePicker(
      context: context,
      initialDate: base,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365 * 2)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(base),
    );
    if (!mounted) return;
    setState(() {
      _nextReviewAt = DateTime(
        date.year,
        date.month,
        date.day,
        time?.hour ?? 9,
        time?.minute ?? 0,
      );
    });
  }

  Future<void> _save() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    final repo = ref.read(treatmentNotesRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await repo.upsert(
        widget.appointmentId,
        diagnosis: _diagnosis.text,
        notes: _notes.text,
        recoveryInstructions: _recovery.text,
        nextReviewAt: _nextReviewAt,
      );
      ref.invalidate(
        treatmentNoteForAppointmentProvider(widget.appointmentId),
      );
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(_isEdit ? 'Treatment note updated' : 'Treatment note saved'),
        ),
      );
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HealynAppBar(
        title: _isEdit ? 'Edit treatment note' : 'Treatment note',
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(HealynSpacing.screenEdge),
          children: [
            if (_error != null) ...[
              ErrorBanner(message: _error!),
              const SizedBox(height: HealynSpacing.s4),
            ],
            const FieldLabel('Diagnosis'),
            _NoteField(
              controller: _diagnosis,
              hint: 'Assessment / diagnosis',
            ),
            const SizedBox(height: HealynSpacing.s5),
            const FieldLabel('Notes'),
            _NoteField(
              controller: _notes,
              hint: 'Session notes and observations',
            ),
            const SizedBox(height: HealynSpacing.s5),
            const FieldLabel('Recovery instructions'),
            _NoteField(
              controller: _recovery,
              hint: 'Exercises, precautions, home care',
            ),
            const SizedBox(height: HealynSpacing.s6),
            const FieldLabel('Next review'),
            const SizedBox(height: HealynSpacing.s2),
            _ReviewRow(
              value: _nextReviewAt,
              onPick: _submitting ? null : _pickReview,
              onClear: _nextReviewAt == null || _submitting
                  ? null
                  : () => setState(() => _nextReviewAt = null),
            ),
            const SizedBox(height: HealynSpacing.s3),
            Text(
              'At least one of diagnosis, notes, or recovery instructions is '
              'required.',
              style: HealynTypography.caption.copyWith(
                color: HealynColors.textMuted,
              ),
            ),
            const SizedBox(height: HealynSpacing.s7),
            PrimaryButton(
              label: _isEdit ? 'Save changes' : 'Save note',
              loading: _submitting,
              onPressed: (!_hasContent || _submitting) ? null : _save,
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteField extends StatelessWidget {
  const _NoteField({required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: 2,
      maxLines: 6,
      maxLength: 8000,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText: hint,
        counterText: '',
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({
    required this.value,
    required this.onPick,
    required this.onClear,
  });

  final DateTime? value;
  final VoidCallback? onPick;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            value == null ? 'Not set' : formatReviewWhen(value!),
            style: HealynTypography.body.copyWith(
              color: value == null
                  ? HealynColors.textSecondary
                  : HealynColors.textPrimary,
            ),
          ),
        ),
        if (value != null)
          TextButton(onPressed: onClear, child: const Text('Clear')),
        TextButton(
          onPressed: onPick,
          child: Text(value == null ? 'Set date' : 'Change'),
        ),
      ],
    );
  }
}
