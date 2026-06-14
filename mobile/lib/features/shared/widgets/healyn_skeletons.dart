import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/elevation.dart';
import '../design/radii.dart';
import '../design/spacing.dart';
import 'healyn_shimmer.dart';

/// A skeleton text line — a low rounded bar in the base tone. [widthFactor]
/// sizes it as a fraction of the available width so lines read like ragged text.
class HealynSkeletonLine extends StatelessWidget {
  const HealynSkeletonLine({
    this.widthFactor = 1,
    this.height = 14,
    super.key,
  });

  final double widthFactor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: widthFactor.clamp(0.0, 1.0),
      child: HealynSkeletonBox(height: height),
    );
  }
}

/// A skeleton standing in for a [HealynListRow]: the same white, hairline-
/// bordered, [HealynElevation.e1] card with the same padding, so swapping in the
/// real row when data arrives doesn't shift the layout. Shows a title line and,
/// optionally, a [leading] block (avatar + time, for roster rows) and a footer
/// pill (for rows that carry a status chip).
class HealynListRowSkeleton extends StatelessWidget {
  const HealynListRowSkeleton({
    this.hasLeading = false,
    this.hasFooter = true,
    super.key,
  });

  /// Whether to reserve a leading avatar + time block, mirroring the
  /// physiotherapist's roster rows.
  final bool hasLeading;
  final bool hasFooter;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HealynColors.surfaceBase,
        borderRadius: HealynRadii.brLg,
        border: Border.all(color: HealynColors.borderSubtle),
        boxShadow: HealynElevation.e1,
      ),
      padding: const EdgeInsets.all(HealynSpacing.s4),
      child: Row(
        children: [
          if (hasLeading) ...[
            const HealynSkeletonBox(
              width: 36,
              height: 36,
              radius: BorderRadius.all(Radius.circular(HealynRadii.full)),
            ),
            const SizedBox(width: HealynSpacing.s2),
            const HealynSkeletonBox(width: 44, height: 36, radius: HealynRadii.brMd),
            const SizedBox(width: HealynSpacing.s3),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HealynSkeletonLine(widthFactor: 0.62, height: 15),
                const SizedBox(height: HealynSpacing.s2),
                const HealynSkeletonLine(widthFactor: 0.38, height: 12),
                if (hasFooter) ...[
                  const SizedBox(height: HealynSpacing.s3),
                  const HealynSkeletonBox(
                    width: 84,
                    height: 22,
                    radius: BorderRadius.all(Radius.circular(HealynRadii.full)),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: HealynSpacing.s2),
          const HealynSkeletonBox(
            width: 56,
            height: 14,
            radius: HealynRadii.brSm,
          ),
        ],
      ),
    );
  }
}

/// A skeleton mirroring the active-patient switcher card on Home: avatar circle
/// + two stacked lines, in the same card shell so the header doesn't jump.
class HealynSwitcherSkeleton extends StatelessWidget {
  const HealynSwitcherSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HealynColors.surfaceBase,
        borderRadius: HealynRadii.brLg,
        border: Border.all(color: HealynColors.borderSubtle),
        boxShadow: HealynElevation.e1,
      ),
      padding: const EdgeInsets.all(HealynSpacing.s4),
      child: const Row(
        children: [
          HealynSkeletonBox(
            width: 40,
            height: 40,
            radius: BorderRadius.all(Radius.circular(HealynRadii.full)),
          ),
          SizedBox(width: HealynSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HealynSkeletonLine(widthFactor: 0.30, height: 10),
                SizedBox(height: HealynSpacing.s2),
                HealynSkeletonLine(widthFactor: 0.55, height: 15),
                SizedBox(height: HealynSpacing.s1),
                HealynSkeletonLine(widthFactor: 0.40, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Wraps any composition of skeleton primitives in the shimmer sweep. Sugar so
/// callers write `HealynSkeletonGroup(child: …)` instead of nesting the shimmer
/// by hand.
class HealynSkeletonGroup extends StatelessWidget {
  const HealynSkeletonGroup({required this.child, this.enabled = true, super.key});

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return HealynShimmer(enabled: enabled, child: child);
  }
}

/// A ready-made first-load placeholder for a vertical list of [HealynListRow]s:
/// an optional section-header bar followed by [count] shimmering row skeletons,
/// kept scrollable so pull-to-refresh still works on a cold load. Mirrors the
/// real list's footprint so nothing shifts when data replaces it.
class HealynListSkeleton extends StatelessWidget {
  const HealynListSkeleton({
    this.count = 5,
    this.hasLeading = true,
    this.hasFooter = false,
    this.showHeader = false,
    super.key,
  });

  final int count;
  final bool hasLeading;
  final bool hasFooter;
  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    return HealynShimmer(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(HealynSpacing.screenEdge),
        children: [
          if (showHeader) ...[
            const HealynSkeletonLine(widthFactor: 0.3, height: 20),
            const SizedBox(height: HealynSpacing.s4),
          ],
          for (var i = 0; i < count; i++) ...[
            HealynListRowSkeleton(hasLeading: hasLeading, hasFooter: hasFooter),
            if (i != count - 1) const SizedBox(height: HealynSpacing.s3),
          ],
        ],
      ),
    );
  }
}

/// A skeleton standing in for a document card: a square file-icon block, a
/// filename line and two short meta lines, in the same bordered card shell so
/// the real card doesn't shift the layout when it arrives.
class HealynDocumentCardSkeleton extends StatelessWidget {
  const HealynDocumentCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HealynColors.surfaceBase,
        borderRadius: HealynRadii.brLg,
        border: Border.all(color: HealynColors.borderSubtle),
      ),
      padding: const EdgeInsets.all(HealynSpacing.s4),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HealynSkeletonBox(width: 28, height: 28, radius: HealynRadii.brSm),
          SizedBox(width: HealynSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HealynSkeletonLine(widthFactor: 0.7, height: 15),
                SizedBox(height: HealynSpacing.s2),
                HealynSkeletonLine(widthFactor: 0.45, height: 12),
                SizedBox(height: HealynSpacing.s1),
                HealynSkeletonLine(widthFactor: 0.35, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A skeleton standing in for a discussion thread: a short run of message
/// bubbles of varied width, alternating incoming (left) and outgoing (right)
/// alignment, so the thread fades in over its own footprint rather than popping
/// in. Not scrollable — the composer sits below and the thread is short.
class HealynChatSkeleton extends StatelessWidget {
  const HealynChatSkeleton({super.key});

  // Alignment + size for each placeholder bubble, mimicking a brief exchange.
  static const _bubbles = <({bool mine, double widthFactor, double height})>[
    (mine: false, widthFactor: 0.55, height: 44),
    (mine: true, widthFactor: 0.45, height: 36),
    (mine: false, widthFactor: 0.68, height: 56),
    (mine: true, widthFactor: 0.60, height: 44),
    (mine: false, widthFactor: 0.40, height: 36),
  ];

  @override
  Widget build(BuildContext context) {
    return HealynShimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(HealynSpacing.screenEdge),
        children: [
          for (final b in _bubbles) ...[
            FractionallySizedBox(
              alignment: b.mine
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              widthFactor: b.widthFactor,
              child: HealynSkeletonBox(height: b.height, radius: HealynRadii.brLg),
            ),
            const SizedBox(height: HealynSpacing.s3),
          ],
        ],
      ),
    );
  }
}
