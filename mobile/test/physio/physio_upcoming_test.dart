import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/appointments_api.dart';
import 'package:healyn/features/appointments/data/appointments_repository.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';
import 'package:healyn/features/appointments/presentation/appointments_providers.dart';
import 'package:healyn/features/appointments/presentation/widgets/appointment_status_chip.dart';
import 'package:healyn/features/patients/data/models/patient_models.dart';
import 'package:healyn/features/patients/presentation/patients_providers.dart';
import 'package:healyn/features/physio/presentation/physio_upcoming_providers.dart';
import 'package:healyn/features/physio/presentation/screens/physio_upcoming_screen.dart';

/// Records the filter params passed to [list] and answers empty, so filter-chip
/// taps can be asserted while the real [PhysioAppointmentsNotifier] drives the
/// query.
class _CapturingListRepo extends AppointmentsRepository {
  _CapturingListRepo() : super(AppointmentsApi(Dio()));

  final List<({String? statusCsv, bool? isFollowUp})> listCalls = [];

  @override
  Future<AppointmentPage> list({
    String? patientId,
    String? statusCsv,
    bool? isFollowUp,
    DateTime? from,
    DateTime? to,
    String? cursor,
    int? limit,
  }) async {
    listCalls.add((statusCsv: statusCsv, isFollowUp: isFollowUp));
    return const AppointmentPage(items: [], nextCursor: null);
  }
}

/// Answers the header search with a fixed set and records the query it received,
/// so the autocomplete wiring can be asserted offline. [list] resolves empty so
/// the underlying screen settles.
class _SearchRepo extends AppointmentsRepository {
  _SearchRepo(this._results) : super(AppointmentsApi(Dio()));

  final List<AppointmentSuggestion> _results;
  String? lastQuery;

  @override
  Future<List<AppointmentSuggestion>> search(String q, {int? limit}) async {
    lastQuery = q;
    return _results;
  }

  @override
  Future<AppointmentPage> list({
    String? patientId,
    String? statusCsv,
    bool? isFollowUp,
    DateTime? from,
    DateTime? to,
    String? cursor,
    int? limit,
  }) async => const AppointmentPage(items: [], nextCursor: null);
}

/// Seeds the physio appointments list with a fixed set and no further pages, so
/// the screen renders without hitting the network.
class _FakePhysioNotifier extends PhysioAppointmentsNotifier {
  _FakePhysioNotifier(this._appointments);

  final List<Appointment> _appointments;

  @override
  Future<AppointmentsState> build() async =>
      AppointmentsState(items: _appointments, hasMore: false);
}

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

final _suggestion = AppointmentSuggestion(
  appointmentId: 'ap1',
  appointmentNumber: 'PHY-20260611-0001',
  patientId: 'pt1',
  patientName: 'Asha Rao',
  patientNumber: 'PAT-100001',
  status: AppointmentStatus.confirmed,
  scheduledAt: DateTime(2026, 6, 11, 9),
  requestedDate: DateTime(2026, 6, 11),
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

void main() {
  group('physio appointments list', () {
    testWidgets('groups upcoming and past, with patient and follow-up marking', (
      tester,
    ) async {
      final now = DateTime.now();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            patientsProvider.overrideWith((ref) => [_asha, _vikram]),
            physioAppointmentsProvider.overrideWith(
              () => _FakePhysioNotifier([
                _appt(
                  id: 'a1',
                  patientId: 'pt1',
                  status: AppointmentStatus.confirmed,
                  scheduledAt: now.add(const Duration(days: 1)),
                ),
                _appt(
                  id: 'a2',
                  patientId: 'pt2',
                  status: AppointmentStatus.completed,
                  scheduledAt: now.subtract(const Duration(days: 3)),
                  isFollowUp: true,
                ),
              ]),
            ),
          ],
          child: const MaterialApp(home: PhysioUpcomingScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Renamed screen.
      expect(find.text('Appointments'), findsOneWidget);
      // Status-based section split (confirmed is active → Upcoming; completed → Past).
      expect(find.text('UPCOMING'), findsOneWidget);
      expect(find.text('PAST'), findsOneWidget);

      expect(find.text('Asha Rao'), findsOneWidget);
      expect(find.text('Vikram Singh'), findsOneWidget);
      // Each row leads with a tappable patient monogram (quick patient access).
      expect(find.text('AR'), findsOneWidget);
      expect(find.text('VS'), findsOneWidget);

      expect(
        find.widgetWithText(AppointmentStatusChip, 'Confirmed'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(AppointmentStatusChip, 'Completed'),
        findsOneWidget,
      );
      expect(find.text('Follow-up'), findsOneWidget);
    });

    testWidgets('shows the at-rest empty state on the default Upcoming filter', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            patientsProvider.overrideWith((ref) => [_asha]),
            physioAppointmentsProvider.overrideWith(
              () => _FakePhysioNotifier(const []),
            ),
          ],
          child: const MaterialApp(home: PhysioUpcomingScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Nothing upcoming'), findsOneWidget);
    });
  });

  group('physio appointment filters', () {
    testWidgets('filter chips drive the list query (status + follow-ups)', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final repo = _CapturingListRepo();
      // The real notifier runs (no physioAppointmentsProvider override) so a chip
      // tap flows through physioAppointmentFilterProvider into repo.list.
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            patientsProvider.overrideWith((ref) => [_asha]),
            appointmentsRepositoryProvider.overrideWithValue(repo),
          ],
          child: const MaterialApp(home: PhysioUpcomingScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // First load defaults to the Upcoming status group.
      expect(
        repo.listCalls.last.statusCsv,
        AppointmentStatusFilter.upcoming.statusCsv,
      );
      expect(repo.listCalls.last.isFollowUp, isNull);

      // Selecting a status group sends its CSV.
      final completed = find.widgetWithText(ChoiceChip, 'Completed');
      await tester.ensureVisible(completed);
      await tester.tap(completed);
      await tester.pumpAndSettle();
      expect(repo.listCalls.last.statusCsv, 'COMPLETED');
      expect(repo.listCalls.last.isFollowUp, isNull);

      // The follow-ups toggle combines with the status group.
      final followUps = find.widgetWithText(FilterChip, 'Follow-ups');
      await tester.ensureVisible(followUps);
      await tester.tap(followUps);
      await tester.pumpAndSettle();
      expect(repo.listCalls.last.statusCsv, 'COMPLETED');
      expect(repo.listCalls.last.isFollowUp, isTrue);
    });

    testWidgets('a non-default filter with no matches shows the no-match state', (
      tester,
    ) async {
      final repo = _CapturingListRepo();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            patientsProvider.overrideWith((ref) => [_asha]),
            appointmentsRepositoryProvider.overrideWithValue(repo),
            physioAppointmentFilterProvider.overrideWith(
              (ref) => const AppointmentListFilter(
                status: AppointmentStatusFilter.rejected,
              ),
            ),
          ],
          child: const MaterialApp(home: PhysioUpcomingScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No appointments match this filter'), findsOneWidget);
      expect(find.text('Nothing upcoming'), findsNothing);
    });
  });

  group('physio header search', () {
    testWidgets('the search action opens autocomplete and lists matches', (
      tester,
    ) async {
      final repo = _SearchRepo([_suggestion]);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            patientsProvider.overrideWith((ref) => [_asha]),
            appointmentsRepositoryProvider.overrideWithValue(repo),
          ],
          child: const MaterialApp(home: PhysioUpcomingScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'asha');
      await tester.pump(); // rebuild the body, arming the debounce timer
      await tester.pump(const Duration(milliseconds: 350)); // fire the debounce
      await tester.pumpAndSettle(); // resolve the search future + render rows

      expect(repo.lastQuery, 'asha');
      expect(find.text('Asha Rao'), findsOneWidget);
      // The row's subtitle carries the appointment's human-friendly number.
      expect(find.textContaining('PHY-20260611-0001'), findsOneWidget);
    });
  });
}
