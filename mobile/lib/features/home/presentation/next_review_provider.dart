import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../appointments/data/models/appointment_models.dart';
import '../../appointments/presentation/appointments_providers.dart';
import '../../patients/data/models/patient_models.dart';
import '../../patients/presentation/patients_providers.dart';
import '../../treatment_notes/presentation/next_review_providers.dart';

/// A pending follow-up surfaced on Home (D6): the soonest review a
/// physiotherapist suggested across the account's patients, plus the patient it
/// is for. A "next review" is advisory, never an appointment — the card just
/// deep-links into the normal booking flow with the date prefilled.
class NextReviewSuggestion {
  const NextReviewSuggestion({required this.patient, required this.reviewAt});

  final Patient patient;
  final DateTime reviewAt;
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
          final at = await ref.watch(patientNextReviewProvider(p.id).future);
          return at == null
              ? null
              : NextReviewSuggestion(patient: p, reviewAt: at);
        }),
      );

      final pending = candidates.whereType<NextReviewSuggestion>().toList()
        ..sort((a, b) => a.reviewAt.compareTo(b.reviewAt));
      return pending.isEmpty ? null : pending.first;
    });
