import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/spacing.dart';
import '../design/typography.dart';

/// The title row inside a [SectionCard]: a brand-tinted leading icon, a title in
/// `bodyStrong`, and an optional [trailing] widget (a count, a chevron). Shared
/// so card headers stay visually identical across Home and the dashboards.
class CardHeader extends StatelessWidget {
  const CardHeader({
    required this.icon,
    required this.title,
    this.trailing,
    super.key,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: HealynColors.brandPrimary),
        const SizedBox(width: HealynSpacing.s2),
        Expanded(child: Text(title, style: HealynTypography.bodyStrong)),
        ?trailing,
      ],
    );
  }
}
