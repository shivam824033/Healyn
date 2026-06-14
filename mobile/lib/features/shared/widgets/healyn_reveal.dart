import 'package:flutter/material.dart';

import '../design/motion.dart';

/// A one-shot entrance: the child fades in while sliding gently up from below.
/// Pass an increasing [delay] (or use [HealynReveal.staggered]) to cascade a
/// column of cards so they arrive in sequence rather than popping in together
/// (UI_UX_GUIDELINES §7 — motion that confirms arrival, restrained, no bounce).
///
/// Runs exactly once on first build and then holds at rest, so a parent rebuild
/// (e.g. a provider refresh) never re-triggers it. Honours reduce-motion by
/// rendering the child settled immediately.
class HealynReveal extends StatefulWidget {
  const HealynReveal({
    required this.child,
    this.delay = Duration.zero,
    this.duration = HealynMotion.slow,
    super.key,
  });

  /// Builds a reveal whose delay is [index] × [step] — the standard stagger for
  /// a list/column of cards.
  factory HealynReveal.staggered({
    Key? key,
    required int index,
    required Widget child,
    Duration step = const Duration(milliseconds: 70),
    Duration duration = HealynMotion.slow,
  }) {
    return HealynReveal(
      key: key,
      delay: step * index,
      duration: duration,
      child: child,
    );
  }

  final Widget child;
  final Duration delay;
  final Duration duration;

  @override
  State<HealynReveal> createState() => _HealynRevealState();
}

class _HealynRevealState extends State<HealynReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.delay + widget.duration,
  );

  late final double _start =
      widget.delay.inMilliseconds / _controller.duration!.inMilliseconds;

  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Interval(_start, 1, curve: Curves.easeOut),
  );

  late final Animation<Offset> _slide =
      Tween(begin: const Offset(0, 0.06), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(_start, 1, curve: HealynMotion.standardCurve),
        ),
      );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) return widget.child;
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
