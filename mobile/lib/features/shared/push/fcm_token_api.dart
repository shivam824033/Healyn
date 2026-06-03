import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/dio_client.dart';
import 'fcm_token_models.dart';

/// Thin transport over `POST /auth/fcm_tokens`. Uses the authenticated
/// [dioProvider] (the AuthInterceptor supplies the bearer + 401 refresh). The
/// backend returns the stored token id, which the client does not need.
class FcmTokenApi {
  FcmTokenApi(this._dio);

  final Dio _dio;

  Future<void> register(FcmTokenRegistration body) async {
    await _dio.post<Map<String, dynamic>>(
      '/auth/fcm_tokens',
      data: body.toJson(),
    );
  }
}

final fcmTokenApiProvider = Provider<FcmTokenApi>(
  (ref) => FcmTokenApi(ref.watch(dioProvider)),
);
