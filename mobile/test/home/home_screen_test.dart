import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';
import 'package:healyn/features/appointments/presentation/appointments_providers.dart';
import 'package:healyn/features/discussion/presentation/unread_providers.dart';
import 'package:healyn/features/home/presentation/home_screen.dart';
import 'package:healyn/features/home/presentation/next_review_provider.dart';
import 'package:healyn/features/patients/data/models/patient_models.dart';
import 'package:healyn/features/patients/presentation/patients_providers.dart';

/// Seeds the appointments list with a fixed set and no further pages, so Home
/// renders without hitting the network.
class _FixedAppointments extends AppointmentsNotifier {
  _FixedAppointments(this._items);

  final List<Appointment> _items;

  @override
  Future<AppointmentsState> build() async =>
      AppointmentsState(items: _items, hasMore: false);
}

final _asha = Patient(
  id: 'pt1',
  fullName: 'Asha Rao',
  dateOfBirth: DateTime(1990, 5, 21),
  relationship: PatientRelationship.self,
  primary: true,
);
final _kiran = Patient(
  id: 'pt2',
  fullName: 'Kiran Rao',
  dateOfBirth: DateTime(2015, 3, 10),
  relationship: PatientRelationship.child,
);

Appointment _appt({
  required String id,
  required String patientId,
  required AppointmentStatus status,
  required DateTime scheduledAt,
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
);

Future<void> _pump(
  WidgetTester tester, {
  required List<Patient> patients,
  required List<Appointment> appointments,
  NextReviewSuggestion? suggestion,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        patientsProvider.overrideWith((ref) async => patients),
        appointmentsProvider.overrideWith(
          () => _FixedAppointments(appointments),
        ),
        // Keep the unread roll-up out of the way (it would fan out over the
        // network otherwise); Home renders it as nothing when empty.
        unreadSummaryProvider.overrideWith(
          (ref) async => const UnreadSummary.empty(),
        ),
        // The next-review suggestion fans out over treatment notes; stub it so
        // the card is hidden unless a test opts in.
        nextReviewSuggestionProvider.overrideWith((ref) async => suggestion),
      ],
      child: const MaterialApp(home: HomeScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'surfaces a family member\'s appointment with a "for Name" label even '
    'when the primary is the active patient',
    (tester) async {
      final now = DateTime.now();
      await _pump(
        tester,
        patients: [_asha, _kiran],
        appointments: [
          _appt(
            id: 'a1',
            patientId: 'pt2', // booked for the family member, not the active one
            status: AppointmentStatus.confirmed,
            scheduledAt: now.add(const Duration(days: 2)),
          ),
        ],
      );

      // The appointment shows instead of "Nothing scheduled yet."…
      expect(find.text('Nothing scheduled yet.'), findsNothing);
      expect(find.text('Confirmed'), findsOneWidget);
      // …labelled with the family member it's for.
      expect(find.text('for Kiran Rao'), findsOneWidget);
    },
  );

  testWidgets('omits the label when the next appointment is for the active '
      'patient', (tester) async {
    final now = DateTime.now();
    await _pump(
      tester,
      patients: [_asha, _kiran],
      appointments: [
        _appt(
          id: 'a1',
          patientId: 'pt1', // the active (primary) patient
          status: AppointmentStatus.confirmed,
          scheduledAt: now.add(const Duration(days: 1)),
        ),
      ],
    );

    expect(find.text('Confirmed'), findsOneWidget);
    expect(find.textContaining('for '), findsNothing);
  });

  testWidgets('shows the soonest open appointment across all patients', (
    tester,
  ) async {
    final now = DateTime.now();
    await _pump(
      tester,
      patients: [_asha, _kiran],
      appointments: [
        _appt(
          id: 'later',
          patientId: 'pt1',
          status: AppointmentStatus.confirmed,
          scheduledAt: now.add(const Duration(days: 5)),
        ),
        _appt(
          id: 'sooner',
          patientId: 'pt2',
          status: AppointmentStatus.requested,
          scheduledAt: now.add(const Duration(days: 1)),
        ),
      ],
    );

    // The sooner one (a family member's) wins, so its status and label show.
    expect(find.text('Requested'), findsOneWidget);
    expect(find.text('for Kiran Rao'), findsOneWidget);
  });

  testWidgets('invites booking when nothing is scheduled', (tester) async {
    await _pump(
      tester,
      patients: [_asha],
      appointments: const [],
    );

    expect(find.text('Nothing scheduled yet.'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Book appointment'), findsOneWidget);
  });

  testWidgets('surfaces a suggested next review with a book CTA (D6)', (
    tester,
  ) async {
    await _pump(
      tester,
      patients: [_asha, _kiran],
      appointments: const [],
      suggestion: NextReviewSuggestion(
        patient: _kiran,
        reviewAt: DateTime(2026, 6, 24, 9),
      ),
    );

    expect(find.text('Suggested next review'), findsOneWidget);
    // Labelled with the family member it's for, with a booking CTA.
    expect(find.text('for Kiran Rao'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Book appointment'), findsWidgets);
  });

  testWidgets('hides the next-review card when nothing is suggested', (
    tester,
  ) async {
    await _pump(
      tester,
      patients: [_asha],
      appointments: const [],
    );

    expect(find.text('Suggested next review'), findsNothing);
  });
}
