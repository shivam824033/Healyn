import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/network/api_exception.dart';
import 'files_api.dart';
import 'models/file_models.dart';

/// Data access for files. Orchestrates the three-step upload and maps transport
/// errors to [ApiException]; the UI talks only to this class, never to Dio.
class FilesRepository {
  FilesRepository(this._api);

  final FilesApi _api;

  /// Uploads one file end-to-end: presign → PUT bytes to storage → complete
  /// (the server validates size + magic bytes). [sizeBytes] is taken from the
  /// actual byte length so it always matches what is PUT. Returns the AVAILABLE
  /// file; its [FileObjectView.id] is what a message references via `file_ids`.
  Future<FileObjectView> upload({
    required String patientId,
    String? appointmentId,
    required FileKind kind,
    required String mimeType,
    required String originalFilename,
    required List<int> bytes,
    String context = FileUploadContext.library,
    String? uploadSource,
  }) async {
    final presigned = await _guard(
      () => _api.presign(
        PresignRequest(
          patientId: patientId,
          appointmentId: appointmentId,
          kind: kind,
          context: context,
          uploadSource: uploadSource,
          mimeType: mimeType,
          sizeBytes: bytes.length,
          originalFilename: originalFilename,
        ),
      ),
    );
    // The PUT goes straight to object storage — a different host than the API.
    // Surface its failures distinctly so an unreachable storage endpoint reads
    // as an upload problem, not a vague API error.
    await _guardUpload(() => _api.putBytes(presigned.upload, bytes));
    return _guard(() => _api.complete(presigned.fileId));
  }

  /// One page of a patient's library documents for the given uploader (the
  /// patient/physio split), newest-first.
  Future<DocumentPage> listDocuments({
    required String patientId,
    required DocumentUploader uploader,
    String? cursor,
    int limit = 20,
  }) {
    return _guard(
      () => _api.listDocuments(
        patientId: patientId,
        uploader: uploader,
        cursor: cursor,
        limit: limit,
      ),
    );
  }

  /// Soft-deletes a document (server enforces the reference + role rules).
  Future<void> delete(String fileId) {
    return _guard(() => _api.deleteFile(fileId));
  }

  /// Resolves a stored file to a short-lived presigned GET URL the caller opens.
  Future<DownloadTarget> download(String fileId) {
    return _guard(() => _api.download(fileId));
  }

  /// Pulls a file's bytes into memory for in-app preview (PDF via pdfx, images
  /// via Image.memory). Nothing is written to disk; the caller drops the buffer
  /// when the viewer closes.
  Future<Uint8List> previewBytes(String fileId) async {
    final target = await _guard(() => _api.download(fileId));
    return _guardStorage(() => _api.fetchBytes(target.url));
  }

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// The direct-to-storage PUT has no Healyn error envelope, so [ApiException.fromDio]
  /// would surface a generic transport message. Map it to a clear upload failure
  /// (the usual cause is a storage endpoint the device can't reach).
  Future<void> _guardUpload(Future<void> Function() body) async {
    try {
      await body();
    } on DioException catch (e) {
      throw ApiException(
        code: 'upload_failed',
        message:
            "Couldn't upload the file to storage. Check your connection and try again.",
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Like [_guardUpload] but for reading bytes back from storage (preview): the
  /// presigned GET hits the storage host, so map its failures to a clear message.
  Future<T> _guardStorage<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on DioException catch (e) {
      throw ApiException(
        code: 'download_failed',
        message:
            "Couldn't load the file from storage. Check your connection and try again.",
        statusCode: e.response?.statusCode,
      );
    }
  }
}

final filesRepositoryProvider = Provider<FilesRepository>(
  (ref) => FilesRepository(ref.watch(filesApiProvider)),
);
