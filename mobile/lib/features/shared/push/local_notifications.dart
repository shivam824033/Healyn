import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const _channelId = 'healyn_main';
const _channelName = 'Healyn Notifications';

final _plugin = FlutterLocalNotificationsPlugin();

/// Called with a tapped notification's decoded data map when the app is running
/// (foreground or background). The app sets this to route the deep link; the
/// background isolate leaves it null (a tap there is replayed via
/// [notificationLaunchData] on the next resume). Our FCM messages are data-only,
/// so taps arrive here via the local plugin — not via FCM's tap streams.
void Function(Map<String, String> data)? onNotificationTap;

Future<void> initLocalNotifications() async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  await _plugin.initialize(
    const InitializationSettings(android: android),
    onDidReceiveNotificationResponse: _onResponse,
  );
  await _plugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
        _channelId,
        _channelName,
        importance: Importance.high,
      ));
}

void _onResponse(NotificationResponse response) {
  final data = _decodePayload(response.payload);
  if (data != null) onNotificationTap?.call(data);
}

/// The data map of the notification tap that cold-started the app, if any. Used
/// once at startup so a tap from a terminated state still deep-links.
Future<Map<String, String>?> notificationLaunchData() async {
  final details = await _plugin.getNotificationAppLaunchDetails();
  if (details?.didNotificationLaunchApp != true) return null;
  return _decodePayload(details?.notificationResponse?.payload);
}

Map<String, String>? _decodePayload(String? payload) {
  if (payload == null || payload.isEmpty) return null;
  try {
    final decoded = jsonDecode(payload);
    if (decoded is Map) {
      return decoded.map((k, v) => MapEntry('$k', '$v'));
    }
  } catch (_) {
    // A malformed payload is not actionable — drop it rather than crash.
  }
  return null;
}

/// Shows a local notification banner from a data-only FCM payload.
///
/// No PHI: the visible text is built from the event [kind] and the human-friendly
/// appointment number only (a business id, never a name or message body) — the
/// banner can appear on a lock screen, so it must stay PHI-free
/// (SECURITY_GUIDELINES §1, CLAUDE.md Hard Rule #4). The raw data map is carried
/// as the notification `payload` so a tap can deep-link to the right screen.
Future<void> showPushNotification(Map<String, String> data) async {
  final (title, body) = notificationContent(data);
  final id = DateTime.now().millisecondsSinceEpoch.remainder(2147483647);
  await _plugin.show(
    id,
    title,
    body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
    payload: jsonEncode(data),
  );
}

/// Maps a data-only push payload to its user-facing `(title, body)`. Pure and
/// PHI-free: keys off `kind` and uses `appointmentNumber` (a business id) when
/// present, falling back to generic text for legacy payloads that omit it. Never
/// reads a name or message body — none are sent (Hard Rule #4).
(String, String) notificationContent(Map<String, String> data) {
  final number = _appointmentNumber(data);
  return switch (data['kind'] ?? '') {
    'BOOKING_REQUESTED' => (
        'New appointment request',
        number ?? 'A new appointment has been requested.',
      ),
    'BOOKING_CONFIRMED' => (
        'Appointment confirmed',
        number ?? 'Your appointment has been confirmed.',
      ),
    'BOOKING_CANCELLED' => (
        'Appointment cancelled',
        number ?? 'An appointment has been cancelled.',
      ),
    'APPOINTMENT_REMINDER' => (
        'Appointment reminder',
        number ?? 'You have an upcoming appointment.',
      ),
    'DISCUSSION_NEW_MESSAGE' => (
        'New message',
        number != null ? 'In $number' : 'You have a new message.',
      ),
    'TREATMENT_NOTE_ADDED' => (
        'Treatment note added',
        number ?? 'A treatment note has been added.',
      ),
    _ => ('Healyn', 'You have a new notification.'),
  };
}

/// The appointment number from a payload, or null when absent/blank.
String? _appointmentNumber(Map<String, String> data) {
  final n = data['appointmentNumber'];
  return (n == null || n.isEmpty) ? null : n;
}
