import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/files/data/files_api.dart';
import 'package:healyn/features/files/data/files_repository.dart';
import 'package:healyn/features/files/data/models/file_models.dart';
import 'package:healyn/features/files/presentation/screens/patient_documents_screen.dart';

/// Returns one document per uploader so the two sections are populated.
class _FakeDocsRepo extends FilesRepository {
  _FakeDocsRepo() : super(FilesApi(Dio(), Dio()));

  @override
  Future<DocumentPage> listDocuments({
    required String patientId,
    required DocumentUploader uploader,
    String? cursor,
    int limit = 20,
  }) async {
    final isPhysio = uploader == DocumentUploader.physio;
    return DocumentPage(
      items: [
        FileDocument(
          id: '${uploader.query}-1',
          patientId: patientId,
          kind: FileKind.report,
          mimeType: 'application/pdf',
          originalFilename: isPhysio ? 'exercise-plan.pdf' : 'my-mri.pdf',
          sizeBytes: 100,
          uploadedByRole: isPhysio
              ? DocumentUploaderRole.physiotherapist
              : DocumentUploaderRole.patient,
          createdAt: DateTime.utc(2026, 6, 13),
        ),
      ],
    );
  }
}

/// Returns no documents, to exercise the empty states.
class _EmptyDocsRepo extends FilesRepository {
  _EmptyDocsRepo() : super(FilesApi(Dio(), Dio()));

  @override
  Future<DocumentPage> listDocuments({
    required String patientId,
    required DocumentUploader uploader,
    String? cursor,
    int limit = 20,
  }) async => const DocumentPage();
}

Widget _host(Widget child, FilesRepository repo) => ProviderScope(
  overrides: [filesRepositoryProvider.overrideWithValue(repo)],
  child: MaterialApp(home: child),
);

void main() {
  testWidgets('renders both sections split by uploader (patient viewer)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const PatientDocumentsScreen(patientId: 'p1', patientName: 'John'),
        _FakeDocsRepo(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Uploaded by physiotherapist'), findsOneWidget);
    expect(find.text('Uploaded by you'), findsOneWidget);
    expect(find.text('exercise-plan.pdf'), findsOneWidget);
    expect(find.text('my-mri.pdf'), findsOneWidget);
    expect(find.text('John'), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);
    // The patient cannot delete the physio document, so only their own has a
    // delete affordance.
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
  });

  testWidgets('physio viewer can delete either document', (tester) async {
    await tester.pumpWidget(
      _host(
        const PatientDocumentsScreen(
          patientId: 'p1',
          viewer: DocumentsViewer.physio,
        ),
        _FakeDocsRepo(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Uploaded by patient'), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsNWidgets(2));
  });

  testWidgets('shows an empty state per section when there are no documents', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(const PatientDocumentsScreen(patientId: 'p1'), _EmptyDocsRepo()),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('No documents from your physiotherapist yet.'),
      findsOneWidget,
    );
    expect(find.text('No documents uploaded yet.'), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsNothing);
  });
}
