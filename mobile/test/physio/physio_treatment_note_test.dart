import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/physio/presentation/screens/physio_treatment_note_screen.dart';
import 'package:healyn/features/physio/presentation/widgets/physio_treatment_note_section.dart';
import 'package:healyn/features/treatment_notes/data/models/treatment_note_models.dart';
import 'package:healyn/features/treatment_notes/data/treatment_notes_api.dart';
import 'package:healyn/features/treatment_notes/data/treatment_notes_repository.dart';

/// Captures the request the repository builds, so the real trim/null/UTC
/// normalisation in [TreatmentNotesRepository.upsert] is exercised end to end.
class _RecordingApi extends TreatmentNotesApi {
  _RecordingApi() : super(Dio());

  UpsertTreatmentNoteRequest? body;

  @override
  Future<TreatmentNote> upsert(
    String appointmentId,
    UpsertTreatmentNoteRequest b,
  ) async {
    body = b;
    return _note();
  }
}

/// Records upserts and serves a fixed note without the network.
class _FakeRepo extends TreatmentNotesRepository {
  _FakeRepo({this.note}) : super(TreatmentNotesApi(Dio()));

  final TreatmentNote? note;

  bool upsertCalled = false;
  String? lastDiagnosis;
  String? lastNotes;
  String? lastRecovery;
  DateTime? lastReview;

  @override
  Future<TreatmentNote?> forAppointment(String appointmentId) async => note;

  @override
  Future<TreatmentNote> upsert(
    String appointmentId, {
    String? diagnosis,
    String? notes,
    String? recoveryInstructions,
    DateTime? nextReviewAt,
  }) async {
    upsertCalled = true;
    lastDiagnosis = diagnosis;
    lastNotes = notes;
    lastRecovery = recoveryInstructions;
    lastReview = nextReviewAt;
    return TreatmentNote(
      id: 'tn1',
      appointmentId: appointmentId,
      patientId: 'pt1',
      authorAccountId: 'phys',
      diagnosis: diagnosis,
      notes: notes,
      recoveryInstructions: recoveryInstructions,
      nextReviewAt: nextReviewAt,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
  }
}

TreatmentNote _note({
  String? diagnosis = 'Lateral ankle sprain',
  String? notes,
  String? recoveryInstructions,
}) => TreatmentNote(
  id: 'tn1',
  appointmentId: 'ap1',
  patientId: 'pt1',
  authorAccountId: 'phys',
  diagnosis: diagnosis,
  notes: notes,
  recoveryInstructions: recoveryInstructions,
  createdAt: DateTime.utc(2026, 6, 10, 9),
  updatedAt: DateTime.utc(2026, 6, 10, 9),
);

/// Pumps the editor pushed over a launcher route, so its `pop` on save returns
/// somewhere (mirrors how it is reached from the detail screen).
Future<void> _pumpEditor(
  WidgetTester tester, {
  required _FakeRepo repo,
  TreatmentNote? existing,
}) async {
  // The form is taller than the default 800×600 surface; give it room so every
  // field and the save button are laid out (and tappable) without scrolling.
  tester.view.physicalSize = const Size(1200, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [treatmentNotesRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => PhysioTreatmentNoteScreen(
                    appointmentId: 'ap1',
                    existing: existing,
                  ),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

Future<void> _pumpSection(
  WidgetTester tester, {
  required _FakeRepo repo,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [treatmentNotesRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(
        home: Scaffold(
          body: PhysioTreatmentNoteSection(appointmentId: 'ap1'),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  test('repository trims fields, drops blanks to null, and sends review as UTC',
      () async {
    final api = _RecordingApi();
    final repo = TreatmentNotesRepository(api);

    await repo.upsert(
      'ap1',
      diagnosis: '  Lateral ankle sprain  ',
      notes: '   ',
      recoveryInstructions: '',
      nextReviewAt: DateTime(2026, 7, 1, 14, 30), // local
    );

    expect(api.body!.diagnosis, 'Lateral ankle sprain');
    expect(api.body!.notes, isNull);
    expect(api.body!.recoveryInstructions, isNull);
    expect(api.body!.nextReviewAt!.isUtc, isTrue);
  });

  testWidgets('save is gated until at least one field has content', (
    tester,
  ) async {
    final repo = _FakeRepo();
    await _pumpEditor(tester, repo: repo);

    ElevatedButton saveButton() =>
        tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Save note'),
        );

    expect(saveButton().onPressed, isNull); // all fields blank

    await tester.enterText(
      find.widgetWithText(TextField, 'Assessment / diagnosis'),
      'Lateral ankle sprain',
    );
    await tester.pump();

    expect(saveButton().onPressed, isNotNull);
  });

  testWidgets('saving a new note upserts the entered fields', (tester) async {
    final repo = _FakeRepo();
    await _pumpEditor(tester, repo: repo);

    await tester.enterText(
      find.widgetWithText(TextField, 'Assessment / diagnosis'),
      'Lateral ankle sprain',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Exercises, precautions, home care'),
      'RICE for 48h, then mobilise.',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save note'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(repo.upsertCalled, isTrue);
    expect(repo.lastDiagnosis, 'Lateral ankle sprain');
    expect(repo.lastRecovery, 'RICE for 48h, then mobilise.');
    // Untouched notes field carries no content (cleaned to null in the repo).
    expect(repo.lastNotes ?? '', isEmpty);
    expect(repo.lastReview, isNull);
    // The editor popped back to the launcher.
    expect(find.text('open'), findsOneWidget);
  });

  testWidgets('editing prefills the existing note and re-upserts', (
    tester,
  ) async {
    final repo = _FakeRepo();
    await _pumpEditor(
      tester,
      repo: repo,
      existing: _note(diagnosis: 'Lateral ankle sprain', notes: 'Mild swelling'),
    );

    // Editing surfaces the edit title and prefilled values.
    expect(find.text('Edit treatment note'), findsOneWidget);
    expect(find.text('Lateral ankle sprain'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Session notes and observations'),
      'Swelling resolving',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save changes'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(repo.upsertCalled, isTrue);
    expect(repo.lastDiagnosis, 'Lateral ankle sprain');
    expect(repo.lastNotes, 'Swelling resolving');
  });

  testWidgets('section shows the empty state with an add affordance', (
    tester,
  ) async {
    final repo = _FakeRepo(); // forAppointment returns null
    await _pumpSection(tester, repo: repo);

    expect(find.text('No treatment note for this visit yet.'), findsOneWidget);
    expect(find.text('Add treatment note'), findsOneWidget);
    expect(find.text('Edit treatment note'), findsNothing);
  });

  testWidgets('section renders an existing note with an edit affordance', (
    tester,
  ) async {
    final repo = _FakeRepo(
      note: _note(
        diagnosis: 'Lateral ankle sprain',
        recoveryInstructions: 'RICE for 48h',
      ),
    );
    await _pumpSection(tester, repo: repo);

    expect(find.text('Lateral ankle sprain'), findsOneWidget);
    expect(find.text('RICE for 48h'), findsOneWidget);
    expect(find.text('Edit treatment note'), findsOneWidget);
    expect(find.text('Add treatment note'), findsNothing);
  });
}
