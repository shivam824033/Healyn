import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';
import 'package:healyn/features/appointments/presentation/appointment_format.dart';
import 'package:healyn/features/patients/data/models/patient_models.dart';
import 'package:healyn/features/patients/presentation/patients_providers.dart';
import 'package:healyn/features/physio/presentation/physio_calendar_providers.dart';
import 'package:healyn/features/physio/presentation/physio_requests_providers.dart';
import 'package:healyn/features/physio/presentation/physio_schedule_providers.dart';
import 'package:healyn/features/physio/presentation/screens/physio_today_screen.dart';
import 'package:healyn/features/physio/presentation/widgets/month_calendar.dart';

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
  // A tall surface so the calendar + roster both fit and the lazy roster list
  // builds its tiles / empty state (default is 800x600).
  tester.view.physicalSize = const Size(1000, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        physioScheduleProvider.overrideWith((ref) async => appointments),
        physioRequestsProvider.overrideWith((ref) async => const []),
        calendarMarkedDaysProvider.overrideWith((ref) async => <DateTime>{}),
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

  testWidgets('picking a day in the calendar moves the roster header', (
    tester,
  ) async {
    // The schedule list is pinned empty; the header reads scheduleDayProvider,
    // which a calendar tap mutates — so only the date label changes.
    await _pump(tester, appointments: const []);
    await tester.pumpAndSettle();

    final today = DateTime.now();
    final todayMidnight = DateTime(today.year, today.month, today.day);
    expect(find.text(formatDateLong(todayMidnight)), findsOneWidget);

    // The month grid lives in a sheet reached from the "Appointments" stat
    // card (its calendar icon is unique on the screen); open it, then pick a day.
    await tester.tap(find.byIcon(Icons.calendar_month_outlined));
    await tester.pumpAndSettle();

    // The 15th (or 16th, to avoid landing on today) is always present in the
    // visible month; scope to the grid so the week strip's numbers don't collide.
    final targetDay = today.day == 15 ? 16 : 15;
    await tester.tap(
      find.descendant(
        of: find.byType(MonthCalendar),
        matching: find.text('$targetDay'),
      ),
    );
    await tester.pumpAndSettle();

    final picked = DateTime(today.year, today.month, targetDay);
    expect(find.text(formatDateLong(picked)), findsOneWidget);
  });

  testWidgets('the month arrows page the grid without moving the selected day', (
    tester,
  ) async {
    await _pump(tester, appointments: const []);
    await tester.pumpAndSettle();

    // The month grid + its arrows live in a sheet reached from the
    // "Appointments" stat card.
    await tester.tap(find.byIcon(Icons.calendar_month_outlined));
    await tester.pumpAndSettle();

    final today = DateTime.now();
    final month = DateTime(today.year, today.month);
    expect(find.text(formatMonthYear(month)), findsOneWidget);

    await tester.tap(find.byTooltip('Next month'));
    await tester.pumpAndSettle();

    final next = DateTime(today.year, today.month + 1);
    expect(find.text(formatMonthYear(next)), findsOneWidget);
    // The selected day (the hero's date pill, behind the sheet) stays on today.
    final todayMidnight = DateTime(today.year, today.month, today.day);
    expect(find.text(formatDateLong(todayMidnight)), findsOneWidget);
  });
}
