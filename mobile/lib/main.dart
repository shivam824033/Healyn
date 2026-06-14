import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'features/shared/push/local_notifications.dart';

/// Runs in a separate Dart isolate — must re-initialize Firebase and the
/// local notifications plugin before showing a banner.
@pragma('vm:entry-point')
Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initLocalNotifications();
  final data = message.data.map((k, v) => MapEntry(k, '$v'));
  await showPushNotification(data);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Push is not required to open the app. Initialize it fire-and-forget so a
  // failure or a hung platform-channel call can never delay or block the first
  // frame (which would leave the user on a black screen).
  unawaited(_initPush());
  runApp(const ProviderScope(child: HealynApp()));
}

/// Foreground Firebase + notification setup. Guarded so any failure degrades to
/// "app runs without push" rather than preventing launch.
Future<void> _initPush() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    await initLocalNotifications();
  } catch (e, st) {
    debugPrint('Push init skipped (continuing without it): $e\n$st');
  }
}
