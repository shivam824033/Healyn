import 'package:flutter/material.dart';

import '../design/motion.dart';

/// A drop-in [AnimatedSwitcher] for swapping a screen's loading / data / empty /
/// error states without the skeleton ever ghosting over the real content.
///
/// A plain [AnimatedSwitcher] cross-fades: the outgoing and incoming children
/// are both painted at partial opacity for the whole duration, so a skeleton and
/// the cards it replaces overlap on screen — it reads as a shimmer laid on top of
/// real data. This is a *fade-through* instead (UI_UX_GUIDELINES §7): the fade
/// runs only over the second half of each child's timeline, so the outgoing child
/// (whose animation reverses) is fully gone by the midpoint and the incoming one
/// begins from there. The two are never visible at once — a hand-off, not an
/// overlap.
///
/// Give each state a stable [Key] so the switcher knows when to animate between
/// them. Honours reduce-motion by swapping instantly.
class HealynStateSwitcher extends StatelessWidget {
  const HealynStateSwitcher({
    required this.child,
    this.duration = HealynMotion.slow,
    super.key,
  });

  /// The currently-visible state. Swap its [Key] to drive the fade-through.
  final Widget child;

  /// Total hand-off duration, split across the fade-out and fade-in halves.
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return AnimatedSwitcher(
      duration: reduceMotion ? Duration.zero : duration,
      transitionBuilder: (child, animation) => FadeTransition(
        // The second-half interval is what makes this a fade-through: the
        // incoming child stays invisible until the outgoing one has left.
        opacity: CurvedAnimation(
          parent: animation,
          curve: const Interval(0.5, 1, curve: Curves.easeOut),
        ),
        child: child,
      ),
      child: child,
    );
  }
}
