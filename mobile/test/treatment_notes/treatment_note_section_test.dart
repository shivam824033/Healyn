import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/shared/network/api_exception.dart';
import 'package:healyn/features/treatment_notes/data/models/treatment_note_models.dart';
import 'package:healyn/features/treatment_notes/data/treatment_notes_api.dart';
import 'package:healyn/features/treatment_notes/data/treatment_notes_repository.dart';
import 'package:healyn/features/treatment_notes/presentation/widgets/treatment_note_section.dart';

/// Serves a fixed result (or throws) without hitting the network.
class _FakeRepo extends TreatmentNotesRepository {
  _FakeRepo({this.note, this.fail = false}) : super(TreatmentNotesApi(Dio()));

  final TreatmentNote? note;
  final bool fail;

  @override
  Future<TreatmentNote?> forAppointment(String appointmentId) async {
    if (fail) {
      throw const ApiException(code: 'boom', message: 'nope', statusCode: 500);
    }
    return note;
  }
}

Future<void> _pump(WidgetTester tester, _FakeRepo repo) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [treatmentNotesRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(
        home: Scaffold(body: TreatmentNoteSection(appointmentId: 'ap1')),
      ),
    ),
  );
}

void main() {
  testWidgets('renders the note fields when present', (tester) async {
    await _pump(
      tester,
      _FakeRepo(
        note: TreatmentNote(
          id: 'tn1',
          appointmentId: 'ap1',
          patientId: 'pt1',
          authorAccountId: 'physio',
          diagnosis: 'Lumbar strain',
          notes: 'Improving.',
          recoveryInstructions: 'Daily stretches.',
          nextReviewAt: DateTime.utc(2026, 6, 20, 9, 30),
          createdAt: DateTime.utc(2026, 6, 10, 11),
          updatedAt: DateTime.utc(2026, 6, 10, 11),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Lumbar strain'), findsOneWidget);
    expect(find.text('Improving.'), findsOneWidget);
    expect(find.text('Daily stretches.'), findsOneWidget);
    expect(find.text('NEXT REVIEW'), findsOneWidget);
  });

  testWidgets('shows an empty state when no note exists yet', (tester) async {
    await _pump(tester, _FakeRepo());
    await tester.pumpAndSettle();

    expect(
      find.textContaining('hasn’t added a note'),
      findsOneWidget,
    );
  });

  testWidgets('offers a retry when the note fails to load', (tester) async {
    await _pump(tester, _FakeRepo(fail: true));
    await tester.pumpAndSettle();

    expect(find.text('Retry'), findsOneWidget);
    expect(find.textContaining("Couldn't load"), findsOneWidget);
  });
}
