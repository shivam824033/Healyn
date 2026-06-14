import 'package:flutter/material.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/healyn_shimmer.dart';
import '../../../shared/widgets/healyn_skeletons.dart';
import '../../data/models/appointment_models.dart';
import '../appointment_format.dart';

/// The time-slot step shared by the assign-time flows: shows guidance until a
/// date is chosen, then the day's 15-minute grid as chips. The physiotherapist
/// taps a *start* cell; the chosen duration paints the whole occupied range
/// ([selectedStarts]) so they see exactly which cells the visit takes. Cells a
/// different appointment already holds render as non-selectable "booked" chips
/// ([bookedStarts] — every covered cell, not just the start). When the selected
/// range overlaps a booked cell, [hasConflict] flags it: the clashing cells turn
/// danger-coloured and an explanatory message appears. Cells are matched by
/// moment, the exact instant the backend keys an appointment to.
class SlotPicker extends StatelessWidget {
  const SlotPicker({
    required this.label,
    required this.day,
    required this.loading,
    required this.error,
    required this.slots,
    required this.selectedStarts,
    required this.enabled,
    required this.onSelected,
    required this.onRetry,
    this.bookedStarts = const {},
    this.hasConflict = false,
    super.key,
  });

  final String label;
  final DateTime? day;
  final bool loading;
  final String? error;
  final List<Slot>? slots;

  /// Cell start instants covered by the current start + duration — the visit's
  /// occupied range, rendered as the selection. Empty until a start is picked.
  /// Reducing the duration drops trailing cells here, releasing them at once.
  final Set<DateTime> selectedStarts;

  final bool enabled;
  final ValueChanged<Slot> onSelected;
  final VoidCallback? onRetry;

  /// Start instants of cells a *different* appointment already occupies (the
  /// whole booked range, not only its start). Rendered as non-selectable "booked"
  /// chips. Empty for flows that only ever see open cells.
  final Set<DateTime> bookedStarts;

  /// True when [selectedStarts] overlaps [bookedStarts] — the chosen duration
  /// runs into another appointment. The overlapping cells turn danger-coloured
  /// and the picker shows a message; the caller also blocks confirmation.
  final bool hasConflict;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: HealynTypography.caption.copyWith(
            color: HealynColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: HealynSpacing.s2),
        _body(),
      ],
    );
  }

  Widget _body() {
    if (day == null) {
      return const Text(
        'Pick a date to see available times.',
        style: HealynTypography.caption,
      );
    }
    if (loading) {
      // Shimmering chip-shaped placeholders so the slot row keeps its footprint
      // while the day's open times load, rather than collapsing to a spinner.
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: HealynSpacing.s1),
        child: HealynSkeletonGroup(
          child: Wrap(
            spacing: HealynSpacing.s2,
            runSpacing: HealynSpacing.s2,
            children: [
              HealynSkeletonBox(width: 64, height: 32, radius: HealynRadii.brSm),
              HealynSkeletonBox(width: 72, height: 32, radius: HealynRadii.brSm),
              HealynSkeletonBox(width: 60, height: 32, radius: HealynRadii.brSm),
              HealynSkeletonBox(width: 68, height: 32, radius: HealynRadii.brSm),
              HealynSkeletonBox(width: 64, height: 32, radius: HealynRadii.brSm),
            ],
          ),
        ),
      );
    }
    if (error != null) {
      return Row(
        children: [
          Expanded(
            child: Text(
              error!,
              style: HealynTypography.caption.copyWith(
                color: HealynColors.statusDanger,
              ),
            ),
          ),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      );
    }
    final list = slots ?? const [];
    if (list.isEmpty) {
      return const Text(
        'No open slots on this day. Try another date.',
        style: HealynTypography.caption,
      );
    }
    final hasBooked = list.any(_isBooked);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: HealynSpacing.s2,
          runSpacing: HealynSpacing.s2,
          children: [for (final s in list) _chip(s)],
        ),
        if (hasConflict) ...[
          const SizedBox(height: HealynSpacing.s2),
          Text(
            'Selected duration overlaps with another appointment. '
            'Please choose another time.',
            style: HealynTypography.caption.copyWith(
              color: HealynColors.statusDanger,
              fontWeight: FontWeight.w600,
            ),
          ),
        ] else if (hasBooked) ...[
          const SizedBox(height: HealynSpacing.s2),
          Text(
            'Amber times are already booked.',
            style: HealynTypography.caption.copyWith(
              color: HealynColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  /// One cell, by its role in the day: a clash (selected over a booked cell), a
  /// booked cell (disabled), a selected cell in the chosen range, or an open one.
  Widget _chip(Slot s) {
    final selected = _isSelected(s);
    final booked = _isBooked(s);
    if (selected && booked) return _conflictChip(s);
    if (booked) return _bookedChip(s);
    return ChoiceChip(
      label: Text(formatTimeOfDay(s.startsAt)),
      selected: selected,
      onSelected: enabled ? (_) => onSelected(s) : null,
    );
  }

  bool _isBooked(Slot s) =>
      bookedStarts.any((b) => b.isAtSameMomentAs(s.startsAt));

  bool _isSelected(Slot s) =>
      selectedStarts.any((b) => b.isAtSameMomentAs(s.startsAt));

  /// A non-selectable chip for a cell another appointment already fills.
  Widget _bookedChip(Slot s) {
    const booked = HealynColors.statusWarning;
    return Chip(
      avatar: const Icon(Icons.event_busy, size: 16, color: booked),
      label: Text(formatTimeOfDay(s.startsAt)),
      labelStyle: HealynTypography.caption.copyWith(
        color: booked,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: booked.withValues(alpha: 0.12),
      side: BorderSide(color: booked.withValues(alpha: 0.4)),
      visualDensity: VisualDensity.compact,
    );
  }

  /// A cell the chosen duration covers that is *also* booked — the overlap the
  /// physiotherapist must resolve. Stays tappable (tapping re-anchors the start
  /// elsewhere) but is danger-coloured to read as a clash.
  Widget _conflictChip(Slot s) {
    const danger = HealynColors.statusDanger;
    return ChoiceChip(
      avatar: const Icon(Icons.warning_amber_rounded, size: 16, color: danger),
      label: Text(formatTimeOfDay(s.startsAt)),
      selected: true,
      onSelected: enabled ? (_) => onSelected(s) : null,
      labelStyle: HealynTypography.caption.copyWith(
        color: danger,
        fontWeight: FontWeight.w600,
      ),
      selectedColor: danger.withValues(alpha: 0.14),
      side: BorderSide(color: danger.withValues(alpha: 0.5)),
    );
  }
}
