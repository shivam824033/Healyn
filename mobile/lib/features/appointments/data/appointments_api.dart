import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/network/dio_client.dart';
import 'models/appointment_models.dart';

/// Thin transport for the patient booking flow: the `/appointments` lifecycle
/// endpoints plus `/availability` (the slot source the booking form reads).
/// Returns typed models; DioErrors propagate and are mapped in the repository.
class AppointmentsApi {
  AppointmentsApi(this._dio);

  final Dio _dio;

  /// A page of the account's appointments, newest schedule first. Optional
  /// filters mirror the backend query params (snake_case on the wire). [from]
  /// and [to] bound `scheduledAt` (`>= from`, `< to`) and are sent as UTC
  /// instants — the physiotherapist's day schedule uses them to fetch one day.
  Future<AppointmentPage> list({
    String? patientId,
    String? statusCsv,
    DateTime? from,
    DateTime? to,
    String? cursor,
    int? limit,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/appointments',
      queryParameters: <String, dynamic>{
        'patient_id': ?patientId,
        if (statusCsv != null && statusCsv.isNotEmpty) 'status': statusCsv,
        if (from != null) 'from': from.toUtc().toIso8601String(),
        if (to != null) 'to': to.toUtc().toIso8601String(),
        if (cursor != null && cursor.isNotEmpty) 'cursor': cursor,
        'limit': ?limit,
      },
    );
    return AppointmentPage.fromJson(res.data!);
  }

  Future<Appointment> get(String id) async {
    final res = await _dio.get<Map<String, dynamic>>('/appointments/$id');
    return Appointment.fromJson(res.data!);
  }

  /// Books a new (REQUESTED) appointment. [idempotencyKey] dedupes retries of
  /// the same intended booking — generate it once per attempt and reuse it.
  Future<Appointment> book(
    BookAppointmentRequest body, {
    required String idempotencyKey,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/appointments',
      data: body.toJson(),
      options: Options(headers: {'Idempotency-Key': idempotencyKey}),
    );
    return Appointment.fromJson(res.data!);
  }

  /// Moves an appointment to a new time. The backend marks the original
  /// RESCHEDULED and returns the *new* appointment (HTTP 201). No
  /// Idempotency-Key — the original appointment id makes the call idempotent.
  Future<Appointment> reschedule(
    String id,
    RescheduleAppointmentRequest body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/appointments/$id/reschedule',
      data: body.toJson(),
    );
    return Appointment.fromJson(res.data!);
  }

  /// Drives a status transition. The patient app uses this only to cancel.
  Future<Appointment> transition(String id, TransitionRequest body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/appointments/$id/transitions',
      data: body.toJson(),
    );
    return Appointment.fromJson(res.data!);
  }

  /// Open slots for the physiotherapist over [from]..[to] (inclusive, date-only
  /// — pass the same day for both to fetch a single day). Resolves to the lone
  /// configured physiotherapist when [physiotherapistId] is null.
  Future<SlotListResponse> slots({
    required DateTime from,
    required DateTime to,
    String? physiotherapistId,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/availability',
      queryParameters: <String, dynamic>{
        'from': _isoDate(from),
        'to': _isoDate(to),
        'physiotherapist_id': ?physiotherapistId,
      },
    );
    return SlotListResponse.fromJson(res.data!);
  }

  static String _isoDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}

final appointmentsApiProvider = Provider<AppointmentsApi>(
  (ref) => AppointmentsApi(ref.watch(dioProvider)),
);
