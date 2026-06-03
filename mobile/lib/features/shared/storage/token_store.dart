import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists auth tokens in the platform secure enclave (Keychain / Keystore).
///
/// CLAUDE.md §11: never cache PHI or tokens in plain SharedPreferences — tokens
/// live in `flutter_secure_storage` only. The session id is stored too so the
/// app can revoke its own session on logout.
class TokenStore {
  TokenStore(this._storage);

  final FlutterSecureStorage _storage;

  static const String _kAccess = 'healyn.access_token';
  static const String _kRefresh = 'healyn.refresh_token';
  static const String _kSession = 'healyn.session_id';

  Future<String?> readAccessToken() => _storage.read(key: _kAccess);

  Future<String?> readRefreshToken() => _storage.read(key: _kRefresh);

  Future<String?> readSessionId() => _storage.read(key: _kSession);

  Future<bool> hasSession() async => (await readRefreshToken()) != null;

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String sessionId,
  }) async {
    await _storage.write(key: _kAccess, value: accessToken);
    await _storage.write(key: _kRefresh, value: refreshToken);
    await _storage.write(key: _kSession, value: sessionId);
  }

  /// Rotates just the token pair after a refresh; the session id is unchanged.
  Future<void> updateTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _kAccess, value: accessToken);
    await _storage.write(key: _kRefresh, value: refreshToken);
  }

  Future<void> clear() async {
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
    await _storage.delete(key: _kSession);
  }
}

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

final tokenStoreProvider = Provider<TokenStore>(
  (ref) => TokenStore(ref.watch(secureStorageProvider)),
);
