import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/network/api_exception.dart';
import 'appointments_api.dart';
import 'models/appointment_models.dart';

/// The booking flow's data access. Maps transport errors to [ApiException]; the
/// UI talks only to this class, never to Dio directly.
class AppointmentsRepository {
  AppointmentsRepository(this._api);

  final AppointmentsApi _api;

  Future<AppointmentPage> list({
    String? patientId,
    String? statusCsv,
    DateTime? from,
    DateTime? to,
    String? cursor,
    int? limit,
  }) async {
    return _guard(
      () => _api.list(
        patientId: patientId,
        statusCsv: statusCsv,
        from: from,
        to: to,
        cursor: cursor,
        limit: limit,
      ),
    );
  }

  Future<Appointment> get(String id) async {
    return _guard(() => _api.get(id));
  }

  /// The next live scheduled appointments from now, ascending (capped server
  /// side). Backs the physiotherapist's Upcoming dashboard.
  Future<List<Appointment>> upcoming({int? limit}) async {
    return _guard(() => _api.upcoming(limit: limit));
  }

  /// Every scheduled appointment with a time in [from]..[to], ascending — the
  /// month calendar's marker source.
  Future<List<Appointment>> calendar({
    required DateTime from,
    required DateTime to,
  }) async {
    return _guard(() => _api.calendar(from: from, to: to));
  }

  Future<Appointment> book(
    BookAppointmentRequest body, {
    required String idempotencyKey,
  }) async {
    return _guard(() => _api.book(body, idempotencyKey: idempotencyKey));
  }

  /// Moves [id] to a new time, returning the new appointment the backend
  /// creates (the original becomes RESCHEDULED).
  Future<Appointment> reschedule(
    String id,
    RescheduleAppointmentRequest body,
  ) async {
    return _guard(() => _api.reschedule(id, body));
  }

  /// Physiotherapist assigns the final time to a REQUESTED [id], confirming it.
  Future<Appointment> schedule(
    String id,
    ScheduleAppointmentRequest body,
  ) async {
    return _guard(() => _api.schedule(id, body));
  }

  /// Physiotherapist books a follow-up review, returning the new appointment.
  Future<Appointment> createFollowUp(FollowUpRequest body) async {
    return _guard(() => _api.createFollowUp(body));
  }

  /// Physiotherapist reschedules [id] to a new assigned time, returning the new
  /// appointment the backend creates (the original becomes RESCHEDULED).
  Future<Appointment> rescheduleByPhysio(
    String id,
    PhysioRescheduleRequest body,
  ) async {
    return _guard(() => _api.rescheduleByPhysio(id, body));
  }

  /// Drives a status transition. The physiotherapist confirms / starts /
  /// completes / marks no-show and may cancel; [reason] and [note] are only
  /// meaningful when [to] is [AppointmentStatus.cancelled] (the backend requires
  /// a reason then, and a note when the physio cancels). Returns the updated
  /// appointment.
  Future<Appointment> transition(
    String id, {
    required AppointmentStatus to,
    AppointmentCancelReason? reason,
    String? note,
  }) async {
    return _guard(
      () => _api.transition(
        id,
        TransitionRequest(to: to, cancelReason: reason, cancelNote: note),
      ),
    );
  }

  /// Patient-side cancel: shorthand for [transition] to cancelled with the
  /// patient reason.
  Future<Appointment> cancel(String id, {String? note}) async {
    return transition(
      id,
      to: AppointmentStatus.cancelled,
      reason: AppointmentCancelReason.patientCancelled,
      note: note,
    );
  }

  Future<List<Slot>> slotsFor(DateTime day) async {
    return _guard(() async => (await _api.slots(from: day, to: day)).slots);
  }

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final appointmentsRepositoryProvider = Provider<AppointmentsRepository>(
  (ref) => AppointmentsRepository(ref.watch(appointmentsApiProvider)),
);
