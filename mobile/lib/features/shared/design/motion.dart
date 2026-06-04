import 'package:flutter/animation.dart';

/// Motion tokens from UI_UX_GUIDELINES §7. Motion confirms cause and effect;
/// it never delights for its own sake. No bouncy/elastic curves.
abstract final class HealynMotion {
  static const Duration fast = Duration(milliseconds: 120); // hover, tap
  static const Duration standard = Duration(milliseconds: 220); // nav, sheets
  static const Duration slow = Duration(milliseconds: 320); // large reveals

  /// Default easing — easeOutCubic (§7.2).
  static const Curve standardCurve = Cubic(0.22, 1, 0.36, 1);
}
