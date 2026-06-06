import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/elevation.dart';
import '../design/radii.dart';
import '../design/spacing.dart';

/// A surface that groups related content (UI_UX_GUIDELINES §4.3: a radius-lg
/// card at elevation §4.4 e1). White on the scaffold, defined by a hairline
/// border plus a soft shadow — calm and premium, never floating.
class SectionCard extends StatelessWidget {
  const SectionCard({required this.child, this.padding, super.key});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(HealynSpacing.s4),
      decoration: BoxDecoration(
        color: HealynColors.surfaceBase,
        borderRadius: HealynRadii.brLg,
        border: Border.all(color: HealynColors.borderSubtle),
        boxShadow: HealynElevation.e1,
      ),
      child: child,
    );
  }
}
