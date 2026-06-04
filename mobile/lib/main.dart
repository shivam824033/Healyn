import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'features/shared/push/local_notifications.dart';

/// Runs in a separate Dart isolate — must re-initialize Firebase and the
/// local notifications plugin before showing a banner.
@pragma('vm:entry-point')
Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await initLocalNotifications();
  final data = message.data.map((k, v) => MapEntry(k, '$v'));
  await showPushNotification(data);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  await initLocalNotifications();
  runApp(const ProviderScope(child: HealynApp()));
}
