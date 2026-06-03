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
    return Wrap(
      spacing: HealynSpacing.s2,
      runSpacing: HealynSpacing.s2,
      children: [
        for (final s in list)
          ChoiceChip(
            label: Text(formatTimeOfDay(s.startsAt)),
            selected: selected?.startsAt == s.startsAt,
            onSelected: enabled ? (_) => onSelected(s) : null,
          ),
      ],
    );
  }
}
