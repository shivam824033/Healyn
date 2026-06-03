import 'package:flutter/material.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';

/// Appointments tab. Booking and the appointment timeline arrive in a later
/// mobile slice; for now this is an honest empty state, not a fake list.
class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointments')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(HealynSpacing.s8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.event_outlined,
                  size: 48,
                  color: HealynColors.textMuted,
                ),
                const SizedBox(height: HealynSpacing.s4),
                const Text(
                  'No appointments yet',
                  style: HealynTypography.h3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: HealynSpacing.s2),
                Text(
                  'Booking and your appointment history arrive in an upcoming '
                  'update.',
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
