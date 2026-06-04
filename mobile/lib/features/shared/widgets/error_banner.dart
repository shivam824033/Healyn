import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/radii.dart';
import '../design/spacing.dart';
import '../design/typography.dart';

/// Inline banner for a submit/system error (UI_UX_GUIDELINES §5.7). Describes
/// what happened; pairs the danger color with an icon so state isn't conveyed
/// by color alone (§10 color independence).
class ErrorBanner extends StatelessWidget {
  const ErrorBanner({required this.message, super.key});

  final String message;

  static const Color _bg = Color(0xFFFEE2E2);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(HealynSpacing.s3),
      decoration: const BoxDecoration(
        color: _bg,
        borderRadius: HealynRadii.brMd,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline,
            size: 20,
            color: HealynColors.statusDanger,
          ),
          const SizedBox(width: HealynSpacing.s2),
          Expanded(
            child: Text(
              message,
              style: HealynTypography.caption.copyWith(
                color: const Color(0xFFB91C1C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
