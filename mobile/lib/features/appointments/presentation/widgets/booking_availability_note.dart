import 'package:flutter/material.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../booking_availability.dart';

/// A passive, non-blocking note shown under the date/time fields when the
/// physiotherapist isn't available on the picked day, or the preferred time
/// falls outside their hours. Informational only — the request still goes
/// through. Pairs the tone colour with an icon so state isn't colour-only
/// (UI_UX_GUIDELINES §10).
class BookingAvailabilityNote extends StatelessWidget {
  const BookingAvailabilityNote({required this.message, super.key});

  final BookingHintMessage message;

  @override
  Widget build(BuildContext context) {
    final accent = switch (message.tone) {
      BookingHintTone.warning => HealynColors.statusWarning,
      BookingHintTone.info => HealynColors.statusInfo,
    };
    final icon = switch (message.tone) {
      BookingHintTone.warning => Icons.event_busy_outlined,
      BookingHintTone.info => Icons.info_outline,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(HealynSpacing.s3),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: HealynRadii.brMd,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: accent),
          const SizedBox(width: HealynSpacing.s2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.title,
                  style: HealynTypography.bodyStrong.copyWith(color: accent),
                ),
                const SizedBox(height: 2),
                Text(
                  message.subtitle,
                  style: HealynTypography.caption.copyWith(
                    color: accent.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
