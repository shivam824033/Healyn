import 'package:freezed_annotation/freezed_annotation.dart';

part 'treatment_note_models.freezed.dart';
part 'treatment_note_models.g.dart';

/// The physiotherapist's clinical note for one appointment. Mirrors the backend
/// `TreatmentNoteView`. Written physio-side once the appointment is COMPLETED;
/// the patient app reads it. At least one of [diagnosis] / [notes] /
/// [recoveryInstructions] is non-blank (a server invariant), but any individual
/// field may be null. Timestamps are UTC instants; convert to local for display.
/// All text fields are PHI — never log them (CLAUDE.md §3).
@freezed
abstract class TreatmentNote with _$TreatmentNote {
  const factory TreatmentNote({
    required String id,
    required String appointmentId,
    required String patientId,
    required String authorAccountId,
    String? diagnosis,
    String? notes,
    String? recoveryInstructions,
    DateTime? nextReviewAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TreatmentNote;

  factory TreatmentNote.fromJson(Map<String, dynamic> json) =>
      _$TreatmentNoteFromJson(json);
}

/// One cursor page of a patient's treatment notes, newest-first (the backend
/// order). [nextCursor] is null on the last (oldest) page. Mirrors the backend
/// `TreatmentNotePage`.
@freezed
abstract class TreatmentNotePage with _$TreatmentNotePage {
  const factory TreatmentNotePage({
    required List<TreatmentNote> items,
    String? nextCursor,
  }) = _TreatmentNotePage;

  factory TreatmentNotePage.fromJson(Map<String, dynamic> json) =>
      _$TreatmentNotePageFromJson(json);
}
