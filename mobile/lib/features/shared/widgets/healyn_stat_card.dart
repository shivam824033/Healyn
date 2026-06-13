import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/elevation.dart';
import '../design/radii.dart';
import '../design/spacing.dart';
import '../design/typography.dart';
import 'healyn_tonal_icon.dart';

/// A single floating stat: a tonal icon tile, a big [value] and a [label]. Sits
/// at [HealynElevation.e2] so a row of these lifts off the gradient hero it
/// overlaps. Optionally tappable.
class HealynStatCard extends StatelessWidget {
  const HealynStatCard({
    required this.icon,
    required this.tint,
    required this.value,
    required this.label,
    this.onTap,
    super.key,
  });

  final IconData icon;

  /// The icon hue; the tonal tile fills with this colour at 12%.
  final Color tint;

  /// The headline number/value (e.g. "5").
  final String value;

  /// The caption beneath it (e.g. "Today").
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(HealynSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          HealynTonalIcon(icon: icon, color: tint),
          const SizedBox(height: HealynSpacing.s3),
          Text(
            value,
            style: HealynTypography.h1.copyWith(fontWeight: FontWeight.w800),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: HealynSpacing.s1),
          Text(
            label,
            style: HealynTypography.caption.copyWith(
              color: HealynColors.textMuted,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: HealynColors.surfaceBase,
        borderRadius: HealynRadii.brLg,
        border: Border.all(color: HealynColors.borderSubtle),
        boxShadow: HealynElevation.e2,
      ),
      child: onTap == null
          ? content
          : Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: HealynRadii.brLg,
                onTap: onTap,
                child: content,
              ),
            ),
    );
  }
}

/// An equal-width row of [HealynStatCard]s that floats up into the hero above
/// it. [overlap] is how far the row lifts; give the hero that much extra bottom
/// padding (its `bottomOverlap`) so the cards sit over the gradient.
class HealynStatRow extends StatelessWidget {
  const HealynStatRow({
    required this.cards,
    this.overlap = 34,
    this.padding = const EdgeInsets.symmetric(horizontal: HealynSpacing.s5),
    super.key,
  });

  final List<HealynStatCard> cards;

  /// Upward lift, in dp, into the hero. Leaves an equal gap below the row.
  final double overlap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -overlap),
      child: Padding(
        padding: padding,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                if (i > 0) const SizedBox(width: HealynSpacing.s3),
                Expanded(child: cards[i]),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
