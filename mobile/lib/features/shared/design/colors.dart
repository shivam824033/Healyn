import 'package:flutter/painting.dart';

/// Color tokens from UI_UX_GUIDELINES §2. Light mode only (Phase 1); dark mode
/// (Phase 2) is a token swap, not a re-skin. One brand color, used sparingly.
abstract final class HealynColors {
  // Brand — premium indigo (§2.1). One hue: primary for actions/active states,
  // hover for the pressed step, subtle for selected backgrounds and tonal chips.
  static const Color brandPrimary = Color(0xFF3B4AA0);
  static const Color brandPrimaryHover = Color(0xFF2E3A82);
  static const Color brandPrimarySubtle = Color(0xFFECEDF9);

  /// The signature indigo gradient — used on headers (and the selected calendar
  /// day) for a premium, depth-rich brand surface. A diagonal blend from
  /// [brandPrimary] into the deeper [brandPrimaryHover].
  static const Gradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandPrimary, brandPrimaryHover],
  );

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
