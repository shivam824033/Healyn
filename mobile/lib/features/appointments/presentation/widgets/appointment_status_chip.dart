import 'package:flutter/material.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../data/models/appointment_models.dart';

/// A small status pill: colored label on a subtle tint of the same hue. One
/// glance tells the patient where the appointment stands.
class AppointmentStatusChip extends StatelessWidget {
  const AppointmentStatusChip({required this.status, super.key});

  final AppointmentStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _colorOf(status);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HealynSpacing.s2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: HealynRadii.brSm,
      ),
      child: Text(
        status.label,
        style: HealynTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static Color _colorOf(AppointmentStatus status) => switch (status) {
    AppointmentStatus.requested => HealynColors.statusWarning,
    AppointmentStatus.confirmed => HealynColors.statusSuccess,
    AppointmentStatus.inProgress => HealynColors.statusInfo,
    AppointmentStatus.completed => HealynColors.textSecondary,
    AppointmentStatus.cancelled => HealynColors.statusDanger,
    AppointmentStatus.noShow => HealynColors.statusDanger,
    AppointmentStatus.rescheduled => HealynColors.textMuted,
    AppointmentStatus.rejected => HealynColors.statusDanger,
  };
}
