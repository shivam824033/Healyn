// Presentation helpers for availability rules and blackouts. Rule clock strings
// are wire `"HH:mm[:ss]"` values in the rule's own timezone (rendered as-is, not
// converted); blackout instants arrive in UTC and are shown in local time. Pure
// functions.

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

/// Full weekday name for a wire day-of-week (`0=Sun … 6=Sat`).
const _dayNames = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
];

String dayOfWeekLabel(int dayOfWeek) => _dayNames[dayOfWeek % 7];

/// Monday-first sort key for a wire day-of-week (`0=Sun … 6=Sat`): Mon→0 … Sun→6.
int dayDisplayOrder(int dayOfWeek) => (dayOfWeek + 6) % 7;

/// A wire clock string `"HH:mm[:ss]"` as `9:00 AM` / `2:30 PM`.
String formatClockTime(String wire) {
  final parts = wire.split(':');
  final hour = int.tryParse(parts.first) ?? 0;
  final minute = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
  final hour12 = hour % 12 == 0 ? 12 : hour % 12;
  final period = hour < 12 ? 'AM' : 'PM';
  return '$hour12:${minute.toString().padLeft(2, '0')} $period';
}

/// A rule's daily window as `9:00 AM – 1:00 PM`.
String formatTimeRange(String startTime, String endTime) =>
    '${formatClockTime(startTime)} – ${formatClockTime(endTime)}';

String _dateLong(DateTime d) =>
    '${_weekdays[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]} ${d.year}';

String _clockOf(DateTime d) {
  final hour12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final period = d.hour < 12 ? 'AM' : 'PM';
  return '$hour12:${d.minute.toString().padLeft(2, '0')} $period';
}

/// A blackout window in local time. Same calendar day:
/// `Wed, 10 Jun 2026 · 9:00 AM – 11:00 AM`. Spanning days:
/// `Wed, 10 Jun 2026, 9:00 AM → Thu, 11 Jun 2026, 8:00 AM`.
String formatBlackoutRange(DateTime startsAt, DateTime endsAt) {
  final s = startsAt.toLocal();
  final e = endsAt.toLocal();
  final sameDay = s.year == e.year && s.month == e.month && s.day == e.day;
  if (sameDay) {
    return '${_dateLong(s)} · ${_clockOf(s)} – ${_clockOf(e)}';
  }
  return '${_dateLong(s)}, ${_clockOf(s)} → ${_dateLong(e)}, ${_clockOf(e)}';
}
