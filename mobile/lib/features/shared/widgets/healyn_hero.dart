import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/elevation.dart';
import '../design/radii.dart';
import '../design/spacing.dart';
import '../design/typography.dart';

/// The signature *Refined Indigo* header: a full-bleed brand-gradient panel with
/// rounded bottom corners, an optional [eyebrow], a bold white [title], an
/// optional [subtitle] or [pill], and a [trailing] slot (avatar / action).
///
/// Set [bottomOverlap] to the lift of any floating stat row below it, so the
/// cards overlap the gradient. By default the panel bleeds under the status bar
/// ([applyTopInset]); place it at the top of the page outside a top `SafeArea`.
class HealynHero extends StatelessWidget {
  const HealynHero({
    required this.title,
    this.eyebrow,
    this.subtitle,
    this.pill,
    this.trailing,
    this.bottomOverlap = HealynSpacing.s8,
    this.applyTopInset = true,
    super.key,
  });

  final String title;
  final String? eyebrow;
  final String? subtitle;

  /// A widget placed under the title row (e.g. a [HealynHeroPill] date chip).
  final Widget? pill;

  /// Top-right slot — typically a [HealynAvatar] or an icon action.
  final Widget? trailing;

  /// Extra bottom padding (gradient runway) for overlapping content below.
  final double bottomOverlap;

  /// When true, adds the status-bar inset so content clears the notch.
  final bool applyTopInset;

  /// The hero's signature bottom radius — deliberately larger than [HealynRadii]
  /// (per the Refined Indigo spec) to give the brand panel its soft, deep base.
  static const double _bottomRadius = 30;

  @override
  Widget build(BuildContext context) {
    final topInset = applyTopInset ? MediaQuery.of(context).padding.top : 0.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        HealynSpacing.s5,
        topInset + HealynSpacing.s2,
        HealynSpacing.s5,
        bottomOverlap,
      ),
      decoration: BoxDecoration(
        gradient: HealynColors.brandGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(_bottomRadius),
          bottomRight: Radius.circular(_bottomRadius),
        ),
        boxShadow: HealynElevation.e2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (eyebrow != null) ...[
                      Text(
                        eyebrow!,
                        style: HealynTypography.body.copyWith(
                          color: HealynColors.textInverse.withValues(
                            alpha: 0.82,
                          ),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: HealynSpacing.s1),
                    ],
                    Text(
                      title,
                      style: HealynTypography.h1.copyWith(
                        color: HealynColors.textInverse,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: HealynSpacing.s3),
                trailing!,
              ],
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: HealynSpacing.s2),
            Text(
              subtitle!,
              style: HealynTypography.body.copyWith(
                color: HealynColors.textInverse.withValues(alpha: 0.82),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (pill != null) ...[
            const SizedBox(height: HealynSpacing.s4),
            pill!,
          ],
        ],
      ),
    );
  }
}

/// A rounded-full chip for the hero (e.g. the long date): a white-tinted fill
/// with a leading icon and white label. Reads cleanly on the gradient.
class HealynHeroPill extends StatelessWidget {
  const HealynHeroPill({required this.icon, required this.label, super.key});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HealynSpacing.s3,
        vertical: HealynSpacing.s1,
      ),
      decoration: BoxDecoration(
        color: HealynColors.textInverse.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(HealynRadii.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: HealynColors.textInverse),
          const SizedBox(width: HealynSpacing.s1),
          Flexible(
            child: Text(
              label,
              style: HealynTypography.caption.copyWith(
                color: HealynColors.textInverse,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
