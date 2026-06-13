import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/device/device_info.dart';
import '../../shared/network/api_exception.dart';
import '../../shared/storage/device_identity.dart';
import '../../shared/storage/token_store.dart';
import 'auth_api.dart';
import 'models/auth_models.dart';

/// Orchestrates the auth flows: calls [AuthApi], maps transport errors to
/// [ApiException], and persists the issued tokens in the [TokenStore]. The UI
/// talks only to this class, never to Dio directly.
class AuthRepository {
  AuthRepository(this._api, this._tokenStore, this._deviceIdentity, this._deviceInfo);

  final AuthApi _api;
  final TokenStore _tokenStore;
  final DeviceIdentity _deviceIdentity;
  final DeviceInfo _deviceInfo;

  /// Step 1 of registration — sends an OTP to the target. Returns the
  /// challenge id that ties the OTP to step 2.
  Future<String> startRegistration(ContactTarget target) async {
    return _guard(() async {
      final res = await _api.registerStart(
        RegisterStartRequest(target: target),
      );
      return res.challengeId;
    });
  }

  /// Step 2 of registration — verifies the OTP, sets the password and primary
  /// patient profile, and starts a session.
  Future<void> completeRegistration({
    required String challengeId,
    required String code,
    required String password,
    required PrimaryPatientProfile profile,
  }) async {
    await _guard(() async {
      final token = await _api.registerComplete(
        RegisterCompleteRequest(
          challengeId: challengeId,
          code: code,
          password: password,
          device: await _device(),
          profile: profile,
        ),
      );
      await _persist(token);
    });
  }

  /// Step 1 of password reset — sends an OTP to the target. Returns the
  /// challenge id that ties the OTP to step 2. Mirrors [startRegistration].
  Future<String> startPasswordReset(ContactTarget target) async {
    return _guard(() async {
      final res = await _api.passwordResetStart(
        PasswordResetStartRequest(target: target),
      );
      return res.challengeId;
    });
  }

  /// Step 2 of password reset — verifies the OTP and sets the new password. No
  /// session is issued (the backend responds 204); the user signs in afterward.
  Future<void> completePasswordReset({
    required String challengeId,
    required String code,
    required String newPassword,
  }) async {
    await _guard(() async {
      await _api.passwordResetComplete(
        PasswordResetCompleteRequest(
          challengeId: challengeId,
          code: code,
          newPassword: newPassword,
        ),
      );
    });
  }

  Future<void> login({
    required String emailOrPhone,
    required String password,
  }) async {
    await _guard(() async {
      final token = await _api.login(
        LoginRequest(
          emailOrPhone: emailOrPhone,
          password: password,
          device: await _device(),
        ),
      );
      await _persist(token);
    });
  }

  Future<List<SessionView>> listSessions() async {
    return _guard(() async => (await _api.listSessions()).sessions);
  }

  /// Revokes one device's session by id — the per-device "Sign out this device"
  /// action. Local tokens are untouched; revoking *this* device is [logout].
  Future<void> revokeSession(String id) async {
    await _guard(() => _api.revokeSession(id));
  }

  /// The id of this device's own session, so the devices list can mark and guard
  /// the current device (it can't sign itself out from the list — that's [logout]).
  Future<String?> currentSessionId() => _tokenStore.readSessionId();

  /// Revokes this device's session server-side, then clears local tokens.
  /// Local tokens are cleared even if the revoke call fails.
  Future<void> logout() async {
    final sessionId = await _tokenStore.readSessionId();
    try {
      if (sessionId != null) await _api.revokeSession(sessionId);
    } on DioException {
      // Best-effort: a failed revoke must not strand the user logged-in locally.
    } finally {
      await _tokenStore.clear();
    }
  }

  Future<DeviceRequest> _device() async => DeviceRequest(
    deviceId: await _deviceIdentity.getOrCreate(),
    // The real device name (e.g. "Samsung SM-S921B"), so each session in the
    // "Signed-in devices" list is identifiable instead of a constant app name.
    deviceLabel: await _deviceInfo.deviceLabel(),
    // fcmToken stays null here: the push token is registered out-of-band via
    // POST /auth/fcm_tokens (see shared/push/PushService), not inline at login —
    // the token may not exist yet until the user grants notification permission.
  );

  Future<void> _persist(TokenResponse t) => _tokenStore.saveSession(
    accessToken: t.accessToken,
    refreshToken: t.refreshToken,
    sessionId: t.sessionId,
  );

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    ref.watch(authApiProvider),
    ref.watch(tokenStoreProvider),
    ref.watch(deviceIdentityProvider),
    ref.watch(deviceInfoProvider),
  ),
);
