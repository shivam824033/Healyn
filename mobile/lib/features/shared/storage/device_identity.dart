import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'token_store.dart';

/// A stable per-install device id, generated once and persisted in secure
/// storage. The backend keys device sessions on it, so it must survive app
/// restarts (but not reinstalls — a fresh install is a new device).
class DeviceIdentity {
  DeviceIdentity(this._storage);

  final FlutterSecureStorage _storage;

  static const String _kDeviceId = 'healyn.device_id';

  Future<String> getOrCreate() async {
    final existing = await _storage.read(key: _kDeviceId);
    if (existing != null) return existing;
    final id = _randomHex(16);
    await _storage.write(key: _kDeviceId, value: id);
    return id;
  }

  static String _randomHex(int bytes) {
    final rng = Random.secure();
    return List<int>.generate(bytes, (_) => rng.nextInt(256))
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
  }
}

final deviceIdentityProvider = Provider<DeviceIdentity>(
  (ref) => DeviceIdentity(ref.watch(secureStorageProvider)),
);
