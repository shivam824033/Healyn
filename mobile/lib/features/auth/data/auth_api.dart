import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/network/dio_client.dart';
import 'models/auth_models.dart';

/// Thin transport over the `/auth` endpoints. Returns typed models; DioErrors
/// propagate and are mapped to ApiException one layer up (the repository).
class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  Future<ChallengeResponse> registerStart(RegisterStartRequest body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/register/start',
      data: body.toJson(),
    );
    return ChallengeResponse.fromJson(res.data!);
  }

  Future<TokenResponse> registerComplete(RegisterCompleteRequest body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/register/complete',
      data: body.toJson(),
    );
    return TokenResponse.fromJson(res.data!);
  }

  Future<ChallengeResponse> passwordResetStart(
    PasswordResetStartRequest body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/password-reset/start',
      data: body.toJson(),
    );
    return ChallengeResponse.fromJson(res.data!);
  }

  /// Completes the reset. The backend responds 204 No Content, so there is
  /// nothing to deserialize.
  Future<void> passwordResetComplete(
    PasswordResetCompleteRequest body,
  ) async {
    await _dio.post<void>(
      '/auth/password-reset/complete',
      data: body.toJson(),
    );
  }

  Future<TokenResponse> login(LoginRequest body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: body.toJson(),
    );
    return TokenResponse.fromJson(res.data!);
  }

  Future<SessionListResponse> listSessions() async {
    final res = await _dio.get<Map<String, dynamic>>('/auth/sessions');
    return SessionListResponse.fromJson(res.data!);
  }

  Future<void> revokeSession(String id) async {
    await _dio.delete<void>('/auth/sessions/$id');
  }
}

final authApiProvider = Provider<AuthApi>(
  (ref) => AuthApi(ref.watch(dioProvider)),
);
