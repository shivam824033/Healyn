import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/elevation.dart';
import '../design/radii.dart';
import '../design/spacing.dart';
import '../design/typography.dart';

/// A compact 7-day selector for the week containing [weekOf]. The week starts
/// Monday (matching the app's month grid). The [selected] day fills with the
/// brand gradient; days in [markedDays] show a dot. Tapping a cell calls
/// [onSelect] with that day at local midnight.
class HealynWeekStrip extends StatelessWidget {
  const HealynWeekStrip({
    required this.weekOf,
    required this.selected,
    required this.onSelect,
    this.markedDays = const {},
    this.padding = const EdgeInsets.symmetric(
      horizontal: HealynSpacing.screenEdge,
    ),
    super.key,
  });

  /// Any day within the week to display.
  final DateTime weekOf;
  final DateTime selected;
  final ValueChanged<DateTime> onSelect;
  final Set<DateTime> markedDays;
  final EdgeInsetsGeometry padding;

  static const List<String> _labels = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  @override
  Widget build(BuildContext context) {
    final base = DateTime(weekOf.year, weekOf.month, weekOf.day);
    final monday = base.subtract(Duration(days: base.weekday - DateTime.monday));
    final days = [for (var i = 0; i < 7; i++) monday.add(Duration(days: i))];

    return Padding(
      padding: padding,
      child: Row(
        children: [
          for (var i = 0; i < days.length; i++) ...[
            if (i > 0) const SizedBox(width: HealynSpacing.s2),
            Expanded(
              child: _DayCell(
                label: _labels[i],
                day: days[i],
                selected: _isSameDay(days[i], selected),
                marked: markedDays.any((m) => _isSameDay(m, days[i])),
                onTap: () => onSelect(days[i]),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.label,
    required this.day,
    required this.selected,
    required this.marked,
    required this.onTap,
  });

  final String label;
  final DateTime day;
  final bool selected;
  final bool marked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? HealynColors.textInverse : HealynColors.textMuted;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: HealynRadii.brLg,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: HealynSpacing.s3),
          decoration: BoxDecoration(
            gradient: selected ? HealynColors.brandGradient : null,
            borderRadius: HealynRadii.brLg,
            boxShadow: selected ? HealynElevation.e2 : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: HealynTypography.caption.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: HealynSpacing.s1),
              Text(
                '${day.day}',
                style: HealynTypography.bodyStrong.copyWith(
                  color: selected
                      ? HealynColors.textInverse
                      : HealynColors.textPrimary,
                ),
              ),
              const SizedBox(height: HealynSpacing.s1),
              // A reserved 5dp dot slot keeps every cell the same height.
              SizedBox(
                height: 5,
                width: 5,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: marked
                        ? (selected
                              ? HealynColors.textInverse
                              : HealynColors.brandPrimary)
                        : Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
