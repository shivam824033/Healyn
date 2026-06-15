import 'package:dio/dio.dart';

import '../storage/token_store.dart';

/// Attaches the RS256 access token to authenticated requests and transparently
/// refreshes it on a 401, retrying the original request once.
///
/// Refreshes are single-flight: concurrent 401s share one `/auth/refresh` call
/// so the rotating refresh token isn't spent twice. The retry and the refresh
/// both go through a bare Dio (no interceptor) to avoid re-entering this logic.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStore, this._refreshClient, {this.onSessionExpired});

  final TokenStore _tokenStore;
  final Dio _refreshClient;

  /// Called once when an authenticated request fails with 401 and even a refresh
  /// can't recover it — i.e. the session is gone (this device was signed out, or
  /// the refresh token is dead). Local tokens are already cleared by then; the
  /// callback lets the app flip to logged-out and bounce to the login screen.
  final void Function()? onSessionExpired;

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
      // Legal documents are public (readable during registration, before any
      // token exists) — never attach a bearer or trigger refresh-on-401.
      path.contains('/legal/') || _publicPaths.any((p) => path.endsWith(p));

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
      // The session is irrecoverable (revoked / signed out elsewhere). Clear the
      // stranded tokens and let the app react by sending the user to login.
      await _tokenStore.clear();
      onSessionExpired?.call();
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
