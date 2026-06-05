import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/treatment_note_models.dart';
import '../data/treatment_notes_repository.dart';

/// How many recent notes to scan for the operative review. A patient's note
/// count is small in Phase 1, so a single page always covers it.
const _reviewScanLimit = 20;

/// The operative pending "next review" from [notes] (which arrive newest-first):
/// the review the physiotherapist set on the most recent note that carries one,
/// returned only when it falls today or later. A review that has already passed
/// has lapsed and is treated as none. Older notes are superseded by the newest
/// one that carries a review, so this is the current clinical guidance.
///
/// Pure (inject [now] in tests). The returned instant is the stored UTC value —
/// format it with `formatReviewWhen`, which converts to local.
DateTime? pendingReviewFrom(List<TreatmentNote> notes, {DateTime? now}) {
  final ref = (now ?? DateTime.now()).toLocal();
  final today = DateTime(ref.year, ref.month, ref.day);
  for (final n in notes) {
    final at = n.nextReviewAt;
    if (at != null) {
      // The first (newest) note that carries a review wins.
      return at.toLocal().isBefore(today) ? null : at;
    }
  }
  return null;
}

/// The pending next-review date a physiotherapist suggested for [patientId], or
/// null when none is due. Advisory only — booking still goes through the slot
/// flow (CLAUDE.md §11), never auto-created. Used by the physio patient detail
/// ("follow-up due") and the patient Home suggestion.
final patientNextReviewProvider = FutureProvider.autoDispose
    .family<DateTime?, String>((ref, patientId) async {
      final page = await ref
          .watch(treatmentNotesRepositoryProvider)
          .forPatient(patientId, limit: _reviewScanLimit);
      return pendingReviewFrom(page.items);
    });
