import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';
import 'package:healyn/features/appointments/presentation/appointments_providers.dart';
import 'package:healyn/features/discussion/data/discussion_api.dart';
import 'package:healyn/features/discussion/data/discussion_repository.dart';
import 'package:healyn/features/discussion/presentation/screens/unread_discussions_screen.dart';
import 'package:healyn/features/discussion/presentation/unread_providers.dart';
import 'package:healyn/features/patients/data/models/patient_models.dart';
import 'package:healyn/features/patients/presentation/patients_providers.dart';

/// Returns a fixed unread count per appointment id; 0 for anything unmapped.
class _FakeDiscussionRepo extends DiscussionRepository {
  _FakeDiscussionRepo(this._counts) : super(DiscussionApi(Dio()));

  final Map<String, int> _counts;

  @override
  Future<int> unreadCount(String appointmentId) async =>
      _counts[appointmentId] ?? 0;
}

class _FixedAppointments extends AppointmentsNotifier {
  _FixedAppointments(this._items);

  final List<Appointment> _items;

  @override
  Future<AppointmentsState> build() async =>
      AppointmentsState(items: _items, hasMore: false);
}

Appointment _appt(String id, AppointmentStatus status, {String patientId = 'pt1'}) {
  // Deterministic, id-ordered schedule so summary ordering is stable in tests.
  final start = DateTime.utc(2026, 6, 1).add(Duration(minutes: id.codeUnitAt(0)));
  return Appointment(
    id: id,
    patientId: patientId,
    bookedByAccountId: 'ac1',
    physiotherapistId: 'ph1',
    requestedDate: DateTime(start.year, start.month, start.day),
    scheduledAt: start,
    scheduledEndAt: start.add(const Duration(minutes: 30)),
    durationMinutes: 30,
    status: status,
  );
}

final _asha = Patient(
  id: 'pt1',
  fullName: 'Asha Rao',
  dateOfBirth: DateTime(1990, 5, 21),
  relationship: PatientRelationship.self,
  primary: true,
);

ProviderContainer _container({
  required List<Appointment> appointments,
  required Map<String, int> counts,
}) {
  final container = ProviderContainer(
    overrides: [
      appointmentsProvider.overrideWith(() => _FixedAppointments(appointments)),
      discussionRepositoryProvider.overrideWithValue(
        _FakeDiscussionRepo(counts),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('unreadSummaryProvider', () {
    test('sums counts and lists only threads with unread', () async {
      final container = _container(
        appointments: [
          _appt('a', AppointmentStatus.confirmed),
          _appt('b', AppointmentStatus.completed),
          _appt('c', AppointmentStatus.requested),
        ],
        counts: {'a': 2, 'b': 3, 'c': 0},
      );

      final summary = await container.read(unreadSummaryProvider.future);

      expect(summary.total, 5);
      expect(summary.threads.map((t) => t.appointment.id), ['a', 'b']);
    });

    test('skips dead-state appointments (cancelled / no-show / rescheduled)',
        () async {
      final container = _container(
        appointments: [
          _appt('a', AppointmentStatus.confirmed),
          _appt('x', AppointmentStatus.cancelled),
          _appt('y', AppointmentStatus.noShow),
          _appt('z', AppointmentStatus.rescheduled),
        ],
        // Even if the server would report unread, dead threads are never polled.
        counts: {'a': 1, 'x': 9, 'y': 9, 'z': 9},
      );

      final summary = await container.read(unreadSummaryProvider.future);

      expect(summary.total, 1);
      expect(summary.threads.single.appointment.id, 'a');
    });

    test('is empty when nothing is unread', () async {
      final container = _container(
        appointments: [_appt('a', AppointmentStatus.confirmed)],
        counts: {'a': 0},
      );

      final summary = await container.read(unreadSummaryProvider.future);

      expect(summary.total, 0);
      expect(summary.threads, isEmpty);
    });
  });

  group('UnreadDiscussionsScreen', () {
    Future<void> pump(
      WidgetTester tester, {
      required List<Appointment> appointments,
      required Map<String, int> counts,
    }) {
      return tester.pumpWidget(
        ProviderScope(
          overrides: [
            patientsProvider.overrideWith((ref) => [_asha]),
            appointmentsProvider.overrideWith(
              () => _FixedAppointments(appointments),
            ),
            discussionRepositoryProvider.overrideWithValue(
              _FakeDiscussionRepo(counts),
            ),
          ],
          child: const MaterialApp(home: UnreadDiscussionsScreen()),
        ),
      );
    }

    testWidgets('lists a row per unread appointment with its patient name', (
      tester,
    ) async {
      await pump(
        tester,
        appointments: [_appt('a', AppointmentStatus.confirmed)],
        counts: {'a': 4},
      );
      await tester.pumpAndSettle();

      expect(find.text('Asha Rao'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('shows the caught-up empty state when nothing is unread', (
      tester,
    ) async {
      await pump(
        tester,
        appointments: [_appt('a', AppointmentStatus.confirmed)],
        counts: {'a': 0},
      );
      await tester.pumpAndSettle();

      expect(find.text("You're all caught up"), findsOneWidget);
    });
  });
}
