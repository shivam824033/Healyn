import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';

void main() {
  Map<String, dynamic> appointmentJson({
    String status = 'CONFIRMED',
    String? cancelReason,
    bool scheduled = true,
  }) => <String, dynamic>{
    'id': 'ap1',
    'patient_id': 'pt1',
    'booked_by_account_id': 'ac1',
    'physiotherapist_id': 'ph1',
    'requested_date': '2026-06-10',
    if (scheduled) 'scheduled_at': '2026-06-10T09:00:00Z',
    if (scheduled) 'scheduled_end_at': '2026-06-10T09:45:00Z',
    'duration_minutes': 45,
    'status': status,
    'is_follow_up': false,
    'reason': 'Lower back pain',
    'cancel_reason': cancelReason,
    'created_at': '2026-06-01T10:00:00Z',
    'updated_at': '2026-06-01T10:00:00Z',
  };

  test('parses a scheduled appointment from snake_case JSON (instants are UTC)', () {
    final appt = Appointment.fromJson(appointmentJson());

    expect(appt.id, 'ap1');
    expect(appt.patientId, 'pt1');
    expect(appt.bookedByAccountId, 'ac1');
    expect(appt.status, AppointmentStatus.confirmed);
    expect(appt.durationMinutes, 45);
    expect(appt.reason, 'Lower back pain');
    expect(appt.cancelReason, isNull);
    expect(appt.isFollowUp, isFalse);
    expect(appt.isScheduled, isTrue);
    expect(appt.scheduledAt!.isUtc, isTrue);
    expect(appt.scheduledAt!.toUtc(), DateTime.utc(2026, 6, 10, 9));
    expect(appt.scheduledEndAt!.toUtc(), DateTime.utc(2026, 6, 10, 9, 45));
    // requested_date is a bare calendar day.
    expect(appt.requestedDate.year, 2026);
    expect(appt.requestedDate.month, 6);
    expect(appt.requestedDate.day, 10);
  });

  test('parses an unscheduled request — no time yet, an optional preferred hint', () {
    final json = appointmentJson(status: 'REQUESTED', scheduled: false)
      ..['preferred_time'] = '09:30:00';
    final appt = Appointment.fromJson(json);

    expect(appt.status, AppointmentStatus.requested);
    expect(appt.isScheduled, isFalse);
    expect(appt.scheduledAt, isNull);
    expect(appt.scheduledEndAt, isNull);
    expect(appt.preferredTime, '09:30:00');
    // `day` falls back to the requested date when there's no scheduled time.
    expect(appt.day, appt.requestedDate);
    // A request is active and the patient may cancel it.
    expect(appt.status.isActive, isTrue);
    expect(appt.status.isCancellableByPatient, isTrue);
  });

  test('maps cancel reason and closed-status flags', () {
    final appt = Appointment.fromJson(
      appointmentJson(status: 'CANCELLED', cancelReason: 'PATIENT_CANCELLED'),
    );

    expect(appt.status, AppointmentStatus.cancelled);
    expect(appt.cancelReason, AppointmentCancelReason.patientCancelled);
    expect(appt.status.isActive, isFalse);
    expect(appt.status.isCancellableByPatient, isFalse);
  });

  test('parses a rejected request — a terminal, inactive status', () {
    final appt = Appointment.fromJson(
      appointmentJson(status: 'REJECTED', scheduled: false),
    );

    expect(appt.status, AppointmentStatus.rejected);
    expect(appt.status.label, 'Rejected');
    // Rejected is terminal: not active, and the patient can do nothing with it.
    expect(appt.status.isActive, isFalse);
    expect(appt.status.isCancellableByPatient, isFalse);
    expect(appt.status.isReschedulableByPatient, isFalse);
  });

  test('is_follow_up defaults to false when absent, true when set', () {
    final without =
        Appointment.fromJson(appointmentJson()..remove('is_follow_up'));
    expect(without.isFollowUp, isFalse);

    final follow =
        Appointment.fromJson(appointmentJson()..['is_follow_up'] = true);
    expect(follow.isFollowUp, isTrue);
  });

  test('AppointmentPage carries items and an optional next cursor', () {
    final page = AppointmentPage.fromJson(<String, dynamic>{
      'items': [appointmentJson()],
      'next_cursor': 'CURSOR',
    });
    expect(page.items, hasLength(1));
    expect(page.nextCursor, 'CURSOR');

    final last = AppointmentPage.fromJson(<String, dynamic>{
      'items': <dynamic>[],
      'next_cursor': null,
    });
    expect(last.items, isEmpty);
    expect(last.nextCursor, isNull);
  });

  test('BookAppointmentRequest serializes a request to snake_case', () {
    final json = BookAppointmentRequest(
      patientId: 'pt1',
      requestedDate: DateTime(2026, 6, 10),
      preferredTime: '09:30:00',
      reason: 'Follow-up',
    ).toJson();

    expect(json['patient_id'], 'pt1');
    expect(json['requested_date'], '2026-06-10');
    expect(json['preferred_time'], '09:30:00');
    expect(json['reason'], 'Follow-up');
    // The patient never sends a final time — the physiotherapist assigns it.
    expect(json.containsKey('scheduled_at'), isFalse);
    expect(json.containsKey('duration_minutes'), isFalse);
  });

  test('BookAppointmentRequest omits a null preferred time and reason', () {
    final json = BookAppointmentRequest(
      patientId: 'pt1',
      requestedDate: DateTime(2026, 6, 10),
    ).toJson();
    // include_if_null:false — unset optionals are absent, not null.
    expect(json.containsKey('preferred_time'), isFalse);
    expect(json.containsKey('reason'), isFalse);
  });

  test('ScheduleAppointmentRequest serializes a UTC instant + duration', () {
    final json = ScheduleAppointmentRequest(
      scheduledAt: DateTime.utc(2026, 6, 10, 9),
      durationMinutes: 45,
    ).toJson();

    expect(DateTime.parse(json['scheduled_at'] as String).toUtc(),
        DateTime.utc(2026, 6, 10, 9));
    expect(json['scheduled_at'], endsWith('Z')); // unambiguous UTC on the wire
    expect(json['duration_minutes'], 45);
  });

  test('ScheduleAppointmentRequest converts a local instant to UTC', () {
    final local = DateTime(2026, 6, 10, 9); // local wall time
    final json = ScheduleAppointmentRequest(
      scheduledAt: local,
      durationMinutes: 30,
    ).toJson();

    expect(DateTime.parse(json['scheduled_at'] as String), local.toUtc());
  });

  test('FollowUpRequest serializes patient, time, duration and reason', () {
    final json = FollowUpRequest(
      patientId: 'pt1',
      scheduledAt: DateTime.utc(2026, 6, 17, 14, 30),
      durationMinutes: 60,
      reason: 'Progress review',
    ).toJson();

    expect(json['patient_id'], 'pt1');
    expect(DateTime.parse(json['scheduled_at'] as String).toUtc(),
        DateTime.utc(2026, 6, 17, 14, 30));
    expect(json['duration_minutes'], 60);
    expect(json['reason'], 'Progress review');
  });

  test('FollowUpRequest omits a null reason', () {
    final json = FollowUpRequest(
      patientId: 'pt1',
      scheduledAt: DateTime.utc(2026, 6, 17, 14, 30),
      durationMinutes: 60,
    ).toJson();
    expect(json.containsKey('reason'), isFalse);
  });

  test('PhysioRescheduleRequest serializes an assigned time, not a re-request',
      () {
    final json = PhysioRescheduleRequest(
      scheduledAt: DateTime.utc(2026, 6, 12, 11),
      durationMinutes: 45,
    ).toJson();

    expect(DateTime.parse(json['scheduled_at'] as String).toUtc(),
        DateTime.utc(2026, 6, 12, 11));
    expect(json['duration_minutes'], 45);
    // The physio assigns a final time — no requested_date / preferred_time.
    expect(json.containsKey('requested_date'), isFalse);
    expect(json.containsKey('preferred_time'), isFalse);
    expect(json.containsKey('reason'), isFalse);
  });

  test('TransitionRequest serializes a patient cancellation', () {
    final json = const TransitionRequest(
      to: AppointmentStatus.cancelled,
      cancelReason: AppointmentCancelReason.patientCancelled,
    ).toJson();

    expect(json['to'], 'CANCELLED');
    expect(json['cancel_reason'], 'PATIENT_CANCELLED');
    expect(json.containsKey('cancel_note'), isFalse);
  });

  test('RescheduleAppointmentRequest serializes a re-request; no final time or '
      'patient is sent', () {
    final json = RescheduleAppointmentRequest(
      requestedDate: DateTime(2026, 6, 12),
      preferredTime: '14:30:00',
      reason: 'Need an earlier day',
    ).toJson();

    expect(json['requested_date'], '2026-06-12');
    expect(json['preferred_time'], '14:30:00');
    expect(json['reason'], 'Need an earlier day');
    // The patient never self-assigns a time; the backend keeps patient + physio.
    expect(json.containsKey('scheduled_at'), isFalse);
    expect(json.containsKey('duration_minutes'), isFalse);
    expect(json.containsKey('patient_id'), isFalse);
  });

  test('RescheduleAppointmentRequest omits a null reason (keeps the original)', () {
    final json = RescheduleAppointmentRequest(
      requestedDate: DateTime(2026, 6, 12),
    ).toJson();
    expect(json.containsKey('reason'), isFalse);
    expect(json.containsKey('preferred_time'), isFalse);
  });

  test('isReschedulableByPatient is true only for open, pre-start statuses', () {
    expect(AppointmentStatus.requested.isReschedulableByPatient, isTrue);
    expect(AppointmentStatus.confirmed.isReschedulableByPatient, isTrue);
    expect(AppointmentStatus.inProgress.isReschedulableByPatient, isFalse);
    expect(AppointmentStatus.completed.isReschedulableByPatient, isFalse);
    expect(AppointmentStatus.cancelled.isReschedulableByPatient, isFalse);
    expect(AppointmentStatus.noShow.isReschedulableByPatient, isFalse);
    expect(AppointmentStatus.rescheduled.isReschedulableByPatient, isFalse);
  });

  test('SlotListResponse parses slots with UTC instants', () {
    final res = SlotListResponse.fromJson(<String, dynamic>{
      'physiotherapist_id': 'ph1',
      'slots': [
        {
          'starts_at': '2026-06-10T09:00:00Z',
          'ends_at': '2026-06-10T09:45:00Z',
          'duration_minutes': 45,
        },
      ],
    });

    expect(res.physiotherapistId, 'ph1');
    expect(res.slots, hasLength(1));
    expect(res.slots.first.durationMinutes, 45);
    expect(res.slots.first.startsAt.toUtc(), DateTime.utc(2026, 6, 10, 9));
  });
}
