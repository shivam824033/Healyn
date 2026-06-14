import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/radii.dart';

/// A premium loading shimmer (UI_UX_GUIDELINES §7: motion confirms state, never
/// decorates). Wrap a tree of opaque [HealynSkeletonBox]es and a soft highlight
/// sweeps across them left-to-right on a gentle loop.
///
/// Built from primitives only (no shimmer package): a [ShaderMask] paints a
/// moving three-stop gradient over the child via [BlendMode.srcATop], so the
/// skeleton shapes themselves define the lit area. Honours the platform
/// reduce-motion setting — when animations are disabled it renders the static
/// base tone, so nothing pulses for motion-sensitive users.
class HealynShimmer extends StatefulWidget {
  const HealynShimmer({required this.child, this.enabled = true, super.key});

  final Widget child;

  /// When false the child renders as a static skeleton (no sweep). Use to stop
  /// the loop once real data has arrived but before the cross-fade completes.
  final bool enabled;

  @override
  State<HealynShimmer> createState() => _HealynShimmerState();
}

class _HealynShimmerState extends State<HealynShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  );

  @override
  void initState() {
    super.initState();
    if (widget.enabled) _controller.repeat();
  }

  @override
  void didUpdateWidget(HealynShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.enabled && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Respect reduce-motion: a still skeleton instead of a sweeping highlight.
    if (MediaQuery.of(context).disableAnimations) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                HealynColors.skeletonBase,
                HealynColors.skeletonHighlight,
                HealynColors.skeletonBase,
              ],
              stops: const [0.35, 0.5, 0.65],
              transform: _SlideGradient(_controller.value),
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}

/// Translates the gradient horizontally from fully off-screen left to fully
/// off-screen right as [percent] runs 0→1, giving the highlight its travel.
class _SlideGradient extends GradientTransform {
  const _SlideGradient(this.percent);

  final double percent;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    final dx = (percent * 2 - 1) * bounds.width;
    return Matrix4.translationValues(dx, 0, 0);
  }
}

/// A single opaque skeleton shape — a rounded rectangle in the neutral base
/// tone. The enclosing [HealynShimmer] paints the moving highlight over it.
/// Give it a concrete [height]/[width] that matches the real content's size so
/// the layout doesn't shift when data replaces the skeleton.
class HealynSkeletonBox extends StatelessWidget {
  const HealynSkeletonBox({
    this.width,
    this.height = 16,
    this.radius = HealynRadii.brSm,
    super.key,
  });

  final double? width;
  final double height;
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: HealynColors.skeletonBase,
        borderRadius: radius,
      ),
    );
  }
}
