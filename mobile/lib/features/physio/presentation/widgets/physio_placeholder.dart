import 'package:flutter/material.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/app_bar.dart';

/// A calm "coming soon" panel for physiotherapist screens whose real content
/// lands in a later increment, so the shell is navigable from C1.
class PhysioPlaceholder extends StatelessWidget {
  const PhysioPlaceholder({
    required this.title,
    required this.icon,
    required this.message,
    super.key,
  });

  final String title;
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HealynAppBar(title: title),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(HealynSpacing.s8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 48, color: HealynColors.textMuted),
                const SizedBox(height: HealynSpacing.s4),
                Text(
                  message,
                  style: HealynTypography.body.copyWith(
                    color: HealynColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
