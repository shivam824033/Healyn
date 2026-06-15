import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/network/api_exception.dart';
import 'models/promotion_models.dart';
import 'promotions_api.dart';

/// Reads/writes clinic promotions. Maps transport errors to [ApiException]; the UI
/// talks only to this class, never to Dio directly.
class PromotionsRepository {
  PromotionsRepository(this._api);

  final PromotionsApi _api;

  Future<List<Promotion>> listForPatient() =>
      _guard(() => _api.listForPatient());

  Future<List<ManagedPromotion>> listForManagement() =>
      _guard(() => _api.listForManagement());

  Future<ManagedPromotion> create(CreatePromotionRequest body) =>
      _guard(() => _api.create(body));

  Future<ManagedPromotion> update(String id, UpdatePromotionRequest body) =>
      _guard(() => _api.update(id, body));

  Future<ManagedPromotion> setActive(String id, {required bool active}) =>
      _guard(() => _api.setActive(id, active: active));

  Future<List<ManagedPromotion>> reorder(List<String> orderedIds) =>
      _guard(() => _api.reorder(orderedIds));

  Future<void> delete(String id) => _guard(() => _api.delete(id));

  /// Full cover upload: presign → PUT bytes → confirm. Returns the updated promotion.
  Future<ManagedPromotion> uploadCover({
    required String id,
    required List<int> bytes,
    required String mimeType,
  }) {
    return _guard(() async {
      final target = await _api.presignCover(
        id,
        mimeType: mimeType,
        sizeBytes: bytes.length,
      );
      await _api.putCoverBytes(target, bytes);
      return _api.confirmCover(id, objectKey: target.objectKey, mimeType: mimeType);
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

final promotionsRepositoryProvider = Provider<PromotionsRepository>(
  (ref) => PromotionsRepository(ref.watch(promotionsApiProvider)),
);

/// Active, in-window promotions for the patient Home carousel. Refresh via
/// `ref.invalidate(patientPromotionsProvider)`.
final patientPromotionsProvider =
    FutureProvider.autoDispose<List<Promotion>>(
  (ref) => ref.watch(promotionsRepositoryProvider).listForPatient(),
);

/// Every non-deleted promotion for the physiotherapist's management list.
final managedPromotionsProvider =
    FutureProvider.autoDispose<List<ManagedPromotion>>(
  (ref) => ref.watch(promotionsRepositoryProvider).listForManagement(),
);
