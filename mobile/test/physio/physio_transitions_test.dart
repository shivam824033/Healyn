import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/appointments_api.dart';
import 'package:healyn/features/appointments/data/appointments_repository.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';
import 'package:healyn/features/patients/data/models/patient_models.dart';
import 'package:healyn/features/patients/presentation/patients_providers.dart';
import 'package:healyn/features/physio/presentation/physio_appointment_actions.dart';
import 'package:healyn/features/physio/presentation/physio_schedule_providers.dart';
import 'package:healyn/features/physio/presentation/screens/physio_appointment_detail_screen.dart';
import 'package:healyn/features/treatment_notes/data/models/treatment_note_models.dart';
import 'package:healyn/features/treatment_notes/data/treatment_notes_api.dart';
import 'package:healyn/features/treatment_notes/data/treatment_notes_repository.dart';

class _Call {
  _Call({required this.id, required this.to, this.reason, this.note});
  final String id;
  final AppointmentStatus to;
  final AppointmentCancelReason? reason;
  final String? note;
}

/// Records transition calls and echoes the appointment with the new status, so
/// the screen can re-render its updated state without touching the network.
class _RecordingRepo extends AppointmentsRepository {
  _RecordingRepo(this._template) : super(AppointmentsApi(Dio()));

  final Appointment _template;
  final List<_Call> calls = [];

  @override
  Future<Appointment> transition(
    String id, {
    required AppointmentStatus to,
    AppointmentCancelReason? reason,
    String? note,
  }) async {
    calls.add(_Call(id: id, to: to, reason: reason, note: note));
    return _template.copyWith(status: to, cancelReason: reason, cancelNote: note);
  }
}

/// A COMPLETED appointment mounts the treatment-note section, which reads this
/// repo. Stub it so it resolves to "no note yet" instead of hitting the network.
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

Appointment _appt(AppointmentStatus status) => Appointment(
  id: 'ap1',
  patientId: 'pt1',
  bookedByAccountId: 'ac1',
  physiotherapistId: 'ph1',
  requestedDate: DateTime.now(),
  scheduledAt: DateTime.now().add(const Duration(hours: 2)),
  scheduledEndAt: DateTime.now().add(const Duration(hours: 2, minutes: 45)),
  durationMinutes: 45,
  status: status,
);

Future<_RecordingRepo> _pump(
  WidgetTester tester,
  Appointment appointment,
) async {
  // A tall surface so the full action stack is on-screen (default is 800x600).
  tester.view.physicalSize = const Size(1000, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final repo = _RecordingRepo(appointment);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appointmentsRepositoryProvider.overrideWithValue(repo),
        patientsProvider.overrideWith((ref) => [_asha]),
        physioScheduleProvider.overrideWith((ref) async => <Appointment>[]),
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
  group('physioActionsFor', () {
    test('mirrors the allowed-transition matrix', () {
      // Request-first: a REQUESTED appointment offers only Reject as a plain
      // transition — confirming it assigns a time (the assign-time sheet).
      expect(physioActionsFor(AppointmentStatus.requested), [
        PhysioAppointmentAction.reject,
      ]);
      expect(physioActionsFor(AppointmentStatus.confirmed), [
        PhysioAppointmentAction.start,
        PhysioAppointmentAction.noShow,
        PhysioAppointmentAction.cancel,
      ]);
      expect(physioActionsFor(AppointmentStatus.inProgress), [
        PhysioAppointmentAction.complete,
        PhysioAppointmentAction.cancel,
      ]);
      expect(physioActionsFor(AppointmentStatus.completed), isEmpty);
      expect(physioActionsFor(AppointmentStatus.cancelled), isEmpty);
    });

    test('cancel reason is OTHER mid-session, else PHYSIO_CANCELLED', () {
      expect(
        physioCancelReasonFor(AppointmentStatus.inProgress),
        AppointmentCancelReason.other,
      );
      expect(
        physioCancelReasonFor(AppointmentStatus.confirmed),
        AppointmentCancelReason.physioCancelled,
      );
      expect(
        physioCancelReasonFor(AppointmentStatus.requested),
        AppointmentCancelReason.physioCancelled,
      );
    });
  });

  group('physio appointment detail actions', () {
    testWidgets('a requested appointment offers Set time & confirm and Reject', (
      tester,
    ) async {
      await _pump(tester, _appt(AppointmentStatus.requested));

      expect(
        find.widgetWithText(ElevatedButton, 'Set time & confirm'),
        findsOneWidget,
      );
      expect(find.widgetWithText(OutlinedButton, 'Reject'), findsOneWidget);
      expect(find.text('Start session'), findsNothing);
    });

    testWidgets('a confirmed appointment offers Start, Reschedule, no-show and '
        'Cancel', (tester) async {
      await _pump(tester, _appt(AppointmentStatus.confirmed));

      expect(find.text('Start session'), findsOneWidget);
      expect(find.text('Reschedule'), findsOneWidget);
      expect(find.text('Mark no-show'), findsOneWidget);
      expect(find.text('Cancel appointment'), findsOneWidget);
      expect(find.text('Set time & confirm'), findsNothing);
    });

    testWidgets('an in-progress appointment offers Complete and Cancel', (
      tester,
    ) async {
      await _pump(tester, _appt(AppointmentStatus.inProgress));

      expect(find.text('Mark completed'), findsOneWidget);
      expect(find.text('Cancel appointment'), findsOneWidget);
      expect(find.text('Start session'), findsNothing);
    });

    testWidgets('a completed appointment offers no actions', (tester) async {
      await _pump(tester, _appt(AppointmentStatus.completed));

      expect(find.text('Confirm'), findsNothing);
      expect(find.text('Start session'), findsNothing);
      expect(find.text('Cancel appointment'), findsNothing);
    });

    testWidgets('rejecting a request needs a note and fires a REJECTED '
        'transition with no cancel reason', (tester) async {
      final repo = await _pump(tester, _appt(AppointmentStatus.requested));

      final reject = find.widgetWithText(OutlinedButton, 'Reject');
      await tester.ensureVisible(reject);
      await tester.tap(reject);
      await tester.pumpAndSettle();

      // The dialog's submit (a TextButton) is disabled while the note is empty.
      final submit = find.widgetWithText(TextButton, 'Reject');
      expect(tester.widget<TextButton>(submit).onPressed, isNull);
      expect(repo.calls, isEmpty);

      await tester.enterText(find.byType(TextField), 'No availability that week');
      await tester.pump();
      await tester.tap(submit);
      await tester.pumpAndSettle();

      expect(repo.calls, hasLength(1));
      // A rejection is its own terminal state, not a cancellation: no reason.
      expect(repo.calls.single.to, AppointmentStatus.rejected);
      expect(repo.calls.single.reason, isNull);
      expect(repo.calls.single.note, 'No availability that week');
      // Rejected is terminal: the scheduling action is gone.
      expect(find.text('Set time & confirm'), findsNothing);

      // Flush the success snackbar's auto-dismiss timer before teardown.
      await tester.pumpAndSettle(const Duration(seconds: 5));
    });

    testWidgets('cancel needs a note before it can be sent', (tester) async {
      final repo = await _pump(tester, _appt(AppointmentStatus.confirmed));

      final cancelButton = find.widgetWithText(
        OutlinedButton,
        'Cancel appointment',
      );
      await tester.ensureVisible(cancelButton);
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      // The dialog's submit (a TextButton) is disabled while the note is empty.
      final submit = find.widgetWithText(TextButton, 'Cancel appointment');
      expect(tester.widget<TextButton>(submit).onPressed, isNull);
      expect(repo.calls, isEmpty);

      await tester.enterText(find.byType(TextField), 'Clinic closed today');
      await tester.pump();
      expect(tester.widget<TextButton>(submit).onPressed, isNotNull);

      await tester.tap(submit);
      await tester.pumpAndSettle();

      expect(repo.calls, hasLength(1));
      expect(repo.calls.single.to, AppointmentStatus.cancelled);
      expect(repo.calls.single.reason, AppointmentCancelReason.physioCancelled);
      expect(repo.calls.single.note, 'Clinic closed today');

      // Flush the success snackbar's auto-dismiss timer before teardown.
      await tester.pumpAndSettle(const Duration(seconds: 5));
    });
  });
}
