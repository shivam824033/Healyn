import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';

void main() {
  Map<String, dynamic> appointmentJson({
    String status = 'REQUESTED',
    String? cancelReason,
  }) => <String, dynamic>{
    'id': 'ap1',
    'patient_id': 'pt1',
    'booked_by_account_id': 'ac1',
    'physiotherapist_id': 'ph1',
    'scheduled_at': '2026-06-10T09:00:00Z',
    'scheduled_end_at': '2026-06-10T09:45:00Z',
    'duration_minutes': 45,
    'status': status,
    'reason': 'Lower back pain',
    'cancel_reason': cancelReason,
    'created_at': '2026-06-01T10:00:00Z',
    'updated_at': '2026-06-01T10:00:00Z',
  };

  test('parses an appointment from snake_case JSON (instants are UTC)', () {
    final appt = Appointment.fromJson(appointmentJson());

    expect(appt.id, 'ap1');
    expect(appt.patientId, 'pt1');
    expect(appt.bookedByAccountId, 'ac1');
    expect(appt.status, AppointmentStatus.requested);
    expect(appt.durationMinutes, 45);
    expect(appt.reason, 'Lower back pain');
    expect(appt.cancelReason, isNull);
    expect(appt.scheduledAt.isUtc, isTrue);
    expect(appt.scheduledAt.toUtc(), DateTime.utc(2026, 6, 10, 9));
    expect(appt.scheduledEndAt.toUtc(), DateTime.utc(2026, 6, 10, 9, 45));
    // A requested appointment is active and the patient may cancel it.
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

  test('BookAppointmentRequest serializes to snake_case; UTC instant round-trips', () {
    final json = BookAppointmentRequest(
      patientId: 'pt1',
      scheduledAt: DateTime.utc(2026, 6, 10, 9),
      durationMinutes: 45,
      reason: 'Follow-up',
    ).toJson();

    expect(json['patient_id'], 'pt1');
    expect(json['duration_minutes'], 45);
    expect(json['reason'], 'Follow-up');
    // The exact instant the backend matches against a slot's starts_at.
    expect(json['scheduled_at'], '2026-06-10T09:00:00.000Z');
  });

  test('BookAppointmentRequest omits a null reason', () {
    final json = BookAppointmentRequest(
      patientId: 'pt1',
      scheduledAt: DateTime.utc(2026, 6, 10, 9),
      durationMinutes: 30,
    ).toJson();
    // include_if_null:false — an unset reason is absent, not null.
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
