import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/elevation.dart';
import '../design/radii.dart';
import '../design/spacing.dart';
import '../design/typography.dart';

/// The soft card row that carries every *Refined Indigo* list: an optional
/// [leading] element (time block / avatar / tonal icon), a [title] and optional
/// [subtitle], an optional [footer] (a `Wrap` of chips/badges) and a trailing
/// chevron. White, hairline-bordered, [HealynElevation.e1], with an `InkWell`
/// press.
///
/// Pure presentation: navigation is the caller's via [onTap].
class HealynListRow extends StatelessWidget {
  const HealynListRow({
    required this.title,
    this.leading,
    this.subtitle,
    this.footer,
    this.trailing,
    this.onTap,
    this.padding = const EdgeInsets.all(HealynSpacing.s4),
    super.key,
  });

  final String title;
  final Widget? leading;
  final String? subtitle;

  /// A `Wrap` of chips/badges shown under the title block.
  final Widget? footer;

  /// Overrides the default trailing chevron (pass [SizedBox.shrink] to hide it).
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final effectiveTrailing =
        trailing ??
        (onTap != null
            ? const Icon(Icons.chevron_right, color: HealynColors.textMuted)
            : null);

    return Container(
      decoration: BoxDecoration(
        color: HealynColors.surfaceBase,
        borderRadius: HealynRadii.brLg,
        border: Border.all(color: HealynColors.borderSubtle),
        boxShadow: HealynElevation.e1,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: HealynRadii.brLg,
          onTap: onTap,
          child: Padding(
            padding: padding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: HealynSpacing.s3),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: HealynTypography.bodyStrong,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: HealynSpacing.s1),
                        Text(
                          subtitle!,
                          style: HealynTypography.body.copyWith(
                            color: HealynColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (footer != null) ...[
                        const SizedBox(height: HealynSpacing.s2),
                        footer!,
                      ],
                    ],
                  ),
                ),
                if (effectiveTrailing != null) ...[
                  const SizedBox(width: HealynSpacing.s2),
                  effectiveTrailing,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
