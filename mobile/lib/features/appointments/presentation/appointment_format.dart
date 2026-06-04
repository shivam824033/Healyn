// Presentation helpers for appointment dates/times. Instants arrive in UTC;
// every formatter converts to local time before rendering. Pure functions.

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

/// Local clock time as `9:00 AM` / `2:30 PM`.
String formatTimeOfDay(DateTime instant) {
  final t = instant.toLocal();
  final hour12 = t.hour % 12 == 0 ? 12 : t.hour % 12;
  final minute = t.minute.toString().padLeft(2, '0');
  final period = t.hour < 12 ? 'AM' : 'PM';
  return '$hour12:$minute $period';
}

/// Local calendar day as `Wed, 10 Jun 2026`.
String formatDateLong(DateTime instant) {
  final d = instant.toLocal();
  return '${_weekdays[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]} ${d.year}';
}

/// Local calendar day as `Wed, 10 Jun` — for compact headings / pickers.
String formatDateShort(DateTime instant) {
  final d = instant.toLocal();
  return '${_weekdays[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]}';
}

/// Full when-line for a tile or detail: `Wed, 10 Jun 2026 · 9:00 AM`.
String formatWhen(DateTime instant) =>
    '${formatDateLong(instant)} · ${formatTimeOfDay(instant)}';

/// Human duration: `45 min`, `1 hr`, `1 hr 30 min`.
String formatDuration(int minutes) {
  if (minutes < 60) return '$minutes min';
  final hours = minutes ~/ 60;
  final rest = minutes % 60;
  final hr = '$hours hr';
  return rest == 0 ? hr : '$hr $rest min';
}
