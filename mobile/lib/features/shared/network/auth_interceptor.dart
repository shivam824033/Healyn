import 'package:dio/dio.dart';

import '../storage/token_store.dart';

/// Attaches the RS256 access token to authenticated requests and transparently
/// refreshes it on a 401, retrying the original request once.
///
/// Refreshes are single-flight: concurrent 401s share one `/auth/refresh` call
/// so the rotating refresh token isn't spent twice. The retry and the refresh
/// both go through a bare Dio (no interceptor) to avoid re-entering this logic.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStore, this._refreshClient);

  final TokenStore _tokenStore;
  final Dio _refreshClient;

  Future<bool>? _refreshing;

  /// Endpoints that take no bearer (and must not trigger a refresh-on-401).
  static const Set<String> _publicPaths = {
    '/auth/register/start',
    '/auth/register/complete',
    '/auth/login',
    '/auth/refresh',
    '/auth/password-reset/start',
    '/auth/password-reset/complete',
  };

  static bool _isPublic(String path) =>
      _publicPaths.any((p) => path.endsWith(p));

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isPublic(options.path)) {
      final token = await _tokenStore.readAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final alreadyRetried = err.requestOptions.extra['retried'] == true;
    if (!isUnauthorized ||
        alreadyRetried ||
        _isPublic(err.requestOptions.path)) {
      handler.next(err);
      return;
    }

    final refreshed = await _refreshOnce();
    if (!refreshed) {
      await _tokenStore.clear();
      handler.next(err);
      return;
    }

    try {
      final token = await _tokenStore.readAccessToken();
      final options = err.requestOptions
        ..headers['Authorization'] = 'Bearer $token'
        ..extra['retried'] = true;
      final retried = await _refreshClient.fetch<dynamic>(options);
      handler.resolve(retried);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  Future<bool> _refreshOnce() =>
      _refreshing ??= _doRefresh().whenComplete(() => _refreshing = null);

  Future<bool> _doRefresh() async {
    final refreshToken = await _tokenStore.readRefreshToken();
    if (refreshToken == null) return false;
    try {
      final res = await _refreshClient.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      final data = res.data;
      if (data == null) return false;
      await _tokenStore.updateTokens(
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
      );
      return true;
    } on DioException {
      return false;
    }
  }
}
