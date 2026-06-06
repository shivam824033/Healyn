// Presentation helpers for appointment dates/times. Instants arrive in UTC;
// every formatter converts to local time before rendering. Pure functions.

import '../data/models/appointment_models.dart';

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

/// A wire `HH:mm[:ss]` clock string (a backend `LocalTime`) as `9:30 AM`.
/// Returns null when [wire] is null or unparseable, so callers can fall back.
String? formatClockTime(String? wire) {
  if (wire == null) return null;
  final parts = wire.split(':');
  if (parts.length < 2) return null;
  final h = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  if (h == null || m == null) return null;
  final hour12 = h % 12 == 0 ? 12 : h % 12;
  final minute = m.toString().padLeft(2, '0');
  final period = h < 12 ? 'AM' : 'PM';
  return '$hour12:$minute $period';
}

/// The wire `HH:mm:ss` (a `LocalTime`) for a picked time-of-day; seconds are
/// always `00`. Used when sending an optional preferred-time hint.
String wireClockTime(int hour, int minute) =>
    '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:00';

/// The full when-line for an appointment, whatever its status: the confirmed
/// date + time once scheduled, otherwise the requested day with a note that the
/// physiotherapist will confirm the time.
String formatAppointmentWhen(Appointment a) {
  final at = a.scheduledAt;
  if (at != null) return formatWhen(at);
  return '${formatDateLong(a.requestedDate)} · time to be confirmed';
}

/// A compact date(+time) line for a tile. A scheduled appointment shows
/// `Wed, 10 Jun · 9:00 AM`; an unscheduled request shows
/// `Wed, 10 Jun · Time to be confirmed`.
String formatAppointmentWhenShort(Appointment a) {
  final at = a.scheduledAt;
  if (at != null) {
    return '${formatDateShort(at)} · ${formatTimeOfDay(at)}';
  }
  return '${formatDateShort(a.requestedDate)} · Time to be confirmed';
}

/// Human duration: `45 min`, `1 hr`, `1 hr 30 min`.
String formatDuration(int minutes) {
  if (minutes < 60) return '$minutes min';
  final hours = minutes ~/ 60;
  final rest = minutes % 60;
  final hr = '$hours hr';
  return rest == 0 ? hr : '$hr $rest min';
}
