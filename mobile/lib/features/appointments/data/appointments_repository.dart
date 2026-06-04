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

  Future<AppointmentPage> list({String? cursor, int? limit}) async {
    return _guard(() => _api.list(cursor: cursor, limit: limit));
  }

  Future<Appointment> get(String id) async {
    return _guard(() => _api.get(id));
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

  Future<Appointment> cancel(String id, {String? note}) async {
    return _guard(
      () => _api.transition(
        id,
        TransitionRequest(
          to: AppointmentStatus.cancelled,
          cancelReason: AppointmentCancelReason.patientCancelled,
          cancelNote: note,
        ),
      ),
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
