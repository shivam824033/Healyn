import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_exception.dart';
import '../storage/device_identity.dart';
import 'fcm_messaging.dart';
import 'fcm_token_api.dart';
import 'fcm_token_models.dart';
import 'local_notifications.dart';

/// Maps a push data payload to an in-app route. The backend sends IDs only
/// (Hard Rule #4); every actionable notification carries `appointmentId`.
///
/// A `DISCUSSION_NEW_MESSAGE` opens the appointment's discussion thread; every
/// other (appointment-lifecycle) kind opens its detail. The route is
/// role-scoped: a physiotherapist's screens live under `/physio/*` (the router
/// redirect bounces a physio out of the patient routes, so the prefix matters).
/// Returns null when there is nothing actionable to open.
String? routeForPush(Map<String, String> data, {required bool isPhysio}) {
  final appointmentId = data['appointmentId'];
  if (appointmentId == null || appointmentId.isEmpty) return null;
  final base = isPhysio
      ? '/physio/appointments/$appointmentId'
      : '/appointments/$appointmentId';
  return data['kind'] == 'DISCUSSION_NEW_MESSAGE' ? '$base/discussion' : base;
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
  StreamSubscription<Map<String, String>>? _messageSub;
  StreamSubscription<Map<String, String>>? _tapSub;

  /// Registers the current FCM token and keeps it fresh on rotation. Safe to
  /// call repeatedly (e.g. on every authentication and on app bootstrap).
  Future<void> register() async {
    if (!await _messaging.ensureInitialized()) return;
    if (!await _messaging.requestPermission()) return;

    final token = await _messaging.getToken();
    if (token != null) await _registerToken(token);

    _refreshSub ??= _messaging.onTokenRefresh.listen(_registerToken);
    _messageSub ??= _messaging.onMessage.listen(showPushNotification);
  }

  /// Tears down push for this install on logout. Order matters: unlink the token
  /// on the backend *first* (while the session is still authenticated) so the
  /// signed-out device stops resolving as a delivery target, then stop local
  /// delivery. The account's other devices are untouched (the backend keys off
  /// this device id). Every step is best-effort — logout must never be blocked.
  Future<void> unregister() async {
    await _refreshSub?.cancel();
    _refreshSub = null;
    await _messageSub?.cancel();
    _messageSub = null;

    final deviceId = await _deviceIdentity.getOrCreate();
    try {
      await _api.unregister(deviceId);
    } catch (_) {
      // A failed backend unlink must not strand logout: the FCM token deletion
      // below still stops delivery, and the dispatcher retires the row lazily
      // on its next failed send.
    }

    try {
      await clearAllNotifications();
    } catch (_) {
      // Best-effort: clearing shown banners must not surface on logout.
    }

    if (!await _messaging.ensureInitialized()) return;
    try {
      await _messaging.deleteToken();
    } catch (_) {
      // Best-effort: a cleanup failure must not surface on logout.
    }
  }

  /// Wires FCM notification taps to [onData], delivering the raw payload so the
  /// caller can resolve the route with the live account role: the tap that
  /// cold-started the app (if any) plus every tap while it is running. Inert when
  /// push is unconfigured. Idempotent.
  ///
  /// Note: the backend sends data-only messages, whose taps are delivered by the
  /// local-notifications plugin, not these FCM streams. This path is kept for
  /// robustness (and any future notification-type messages); the local plugin's
  /// tap callback is the primary route for this app.
  Future<void> wireTaps(void Function(Map<String, String> data) onData) async {
    if (!await _messaging.ensureInitialized()) return;

    final initial = await _messaging.getInitialMessage();
    if (initial != null) onData(initial);

    _tapSub ??= _messaging.onMessageOpenedApp.listen(onData);
  }

  /// Cancels the token-refresh and tap subscriptions (wired to provider dispose).
  void dispose() {
    _refreshSub?.cancel();
    _messageSub?.cancel();
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
