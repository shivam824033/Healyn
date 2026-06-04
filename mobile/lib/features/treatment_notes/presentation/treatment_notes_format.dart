// Presentation helpers for treatment-note timestamps. Instants arrive in UTC;
// every formatter converts to local before rendering. Pure functions.

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

/// A note's calendar day, e.g. `Wed, 10 Jun 2026`.
String formatNoteDate(DateTime instant) {
  final d = instant.toLocal();
  return '${_weekdays[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]} ${d.year}';
}

/// The next-review when-line: `Wed, 10 Jun 2026 · 9:00 AM`.
String formatReviewWhen(DateTime instant) {
  final d = instant.toLocal();
  final hour12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final minute = d.minute.toString().padLeft(2, '0');
  final period = d.hour < 12 ? 'AM' : 'PM';
  return '${formatNoteDate(instant)} · $hour12:$minute $period';
}
