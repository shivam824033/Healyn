import 'package:flutter/material.dart';

import '../design/colors.dart';

/// A calm, on-brand loading indicator: a solid indigo dot with a soft ring that
/// breathes outward and fades — a quiet "working" pulse rather than the default
/// spinner. Use anywhere a [CircularProgressIndicator] would otherwise sit
/// (full-screen route resolves, button-free waits).
///
/// Honours reduce-motion by holding the static dot.
class HealynPulseLoader extends StatefulWidget {
  const HealynPulseLoader({this.size = 44, this.color, super.key});

  final double size;
  final Color? color;

  @override
  State<HealynPulseLoader> createState() => _HealynPulseLoaderState();
}

class _HealynPulseLoaderState extends State<HealynPulseLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? HealynColors.brandPrimary;
    final dot = widget.size * 0.34;

    if (MediaQuery.of(context).disableAnimations) {
      return Center(
        child: _Dot(size: dot, color: color),
      );
    }

    return Center(
      child: SizedBox.square(
        dimension: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final t = _controller.value;
            return Stack(
              alignment: Alignment.center,
              children: [
                // The breathing ring: grows from the dot to the full box while
                // fading out, then restarts.
                Opacity(
                  opacity: (1 - t) * 0.45,
                  child: Container(
                    width: dot + (widget.size - dot) * t,
                    height: dot + (widget.size - dot) * t,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: color, width: 2),
                    ),
                  ),
                ),
                child!,
              ],
            );
          },
          child: _Dot(size: dot, color: color),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
