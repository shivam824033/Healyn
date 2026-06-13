import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/network/api_exception.dart';
import 'models/treatment_note_models.dart';
import 'treatment_notes_api.dart';

/// Data access for treatment notes. Maps transport errors to [ApiException];
/// the UI talks only to this class, never to Dio directly.
class TreatmentNotesRepository {
  TreatmentNotesRepository(this._api);

  final TreatmentNotesApi _api;

  /// The note for [appointmentId], or `null` when none has been written yet.
  /// The backend returns `404 treatment_notes.not_found` until the physio adds
  /// one, which is an expected empty state — not an error — so it maps to null.
  Future<TreatmentNote?> forAppointment(String appointmentId) async {
    try {
      return await _api.getForAppointment(appointmentId);
    } on DioException catch (e) {
      final ex = ApiException.fromDio(e);
      if (ex.statusCode == 404) return null;
      throw ex;
    }
  }

  /// Creates or replaces the treatment note for [appointmentId] (physio only;
  /// the appointment must be COMPLETED — both enforced server-side). Blank text
  /// fields are normalised to null so they drop off the wire and clear on the
  /// server; [nextReviewAt] is sent as a UTC instant. The caller is responsible
  /// for ensuring at least one of the three text fields is non-blank (the server
  /// rejects an all-blank note with 422).
  Future<TreatmentNote> upsert(
    String appointmentId, {
    String? diagnosis,
    String? notes,
    String? recoveryInstructions,
    DateTime? nextReviewAt,
  }) async {
    try {
      return await _api.upsert(
        appointmentId,
        UpsertTreatmentNoteRequest(
          diagnosis: _clean(diagnosis),
          notes: _clean(notes),
          recoveryInstructions: _clean(recoveryInstructions),
          nextReviewAt: nextReviewAt?.toUtc(),
        ),
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// One cursor page of [patientId]'s treatment notes, newest-first.
  Future<TreatmentNotePage> forPatient(
    String patientId, {
    String? cursor,
    int? limit,
  }) async {
    try {
      return await _api.listForPatient(patientId, cursor: cursor, limit: limit);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Which of [appointmentIds] already have a treatment note (physio only) — used
  /// to flag completed appointments that still need one. Returns a set for O(1)
  /// membership at the call site.
  Future<Set<String>> appointmentsWithNotes(List<String> appointmentIds) async {
    if (appointmentIds.isEmpty) return const <String>{};
    try {
      return (await _api.appointmentsWithNotes(appointmentIds)).toSet();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Trims [s] and collapses blank to null so optional note fields drop off the
  /// wire (`include_if_null: false`) rather than persisting an empty string.
  static String? _clean(String? s) {
    final t = s?.trim() ?? '';
    return t.isEmpty ? null : t;
  }
}

final treatmentNotesRepositoryProvider = Provider<TreatmentNotesRepository>(
  (ref) => TreatmentNotesRepository(ref.watch(treatmentNotesApiProvider)),
);
