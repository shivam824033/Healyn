import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const _channelId = 'healyn_main';
const _channelName = 'Healyn Notifications';

final _plugin = FlutterLocalNotificationsPlugin();

Future<void> initLocalNotifications() async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  await _plugin.initialize(const InitializationSettings(android: android));
  await _plugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
        _channelId,
        _channelName,
        importance: Importance.high,
      ));
}

/// Shows a local notification banner from a data-only FCM payload.
/// No PHI — only generic text derived from the [kind] key.
Future<void> showPushNotification(Map<String, String> data) async {
  final kind = data['kind'] ?? '';
  final (title, body) = _kindContent(kind);
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
  );
}

(String, String) _kindContent(String kind) => switch (kind) {
      'BOOKING_REQUESTED'      => ('New appointment request', 'A new appointment has been requested.'),
      'BOOKING_CONFIRMED'      => ('Appointment confirmed', 'Your appointment has been confirmed.'),
      'BOOKING_CANCELLED'      => ('Appointment cancelled', 'An appointment has been cancelled.'),
      'APPOINTMENT_REMINDER'   => ('Appointment reminder', 'You have an upcoming appointment.'),
      'DISCUSSION_NEW_MESSAGE' => ('New message', 'You have a new message.'),
      'TREATMENT_NOTE_ADDED'   => ('Treatment note added', 'A treatment note has been added.'),
      _                        => ('Healyn', 'You have a new notification.'),
    };
