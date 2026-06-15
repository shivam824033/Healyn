// Pure logic for the non-blocking availability hint shown while a patient is
// choosing a date/time to request (or reschedule) an appointment. Booking is
// request-first: the physiotherapist always finalises the date and time, so
// this never blocks the request — it only tells the patient, up front, when the
// physiotherapist isn't working or their preferred time falls outside hours.
//
// Slots come from `GET /availability` (working hours minus time-off). Instants
// arrive in UTC; every comparison is done in local time, against the locally
// picked calendar day. Pure functions — no Flutter, no I/O.

import '../../availability/data/models/availability_models.dart';
import 'appointment_format.dart';

/// The tone of a [BookingHintMessage] — maps to the info-banner tones.
enum BookingHintTone { info, warning }

/// What the hint computed for a picked date (+ optional preferred time).
class BookingAvailabilityHint {
  const BookingAvailabilityHint({
    required this.dayAvailable,
    this.nextAvailableDate,
    this.preferredTimeAvailable,
  });

  /// Whether the physiotherapist has any open slot on the picked day.
  final bool dayAvailable;

  /// The first open day strictly after the picked day within the looked-up
  /// window (local, date-only), or null if none was found.
  final DateTime? nextAvailableDate;

  /// Whether the preferred time falls inside an open slot on the picked day;
  /// null when the patient picked no preferred time.
  final bool? preferredTimeAvailable;
}

/// A composed hint ready to render, or null when there is nothing to flag
/// (the physiotherapist is available and the preferred time, if any, fits).
class BookingHintMessage {
  const BookingHintMessage({
    required this.tone,
    required this.title,
    required this.subtitle,
  });

  final BookingHintTone tone;
  final String title;
  final String subtitle;
}

/// Derives the hint from the slots returned for `[pickedDate, window]`.
/// [pickedDate] is a local calendar day; [preferredMinutes] is minutes since
/// local midnight, or null when no preference was set.
BookingAvailabilityHint deriveBookingHint({
  required List<AvailabilitySlot> slots,
  required DateTime pickedDate,
  int? preferredMinutes,
}) {
  final day = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
  var dayAvailable = false;
  var preferredAvailable = false;
  DateTime? nextDate;

  for (final slot in slots) {
    final start = slot.startsAt.toLocal();
    final startDay = DateTime(start.year, start.month, start.day);
    if (startDay == day) {
      dayAvailable = true;
      if (preferredMinutes != null) {
        final target = day.add(Duration(minutes: preferredMinutes));
        final end = slot.endsAt.toLocal();
        if (!start.isAfter(target) && target.isBefore(end)) {
          preferredAvailable = true;
        }
      }
    } else if (startDay.isAfter(day)) {
      if (nextDate == null || startDay.isBefore(nextDate)) {
        nextDate = startDay;
      }
    }
  }

  return BookingAvailabilityHint(
    dayAvailable: dayAvailable,
    nextAvailableDate: nextDate,
    preferredTimeAvailable: preferredMinutes == null ? null : preferredAvailable,
  );
}

/// Composes the user-facing message for a hint, or null when nothing needs to
/// be surfaced. A non-working day takes precedence over a preferred-time note.
BookingHintMessage? composeBookingHint(BookingAvailabilityHint hint) {
  if (!hint.dayAvailable) {
    final next = hint.nextAvailableDate;
    final subtitle = next != null
        ? 'Next available from ${formatDateLong(next)}. You can still request '
              'this date — the physiotherapist confirms the final date and time.'
        : 'You can still request this date — the physiotherapist confirms the '
              'final date and time.';
    return BookingHintMessage(
      tone: BookingHintTone.warning,
      title: 'The physiotherapist is not available on this date',
      subtitle: subtitle,
    );
  }

  if (hint.preferredTimeAvailable == false) {
    return const BookingHintMessage(
      tone: BookingHintTone.info,
      title: 'Your preferred time may not be available',
      subtitle: 'It falls outside the physiotherapist\'s hours that day. You '
          'can still request it — they confirm the final time.',
    );
  }

  return null;
}
