import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/radii.dart';
import '../design/spacing.dart';
import '../design/typography.dart';

/// A tappable navigation row inside a bordered card — used for Profile entries
/// like treatment history and notification settings. Shared by the patient and
/// physiotherapist profiles so the two stay visually identical.
class NavCard extends StatelessWidget {
  const NavCard({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HealynColors.surfaceBase,
        borderRadius: HealynRadii.brLg,
        border: Border.all(color: HealynColors.borderSubtle),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: HealynRadii.brLg,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(HealynSpacing.s4),
            child: Row(
              children: [
                Icon(icon, size: 20, color: HealynColors.textSecondary),
                const SizedBox(width: HealynSpacing.s3),
                Expanded(
                  child: Text(label, style: HealynTypography.bodyStrong),
                ),
                const Icon(Icons.chevron_right, color: HealynColors.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
