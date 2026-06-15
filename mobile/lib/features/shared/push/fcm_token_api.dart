import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/dio_client.dart';
import 'fcm_token_models.dart';

/// Thin transport over `/auth/fcm_tokens`. Uses the authenticated [dioProvider]
/// (the AuthInterceptor supplies the bearer + 401 refresh). The backend returns
/// the stored token id on register, which the client does not need.
class FcmTokenApi {
  FcmTokenApi(this._dio);

  final Dio _dio;

  Future<void> register(FcmTokenRegistration body) async {
    await _dio.post<Map<String, dynamic>>(
      '/auth/fcm_tokens',
      data: body.toJson(),
    );
  }

  /// Retires this device's push token server-side (logout). Must be called while
  /// still authenticated, before the local FCM token is deleted — the backend
  /// keys off [deviceId] (account is taken from the bearer), so the row is
  /// unlinked even though FCM may already have invalidated the token string.
  Future<void> unregister(String deviceId) async {
    await _dio.delete<void>(
      '/auth/fcm_tokens',
      data: <String, dynamic>{'device_id': deviceId},
    );
  }
}

final fcmTokenApiProvider = Provider<FcmTokenApi>(
  (ref) => FcmTokenApi(ref.watch(dioProvider)),
);
