import 'package:flutter/material.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/typography.dart';
import '../patient_format.dart';

/// A circular initials avatar for a patient — the *Refined Indigo* monogram in a
/// subtle brand-tinted circle. Pure presentation; pass [name] (initials are
/// derived) and an optional [radius]. The label is not PHI: initials only.
class PatientAvatar extends StatelessWidget {
  const PatientAvatar({required this.name, this.radius = 22, this.textStyle, super.key});

  final String name;
  final double radius;

  /// Overrides the default monogram style (scaled for a larger avatar).
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: HealynColors.brandPrimarySubtle,
      child: Text(
        patientInitials(name),
        style: (textStyle ?? HealynTypography.bodyStrong).copyWith(
          color: HealynColors.brandPrimaryHover,
        ),
      ),
    );
  }
}
