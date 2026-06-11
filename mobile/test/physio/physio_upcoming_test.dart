import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';
import 'package:healyn/features/appointments/presentation/appointment_format.dart';
import 'package:healyn/features/patients/data/models/patient_models.dart';
import 'package:healyn/features/patients/presentation/patients_providers.dart';
import 'package:healyn/features/physio/presentation/physio_upcoming_providers.dart';
import 'package:healyn/features/physio/presentation/screens/physio_upcoming_screen.dart';
import 'package:healyn/features/shared/network/api_exception.dart';

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
  bool isFollowUp = false,
}) => Appointment(
  id: id,
  patientId: patientId,
  bookedByAccountId: 'ac1',
  physiotherapistId: 'ph1',
  requestedDate: DateTime(scheduledAt.year, scheduledAt.month, scheduledAt.day),
  scheduledAt: scheduledAt,
  scheduledEndAt: scheduledAt.add(const Duration(minutes: 45)),
  durationMinutes: 45,
  status: status,
  isFollowUp: isFollowUp,
);

Future<void> _pump(
  WidgetTester tester, {
  required Future<List<Appointment>> Function() upcoming,
}) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        physioUpcomingProvider.overrideWith((ref) => upcoming()),
        patientsProvider.overrideWith((ref) => [_asha, _vikram]),
      ],
      child: const MaterialApp(home: PhysioUpcomingScreen()),
    ),
  );
}

void main() {
  testWidgets('lists upcoming appointments grouped by day, marking follow-ups', (
    tester,
  ) async {
    await _pump(
      tester,
      upcoming: () async => [
        _appt(
          id: 'a1',
          patientId: 'pt1',
          status: AppointmentStatus.confirmed,
          scheduledAt: DateTime(2026, 6, 10, 9),
        ),
        _appt(
          id: 'a2',
          patientId: 'pt2',
          status: AppointmentStatus.inProgress,
          scheduledAt: DateTime(2026, 6, 12, 14),
          isFollowUp: true,
        ),
      ],
    );
    await tester.pumpAndSettle();

    expect(find.text('Asha Rao'), findsOneWidget);
    expect(find.text('Vikram Singh'), findsOneWidget);
    // Each row leads with a tappable patient monogram (quick patient access).
    expect(find.text('AR'), findsOneWidget);
    expect(find.text('VS'), findsOneWidget);
    expect(find.text('Confirmed'), findsOneWidget);
    expect(find.text('In progress'), findsOneWidget);
    expect(find.text('Follow-up'), findsOneWidget);

    // One day header per distinct scheduled day.
    expect(
      find.text(formatDateLong(DateTime(2026, 6, 10)).toUpperCase()),
      findsOneWidget,
    );
    expect(
      find.text(formatDateLong(DateTime(2026, 6, 12)).toUpperCase()),
      findsOneWidget,
    );
  });

  testWidgets('shows an empty state when nothing is upcoming', (tester) async {
    await _pump(tester, upcoming: () async => const []);
    await tester.pumpAndSettle();

    expect(find.text('Nothing upcoming'), findsOneWidget);
  });

  testWidgets('shows an error banner when the load fails', (tester) async {
    await _pump(
      tester,
      upcoming: () async =>
          throw const ApiException(code: 'error', message: 'boom'),
    );
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Could not load upcoming appointments'),
      findsOneWidget,
    );
  });
}
