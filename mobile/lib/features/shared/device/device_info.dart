import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Resolves a human-readable name for the current device (e.g. "Samsung SM-S921B")
/// for the session's device label, so the "Signed-in devices" list shows the real
/// hardware instead of a constant app name.
///
/// Backed by a tiny platform channel — Android reads `Build.MANUFACTURER`/`MODEL`
/// (see MainActivity). When the channel has no handler (iOS today, widget tests)
/// or fails, it falls back to a platform-derived label so the value is never blank
/// and never blocks session creation. No PHI is involved — this is hardware info.
class DeviceInfo {
  const DeviceInfo();

  static const MethodChannel _channel = MethodChannel('healyn/device_info');

  Future<String> deviceLabel() async {
    try {
      final label = await _channel.invokeMethod<String>('deviceLabel');
      if (label != null && label.trim().isNotEmpty) return label.trim();
    } on MissingPluginException {
      // No native handler on this platform — use the generic label below.
    } on PlatformException {
      // Native side failed — fall back rather than fail the login/registration.
    }
    return _fallbackLabel();
  }

  String _fallbackLabel() {
    if (Platform.isIOS) return 'iPhone';
    if (Platform.isAndroid) return 'Android device';
    return '${_capitalize(Platform.operatingSystem)} device';
  }

  static String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}

final deviceInfoProvider = Provider<DeviceInfo>((ref) => const DeviceInfo());
