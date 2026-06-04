import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/network/dio_client.dart';
import 'models/file_models.dart';

/// Thin transport for the `/files` endpoints plus the direct-to-storage PUT.
/// Two clients: [_dio] (the authenticated app client) for the API calls, and
/// [_uploadDio] (bare, no auth) for the presigned PUT. DioErrors propagate and
/// are mapped to [ApiException] in the repository.
class FilesApi {
  FilesApi(this._dio, this._uploadDio);

  final Dio _dio;
  final Dio _uploadDio;

  /// Reserves a `PENDING_UPLOAD` file row and returns where to PUT its bytes.
  Future<PresignResponse> presign(PresignRequest body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/files/presign',
      data: body.toJson(),
    );
    return PresignResponse.fromJson(res.data!);
  }

  /// Uploads [bytes] straight to object storage using the presigned PUT. Sends
  /// exactly the headers the presign returned (the storage signed the
  /// Content-Type) plus an explicit Content-Length for the streamed body.
  Future<void> putBytes(UploadTarget target, List<int> bytes) async {
    final headers = <String, dynamic>{
      ...target.headers,
      Headers.contentLengthHeader: bytes.length,
    };
    await _uploadDio.put<void>(
      target.url,
      data: Stream<List<int>>.fromIterable([bytes]),
      options: Options(headers: headers),
    );
  }

  /// Signals upload completion; the server verifies presence, size, and magic
  /// bytes and promotes the file to `AVAILABLE` (or `QUARANTINED` on mismatch).
  Future<FileObjectView> complete(String fileId) async {
    final res = await _dio.post<Map<String, dynamic>>('/files/$fileId/complete');
    return FileObjectView.fromJson(res.data!);
  }

  /// Resolves a file to a short-lived presigned GET URL (the server enforces the
  /// per-patient access policy and records a DOWNLOAD audit event).
  Future<DownloadTarget> download(String fileId) async {
    final res = await _dio.get<Map<String, dynamic>>('/files/$fileId/download');
    return DownloadTarget.fromJson(res.data!);
  }
}

final filesApiProvider = Provider<FilesApi>(
  (ref) => FilesApi(ref.watch(dioProvider), ref.watch(uploadDioProvider)),
);
