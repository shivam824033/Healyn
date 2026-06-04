import 'package:flutter/widgets.dart';

import 'colors.dart';

/// Type scale from UI_UX_GUIDELINES §3.2. Hierarchy comes from type, not boxes.
///
/// Inter is the intended family (§3.1). Until the Inter TTFs are bundled under
/// `assets/fonts/` and declared in `pubspec.yaml`, [fontFamily] is null and the
/// platform default is used — the scale (size/height/weight) is what matters
/// and is correct now; swapping in Inter later is a one-line change here.
abstract final class HealynTypography {
  static const String? fontFamily = null; // TODO: bundle Inter, set to 'Inter'.

  static const TextStyle display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w700,
    color: HealynColors.textPrimary,
  );

  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w700,
    color: HealynColors.textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
    color: HealynColors.textPrimary,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    height: 24 / 17,
    fontWeight: FontWeight.w600,
    color: HealynColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w400,
    color: HealynColors.textPrimary,
  );

  static const TextStyle bodyStrong = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w600,
    color: HealynColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
    color: HealynColors.textSecondary,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    height: 16 / 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    color: HealynColors.textSecondary,
  );
}
