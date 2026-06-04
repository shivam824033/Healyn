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
}

final treatmentNotesRepositoryProvider = Provider<TreatmentNotesRepository>(
  (ref) => TreatmentNotesRepository(ref.watch(treatmentNotesApiProvider)),
);
