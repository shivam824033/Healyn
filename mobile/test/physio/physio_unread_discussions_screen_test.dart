import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';
import 'package:healyn/features/patients/data/models/patient_models.dart';
import 'package:healyn/features/patients/presentation/patients_providers.dart';
import 'package:healyn/features/physio/presentation/physio_unread_providers.dart';
import 'package:healyn/features/physio/presentation/screens/physio_unread_discussions_screen.dart';

Appointment _appt() => Appointment(
  id: 'ap1',
  appointmentNumber: 'PHY-20260613-1001',
  patientId: 'pt1',
  bookedByAccountId: 'ac1',
  physiotherapistId: 'ph1',
  requestedDate: DateTime(2026, 6, 13),
  durationMinutes: 45,
  status: AppointmentStatus.confirmed,
);

Patient _patient() => Patient(
  id: 'pt1',
  patientNumber: 'PAT-100001',
  fullName: 'John Doe',
  dateOfBirth: DateTime(1990, 1, 1),
);

void main() {
  testWidgets('renders a card per unread thread with name, number, preview, count', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          patientsProvider.overrideWith((ref) => [_patient()]),
          physioUnreadSummaryProvider.overrideWith(
            (ref) => PhysioUnreadSummary(
              total: 3,
              threads: [
                PhysioUnreadThread(
                  appointment: _appt(),
                  count: 3,
                  lastMessagePreview: 'Can we change timing?',
                  lastMessageAt: DateTime.utc(2026, 6, 13, 9),
                ),
              ],
            ),
          ),
        ],
        child: const MaterialApp(home: PhysioUnreadDiscussionsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('PHY-20260613-1001'), findsOneWidget);
    expect(find.text('Can we change timing?'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('shows the all-caught-up state when nothing is unread', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          patientsProvider.overrideWith((ref) => const []),
          physioUnreadSummaryProvider.overrideWith(
            (ref) => const PhysioUnreadSummary.empty(),
          ),
        ],
        child: const MaterialApp(home: PhysioUnreadDiscussionsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("You're all caught up"), findsOneWidget);
  });
}
