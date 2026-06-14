import 'package:flutter/material.dart';

import 'motion.dart';

/// The app-wide route transition (UI_UX_GUIDELINES §7). A restrained fade with a
/// short upward slide and a barely-there scale settle — premium and calm, never
/// the platform's stock horizontal push. Wired once via [ThemeData.pageTransitionsTheme]
/// so every `go_router` push (and the splash → home hand-off) animates the same
/// way, with no per-route plumbing.
///
/// Duration is owned by the route (Material's default ~300ms, within the
/// 250–400ms target); this builder only shapes the motion. The outgoing screen
/// fades back slightly so the incoming one reads as arriving on top.
class HealynPageTransitionsBuilder extends PageTransitionsBuilder {
  const HealynPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final entering = CurvedAnimation(
      parent: animation,
      curve: HealynMotion.standardCurve,
      reverseCurve: Curves.easeInCubic,
    );

    final fade = Tween(begin: 0.0, end: 1.0).animate(entering);
    final slide = Tween(
      begin: const Offset(0, 0.035),
      end: Offset.zero,
    ).animate(entering);
    final scale = Tween(begin: 0.985, end: 1.0).animate(entering);

    // The screen being covered eases back a touch so the new one feels layered
    // over it rather than swapped underneath.
    final outgoing = Tween(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: secondaryAnimation, curve: HealynMotion.standardCurve),
    );

    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide,
        child: ScaleTransition(
          scale: scale,
          child: ScaleTransition(scale: outgoing, child: child),
        ),
      ),
    );
  }
}
