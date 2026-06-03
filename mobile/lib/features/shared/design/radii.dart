import 'package:flutter/painting.dart';

/// Corner-radius tokens from UI_UX_GUIDELINES §4.3. Don't mix radii on one
/// surface: a radius-lg card holds radius-md controls, never the reverse.
abstract final class HealynRadii {
  static const double sm = 6; // pills, badges
  static const double md = 10; // inputs, small buttons
  static const double lg = 14; // cards, primary buttons
  static const double xl = 20; // sheets, modals
  static const double full = 9999; // avatars

  static const BorderRadius brSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius brMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius brLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius brXl = BorderRadius.all(Radius.circular(xl));
}
