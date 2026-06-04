import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/files/data/files_api.dart';
import 'package:healyn/features/files/data/files_repository.dart';
import 'package:healyn/features/files/data/models/file_models.dart';

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

  test('download resolves a file id to its presigned GET target', () async {
    final api = _FakeFilesApi();

    final target = await FilesRepository(api).download('f1');

    expect(api.calls, ['download']);
    expect(api.downloadedFileId, 'f1');
    expect(target.url, 'https://store.example/get?sig=xyz');
    expect(target.expiresInSeconds, 300);
  });
}
