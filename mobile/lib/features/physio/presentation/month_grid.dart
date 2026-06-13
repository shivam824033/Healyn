// Pure date math for the Today-screen month calendar. A "month" is identified by
// any DateTime in it; cells are local-midnight days. Week starts Monday, matching
// the app's weekday labels. All arithmetic goes through the DateTime constructor
// (which normalises overflow) so it stays correct across DST and month ends.

/// The first day of [month] at local midnight.
DateTime firstOfMonth(DateTime month) => DateTime(month.year, month.month, 1);

/// The number of days in [month].
int daysInMonth(DateTime month) => DateTime(month.year, month.month + 1, 0).day;

/// The local-midnight day for an instant (drops the time-of-day).
DateTime localDayOf(DateTime instant) {
  final l = instant.toLocal();
  return DateTime(l.year, l.month, l.day);
}

/// Whether two DateTimes fall on the same local calendar day.
bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Every cell of [month]'s grid, in order: the leading days back to the Monday
/// on/before the 1st, the month itself, and the trailing days out to the Sunday
/// on/after the last. Always a whole number of weeks (length is a multiple of 7,
/// 4–6 rows). Adjacent-month cells let the grid mark appointments that spill in.
List<DateTime> monthGridDays(DateTime month) {
  final first = firstOfMonth(month);
  final leading = first.weekday - DateTime.monday; // Mon→0 … Sun→6
  final lastDay = daysInMonth(month);
  final lastWeekday = DateTime(month.year, month.month, lastDay).weekday;
  final trailing = DateTime.sunday - lastWeekday; // Sun→0 … Mon→6
  final total = leading + lastDay + trailing;
  return [
    for (var i = 0; i < total; i++)
      DateTime(first.year, first.month, 1 - leading + i),
  ];
}

/// [monthGridDays] chunked into weeks of seven, top to bottom.
List<List<DateTime>> monthGridWeeks(DateTime month) {
  final days = monthGridDays(month);
  return [
    for (var i = 0; i < days.length; i += 7) days.sublist(i, i + 7),
  ];
}

/// The half-open instant window `[from, to)` spanning the whole grid, as local
/// midnights — the bounds to pass to `GET /appointments/calendar`. `from` is the
/// first cell; `to` is the day after the last cell (≤ 42 days, within the
/// backend's 62-day cap).
(DateTime from, DateTime to) monthGridRange(DateTime month) {
  final days = monthGridDays(month);
  final first = days.first;
  final last = days.last;
  return (
    DateTime(first.year, first.month, first.day),
    DateTime(last.year, last.month, last.day + 1),
  );
}
