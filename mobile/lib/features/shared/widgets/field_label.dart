import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/spacing.dart';
import '../design/typography.dart';

/// The label above a form control — `caption`/600 in [HealynColors.textPrimary],
/// matching the internal label of [AppTextField] (UI_UX_GUIDELINES §5.2: label
/// above the input, never a placeholder-as-label). Use it to label the controls
/// `AppTextField` can't host — dropdowns and picker-backed fields — so every
/// field on a form reads the same.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: HealynSpacing.s2),
      child: Text(
        text,
        style: HealynTypography.caption.copyWith(
          color: HealynColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
