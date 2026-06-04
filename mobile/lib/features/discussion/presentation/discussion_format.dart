// Presentation helpers for discussion timestamps. Instants arrive in UTC; every
// formatter converts to local before rendering. Pure functions.

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

/// Local clock time on a bubble footer as `9:00 AM` / `2:30 PM`.
String formatClockTime(DateTime instant) {
  final t = instant.toLocal();
  final hour12 = t.hour % 12 == 0 ? 12 : t.hour % 12;
  final minute = t.minute.toString().padLeft(2, '0');
  final period = t.hour < 12 ? 'AM' : 'PM';
  return '$hour12:$minute $period';
}

/// A day-separator label for the stream: `Today`, `Yesterday`, or a calendar
/// day like `Wed, 10 Jun 2026`. [now] is injectable for deterministic tests.
String daySeparatorLabel(DateTime instant, {DateTime? now}) {
  final d = instant.toLocal();
  final today = (now ?? DateTime.now()).toLocal();
  final thatDay = DateTime(d.year, d.month, d.day);
  final todayDay = DateTime(today.year, today.month, today.day);
  final diff = todayDay.difference(thatDay).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  return '${_weekdays[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]} ${d.year}';
}

/// Whether two instants fall on the same local calendar day — used to decide
/// where a day separator goes in the stream.
bool sameLocalDay(DateTime a, DateTime b) {
  final la = a.toLocal();
  final lb = b.toLocal();
  return la.year == lb.year && la.month == lb.month && la.day == lb.day;
}

/// Compact human file size for an attachment chip: `12 KB`, `3.4 MB`.
String formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  final kb = bytes / 1024;
  if (kb < 1024) return '${kb.toStringAsFixed(kb < 10 ? 1 : 0)} KB';
  final mb = kb / 1024;
  return '${mb.toStringAsFixed(mb < 10 ? 1 : 0)} MB';
}
