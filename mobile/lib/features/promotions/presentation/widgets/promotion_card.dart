import 'package:flutter/material.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/elevation.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../data/models/promotion_models.dart';
import 'promotion_cover.dart';

/// A single promotion as a tappable card: cover image (or a branded gradient
/// fallback), title, short description, and an optional CTA pill. Used in the
/// patient Home carousel; the whole card and the CTA both open the details screen.
class PromotionCard extends StatelessWidget {
  const PromotionCard({
    required this.promotion,
    required this.onTap,
    this.coverAspect = 16 / 9,
    super.key,
  });

  final Promotion promotion;
  final VoidCallback onTap;
  final double coverAspect;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HealynColors.surfaceBase,
      borderRadius: HealynRadii.brLg,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: HealynRadii.brLg,
            border: Border.all(color: HealynColors.borderSubtle),
            boxShadow: HealynElevation.e1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PromotionCover(
                url: promotion.coverUrl,
                aspectRatio: coverAspect,
                seed: promotion.title,
                category: promotion.serviceCategory,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(HealynSpacing.s3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        promotion.title,
                        style: HealynTypography.bodyStrong,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (promotion.shortDescription?.trim().isNotEmpty ??
                          false) ...[
                        const SizedBox(height: HealynSpacing.s1),
                        Expanded(
                          child: Text(
                            promotion.shortDescription!.trim(),
                            style: HealynTypography.caption.copyWith(
                              color: HealynColors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ] else
                        const Spacer(),
                      if (promotion.hasCta)
                        _CtaPill(label: promotion.ctaText!.trim()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CtaPill extends StatelessWidget {
  const _CtaPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HealynSpacing.s3,
        vertical: HealynSpacing.s1,
      ),
      decoration: const BoxDecoration(
        color: HealynColors.brandPrimarySubtle,
        borderRadius: HealynRadii.brSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: HealynTypography.caption.copyWith(
              color: HealynColors.brandPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: HealynSpacing.s1),
          const Icon(
            Icons.arrow_forward,
            size: 14,
            color: HealynColors.brandPrimary,
          ),
        ],
      ),
    );
  }
}
