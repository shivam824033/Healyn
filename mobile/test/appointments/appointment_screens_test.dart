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
import 'package:healyn/features/patients/data/models/patient_models.dart';
import 'package:healyn/features/patients/presentation/patients_providers.dart';

/// Records a booking but never completes it, so the submit-guard test can assert
/// the call was *not* made without the screen navigating away.
class _RecordingApptRepo extends AppointmentsRepository {
  _RecordingApptRepo() : super(AppointmentsApi(Dio()));

  bool bookCalled = false;

  @override
  Future<Appointment> book(
    BookAppointmentRequest body, {
    required String idempotencyKey,
  }) {
    bookCalled = true;
    return Completer<Appointment>().future;
  }
}

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
    testWidgets('offers Cancel for a requested appointment', (tester) async {
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

      expect(find.text('Cancel appointment'), findsOneWidget);
    });

    testWidgets('hides Cancel for a completed appointment', (tester) async {
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

      expect(find.text('Cancel appointment'), findsNothing);
    });
  });
}
