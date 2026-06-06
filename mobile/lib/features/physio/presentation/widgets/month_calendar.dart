import 'package:flutter/material.dart';

import '../../../appointments/presentation/appointment_format.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/elevation.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../month_grid.dart';

const _weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

/// A compact month grid for the physiotherapist's Today screen. Pure UI: it
/// renders [month] with [selectedDay] highlighted and a dot under every day in
/// [markedDays], and reports interaction through callbacks — it holds no state
/// and reads no providers, so it golden- and widget-tests in isolation.
///
/// The grid lives on a premium bordered card. Week starts Monday. Days outside
/// [month] (the leading/trailing cells) render muted but stay tappable, so a
/// marked appointment spilling in from a neighbouring month is still reachable.
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
    return Container(
      margin: const EdgeInsets.fromLTRB(
        HealynSpacing.screenEdge,
        HealynSpacing.s3,
        HealynSpacing.screenEdge,
        HealynSpacing.s2,
      ),
      padding: const EdgeInsets.fromLTRB(
        HealynSpacing.s3,
        HealynSpacing.s2,
        HealynSpacing.s3,
        HealynSpacing.s3,
      ),
      decoration: BoxDecoration(
        color: HealynColors.surfaceBase,
        borderRadius: HealynRadii.brXl,
        border: Border.all(color: HealynColors.borderSubtle),
        boxShadow: HealynElevation.e1,
      ),
      child: Column(
        children: [
          _header(),
          const SizedBox(height: HealynSpacing.s2),
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
        _ArrowButton(
          tooltip: 'Previous month',
          icon: Icons.chevron_left,
          onPressed: onPrevMonth,
        ),
        Expanded(
          child: Text(
            formatMonthYear(month),
            style: HealynTypography.h3,
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
        _ArrowButton(
          tooltip: 'Next month',
          icon: Icons.chevron_right,
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
                style: HealynTypography.overline.copyWith(
                  color: HealynColors.textMuted,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// A round, brand-tinted month stepper button — softer than a bare icon.
class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      icon: Icon(icon),
      onPressed: onPressed,
      iconSize: 22,
      color: HealynColors.brandPrimary,
      style: IconButton.styleFrom(
        backgroundColor: HealynColors.brandPrimarySubtle,
        minimumSize: const Size(36, 36),
        padding: EdgeInsets.zero,
      ),
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
    } else if (isToday) {
      textColor = HealynColors.brandPrimary;
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
        radius: 28,
        child: SizedBox(
          height: 46,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: selected ? HealynColors.brandGradient : null,
                  color: !selected && isToday
                      ? HealynColors.brandPrimarySubtle
                      : null,
                  shape: BoxShape.circle,
                  boxShadow: selected ? HealynElevation.e1 : null,
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
              const SizedBox(height: 3),
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
