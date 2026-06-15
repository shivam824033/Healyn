import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/network/dio_client.dart';
import 'models/promotion_models.dart';

/// Thin transport for the `/promotions` endpoints plus the direct-to-storage cover
/// PUT. Two clients: [_dio] (authenticated) for the API, [_uploadDio] (bare) for the
/// presigned PUT. DioErrors propagate; the repository maps them to ApiException.
class PromotionsApi {
  PromotionsApi(this._dio, this._uploadDio);

  final Dio _dio;
  final Dio _uploadDio;

  /// Active, in-window promotions for the patient surface (any authenticated account).
  Future<List<Promotion>> listForPatient() async {
    final res = await _dio.get<Map<String, dynamic>>('/promotions');
    final list = (res.data!['promotions'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();
    return list.map(Promotion.fromJson).toList();
  }

  /// Every non-deleted promotion for the physiotherapist's management view.
  Future<List<ManagedPromotion>> listForManagement() async {
    final res = await _dio.get<Map<String, dynamic>>('/promotions/manage');
    final list = (res.data!['promotions'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();
    return list.map(ManagedPromotion.fromJson).toList();
  }

  Future<ManagedPromotion> create(CreatePromotionRequest body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/promotions',
      data: body.toJson(),
    );
    return ManagedPromotion.fromJson(res.data!);
  }

  Future<ManagedPromotion> update(String id, UpdatePromotionRequest body) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '/promotions/$id',
      data: body.toJson(),
    );
    return ManagedPromotion.fromJson(res.data!);
  }

  Future<ManagedPromotion> setActive(String id, {required bool active}) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/promotions/$id/active',
      data: <String, dynamic>{'active': active},
    );
    return ManagedPromotion.fromJson(res.data!);
  }

  Future<List<ManagedPromotion>> reorder(List<String> orderedIds) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/promotions/reorder',
      data: <String, dynamic>{'ordered_ids': orderedIds},
    );
    final list = (res.data!['promotions'] as List<dynamic>? ?? const [])
        .cast<Map<String, dynamic>>();
    return list.map(ManagedPromotion.fromJson).toList();
  }

  Future<void> delete(String id) async {
    await _dio.delete<void>('/promotions/$id');
  }

  Future<CoverPresign> presignCover(
    String id, {
    required String mimeType,
    required int sizeBytes,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/promotions/$id/cover/presign',
      data: <String, dynamic>{'mime_type': mimeType, 'size_bytes': sizeBytes},
    );
    return CoverPresign.fromJson(res.data!);
  }

  Future<void> putCoverBytes(CoverPresign target, List<int> bytes) async {
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

  Future<ManagedPromotion> confirmCover(
    String id, {
    required String objectKey,
    required String mimeType,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/promotions/$id/cover/confirm',
      data: <String, dynamic>{'object_key': objectKey, 'mime_type': mimeType},
    );
    return ManagedPromotion.fromJson(res.data!);
  }
}

final promotionsApiProvider = Provider<PromotionsApi>(
  (ref) => PromotionsApi(ref.watch(dioProvider), ref.watch(uploadDioProvider)),
);
