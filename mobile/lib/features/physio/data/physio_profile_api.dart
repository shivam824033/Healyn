import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/network/dio_client.dart';
import 'models/physio_profile_models.dart';

/// Thin transport for the `/physio/profile` endpoints plus the direct-to-storage
/// avatar PUT. Two clients: [_dio] (authenticated) for the API, [_uploadDio]
/// (bare, no auth) for the presigned PUT. DioErrors propagate; the repository
/// maps them to ApiException.
class PhysioProfileApi {
  PhysioProfileApi(this._dio, this._uploadDio);

  final Dio _dio;
  final Dio _uploadDio;

  /// The physiotherapist's profile (readable by any authenticated account).
  Future<PhysioProfile> get() async {
    final res = await _dio.get<Map<String, dynamic>>('/physio/profile');
    return PhysioProfile.fromJson(res.data!);
  }

  /// Saves the editable fields (physiotherapist only); returns the updated profile.
  Future<PhysioProfile> update(UpdatePhysioProfileRequest body) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '/physio/profile',
      data: body.toJson(),
    );
    return PhysioProfile.fromJson(res.data!);
  }

  /// Reserves an avatar object key and returns where to PUT the bytes.
  Future<AvatarPresign> presignAvatar({
    required String mimeType,
    required int sizeBytes,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/physio/profile/avatar/presign',
      data: <String, dynamic>{'mime_type': mimeType, 'size_bytes': sizeBytes},
    );
    return AvatarPresign.fromJson(res.data!);
  }

  /// Uploads [bytes] straight to object storage using the presigned PUT, sending
  /// the Content-Type the storage signed plus an explicit Content-Length.
  Future<void> putAvatarBytes(AvatarPresign target, List<int> bytes) async {
    await _uploadDio.put<void>(
      target.url,
      data: Stream<List<int>>.fromIterable([bytes]),
      options: Options(
        headers: <String, dynamic>{
          Headers.contentTypeHeader: target.contentType,
          Headers.contentLengthHeader: bytes.length,
        },
      ),
    );
  }

  /// Verifies the uploaded avatar server-side and sets it on the profile.
  Future<PhysioProfile> confirmAvatar({
    required String objectKey,
    required String mimeType,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/physio/profile/avatar/confirm',
      data: <String, dynamic>{'object_key': objectKey, 'mime_type': mimeType},
    );
    return PhysioProfile.fromJson(res.data!);
  }
}

final physioProfileApiProvider = Provider<PhysioProfileApi>(
  (ref) =>
      PhysioProfileApi(ref.watch(dioProvider), ref.watch(uploadDioProvider)),
);
