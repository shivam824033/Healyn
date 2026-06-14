import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/network/api_exception.dart';
import 'models/physio_profile_models.dart';
import 'physio_profile_api.dart';

/// Reads/writes the physiotherapist profile. Maps transport errors to
/// [ApiException]; the UI talks only to this class, never to Dio directly.
class PhysioProfileRepository {
  PhysioProfileRepository(this._api);

  final PhysioProfileApi _api;

  Future<PhysioProfile> get() => _guard(() => _api.get());

  Future<PhysioProfile> update(UpdatePhysioProfileRequest body) =>
      _guard(() => _api.update(body));

  /// Full avatar upload: presign → PUT bytes → confirm. Returns the updated
  /// profile (with a fresh avatar URL).
  Future<PhysioProfile> uploadAvatar({
    required List<int> bytes,
    required String mimeType,
  }) {
    return _guard(() async {
      final target = await _api.presignAvatar(
        mimeType: mimeType,
        sizeBytes: bytes.length,
      );
      await _api.putAvatarBytes(target, bytes);
      return _api.confirmAvatar(
        objectKey: target.objectKey,
        mimeType: mimeType,
      );
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

final physioProfileRepositoryProvider = Provider<PhysioProfileRepository>(
  (ref) => PhysioProfileRepository(ref.watch(physioProfileApiProvider)),
);

/// The physiotherapist profile, shared by the physio editor and the patient home
/// clinic section. Refresh via `ref.invalidate(physioProfileProvider)`.
final physioProfileProvider = FutureProvider.autoDispose<PhysioProfile>(
  (ref) => ref.watch(physioProfileRepositoryProvider).get(),
);
