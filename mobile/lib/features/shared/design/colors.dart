import 'package:flutter/painting.dart';

/// Color tokens from UI_UX_GUIDELINES §2. Light mode only (Phase 1); dark mode
/// (Phase 2) is a token swap, not a re-skin. One brand color, used sparingly.
abstract final class HealynColors {
  // Brand
  static const Color brandPrimary = Color(0xFF1E88A8);
  static const Color brandPrimaryHover = Color(0xFF176E89);
  static const Color brandPrimarySubtle = Color(0xFFE6F2F6);

  // Surfaces
  static const Color surfaceBase = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF7F8FA);
  static const Color surfaceElevated = Color(0xFFFFFFFF);

  // Borders
  static const Color borderSubtle = Color(0xFFE5E7EB);
  static const Color borderStrong = Color(0xFF9CA3AF);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Semantic / status
  static const Color statusSuccess = Color(0xFF16A34A);
  static const Color statusWarning = Color(0xFFD97706);
  static const Color statusDanger = Color(0xFFDC2626);
  static const Color statusInfo = Color(0xFF2563EB);
}
