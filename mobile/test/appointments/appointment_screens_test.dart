import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/appointments_api.dart';
import 'package:healyn/features/appointments/data/appointments_repository.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';
import 'package:healyn/features/appointments/presentation/appointments_providers.dart';
import 'package:healyn/features/appointments/presentation/screens/appointment_detail_screen.dart';
import 'package:healyn/features/appointments/presentation/screens/appointments_screen.dart';
import 'package:healyn/features/appointments/presentation/screens/book_appointment_screen.dart';
import 'package:healyn/features/appointments/presentation/screens/reschedule_appointment_screen.dart';
import 'package:healyn/features/patients/data/models/patient_models.dart';
import 'package:healyn/features/patients/presentation/patients_providers.dart';
import 'package:healyn/features/treatment_notes/data/models/treatment_note_models.dart';
import 'package:healyn/features/treatment_notes/data/treatment_notes_api.dart';
import 'package:healyn/features/treatment_notes/data/treatment_notes_repository.dart';

/// Records book/reschedule calls but never completes them, so the submit-guard
/// tests can assert the call was *not* made without the screen navigating away.
/// [slots] feeds the slot picker without hitting the network.
class _RecordingApptRepo extends AppointmentsRepository {
  _RecordingApptRepo() : super(AppointmentsApi(Dio()));

  bool bookCalled = false;
  bool rescheduleCalled = false;
  List<Slot> slots = const [];

  @override
  Future<List<Slot>> slotsFor(DateTime day) async => slots;

  @override
  Future<Appointment> book(
    BookAppointmentRequest body, {
    required String idempotencyKey,
  }) {
    bookCalled = true;
    return Completer<Appointment>().future;
  }

  @override
  Future<Appointment> reschedule(String id, RescheduleAppointmentRequest body) {
    rescheduleCalled = true;
    return Completer<Appointment>().future;
  }
}

/// The detail screen loads a treatment note for COMPLETED appointments; this
/// resolves it to "none yet" so the section settles to its empty state offline.
class _FakeTreatmentNotesRepo extends TreatmentNotesRepository {
  _FakeTreatmentNotesRepo() : super(TreatmentNotesApi(Dio()));

  @override
  Future<TreatmentNote?> forAppointment(String appointmentId) async => null;
}

Slot _slot(DateTime startsAt, {int duration = 45}) => Slot(
  startsAt: startsAt,
  endsAt: startsAt.add(Duration(minutes: duration)),
  durationMinutes: duration,
);

final _asha = Patient(
  id: 'pt1',
  fullName: 'Asha Rao',
  dateOfBirth: DateTime(1990, 5, 21),
  relationship: PatientRelationship.self,
  primary: true,
);

Appointment _appt({
  required String id,
  required AppointmentStatus status,
  required DateTime scheduledAt,
  int duration = 45,
}) => Appointment(
  id: id,
  patientId: 'pt1',
  bookedByAccountId: 'ac1',
  physiotherapistId: 'ph1',
  scheduledAt: scheduledAt,
  scheduledEndAt: scheduledAt.add(Duration(minutes: duration)),
  durationMinutes: duration,
  status: status,
);

Future<void> _pump(
  WidgetTester tester,
  Widget home, {
  List<Appointment>? appointments,
  AppointmentsRepository? repo,
}) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        patientsProvider.overrideWith((ref) => [_asha]),
        if (appointments != null)
          appointmentsProvider.overrideWith((ref) => appointments),
        if (repo != null) appointmentsRepositoryProvider.overrideWithValue(repo),
        treatmentNotesRepositoryProvider.overrideWithValue(
          _FakeTreatmentNotesRepo(),
        ),
      ],
      child: MaterialApp(home: home),
    ),
  );
}

void main() {
  group('appointments list', () {
    testWidgets('groups upcoming and past with status chips', (tester) async {
      final now = DateTime.now();
      await _pump(
        tester,
        const AppointmentsScreen(),
        appointments: [
          _appt(
            id: 'up',
            status: AppointmentStatus.confirmed,
            scheduledAt: now.add(const Duration(days: 2)),
          ),
          _appt(
            id: 'past',
            status: AppointmentStatus.completed,
            scheduledAt: now.subtract(const Duration(days: 5)),
          ),
        ],
      );
      await tester.pumpAndSettle();

      // Section titles render as uppercased overlines.
      expect(find.text('UPCOMING'), findsOneWidget);
      expect(find.text('PAST'), findsOneWidget);
      expect(find.text('Confirmed'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
    });

    testWidgets('shows an empty state with a book action', (tester) async {
      await _pump(tester, const AppointmentsScreen(), appointments: []);
      await tester.pumpAndSettle();

      expect(find.text('No appointments yet'), findsOneWidget);
      expect(
        find.widgetWithText(OutlinedButton, 'Book appointment'),
        findsOneWidget,
      );
    });
  });

  group('book appointment', () {
    testWidgets('blocks submit until a date is chosen and does not book', (
      tester,
    ) async {
      final repo = _RecordingApptRepo();
      await _pump(tester, const BookAppointmentScreen(), repo: repo);
      await tester.pumpAndSettle();

      final submit = find.widgetWithText(ElevatedButton, 'Request appointment');
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pumpAndSettle();

      expect(find.text('Pick a date.'), findsOneWidget);
      expect(repo.bookCalled, isFalse);
    });
  });

  group('appointment detail', () {
    testWidgets('offers Reschedule and Cancel for a requested appointment', (
      tester,
    ) async {
      await _pump(
        tester,
        AppointmentDetailScreen(
          appointment: _appt(
            id: 'ap1',
            status: AppointmentStatus.requested,
            scheduledAt: DateTime.now().add(const Duration(days: 3)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Reschedule'), findsOneWidget);
      expect(find.text('Cancel appointment'), findsOneWidget);
    });

    testWidgets('hides Reschedule and Cancel for a completed appointment', (
      tester,
    ) async {
      await _pump(
        tester,
        AppointmentDetailScreen(
          appointment: _appt(
            id: 'ap2',
            status: AppointmentStatus.completed,
            scheduledAt: DateTime.now().subtract(const Duration(days: 3)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Reschedule'), findsNothing);
      expect(find.text('Cancel appointment'), findsNothing);
    });
  });

  group('reschedule appointment', () {
    testWidgets('blocks submit until a slot is chosen and does not reschedule', (
      tester,
    ) async {
      // The form prefills the current date and auto-loads that day's slots, so
      // the only thing missing is the new time selection.
      final repo = _RecordingApptRepo()
        ..slots = [_slot(DateTime.now().add(const Duration(days: 2, hours: 3)))];
      await _pump(
        tester,
        RescheduleAppointmentScreen(
          appointment: _appt(
            id: 'ap1',
            status: AppointmentStatus.confirmed,
            scheduledAt: DateTime.now().add(const Duration(days: 2)),
          ),
        ),
        repo: repo,
      );
      await tester.pumpAndSettle();

      final submit = find.widgetWithText(
        ElevatedButton,
        'Reschedule appointment',
      );
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pumpAndSettle();

      expect(find.text('Choose a time slot.'), findsOneWidget);
      expect(repo.rescheduleCalled, isFalse);
    });
  });
}
