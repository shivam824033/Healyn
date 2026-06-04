import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Seam over the platform URL launcher so attachment-opening stays unit-testable
/// — no plugin or platform channel runs in tests, which inject a fake instead.
abstract interface class UrlOpener {
  /// Opens [url] in the OS browser / native viewer. Returns `false` when no
  /// handler could be launched.
  Future<bool> open(String url);
}

/// Real implementation backed by `url_launcher`. Opens externally so a
/// presigned attachment URL is handled by the browser/native viewer and no
/// bytes ever land in the app's storage.
class LaunchUrlOpener implements UrlOpener {
  const LaunchUrlOpener();

  @override
  Future<bool> open(String url) =>
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

final urlOpenerProvider = Provider<UrlOpener>((ref) => const LaunchUrlOpener());
