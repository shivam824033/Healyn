import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/radii.dart';
import '../design/spacing.dart';
import '../design/typography.dart';

/// A fixed-width leading column for an appointment row: a prominent start time,
/// its AM/PM marker, and an optional duration line. Self-contained 12-hour
/// formatting (no `intl` dependency) so the kit stays free of feature imports —
/// the calling screen passes the raw [start]/[end] instants.
class HealynTimeBlock extends StatelessWidget {
  const HealynTimeBlock({required this.start, this.end, this.width = 54, super.key});

  /// The appointment's start instant (local).
  final DateTime start;

  /// The end instant, if known — drives the duration line.
  final DateTime? end;

  /// Column width. Defaults to the 54dp standard.
  final double width;

  @override
  Widget build(BuildContext context) {
    final local = start.toLocal();
    final hour12 = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final clock = '$hour12:${local.minute.toString().padLeft(2, '0')}';
    final meridiem = local.hour < 12 ? 'AM' : 'PM';
    final duration = _duration();

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: HealynSpacing.s2),
      decoration: const BoxDecoration(
        color: HealynColors.surfaceAlt,
        borderRadius: HealynRadii.brMd,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            clock,
            style: HealynTypography.bodyStrong.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            meridiem,
            style: HealynTypography.caption.copyWith(
              color: HealynColors.textMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (duration != null) ...[
            const SizedBox(height: HealynSpacing.s1),
            Text(
              duration,
              style: HealynTypography.caption.copyWith(
                color: HealynColors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// A compact duration label ("45m", "1h", "1h 15m") or null when no end.
  String? _duration() {
    final endsAt = end;
    if (endsAt == null) return null;
    final minutes = endsAt.toLocal().difference(start.toLocal()).inMinutes;
    if (minutes <= 0) return null;
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return '${m}m';
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }
}
