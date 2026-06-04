import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/treatment_notes/data/models/treatment_note_models.dart';
import 'package:healyn/features/treatment_notes/data/treatment_notes_api.dart';
import 'package:healyn/features/treatment_notes/data/treatment_notes_repository.dart';
import 'package:healyn/features/treatment_notes/presentation/screens/treatment_notes_timeline_screen.dart';

/// Serves fixed pages and records the cursor of each request, without network.
class _FakeRepo extends TreatmentNotesRepository {
  _FakeRepo(this.pages) : super(TreatmentNotesApi(Dio()));

  final List<TreatmentNotePage> pages;
  int calls = 0;
  final List<String?> cursors = [];

  @override
  Future<TreatmentNotePage> forPatient(
    String patientId, {
    String? cursor,
    int? limit,
  }) async {
    cursors.add(cursor);
    final page = pages[calls < pages.length ? calls : pages.length - 1];
    calls++;
    return page;
  }
}

TreatmentNote _note(String diagnosis) => TreatmentNote(
  id: 'n-$diagnosis',
  appointmentId: 'ap-$diagnosis',
  patientId: 'p1',
  authorAccountId: 'ph1',
  diagnosis: diagnosis,
  createdAt: DateTime.utc(2026, 6, 10, 9),
  updatedAt: DateTime.utc(2026, 6, 10, 9),
);

Future<void> _pump(WidgetTester tester, _FakeRepo repo) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [treatmentNotesRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(
        home: TreatmentNotesTimelineScreen(patientId: 'p1'),
      ),
    ),
  );
}

void main() {
  testWidgets('renders the patient’s notes', (tester) async {
    final repo = _FakeRepo([
      TreatmentNotePage(
        items: [_note('Lateral epicondylitis'), _note('Lumbar strain')],
        nextCursor: null,
      ),
    ]);
    await _pump(tester, repo);
    await tester.pumpAndSettle();

    expect(find.text('Treatment history'), findsOneWidget); // app-bar title
    expect(find.text('Lateral epicondylitis'), findsOneWidget);
    expect(find.text('Lumbar strain'), findsOneWidget);
  });

  testWidgets('shows an empty state when there are no notes', (tester) async {
    final repo = _FakeRepo([
      const TreatmentNotePage(items: [], nextCursor: null),
    ]);
    await _pump(tester, repo);
    await tester.pumpAndSettle();

    expect(find.text('No treatment notes yet'), findsOneWidget);
  });

  testWidgets('loads the next page when the list nears its end', (tester) async {
    final repo = _FakeRepo([
      TreatmentNotePage(
        items: [for (var i = 0; i < 12; i++) _note('Note $i')],
        nextCursor: 'cur1',
      ),
      TreatmentNotePage(items: [_note('Older note')], nextCursor: null),
    ]);
    await _pump(tester, repo);
    await tester.pumpAndSettle();
    expect(repo.calls, 1);
    expect(repo.cursors, [null]);

    await tester.drag(find.byType(ListView), const Offset(0, -4000));
    await tester.pumpAndSettle();

    // The end-of-list trigger fetched the next page with the returned cursor.
    expect(repo.calls, 2);
    expect(repo.cursors.last, 'cur1');
  });
}
