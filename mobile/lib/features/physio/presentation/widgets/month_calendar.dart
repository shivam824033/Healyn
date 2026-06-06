import 'package:flutter/material.dart';

import '../../../appointments/presentation/appointment_format.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../month_grid.dart';

const _weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

/// A compact month grid for the physiotherapist's Today screen. Pure UI: it
/// renders [month] with [selectedDay] highlighted and a dot under every day in
/// [markedDays], and reports interaction through callbacks — it holds no state
/// and reads no providers, so it golden- and widget-tests in isolation.
///
/// Week starts Monday. Days outside [month] (the leading/trailing cells) render
/// muted but stay tappable, so a marked appointment spilling in from a
/// neighbouring month is still reachable.
class MonthCalendar extends StatelessWidget {
  const MonthCalendar({
    super.key,
    required this.month,
    required this.selectedDay,
    required this.markedDays,
    required this.onSelectDay,
    required this.onPrevMonth,
    required this.onNextMonth,
    this.onToday,
  });

  /// Any day in the visible month; only its year/month are read.
  final DateTime month;

  /// The currently selected day (local midnight).
  final DateTime selectedDay;

  /// Local-midnight days that hold at least one appointment.
  final Set<DateTime> markedDays;

  final ValueChanged<DateTime> onSelectDay;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  /// Shown as a "Today" shortcut when the selected day is not already today;
  /// null hides it.
  final VoidCallback? onToday;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: HealynSpacing.s2,
        vertical: HealynSpacing.s2,
      ),
      child: Column(
        children: [
          _header(),
          const SizedBox(height: HealynSpacing.s1),
          _weekdayRow(),
          const SizedBox(height: HealynSpacing.s1),
          for (final week in monthGridWeeks(month))
            Row(
              children: [
                for (final day in week)
                  Expanded(
                    child: _DayCell(
                      day: day,
                      inMonth: day.month == month.month,
                      selected: isSameDay(day, selectedDay),
                      isToday: isSameDay(day, today),
                      marked: markedDays.contains(day),
                      onTap: () => onSelectDay(day),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        IconButton(
          tooltip: 'Previous month',
          icon: const Icon(Icons.chevron_left),
          onPressed: onPrevMonth,
        ),
        Expanded(
          child: Text(
            formatMonthYear(month),
            style: HealynTypography.bodyStrong,
            textAlign: TextAlign.center,
          ),
        ),
        if (onToday != null)
          TextButton(
            onPressed: onToday,
            style: TextButton.styleFrom(
              minimumSize: const Size(0, 36),
              padding: const EdgeInsets.symmetric(
                horizontal: HealynSpacing.s2,
              ),
              foregroundColor: HealynColors.brandPrimary,
            ),
            child: const Text('Today'),
          ),
        IconButton(
          tooltip: 'Next month',
          icon: const Icon(Icons.chevron_right),
          onPressed: onNextMonth,
        ),
      ],
    );
  }

  Widget _weekdayRow() {
    return Row(
      children: [
        for (final label in _weekdayLabels)
          Expanded(
            child: Center(
              child: Text(
                label,
                style: HealynTypography.caption.copyWith(
                  color: HealynColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.inMonth,
    required this.selected,
    required this.isToday,
    required this.marked,
    required this.onTap,
  });

  final DateTime day;
  final bool inMonth;
  final bool selected;
  final bool isToday;
  final bool marked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color textColor;
    if (selected) {
      textColor = HealynColors.textInverse;
    } else if (!inMonth) {
      textColor = HealynColors.textMuted;
    } else {
      textColor = HealynColors.textPrimary;
    }

    return Semantics(
      button: true,
      selected: selected,
      label: '${formatDateLong(day)}${marked ? ', has appointments' : ''}',
      child: InkResponse(
        onTap: onTap,
        radius: 26,
        child: SizedBox(
          height: 44,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? HealynColors.brandPrimary : null,
                  shape: BoxShape.circle,
                  border: !selected && isToday
                      ? Border.all(color: HealynColors.brandPrimary)
                      : null,
                ),
                child: Text(
                  '${day.day}',
                  style: HealynTypography.body.copyWith(
                    color: textColor,
                    fontWeight: selected || isToday
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              // A fixed-size slot keeps every row the same height whether or not
              // the day is marked.
              SizedBox(
                height: 5,
                child: marked
                    ? Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: selected
                              ? HealynColors.textInverse
                              : HealynColors.brandPrimary,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
