import 'package:flutter/painting.dart';

import 'colors.dart';

/// Elevation tokens from UI_UX_GUIDELINES §4.4. Soft, low-contrast shadows in a
/// single ink hue (text.primary) — lift without drama. Cards rest at [e1];
/// hovered cards and sheets at [e2]; modals at [e3].
///
/// Not `const`: the alpha blends use [Color.withValues]. Elevation is never the
/// *only* affordance for interactivity — always pair it with a border or a press
/// state (§4.4).
abstract final class HealynElevation {
  static const Color _ink = HealynColors.textPrimary; // #0F172A

  /// Flat surface — no shadow.
  static const List<BoxShadow> e0 = <BoxShadow>[];

  /// Card. A crisp 1px contact shadow over a soft ambient lift, so a bordered
  /// card reads as gently raised off the scaffold rather than painted onto it.
  static final List<BoxShadow> e1 = [
    BoxShadow(
      color: _ink.withValues(alpha: 0.04),
      offset: const Offset(0, 1),
      blurRadius: 2,
    ),
    BoxShadow(
      color: _ink.withValues(alpha: 0.06),
      offset: const Offset(0, 2),
      blurRadius: 8,
    ),
  ];

  /// Hovered card / sheet — a noticeably wider, softer ambient spread.
  static final List<BoxShadow> e2 = [
    BoxShadow(
      color: _ink.withValues(alpha: 0.05),
      offset: const Offset(0, 2),
      blurRadius: 6,
    ),
    BoxShadow(
      color: _ink.withValues(alpha: 0.08),
      offset: const Offset(0, 8),
      blurRadius: 24,
    ),
  ];

  /// Modal.
  static final List<BoxShadow> e3 = [
    BoxShadow(
      color: _ink.withValues(alpha: 0.12),
      offset: const Offset(0, 12),
      blurRadius: 32,
    ),
  ];
}
