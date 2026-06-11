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

  /// The next live scheduled appointments from now (CONFIRMED / IN_PROGRESS),
  /// ascending. The backend caps [limit] (default 30, ≤ 50) and returns a
  /// cursorless `{items}` window — unscheduled REQUESTED rows never appear.
  Future<List<Appointment>> upcoming({int? limit}) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/appointments/upcoming',
      queryParameters: <String, dynamic>{'limit': ?limit},
    );
    return _items(res.data!);
  }

  /// Every scheduled appointment whose time falls in [from]..[to] (sent as UTC
  /// instants — the caller computes the month grid's edges in local time),
  /// ascending, including past COMPLETED / NO_SHOW so a month grid shows
  /// history. Cursorless `{items}`; the backend caps the window at 62 days.
  Future<List<Appointment>> calendar({
    required DateTime from,
    required DateTime to,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/appointments/calendar',
      queryParameters: <String, dynamic>{
        'from': from.toUtc().toIso8601String(),
        'to': to.toUtc().toIso8601String(),
      },
    );
    return _items(res.data!);
  }

  /// The unified lineage timeline of appointment [id]: every lifecycle event
  /// of every appointment sharing its root, oldest first. Cursorless `{items}`
  /// (a lineage is a handful of appointments, each with a bounded event count).
  Future<List<TimelineEvent>> timeline(String id) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/appointments/$id/timeline',
    );
    return ((res.data!['items'] as List<dynamic>?) ?? const <dynamic>[])
        .map((e) => TimelineEvent.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Reads the cursorless `{items: [...]}` body shared by `/upcoming` and
  /// `/calendar` (the backend `AppointmentList`) into typed appointments.
  static List<Appointment> _items(Map<String, dynamic> data) =>
      ((data['items'] as List<dynamic>?) ?? const <dynamic>[])
          .map((e) => Appointment.fromJson(e as Map<String, dynamic>))
          .toList();

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

  /// Physiotherapist assigns the final time to a REQUESTED appointment, moving
  /// it to CONFIRMED. Returns the now-scheduled appointment (same id).
  Future<Appointment> schedule(
    String id,
    ScheduleAppointmentRequest body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/appointments/$id/schedule',
      data: body.toJson(),
    );
    return Appointment.fromJson(res.data!);
  }

  /// Physiotherapist books a follow-up review at a time they set. Returns the
  /// new (CONFIRMED, follow-up) appointment (HTTP 201).
  Future<Appointment> createFollowUp(FollowUpRequest body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/appointments/follow-ups',
      data: body.toJson(),
    );
    return Appointment.fromJson(res.data!);
  }

  /// Physiotherapist reschedules an appointment to a new final time. Shares the
  /// `/reschedule` endpoint with the patient re-request, but sends an assigned
  /// time (the body shape the backend resolves by the caller's role). Returns
  /// the new appointment (HTTP 201).
  Future<Appointment> rescheduleByPhysio(
    String id,
    PhysioRescheduleRequest body,
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
