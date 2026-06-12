import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/appointments_api.dart';
import 'package:healyn/features/appointments/data/appointments_repository.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';
import 'package:healyn/features/appointments/presentation/appointment_format.dart';
import 'package:healyn/features/appointments/presentation/appointments_providers.dart';
import 'package:healyn/features/appointments/presentation/screens/appointment_detail_screen.dart';
import 'package:healyn/features/appointments/presentation/screens/appointments_screen.dart';
import 'package:healyn/features/appointments/presentation/screens/book_appointment_screen.dart';
import 'package:healyn/features/appointments/presentation/screens/reschedule_appointment_screen.dart';
import 'package:healyn/features/appointments/presentation/widgets/appointment_status_chip.dart';
import 'package:healyn/features/shared/widgets/healyn_section_header.dart';
import 'package:healyn/features/patients/data/models/patient_models.dart';
import 'package:healyn/features/patients/presentation/patients_providers.dart';
import 'package:healyn/features/treatment_notes/data/models/treatment_note_models.dart';
import 'package:healyn/features/treatment_notes/data/treatment_notes_api.dart';
import 'package:healyn/features/treatment_notes/data/treatment_notes_repository.dart';

/// Records book/reschedule calls but never completes them, so the submit tests
/// can assert whether the call was made without the screen navigating away.
class _RecordingApptRepo extends AppointmentsRepository {
  _RecordingApptRepo() : super(AppointmentsApi(Dio()));

  bool bookCalled = false;
  bool rescheduleCalled = false;

  @override
  Future<Appointment> book(
    BookAppointmentRequest body, {
    required String idempotencyKey,
  }) {
    bookCalled = true;
    return Completer<Appointment>().future;
  }

  @override
  Future<Appointment> reschedule(String id, RescheduleAppointmentRequest body) {
    rescheduleCalled = true;
    return Completer<Appointment>().future;
  }

  // The detail screen's History section loads the lineage timeline; resolve it
  // empty so the section settles offline.
  @override
  Future<List<TimelineEvent>> timeline(String id) async => const [];
}

/// Records the filter params passed to [list] and answers empty, so filter-chip
/// taps can be asserted while the real [AppointmentsNotifier] drives the query.
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

/// Seeds the appointments list with a fixed set and no further pages, so the
/// screens render without hitting the network.
class _FakeAppointmentsNotifier extends AppointmentsNotifier {
  _FakeAppointmentsNotifier(this._appointments);

  final List<Appointment> _appointments;

  @override
  Future<AppointmentsState> build() async =>
      AppointmentsState(items: _appointments, hasMore: false);
}

/// Reports another page is available and records whether the screen asked for
/// it, so the load-more footer can be tested without the network.
class _PagedAppointmentsNotifier extends AppointmentsNotifier {
  _PagedAppointmentsNotifier(this._appointments);

  final List<Appointment> _appointments;
  bool loadMoreCalled = false;

  @override
  Future<AppointmentsState> build() async =>
      AppointmentsState(items: _appointments, hasMore: true);

  @override
  Future<void> loadMore() async => loadMoreCalled = true;
}

/// The detail screen loads a treatment note for COMPLETED appointments; this
/// resolves it to "none yet" so the section settles to its empty state offline.
class _FakeTreatmentNotesRepo extends TreatmentNotesRepository {
  _FakeTreatmentNotesRepo() : super(TreatmentNotesApi(Dio()));

  @override
  Future<TreatmentNote?> forAppointment(String appointmentId) async => null;
}

final _asha = Patient(
  id: 'pt1',
  fullName: 'Asha Rao',
  dateOfBirth: DateTime(1990, 5, 21),
  relationship: PatientRelationship.self,
  primary: true,
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
  required AppointmentStatus status,
  required DateTime scheduledAt,
  int duration = 45,
}) => Appointment(
  id: id,
  patientId: 'pt1',
  bookedByAccountId: 'ac1',
  physiotherapistId: 'ph1',
  requestedDate: DateTime(scheduledAt.year, scheduledAt.month, scheduledAt.day),
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
          appointmentsProvider.overrideWith(
            () => _FakeAppointmentsNotifier(appointments),
          ),
        if (repo != null) appointmentsRepositoryProvider.overrideWithValue(repo),
        treatmentNotesRepositoryProvider.overrideWithValue(
          _FakeTreatmentNotesRepo(),
        ),
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

      // Section titles render via HealynSectionHeader (title as-is). Scope to
      // the header — the filter bar also carries an 'Upcoming' chip.
      expect(
        find.widgetWithText(HealynSectionHeader, 'Upcoming'),
        findsOneWidget,
      );
      expect(find.widgetWithText(HealynSectionHeader, 'Past'), findsOneWidget);
      // Scope status to the tile chips — the filter bar also has a 'Completed' chip.
      expect(
        find.widgetWithText(AppointmentStatusChip, 'Confirmed'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(AppointmentStatusChip, 'Completed'),
        findsOneWidget,
      );
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

    testWidgets('offers Load more and pages when more is available', (
      tester,
    ) async {
      final notifier = _PagedAppointmentsNotifier([
        _appt(
          id: 'a',
          status: AppointmentStatus.completed,
          scheduledAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ]);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            patientsProvider.overrideWith((ref) => [_asha]),
            appointmentsProvider.overrideWith(() => notifier),
          ],
          child: const MaterialApp(home: AppointmentsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      final loadMore = find.widgetWithText(TextButton, 'Load more');
      expect(loadMore, findsOneWidget);
      await tester.tap(loadMore);
      expect(notifier.loadMoreCalled, isTrue);
    });
  });

  group('appointment filters', () {
    testWidgets('filter chips drive the list query (status + follow-ups)', (
      tester,
    ) async {
      // A tall surface so the horizontal chip bar and the list area both lay out.
      tester.view.physicalSize = const Size(1200, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final repo = _CapturingListRepo();
      // The real notifier runs (no appointmentsProvider override) so a chip tap
      // flows through appointmentFilterProvider into repo.list.
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            patientsProvider.overrideWith((ref) => [_asha]),
            appointmentsRepositoryProvider.overrideWithValue(repo),
          ],
          child: const MaterialApp(home: AppointmentsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // First load: no filter.
      expect(repo.listCalls.last.statusCsv, isNull);
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

    testWidgets('a filter with no matches shows the no-match state, not '
        'onboarding', (tester) async {
      final repo = _CapturingListRepo();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            patientsProvider.overrideWith((ref) => [_asha]),
            appointmentsRepositoryProvider.overrideWithValue(repo),
            // Start already filtered so the empty result is "no match", not first-run.
            appointmentFilterProvider.overrideWith(
              (ref) => const AppointmentListFilter(
                status: AppointmentStatusFilter.rejected,
              ),
            ),
          ],
          child: const MaterialApp(home: AppointmentsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No appointments match this filter'), findsOneWidget);
      expect(find.text('No appointments yet'), findsNothing);
    });
  });

  // Header search lives on the physiotherapist's Appointments screen, not the
  // patient timeline; its widget tests are in test/physio/physio_upcoming_test.dart.
  // This provider-level test stays here as it is screen-agnostic.
  group('appointment search provider', () {
    test('the search provider skips the network below the minimum length', () async {
      final repo = _SearchRepo([_suggestion]);
      final container = ProviderContainer(
        overrides: [appointmentsRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      // One character is below the minimum: no network call.
      expect(
        await container.read(appointmentSearchProvider('a').future),
        isEmpty,
      );
      expect(repo.lastQuery, isNull);

      // Two or more: the repository is queried with the trimmed term.
      final hits = await container.read(appointmentSearchProvider('asha').future);
      expect(hits, hasLength(1));
      expect(repo.lastQuery, 'asha');
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

    testWidgets('prefills the date and patient from a next-review suggestion', (
      tester,
    ) async {
      final day = DateTime.now().add(const Duration(days: 14));
      await _pump(
        tester,
        BookAppointmentScreen(initialPatientId: 'pt1', initialDay: day),
        repo: _RecordingApptRepo(),
      );
      await tester.pumpAndSettle();

      // The date field carries the prefilled day; the patient is preselected.
      expect(find.text(formatDateShort(day)), findsOneWidget);
      expect(find.text('Asha Rao (You)'), findsOneWidget);
    });
  });

  group('appointment detail', () {
    testWidgets('offers Reschedule and Cancel for a requested appointment', (
      tester,
    ) async {
      await _pump(
        tester,
        AppointmentDetailScreen(
          appointment: _appt(
            id: 'ap1',
            status: AppointmentStatus.requested,
            scheduledAt: DateTime.now().add(const Duration(days: 3)),
          ),
        ),
        repo: _RecordingApptRepo(),
      );
      await tester.pumpAndSettle();

      expect(find.text('Reschedule'), findsOneWidget);
      expect(find.text('Cancel appointment'), findsOneWidget);
    });

    testWidgets('hides Reschedule and Cancel for a completed appointment', (
      tester,
    ) async {
      await _pump(
        tester,
        AppointmentDetailScreen(
          appointment: _appt(
            id: 'ap2',
            status: AppointmentStatus.completed,
            scheduledAt: DateTime.now().subtract(const Duration(days: 3)),
          ),
        ),
        repo: _RecordingApptRepo(),
      );
      await tester.pumpAndSettle();

      expect(find.text('Reschedule'), findsNothing);
      expect(find.text('Cancel appointment'), findsNothing);
    });
  });

  group('reschedule appointment', () {
    testWidgets('re-requests for the prefilled date (no slot to pick)', (
      tester,
    ) async {
      // Request-first: the form prefills the current date, so the patient can
      // send a new request straight away — the physiotherapist sets the time.
      final repo = _RecordingApptRepo();
      await _pump(
        tester,
        RescheduleAppointmentScreen(
          appointment: _appt(
            id: 'ap1',
            status: AppointmentStatus.confirmed,
            scheduledAt: DateTime.now().add(const Duration(days: 2)),
          ),
        ),
        repo: repo,
      );
      await tester.pumpAndSettle();

      final submit = find.widgetWithText(ElevatedButton, 'Send new request');
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pump();

      expect(repo.rescheduleCalled, isTrue);
    });
  });
}
