import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App-wide runtime configuration. The API base URL is supplied at build time
/// via `--dart-define=HEALYN_API_BASE_URL=...`.
///
/// Defaults to `10.0.2.2:8080` (the host loopback as seen from an Android
/// emulator). For a physical device, pass your dev machine's LAN IP, e.g.:
///
///   flutter run --dart-define=HEALYN_API_BASE_URL=http://192.168.1.20:8080
class AppConfig {
  const AppConfig({required this.apiBaseUrl});

  factory AppConfig.fromEnvironment() =>
      const AppConfig(apiBaseUrl: _apiBaseUrl);

  final String apiBaseUrl;

  static const String _apiBaseUrl = String.fromEnvironment(
    'HEALYN_API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );
}

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);
