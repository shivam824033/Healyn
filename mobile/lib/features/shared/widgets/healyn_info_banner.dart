import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/radii.dart';
import '../design/spacing.dart';
import '../design/typography.dart';

/// The tone of a [HealynInfoBanner] — drives its fill and accent colour.
enum HealynBannerTone { brand, warning, success, info, danger }

/// A soft, tappable banner: a white icon tile + a title and optional subtitle on
/// a tonal fill, with a trailing chevron. Generalises the "N new requests"
/// banner so any screen can surface a calm, on-brand call to action.
class HealynInfoBanner extends StatelessWidget {
  const HealynInfoBanner({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.tone = HealynBannerTone.brand,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final HealynBannerTone tone;

  @override
  Widget build(BuildContext context) {
    final accent = _accentOf(tone);
    // Brand uses its dedicated subtle token; the rest tint their own accent.
    final fill = tone == HealynBannerTone.brand
        ? HealynColors.brandPrimarySubtle
        : accent.withValues(alpha: 0.12);

    return Material(
      color: fill,
      borderRadius: HealynRadii.brLg,
      child: InkWell(
        borderRadius: HealynRadii.brLg,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: HealynSpacing.s4,
            vertical: HealynSpacing.s3,
          ),
          child: Row(
            children: [
              // A white tile reads cleanly on every tone's subtle fill.
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: HealynColors.surfaceBase,
                  borderRadius: HealynRadii.brMd,
                ),
                child: Icon(icon, size: 18, color: accent),
              ),
              const SizedBox(width: HealynSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: HealynTypography.bodyStrong.copyWith(color: accent),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: HealynTypography.caption.copyWith(
                          color: accent.withValues(alpha: 0.8),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: HealynSpacing.s2),
              Icon(Icons.chevron_right, color: accent),
            ],
          ),
        ),
      ),
    );
  }

  static Color _accentOf(HealynBannerTone tone) => switch (tone) {
    HealynBannerTone.brand => HealynColors.brandPrimary,
    HealynBannerTone.warning => HealynColors.statusWarning,
    HealynBannerTone.success => HealynColors.statusSuccess,
    HealynBannerTone.info => HealynColors.statusInfo,
    HealynBannerTone.danger => HealynColors.statusDanger,
  };
}
