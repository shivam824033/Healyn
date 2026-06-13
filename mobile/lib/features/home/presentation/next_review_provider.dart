import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../appointments/data/models/appointment_models.dart';
import '../../appointments/presentation/appointments_providers.dart';
import '../../patients/data/models/patient_models.dart';
import '../../patients/presentation/patients_providers.dart';
import '../../treatment_notes/data/models/treatment_note_models.dart';
import '../../treatment_notes/presentation/next_review_providers.dart';

/// A pending follow-up surfaced on Home (D6): the soonest review a
/// physiotherapist suggested across the account's patients, plus the patient it
/// is for and the appointment it came from. A "next review" is advisory, never an
/// appointment — the card just deep-links into the normal booking flow with the
/// date prefilled.
class NextReviewSuggestion {
  const NextReviewSuggestion({
    required this.patient,
    required this.reviewAt,
    this.appointmentNumber,
  });

  final Patient patient;
  final DateTime reviewAt;

  /// Human-friendly number of the appointment whose treatment note set this
  /// review (e.g. "PHY-20260610-0001"), so the patient can tell which visit the
  /// follow-up relates to. Null when the source appointment isn't in the loaded
  /// list — we omit the reference rather than guess.
  final String? appointmentNumber;
}

/// The single soonest pending review to nudge about, or null when there's
/// nothing to suggest. A patient who already has an open upcoming appointment is
/// skipped — they don't need a nudge to book. Fans out the per-patient review
/// lookups like the unread roll-up does (a patient account manages few patients).
final nextReviewSuggestionProvider =
    FutureProvider.autoDispose<NextReviewSuggestion?>((ref) async {
      final patients = await ref.watch(patientsProvider.future);
      if (patients.isEmpty) return null;
      final appts = await ref.watch(appointmentsProvider.future);

      bool hasUpcoming(String patientId) =>
          appts.items.any((a) => a.patientId == patientId && a.status.isActive);

      final candidates = await Future.wait(
        patients.where((p) => !hasUpcoming(p.id)).map((p) async {
          final note = await ref.watch(
            patientNextReviewNoteProvider(p.id).future,
          );
          return note == null ? null : _Candidate(patient: p, note: note);
        }),
      );

      final pending = candidates.whereType<_Candidate>().toList()
        ..sort((a, b) => a.note.nextReviewAt!.compareTo(b.note.nextReviewAt!));
      if (pending.isEmpty) return null;
      final best = pending.first;

      // Best-effort: resolve the source appointment's human number from the
      // already-loaded list (no extra fetch). When it isn't on the loaded page we
      // leave it null and the card just omits the reference.
      String? number;
      for (final a in appts.items) {
        if (a.id == best.note.appointmentId) {
          number = a.appointmentNumber;
          break;
        }
      }

      return NextReviewSuggestion(
        patient: best.patient,
        reviewAt: best.note.nextReviewAt!,
        appointmentNumber: number,
      );
    });

/// A patient paired with the treatment note that carries their pending review,
/// while the soonest one is chosen.
class _Candidate {
  _Candidate({required this.patient, required this.note});

  final Patient patient;
  final TreatmentNote note;
}

/// Every managed patient's pending next-review, soonest first — the data behind
/// the "Follow-ups due" screen. One operative review per patient (the newest note
/// that carries a not-yet-lapsed review). Unlike [nextReviewSuggestionProvider] it
/// does NOT drop patients who already have an upcoming appointment; the screen
/// marks those instead, so the full family picture shows.
final pendingReviewsProvider =
    FutureProvider.autoDispose<List<NextReviewSuggestion>>((ref) async {
      final patients = await ref.watch(patientsProvider.future);
      if (patients.isEmpty) return const [];
      final appts = await ref.watch(appointmentsProvider.future);

      final results = await Future.wait(
        patients.map((p) async {
          final note = await ref.watch(
            patientNextReviewNoteProvider(p.id).future,
          );
          if (note == null) return null;
          String? number;
          for (final a in appts.items) {
            if (a.id == note.appointmentId) {
              number = a.appointmentNumber;
              break;
            }
          }
          return NextReviewSuggestion(
            patient: p,
            reviewAt: note.nextReviewAt!,
            appointmentNumber: number,
          );
        }),
      );

      return results.whereType<NextReviewSuggestion>().toList()
        ..sort((a, b) => a.reviewAt.compareTo(b.reviewAt));
    });
