import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/files/data/files_api.dart';
import 'package:healyn/features/files/data/files_repository.dart';
import 'package:healyn/features/files/data/models/file_models.dart';
import 'package:healyn/features/shared/network/api_exception.dart';

/// Records the three upload steps in order without touching the network.
class _FakeFilesApi extends FilesApi {
  _FakeFilesApi() : super(Dio(), Dio());

  final List<String> calls = [];
  PresignRequest? presignedWith;
  List<int>? putBytesData;

  @override
  Future<PresignResponse> presign(PresignRequest body) async {
    calls.add('presign');
    presignedWith = body;
    return const PresignResponse(
      fileId: 'f1',
      upload: UploadTarget(
        method: 'PUT',
        url: 'https://store.example/x?sig=abc',
        headers: {'Content-Type': 'application/pdf'},
        expiresInSeconds: 300,
      ),
    );
  }

  @override
  Future<void> putBytes(UploadTarget target, List<int> bytes) async {
    calls.add('put');
    putBytesData = bytes;
  }

  String? downloadedFileId;

  @override
  Future<DownloadTarget> download(String fileId) async {
    calls.add('download');
    downloadedFileId = fileId;
    return const DownloadTarget(
      url: 'https://store.example/get?sig=xyz',
      expiresInSeconds: 300,
    );
  }

  @override
  Future<FileObjectView> complete(String fileId) async {
    calls.add('complete');
    return FileObjectView(
      id: fileId,
      patientId: 'p1',
      ownerAccountId: 'a1',
      kind: FileKind.report,
      mimeType: 'application/pdf',
      originalFilename: 'spine.pdf',
      sizeBytes: putBytesData?.length ?? 0,
      status: FileStatus.available,
    );
  }

  DocumentUploader? listedUploader;
  String? listedPatientId;

  @override
  Future<DocumentPage> listDocuments({
    required String patientId,
    required DocumentUploader uploader,
    String? cursor,
    int limit = 20,
  }) async {
    calls.add('list');
    listedPatientId = patientId;
    listedUploader = uploader;
    return DocumentPage(
      items: [
        FileDocument(
          id: 'd1',
          patientId: patientId,
          kind: FileKind.report,
          mimeType: 'application/pdf',
          originalFilename: 'mri.pdf',
          sizeBytes: 1024,
          uploadedByRole: uploader == DocumentUploader.physio
              ? DocumentUploaderRole.physiotherapist
              : DocumentUploaderRole.patient,
        ),
      ],
    );
  }

  @override
  Future<Uint8List> fetchBytes(String url) async {
    calls.add('fetch');
    return Uint8List.fromList([1, 2, 3]);
  }
}

/// Fails the direct-to-storage PUT the way an unreachable storage host does.
class _PutFailsApi extends _FakeFilesApi {
  @override
  Future<void> putBytes(UploadTarget target, List<int> bytes) async {
    calls.add('put');
    throw DioException(
      requestOptions: RequestOptions(path: target.url),
      type: DioExceptionType.connectionError,
    );
  }
}

void main() {
  test('upload runs presign → put → complete and returns the AVAILABLE file', () async {
    final api = _FakeFilesApi();
    final bytes = List<int>.generate(12, (i) => i);

    final file = await FilesRepository(api).upload(
      patientId: 'p1',
      appointmentId: 'ap1',
      kind: FileKind.report,
      mimeType: 'application/pdf',
      originalFilename: 'spine.pdf',
      bytes: bytes,
    );

    expect(api.calls, ['presign', 'put', 'complete']);
    // size_bytes is derived from the actual bytes, so it always matches the PUT.
    expect(api.presignedWith!.sizeBytes, 12);
    expect(api.putBytesData, bytes);
    expect(file.id, 'f1');
    expect(file.status, FileStatus.available);
  });

  test('upload surfaces a storage-specific error when the PUT fails (no complete)', () async {
    final api = _PutFailsApi();

    await expectLater(
      () => FilesRepository(api).upload(
        patientId: 'p1',
        appointmentId: 'ap1',
        kind: FileKind.report,
        mimeType: 'application/pdf',
        originalFilename: 'spine.pdf',
        bytes: const [1, 2, 3],
      ),
      throwsA(
        isA<ApiException>()
            .having((e) => e.code, 'code', 'upload_failed')
            .having((e) => e.message, 'message', contains('upload')),
      ),
    );
    // Presign happened and the PUT was attempted, but complete is never reached.
    expect(api.calls, ['presign', 'put']);
  });

  test('download resolves a file id to its presigned GET target', () async {
    final api = _FakeFilesApi();

    final target = await FilesRepository(api).download('f1');

    expect(api.calls, ['download']);
    expect(api.downloadedFileId, 'f1');
    expect(target.url, 'https://store.example/get?sig=xyz');
    expect(target.expiresInSeconds, 300);
  });

  test('upload defaults to a standalone LIBRARY document (no appointment)', () async {
    final api = _FakeFilesApi();

    await FilesRepository(api).upload(
      patientId: 'p1',
      kind: FileKind.report,
      mimeType: 'application/pdf',
      originalFilename: 'r.pdf',
      bytes: const [1, 2, 3, 4],
      uploadSource: 'FILE',
    );

    expect(api.presignedWith!.appointmentId, isNull);
    expect(api.presignedWith!.context, 'LIBRARY');
    expect(api.presignedWith!.uploadSource, 'FILE');
  });

  test('listDocuments returns a page for the requested uploader', () async {
    final api = _FakeFilesApi();

    final page = await FilesRepository(api).listDocuments(
      patientId: 'p1',
      uploader: DocumentUploader.physio,
    );

    expect(api.calls, ['list']);
    expect(api.listedPatientId, 'p1');
    expect(api.listedUploader, DocumentUploader.physio);
    expect(page.items.single.uploadedByRole, DocumentUploaderRole.physiotherapist);
  });

  test('previewBytes downloads then pulls the bytes into memory', () async {
    final api = _FakeFilesApi();

    final bytes = await FilesRepository(api).previewBytes('f1');

    expect(api.calls, ['download', 'fetch']);
    expect(bytes, [1, 2, 3]);
  });
}
