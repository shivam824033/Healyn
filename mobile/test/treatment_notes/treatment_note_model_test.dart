import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/treatment_notes/data/models/treatment_note_models.dart';

void main() {
  Map<String, dynamic> noteJson({
    String? diagnosis = 'Lumbar strain',
    String? notes = 'Responding well to mobilisation.',
    String? recoveryInstructions = 'Daily stretches; avoid heavy lifting.',
    String? nextReviewAt = '2026-06-20T09:30:00Z',
  }) => <String, dynamic>{
    'id': 'tn1',
    'appointment_id': 'ap1',
    'patient_id': 'pt1',
    'author_account_id': 'ac-physio',
    'diagnosis': diagnosis,
    'notes': notes,
    'recovery_instructions': recoveryInstructions,
    'next_review_at': nextReviewAt,
    'created_at': '2026-06-10T11:00:00Z',
    'updated_at': '2026-06-10T11:05:00Z',
  };

  test('parses a treatment note from snake_case JSON (instants are UTC)', () {
    final n = TreatmentNote.fromJson(noteJson());

    expect(n.id, 'tn1');
    expect(n.appointmentId, 'ap1');
    expect(n.patientId, 'pt1');
    expect(n.authorAccountId, 'ac-physio');
    expect(n.diagnosis, 'Lumbar strain');
    expect(n.notes, 'Responding well to mobilisation.');
    expect(n.recoveryInstructions, 'Daily stretches; avoid heavy lifting.');
    expect(n.nextReviewAt!.isUtc, isTrue);
    expect(n.nextReviewAt!.toUtc(), DateTime.utc(2026, 6, 20, 9, 30));
    expect(n.createdAt.toUtc(), DateTime.utc(2026, 6, 10, 11));
    expect(n.updatedAt.toUtc(), DateTime.utc(2026, 6, 10, 11, 5));
  });

  test('optional fields tolerate nulls (a notes-only note, no review date)', () {
    final n = TreatmentNote.fromJson(
      noteJson(diagnosis: null, recoveryInstructions: null, nextReviewAt: null),
    );

    expect(n.diagnosis, isNull);
    expect(n.recoveryInstructions, isNull);
    expect(n.nextReviewAt, isNull);
    expect(n.notes, 'Responding well to mobilisation.');
  });
}
