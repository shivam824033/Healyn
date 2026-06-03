import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Seam over the Firebase Messaging plugin so [PushService] logic stays
/// unit-testable (no plugin, no platform channels in tests). The data maps are
/// flattened to `Map<String, String>` because the backend sends data-only
/// messages whose values are always strings (IDs only — Hard Rule #4).
abstract interface class FcmMessaging {
  /// Initializes Firebase if native config is present. Returns `false` (a no-op
  /// for the caller) when Firebase is not configured, so the app never crashes
  /// on a build without `google-services.json` / `GoogleService-Info.plist`.
  Future<bool> ensureInitialized();

  /// Asks the OS for notification permission. Returns whether it was granted.
  Future<bool> requestPermission();

  Future<String?> getToken();

  Stream<String> get onTokenRefresh;

  Future<void> deleteToken();

  /// A notification tapped while the app was backgrounded.
  Stream<Map<String, String>> get onMessageOpenedApp;

  /// The notification tap that cold-started the app, if any.
  Future<Map<String, String>?> getInitialMessage();
}

/// Real implementation backed by `FirebaseMessaging.instance`.
class FirebaseFcmMessaging implements FcmMessaging {
  bool _initialized = false;

  @override
  Future<bool> ensureInitialized() async {
    if (_initialized) return true;
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      _initialized = true;
      return true;
    } catch (_) {
      // No native Firebase config on this build — push stays disabled. Nothing
      // sensitive to log here.
      return false;
    }
  }

  @override
  Future<bool> requestPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission();
    final status = settings.authorizationStatus;
    return status == AuthorizationStatus.authorized ||
        status == AuthorizationStatus.provisional;
  }

  @override
  Future<String?> getToken() => FirebaseMessaging.instance.getToken();

  @override
  Stream<String> get onTokenRefresh =>
      FirebaseMessaging.instance.onTokenRefresh;

  @override
  Future<void> deleteToken() => FirebaseMessaging.instance.deleteToken();

  @override
  Stream<Map<String, String>> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp.map(_data);

  @override
  Future<Map<String, String>?> getInitialMessage() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();
    return message == null ? null : _data(message);
  }

  static Map<String, String> _data(RemoteMessage message) =>
      message.data.map((k, v) => MapEntry(k, '$v'));
}
