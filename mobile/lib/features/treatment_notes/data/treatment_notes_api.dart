import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/network/dio_client.dart';
import 'models/treatment_note_models.dart';

/// Thin transport for an appointment's treatment note — the nested
/// `/appointments/{appointmentId}/treatment_note` endpoint. Returns the typed
/// model; DioErrors propagate and are mapped to [ApiException] in the
/// repository (a 404 means "no note yet" and is handled there).
class TreatmentNotesApi {
  TreatmentNotesApi(this._dio);

  final Dio _dio;

  Future<TreatmentNote> getForAppointment(String appointmentId) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/appointments/$appointmentId/treatment_note',
    );
    return TreatmentNote.fromJson(res.data!);
  }

  /// Creates or replaces the appointment's treatment note (physio only — the
  /// server enforces the role and that the appointment is COMPLETED). The
  /// endpoint upserts, so the same call covers a first write and later edits.
  Future<TreatmentNote> upsert(
    String appointmentId,
    UpsertTreatmentNoteRequest body,
  ) async {
    final res = await _dio.put<Map<String, dynamic>>(
      '/appointments/$appointmentId/treatment_note',
      data: body.toJson(),
    );
    return TreatmentNote.fromJson(res.data!);
  }

  /// One cursor page of a patient's treatment notes (newest-first) from
  /// `/patients/{patientId}/treatment_notes`.
  Future<TreatmentNotePage> listForPatient(
    String patientId, {
    String? cursor,
    int? limit,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/patients/$patientId/treatment_notes',
      queryParameters: {
        'cursor': ?cursor,
        'limit': ?limit,
      },
    );
    return TreatmentNotePage.fromJson(res.data!);
  }
}

final treatmentNotesApiProvider = Provider<TreatmentNotesApi>(
  (ref) => TreatmentNotesApi(ref.watch(dioProvider)),
);
