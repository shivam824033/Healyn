import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';
import 'package:healyn/features/appointments/presentation/appointment_format.dart';
import 'package:healyn/features/patients/data/models/patient_models.dart';
import 'package:healyn/features/patients/presentation/patients_providers.dart';
import 'package:healyn/features/physio/presentation/physio_requests_providers.dart';
import 'package:healyn/features/physio/presentation/physio_schedule_providers.dart';
import 'package:healyn/features/physio/presentation/screens/physio_today_screen.dart';

final _asha = Patient(
  id: 'pt1',
  fullName: 'Asha Rao',
  dateOfBirth: DateTime(1990, 5, 21),
  relationship: PatientRelationship.self,
  primary: true,
);
final _vikram = Patient(
  id: 'pt2',
  fullName: 'Vikram Singh',
  dateOfBirth: DateTime(1985, 2, 3),
  relationship: PatientRelationship.other,
);

Appointment _appt({
  required String id,
  required String patientId,
  required AppointmentStatus status,
  required DateTime scheduledAt,
  int duration = 45,
}) => Appointment(
  id: id,
  patientId: patientId,
  bookedByAccountId: 'ac1',
  physiotherapistId: 'ph1',
  requestedDate: DateTime(scheduledAt.year, scheduledAt.month, scheduledAt.day),
  scheduledAt: scheduledAt,
  scheduledEndAt: scheduledAt.add(Duration(minutes: duration)),
  durationMinutes: duration,
  status: status,
);

Future<void> _pump(
  WidgetTester tester, {
  required List<Appointment> appointments,
  List<Patient> patients = const [],
}) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        physioScheduleProvider.overrideWith((ref) async => appointments),
        physioRequestsProvider.overrideWith((ref) async => const []),
        patientsProvider.overrideWith((ref) => patients),
      ],
      child: const MaterialApp(home: PhysioTodayScreen()),
    ),
  );
}

void main() {
  testWidgets('lists the day\'s appointments with patient name and status', (
    tester,
  ) async {
    await _pump(
      tester,
      appointments: [
        _appt(
          id: 'a1',
          patientId: 'pt1',
          status: AppointmentStatus.confirmed,
          scheduledAt: DateTime(2026, 6, 4, 9, 0),
        ),
        _appt(
          id: 'a2',
          patientId: 'pt2',
          status: AppointmentStatus.requested,
          scheduledAt: DateTime(2026, 6, 4, 11, 0),
        ),
      ],
      patients: [_asha, _vikram],
    );
    await tester.pumpAndSettle();

    expect(find.text('Asha Rao'), findsOneWidget);
    expect(find.text('Vikram Singh'), findsOneWidget);
    expect(find.text('Confirmed'), findsOneWidget);
    expect(find.text('Requested'), findsOneWidget);
  });

  testWidgets('shows an empty state when the day has no appointments', (
    tester,
  ) async {
    await _pump(tester, appointments: const []);
    await tester.pumpAndSettle();

    expect(find.text('Nothing scheduled'), findsOneWidget);
  });

  testWidgets('day stepper moves the displayed day', (tester) async {
    // The schedule list is pinned empty; the header reads scheduleDayProvider
    // directly, which the stepper mutates — so only the date label changes.
    await _pump(tester, appointments: const []);
    await tester.pumpAndSettle();

    final today = DateTime.now();
    final todayMidnight = DateTime(today.year, today.month, today.day);
    expect(find.text(formatDateLong(todayMidnight)), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);

    await tester.tap(find.byTooltip('Next day'));
    await tester.pumpAndSettle();

    final tomorrow = DateTime(today.year, today.month, today.day + 1);
    expect(find.text(formatDateLong(tomorrow)), findsOneWidget);
    expect(find.text('Jump to today'), findsOneWidget);
  });
}
