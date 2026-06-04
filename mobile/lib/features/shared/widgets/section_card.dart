import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/radii.dart';
import '../design/spacing.dart';

/// A bordered surface that groups related content (UI_UX_GUIDELINES §4.3: a
/// radius-lg card). White on the scaffold, separated by a subtle border rather
/// than a shadow — flat and calm, per the design language.
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
      ),
      child: child,
    );
  }
}
