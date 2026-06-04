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
    required String appointmentId,
    required FileKind kind,
    required String mimeType,
    required String originalFilename,
    required List<int> bytes,
  }) {
    return _guard(() async {
      final presigned = await _api.presign(
        PresignRequest(
          patientId: patientId,
          appointmentId: appointmentId,
          kind: kind,
          mimeType: mimeType,
          sizeBytes: bytes.length,
          originalFilename: originalFilename,
        ),
      );
      await _api.putBytes(presigned.upload, bytes);
      return _api.complete(presigned.fileId);
    });
  }

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final filesRepositoryProvider = Provider<FilesRepository>(
  (ref) => FilesRepository(ref.watch(filesApiProvider)),
);
