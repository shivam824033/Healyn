import 'package:flutter/material.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';

/// The cover image for a promotion at a fixed [aspectRatio]. Fades the network
/// image in once decoded (no flicker), and falls back to a calm branded gradient
/// (seeded by the title so it's stable) when there is no image or it fails to
/// load. An optional [category] chip overlays the top-left.
class PromotionCover extends StatelessWidget {
  const PromotionCover({
    required this.url,
    required this.aspectRatio,
    required this.seed,
    this.category,
    this.borderRadius,
    super.key,
  });

  final String? url;
  final double aspectRatio;
  final String seed;
  final String? category;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final cover = AspectRatio(
      aspectRatio: aspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _base(),
          if (category?.trim().isNotEmpty ?? false)
            Positioned(
              top: HealynSpacing.s2,
              left: HealynSpacing.s2,
              child: _CategoryChip(label: category!.trim()),
            ),
        ],
      ),
    );
    if (borderRadius == null) return cover;
    return ClipRRect(borderRadius: borderRadius!, child: cover);
  }

  Widget _base() {
    final fallback = _GradientFallback(seed: seed);
    if (url == null || url!.isEmpty) return fallback;
    return Image.network(
      url!,
      fit: BoxFit.cover,
      // Fade in once the first frame is ready; show the gradient meanwhile so the
      // box is never an empty flash.
      frameBuilder: (context, child, frame, wasSync) {
        if (wasSync || frame != null) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: child,
          );
        }
        return fallback;
      },
      errorBuilder: (_, _, _) => fallback,
    );
  }
}

/// A deterministic two-tone gradient derived from [seed] so a promotion without a
/// cover still looks intentional and stays the same between rebuilds.
class _GradientFallback extends StatelessWidget {
  const _GradientFallback({required this.seed});

  final String seed;

  @override
  Widget build(BuildContext context) {
    final hue = (seed.hashCode % 360).abs().toDouble();
    final c1 = HSLColor.fromAHSL(1, hue, 0.45, 0.55).toColor();
    final c2 = HSLColor.fromAHSL(1, (hue + 28) % 360, 0.5, 0.42).toColor();
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [c1, c2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.local_hospital_outlined, color: Colors.white70, size: 40),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HealynSpacing.s2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: HealynTypography.caption.copyWith(
          color: HealynColors.textInverse,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
