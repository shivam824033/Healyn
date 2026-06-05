import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/patients/data/models/patient_models.dart';
import 'package:healyn/features/patients/presentation/patients_providers.dart';
import 'package:healyn/features/physio/presentation/screens/physio_patient_detail_screen.dart';
import 'package:healyn/features/physio/presentation/screens/physio_patients_screen.dart';
import 'package:healyn/features/shared/domain/patient_sex.dart';
import 'package:healyn/features/treatment_notes/data/models/treatment_note_models.dart';
import 'package:healyn/features/treatment_notes/data/treatment_notes_api.dart';
import 'package:healyn/features/treatment_notes/data/treatment_notes_repository.dart';
import 'package:healyn/features/treatment_notes/presentation/screens/treatment_notes_timeline_screen.dart';

class _FakeNotesRepo extends TreatmentNotesRepository {
  _FakeNotesRepo(this.page) : super(TreatmentNotesApi(Dio()));

  final TreatmentNotePage page;

  @override
  Future<TreatmentNotePage> forPatient(
    String patientId, {
    String? cursor,
    int? limit,
  }) async => page;
}

Patient _patient({
  required String id,
  required String name,
  PatientSex? sex,
  String? allergies,
  String? notes,
}) => Patient(
  id: id,
  fullName: name,
  dateOfBirth: DateTime(1990, 5, 21),
  sex: sex,
  allergies: allergies,
  notes: notes,
);

Future<void> _pumpRoster(WidgetTester tester, List<Patient> patients) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [patientsProvider.overrideWith((ref) => patients)],
      child: const MaterialApp(home: PhysioPatientsScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('roster', () {
    testWidgets('lists patients name-sorted', (tester) async {
      await _pumpRoster(tester, [
        _patient(id: 'p1', name: 'Zoe Smith'),
        _patient(id: 'p2', name: 'Asha Rao'),
      ]);

      expect(find.text('Asha Rao'), findsOneWidget);
      expect(find.text('Zoe Smith'), findsOneWidget);
      // Asha sorts above Zoe.
      expect(
        tester.getTopLeft(find.text('Asha Rao')).dy,
        lessThan(tester.getTopLeft(find.text('Zoe Smith')).dy),
      );
    });

    testWidgets('search filters the roster by name', (tester) async {
      await _pumpRoster(tester, [
        _patient(id: 'p1', name: 'Zoe Smith'),
        _patient(id: 'p2', name: 'Asha Rao'),
      ]);

      await tester.enterText(find.byType(TextField), 'asha');
      await tester.pumpAndSettle();

      expect(find.text('Asha Rao'), findsOneWidget);
      expect(find.text('Zoe Smith'), findsNothing);
    });

    testWidgets('a search with no match shows the no-matches state', (
      tester,
    ) async {
      await _pumpRoster(tester, [_patient(id: 'p1', name: 'Asha Rao')]);

      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pumpAndSettle();

      expect(find.text('No matches'), findsOneWidget);
      expect(find.text('Asha Rao'), findsNothing);
    });

    testWidgets('an empty roster shows the empty state', (tester) async {
      await _pumpRoster(tester, const []);
      expect(find.text('No patients yet'), findsOneWidget);
    });
  });

  group('patient detail', () {
    Future<void> pumpDetail(
      WidgetTester tester, {
      required Patient patient,
      TreatmentNotePage notes = const TreatmentNotePage(items: []),
    }) async {
      // Tall surface so the whole detail (down to the history link) is laid out.
      tester.view.physicalSize = const Size(1000, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            treatmentNotesRepositoryProvider.overrideWithValue(
              _FakeNotesRepo(notes),
            ),
          ],
          child: MaterialApp(home: PhysioPatientDetailScreen(patient: patient)),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('shows demographics, clinical fields and a history link', (
      tester,
    ) async {
      await pumpDetail(
        tester,
        patient: _patient(
          id: 'p1',
          name: 'Asha Rao',
          sex: PatientSex.female,
          allergies: 'Penicillin',
          notes: 'Prefers morning sessions',
        ),
      );

      expect(find.text('Asha Rao'), findsWidgets);
      expect(find.text('Female'), findsOneWidget);
      expect(find.text('Penicillin'), findsOneWidget);
      expect(find.text('Prefers morning sessions'), findsOneWidget);
      expect(find.text('Treatment history'), findsOneWidget);
      // No review set → no follow-up section.
      expect(find.text('FOLLOW-UP DUE'), findsNothing);
    });

    testWidgets('surfaces a follow-up when the latest note set a future review',
        (tester) async {
      final reviewAt = DateTime.now().toUtc().add(const Duration(days: 14));
      await pumpDetail(
        tester,
        patient: _patient(id: 'p1', name: 'Asha Rao'),
        notes: TreatmentNotePage(
          items: [
            TreatmentNote(
              id: 'n1',
              appointmentId: 'a1',
              patientId: 'p1',
              authorAccountId: 'ph1',
              notes: 'Recovering well',
              nextReviewAt: reviewAt,
              createdAt: DateTime.now().toUtc(),
              updatedAt: DateTime.now().toUtc(),
            ),
          ],
        ),
      );

      expect(find.text('FOLLOW-UP DUE'), findsOneWidget);
    });
  });

  group('treatment history viewer', () {
    test('opens the appointment in each app’s own area', () {
      expect(
        const TreatmentNotesTimelineScreen(
          patientId: 'p1',
        ).appointmentRoutePrefix,
        '/appointments',
      );
      expect(
        const TreatmentNotesTimelineScreen(
          patientId: 'p1',
          viewer: TreatmentHistoryViewer.physio,
        ).appointmentRoutePrefix,
        '/physio/appointments',
      );
    });

    testWidgets('the physio empty state uses physio-facing copy', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            treatmentNotesRepositoryProvider.overrideWithValue(
              _FakeNotesRepo(const TreatmentNotePage(items: [])),
            ),
          ],
          child: const MaterialApp(
            home: TreatmentNotesTimelineScreen(
              patientId: 'p1',
              viewer: TreatmentHistoryViewer.physio,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Notes written after a completed appointment will appear here.',
        ),
        findsOneWidget,
      );
    });
  });
}
