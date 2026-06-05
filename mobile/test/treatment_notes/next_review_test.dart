import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';
import 'package:healyn/features/appointments/presentation/appointments_providers.dart';
import 'package:healyn/features/home/presentation/next_review_provider.dart';
import 'package:healyn/features/patients/data/models/patient_models.dart';
import 'package:healyn/features/patients/presentation/patients_providers.dart';
import 'package:healyn/features/treatment_notes/data/models/treatment_note_models.dart';
import 'package:healyn/features/treatment_notes/data/treatment_notes_api.dart';
import 'package:healyn/features/treatment_notes/data/treatment_notes_repository.dart';
import 'package:healyn/features/treatment_notes/presentation/next_review_providers.dart';

TreatmentNote _note({
  required String id,
  required String patientId,
  DateTime? nextReviewAt,
  required DateTime createdAt,
}) => TreatmentNote(
  id: id,
  appointmentId: 'a-$id',
  patientId: patientId,
  authorAccountId: 'ph1',
  notes: 'note',
  nextReviewAt: nextReviewAt,
  createdAt: createdAt,
  updatedAt: createdAt,
);

final _now = DateTime(2026, 6, 5, 12);

void main() {
  group('pendingReviewFrom', () {
    test('is null for no notes', () {
      expect(pendingReviewFrom(const [], now: _now), isNull);
    });

    test('returns the newest note\'s review when it is today or later', () {
      final at = DateTime(2026, 6, 20, 9).toUtc();
      final notes = [
        _note(id: 'n2', patientId: 'p1', nextReviewAt: at, createdAt: _now),
      ];
      expect(pendingReviewFrom(notes, now: _now), at);
    });

    test('treats a past review as lapsed (null)', () {
      final notes = [
        _note(
          id: 'n2',
          patientId: 'p1',
          nextReviewAt: DateTime(2026, 5, 1, 9).toUtc(),
          createdAt: _now,
        ),
      ];
      expect(pendingReviewFrom(notes, now: _now), isNull);
    });

    test('uses the most recently set review, skipping newer notes with none', () {
      // Newest-first: newest note has no review, the next one set a future review.
      final at = DateTime(2026, 6, 18, 9).toUtc();
      final notes = [
        _note(id: 'newest', patientId: 'p1', createdAt: _now),
        _note(
          id: 'older',
          patientId: 'p1',
          nextReviewAt: at,
          createdAt: _now.subtract(const Duration(days: 7)),
        ),
      ];
      expect(pendingReviewFrom(notes, now: _now), at);
    });
  });

  group('nextReviewSuggestionProvider', () {
    Patient patient(String id, String name, {bool primary = false}) => Patient(
      id: id,
      fullName: name,
      dateOfBirth: DateTime(1990, 1, 1),
      primary: primary,
    );

    ProviderContainer container({
      required List<Patient> patients,
      required List<Appointment> appointments,
      required Map<String, TreatmentNotePage> notesByPatient,
    }) {
      final c = ProviderContainer(
        overrides: [
          patientsProvider.overrideWith((ref) async => patients),
          appointmentsProvider.overrideWith(
            () => _FixedAppointments(appointments),
          ),
          treatmentNotesRepositoryProvider.overrideWithValue(
            _MapNotesRepo(notesByPatient),
          ),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    TreatmentNotePage pageWithReview(String patientId, DateTime at) =>
        TreatmentNotePage(
          items: [
            _note(
              id: '$patientId-n',
              patientId: patientId,
              nextReviewAt: at,
              createdAt: DateTime(2026, 6, 1),
            ),
          ],
        );

    test('picks the soonest pending review across patients', () async {
      final c = container(
        patients: [
          patient('p1', 'Asha Rao', primary: true),
          patient('p2', 'Kiran Rao'),
        ],
        appointments: const [],
        notesByPatient: {
          'p1': pageWithReview('p1', DateTime.now().add(const Duration(days: 20))),
          'p2': pageWithReview('p2', DateTime.now().add(const Duration(days: 5))),
        },
      );

      final s = await c.read(nextReviewSuggestionProvider.future);
      expect(s?.patient.id, 'p2'); // sooner review wins
    });

    test('suppresses a patient who already has an upcoming appointment',
        () async {
      final c = container(
        patients: [patient('p1', 'Asha Rao', primary: true)],
        appointments: [
          Appointment(
            id: 'a1',
            patientId: 'p1',
            bookedByAccountId: 'ac1',
            physiotherapistId: 'ph1',
            scheduledAt: DateTime.now().add(const Duration(days: 3)),
            scheduledEndAt: DateTime.now().add(const Duration(days: 3, hours: 1)),
            durationMinutes: 45,
            status: AppointmentStatus.confirmed,
          ),
        ],
        notesByPatient: {
          'p1': pageWithReview('p1', DateTime.now().add(const Duration(days: 10))),
        },
      );

      final s = await c.read(nextReviewSuggestionProvider.future);
      expect(s, isNull);
    });

    test('is null when no patient has a pending review', () async {
      final c = container(
        patients: [patient('p1', 'Asha Rao', primary: true)],
        appointments: const [],
        notesByPatient: {'p1': const TreatmentNotePage(items: [])},
      );

      final s = await c.read(nextReviewSuggestionProvider.future);
      expect(s, isNull);
    });
  });
}

class _FixedAppointments extends AppointmentsNotifier {
  _FixedAppointments(this._items);

  final List<Appointment> _items;

  @override
  Future<AppointmentsState> build() async =>
      AppointmentsState(items: _items, hasMore: false);
}

class _MapNotesRepo extends TreatmentNotesRepository {
  _MapNotesRepo(this._byPatient) : super(TreatmentNotesApi(Dio()));

  final Map<String, TreatmentNotePage> _byPatient;

  @override
  Future<TreatmentNotePage> forPatient(
    String patientId, {
    String? cursor,
    int? limit,
  }) async => _byPatient[patientId] ?? const TreatmentNotePage(items: []);
}
