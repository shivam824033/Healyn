import 'package:flutter/material.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../data/models/appointment_models.dart';
import '../appointment_format.dart';

/// The time-slot step shared by the book and reschedule forms: shows guidance
/// until a date is chosen, then the open slots for that day as selectable chips
/// (with loading / empty / error states). Slots are matched by [Slot.startsAt],
/// the exact instant the backend keys an appointment to.
class SlotPicker extends StatelessWidget {
  const SlotPicker({
    required this.label,
    required this.day,
    required this.loading,
    required this.error,
    required this.slots,
    required this.selected,
    required this.enabled,
    required this.onSelected,
    required this.onRetry,
    this.bookedStarts = const {},
    super.key,
  });

  final String label;
  final DateTime? day;
  final bool loading;
  final String? error;
  final List<Slot>? slots;
  final Slot? selected;
  final bool enabled;
  final ValueChanged<Slot> onSelected;
  final VoidCallback? onRetry;

  /// Start instants already taken (compared by moment). Such slots render as a
  /// distinct, non-selectable "booked" chip so the physiotherapist can see the
  /// day's commitments at a glance and never double-books. Empty for the patient
  /// flows, which only ever see open slots.
  final Set<DateTime> bookedStarts;

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
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: HealynSpacing.s3),
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
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
          children: [
            for (final s in list)
              if (_isBooked(s))
                _bookedChip(s)
              else
                ChoiceChip(
                  label: Text(formatTimeOfDay(s.startsAt)),
                  selected: selected?.startsAt == s.startsAt,
                  onSelected: enabled ? (_) => onSelected(s) : null,
                ),
          ],
        ),
        if (hasBooked) ...[
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

  bool _isBooked(Slot s) =>
      bookedStarts.any((b) => b.isAtSameMomentAs(s.startsAt));

  /// A non-selectable chip for a slot the physiotherapist has already filled.
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
}
