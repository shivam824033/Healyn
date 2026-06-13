import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';
import 'package:healyn/features/appointments/presentation/appointments_providers.dart';
import 'package:healyn/features/home/presentation/next_review_provider.dart';
import 'package:healyn/features/home/presentation/screens/follow_ups_screen.dart';
import 'package:healyn/features/patients/data/models/patient_models.dart';

Patient _patient(String id, String name, {bool primary = false}) => Patient(
  id: id,
  fullName: name,
  dateOfBirth: DateTime(1990, 1, 1),
  primary: primary,
);

NextReviewSuggestion _review(
  Patient p,
  DateTime at, {
  String? number,
}) => NextReviewSuggestion(patient: p, reviewAt: at, appointmentNumber: number);

class _FixedAppointments extends AppointmentsNotifier {
  _FixedAppointments(this._items);

  final List<Appointment> _items;

  @override
  Future<AppointmentsState> build() async =>
      AppointmentsState(items: _items, hasMore: false);
}

Future<void> _pump(
  WidgetTester tester, {
  required List<NextReviewSuggestion> reviews,
  List<Appointment> appointments = const [],
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        pendingReviewsProvider.overrideWith((ref) async => reviews),
        appointmentsProvider.overrideWith(() => _FixedAppointments(appointments)),
      ],
      child: const MaterialApp(home: FollowUpsScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('one card per patient, with the appointment number and Book', (
    tester,
  ) async {
    await _pump(
      tester,
      reviews: [
        _review(
          _patient('p1', 'Asha Rao', primary: true),
          DateTime.now().add(const Duration(days: 5)),
          number: 'PHY-20260601-0007',
        ),
        _review(
          _patient('p2', 'Kiran Rao'),
          DateTime.now().add(const Duration(days: 9)),
        ),
      ],
    );

    expect(find.text('Asha Rao'), findsOneWidget);
    expect(find.text('Kiran Rao'), findsOneWidget);
    expect(find.text('Appointment PHY-20260601-0007'), findsOneWidget);
    // Neither patient is booked, so both offer a booking action.
    expect(find.text('Book appointment'), findsNWidgets(2));
  });

  testWidgets('marks a patient who already has an upcoming appointment', (
    tester,
  ) async {
    await _pump(
      tester,
      reviews: [
        _review(
          _patient('p1', 'Asha Rao', primary: true),
          DateTime.now().add(const Duration(days: 5)),
        ),
      ],
      appointments: [
        Appointment(
          id: 'a1',
          patientId: 'p1',
          bookedByAccountId: 'ac1',
          physiotherapistId: 'ph1',
          requestedDate: DateTime.now(),
          scheduledAt: DateTime.now().add(const Duration(days: 2)),
          durationMinutes: 45,
          status: AppointmentStatus.confirmed,
        ),
      ],
    );

    expect(find.text('Upcoming appointment already booked'), findsOneWidget);
    expect(find.text('Book appointment'), findsNothing);
  });

  testWidgets('shows an empty state when nothing is due', (tester) async {
    await _pump(tester, reviews: const []);
    expect(find.text('No follow-ups due'), findsOneWidget);
  });
}
