import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';
import 'package:healyn/features/appointments/presentation/appointment_format.dart';
import 'package:healyn/features/patients/data/models/patient_models.dart';
import 'package:healyn/features/patients/presentation/patients_providers.dart';
import 'package:healyn/features/physio/presentation/physio_requests_providers.dart';
import 'package:healyn/features/physio/presentation/physio_schedule_providers.dart';
import 'package:healyn/features/physio/presentation/screens/physio_requests_screen.dart';
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

Appointment _req({
  required String id,
  required String patientId,
  required DateTime scheduledAt,
}) => Appointment(
  id: id,
  patientId: patientId,
  bookedByAccountId: 'ac1',
  physiotherapistId: 'ph1',
  scheduledAt: scheduledAt,
  scheduledEndAt: scheduledAt.add(const Duration(minutes: 45)),
  durationMinutes: 45,
  status: AppointmentStatus.requested,
);

void main() {
  group('PhysioRequestsScreen', () {
    Future<void> pump(
      WidgetTester tester, {
      required List<Appointment> requests,
      List<Patient> patients = const [],
    }) {
      return tester.pumpWidget(
        ProviderScope(
          overrides: [
            physioRequestsProvider.overrideWith((ref) async => requests),
            patientsProvider.overrideWith((ref) => patients),
          ],
          child: const MaterialApp(home: PhysioRequestsScreen()),
        ),
      );
    }

    testWidgets('lists requests by day with patient name and status', (
      tester,
    ) async {
      final day = DateTime(2026, 6, 10, 9, 0);
      await pump(
        tester,
        requests: [
          _req(id: 'r1', patientId: 'pt1', scheduledAt: day),
          _req(
            id: 'r2',
            patientId: 'pt2',
            scheduledAt: day.add(const Duration(hours: 2)),
          ),
        ],
        patients: [_asha, _vikram],
      );
      await tester.pumpAndSettle();

      // One day header for both same-day requests.
      expect(find.text(formatDateLong(day).toUpperCase()), findsOneWidget);
      // The patient name shares a caption with the duration (`Name · 45 min`).
      expect(find.textContaining('Asha Rao'), findsOneWidget);
      expect(find.textContaining('Vikram Singh'), findsOneWidget);
      expect(find.text('Requested'), findsNWidgets(2));
    });

    testWidgets('shows the empty state when nothing is pending', (tester) async {
      await pump(tester, requests: const []);
      await tester.pumpAndSettle();

      expect(find.text('No new requests'), findsOneWidget);
    });
  });

  group('Today requests banner', () {
    Future<void> pump(
      WidgetTester tester, {
      required List<Appointment> requests,
    }) {
      return tester.pumpWidget(
        ProviderScope(
          overrides: [
            physioScheduleProvider.overrideWith((ref) async => const []),
            physioRequestsProvider.overrideWith((ref) async => requests),
            patientsProvider.overrideWith((ref) => [_asha]),
          ],
          child: const MaterialApp(home: PhysioTodayScreen()),
        ),
      );
    }

    testWidgets('surfaces a count when requests are pending', (tester) async {
      await pump(
        tester,
        requests: [
          _req(id: 'r1', patientId: 'pt1', scheduledAt: DateTime(2026, 6, 10, 9)),
          _req(id: 'r2', patientId: 'pt1', scheduledAt: DateTime(2026, 6, 11, 9)),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text('2 new requests'), findsOneWidget);
    });

    testWidgets('singularises a lone request', (tester) async {
      await pump(
        tester,
        requests: [
          _req(id: 'r1', patientId: 'pt1', scheduledAt: DateTime(2026, 6, 10, 9)),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text('1 new request'), findsOneWidget);
    });

    testWidgets('hides the banner when nothing is pending', (tester) async {
      await pump(tester, requests: const []);
      await tester.pumpAndSettle();

      expect(find.textContaining('new request'), findsNothing);
    });
  });
}
