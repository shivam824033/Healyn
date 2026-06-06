import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/appointments_api.dart';
import 'package:healyn/features/appointments/data/appointments_repository.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';
import 'package:healyn/features/patients/data/models/patient_models.dart';
import 'package:healyn/features/patients/presentation/patients_providers.dart';
import 'package:healyn/features/physio/presentation/physio_requests_providers.dart';
import 'package:healyn/features/physio/presentation/physio_schedule_providers.dart';
import 'package:healyn/features/physio/presentation/screens/physio_appointment_detail_screen.dart';
import 'package:healyn/features/treatment_notes/data/models/treatment_note_models.dart';
import 'package:healyn/features/treatment_notes/data/treatment_notes_api.dart';
import 'package:healyn/features/treatment_notes/data/treatment_notes_repository.dart';

/// Records the request-first scheduling calls (assign time / reschedule /
/// follow-up) and echoes a plausible result, so the detail screen can re-render
/// without touching the network.
class _SchedulingRepo extends AppointmentsRepository {
  _SchedulingRepo(this._template) : super(AppointmentsApi(Dio()));

  final Appointment _template;

  String? scheduledId;
  final List<ScheduleAppointmentRequest> scheduleCalls = [];
  String? rescheduledId;
  final List<PhysioRescheduleRequest> rescheduleCalls = [];
  final List<FollowUpRequest> followUpCalls = [];

  @override
  Future<Appointment> schedule(
    String id,
    ScheduleAppointmentRequest body,
  ) async {
    scheduledId = id;
    scheduleCalls.add(body);
    return _template.copyWith(
      status: AppointmentStatus.confirmed,
      scheduledAt: body.scheduledAt,
      scheduledEndAt: body.scheduledAt.add(
        Duration(minutes: body.durationMinutes),
      ),
      durationMinutes: body.durationMinutes,
    );
  }

  @override
  Future<Appointment> rescheduleByPhysio(
    String id,
    PhysioRescheduleRequest body,
  ) async {
    rescheduledId = id;
    rescheduleCalls.add(body);
    return _template.copyWith(
      id: 'new-ap',
      status: AppointmentStatus.confirmed,
      scheduledAt: body.scheduledAt,
      scheduledEndAt: body.scheduledAt.add(
        Duration(minutes: body.durationMinutes),
      ),
      durationMinutes: body.durationMinutes,
    );
  }

  @override
  Future<Appointment> createFollowUp(FollowUpRequest body) async {
    followUpCalls.add(body);
    return _template.copyWith(
      id: 'follow-ap',
      status: AppointmentStatus.confirmed,
      isFollowUp: true,
      scheduledAt: body.scheduledAt,
      scheduledEndAt: body.scheduledAt.add(
        Duration(minutes: body.durationMinutes),
      ),
      durationMinutes: body.durationMinutes,
    );
  }
}

/// A COMPLETED appointment mounts the treatment-note section; stub it to resolve
/// to "no note yet" rather than hitting the network.
class _StubNotesRepo extends TreatmentNotesRepository {
  _StubNotesRepo() : super(TreatmentNotesApi(Dio()));

  @override
  Future<TreatmentNote?> forAppointment(String appointmentId) async => null;
}

final _asha = Patient(
  id: 'pt1',
  fullName: 'Asha Rao',
  dateOfBirth: DateTime(1990, 5, 21),
  relationship: PatientRelationship.self,
  primary: true,
);

Appointment _appt(AppointmentStatus status, {bool scheduled = true}) =>
    Appointment(
      id: 'ap1',
      patientId: 'pt1',
      bookedByAccountId: 'ac1',
      physiotherapistId: 'ph1',
      requestedDate: DateTime(2026, 6, 10),
      preferredTime: scheduled ? null : '09:30:00',
      scheduledAt: scheduled ? DateTime(2026, 6, 10, 9) : null,
      scheduledEndAt: scheduled ? DateTime(2026, 6, 10, 9, 45) : null,
      durationMinutes: 45,
      status: status,
    );

Future<_SchedulingRepo> _pump(
  WidgetTester tester,
  Appointment appointment,
) async {
  // A tall surface so the full action stack + sheet fit (default is 800x600).
  tester.view.physicalSize = const Size(1000, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final repo = _SchedulingRepo(appointment);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appointmentsRepositoryProvider.overrideWithValue(repo),
        patientsProvider.overrideWith((ref) => [_asha]),
        physioScheduleProvider.overrideWith((ref) async => <Appointment>[]),
        physioRequestsProvider.overrideWith((ref) async => <Appointment>[]),
        treatmentNotesRepositoryProvider.overrideWithValue(_StubNotesRepo()),
      ],
      child: MaterialApp(
        home: PhysioAppointmentDetailScreen(appointment: appointment),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return repo;
}

void main() {
  testWidgets('confirming a request assigns a time and moves it to confirmed', (
    tester,
  ) async {
    final repo = await _pump(
      tester,
      _appt(AppointmentStatus.requested, scheduled: false),
    );

    await tester.tap(
      find.widgetWithText(ElevatedButton, 'Set time & confirm'),
    );
    await tester.pumpAndSettle();

    // The assign-time sheet opens prefilled; confirm straight away.
    await tester.tap(find.widgetWithText(ElevatedButton, 'Confirm appointment'));
    await tester.pumpAndSettle();

    expect(repo.scheduleCalls, hasLength(1));
    expect(repo.scheduledId, 'ap1');
    expect(repo.scheduleCalls.single.durationMinutes, greaterThan(0));
    // Re-rendered into the confirmed state.
    expect(find.text('Start session'), findsOneWidget);
    expect(find.text('Set time & confirm'), findsNothing);

    await tester.pumpAndSettle(const Duration(seconds: 5));
  });

  testWidgets('rescheduling a confirmed appointment assigns a new time', (
    tester,
  ) async {
    final repo = await _pump(tester, _appt(AppointmentStatus.confirmed));

    final reschedule = find.widgetWithText(OutlinedButton, 'Reschedule');
    await tester.ensureVisible(reschedule);
    await tester.tap(reschedule);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Confirm new time'));
    await tester.pumpAndSettle();

    expect(repo.rescheduleCalls, hasLength(1));
    expect(repo.rescheduledId, 'ap1');
    expect(repo.rescheduleCalls.single.durationMinutes, 45);

    await tester.pumpAndSettle(const Duration(seconds: 5));
  });

  testWidgets('a completed appointment can schedule a follow-up review', (
    tester,
  ) async {
    final repo = await _pump(tester, _appt(AppointmentStatus.completed));

    final followUp = find.widgetWithText(ElevatedButton, 'Schedule follow-up');
    await tester.ensureVisible(followUp);
    await tester.tap(followUp);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Confirm follow-up'));
    await tester.pumpAndSettle();

    expect(repo.followUpCalls, hasLength(1));
    expect(repo.followUpCalls.single.patientId, 'pt1');

    await tester.pumpAndSettle(const Duration(seconds: 5));
  });
}
