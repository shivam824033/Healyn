import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/radii.dart';
import '../design/spacing.dart';
import '../design/typography.dart';

/// A section title — `h2`/700 — with an optional rounded-full count chip and an
/// optional [trailing] action. The recurring divider between a hero/strip and
/// the list that follows it.
class HealynSectionHeader extends StatelessWidget {
  const HealynSectionHeader({
    required this.title,
    this.countLabel,
    this.trailing,
    super.key,
  });

  final String title;

  /// e.g. "5 appts" — rendered as a brand-tinted pill beside the title.
  final String? countLabel;

  /// Optional trailing widget (e.g. a "See all" button).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: HealynTypography.h2.copyWith(fontWeight: FontWeight.w700),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (countLabel != null) ...[
          const SizedBox(width: HealynSpacing.s2),
          _CountChip(countLabel!),
        ],
        if (trailing != null) ...[
          const SizedBox(width: HealynSpacing.s2),
          trailing!,
        ],
      ],
    );
  }
}

class _CountChip extends StatelessWidget {
  const _CountChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HealynSpacing.s2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: HealynColors.brandPrimarySubtle,
        borderRadius: BorderRadius.circular(HealynRadii.full),
      ),
      child: Text(
        label,
        style: HealynTypography.caption.copyWith(
          color: HealynColors.brandPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
