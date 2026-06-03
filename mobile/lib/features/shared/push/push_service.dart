import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_exception.dart';
import '../storage/device_identity.dart';
import 'fcm_messaging.dart';
import 'fcm_token_api.dart';
import 'fcm_token_models.dart';

/// Maps a push data payload to an in-app route. The backend sends IDs only
/// (Hard Rule #4); appointment-centric notifications carry `appointmentId`,
/// which deep-links to that appointment's detail. Returns null when there is
/// nothing actionable to open.
String? routeForPush(Map<String, String> data) {
  final appointmentId = data['appointmentId'];
  if (appointmentId != null && appointmentId.isNotEmpty) {
    return '/appointments/$appointmentId';
  }
  return null;
}

/// Registers this device's FCM token with the backend and routes notification
/// taps. Everything degrades to a no-op when Firebase is unconfigured or the
/// user declines permission, and a failed registration is swallowed — push must
/// never block normal app use.
class PushService {
  PushService(this._messaging, this._api, this._deviceIdentity, this._platform);

  final FcmMessaging _messaging;
  final FcmTokenApi _api;
  final DeviceIdentity _deviceIdentity;
  final String _platform;

  StreamSubscription<String>? _refreshSub;
  StreamSubscription<Map<String, String>>? _tapSub;

  /// Registers the current FCM token and keeps it fresh on rotation. Safe to
  /// call repeatedly (e.g. on every authentication and on app bootstrap).
  Future<void> register() async {
    if (!await _messaging.ensureInitialized()) return;
    if (!await _messaging.requestPermission()) return;

    final token = await _messaging.getToken();
    if (token != null) await _registerToken(token);

    _refreshSub ??= _messaging.onTokenRefresh.listen(_registerToken);
  }

  /// Stops push to this install (best-effort) — called on logout.
  Future<void> unregister() async {
    await _refreshSub?.cancel();
    _refreshSub = null;
    if (!await _messaging.ensureInitialized()) return;
    try {
      await _messaging.deleteToken();
    } catch (_) {
      // Best-effort: a cleanup failure must not surface on logout.
    }
  }

  /// Wires notification taps to [onRoute]: the tap that cold-started the app
  /// (if any) plus every tap while it is running. Inert when push is
  /// unconfigured. Idempotent.
  Future<void> wireTaps(void Function(String route) onRoute) async {
    if (!await _messaging.ensureInitialized()) return;

    final initial = await _messaging.getInitialMessage();
    final initialRoute = initial == null ? null : routeForPush(initial);
    if (initialRoute != null) onRoute(initialRoute);

    _tapSub ??= _messaging.onMessageOpenedApp.listen((data) {
      final route = routeForPush(data);
      if (route != null) onRoute(route);
    });
  }

  /// Cancels the token-refresh and tap subscriptions (wired to provider dispose).
  void dispose() {
    _refreshSub?.cancel();
    _tapSub?.cancel();
  }

  Future<void> _registerToken(String token) async {
    final deviceId = await _deviceIdentity.getOrCreate();
    try {
      await _api.register(
        FcmTokenRegistration(
          token: token,
          platform: _platform,
          deviceId: deviceId,
        ),
      );
    } on ApiException {
      // A failed registration is swallowed; the next refresh or app start
      // retries. Never block the user on a push-token call.
    }
  }
}

final pushServiceProvider = Provider<PushService>((ref) {
  final service = PushService(
    FirebaseFcmMessaging(),
    ref.watch(fcmTokenApiProvider),
    ref.watch(deviceIdentityProvider),
    _platformTag(),
  );
  ref.onDispose(service.dispose);
  return service;
});

String _platformTag() =>
    defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';
