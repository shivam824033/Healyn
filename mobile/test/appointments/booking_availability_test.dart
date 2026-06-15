import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/presentation/booking_availability.dart';
import 'package:healyn/features/availability/data/models/availability_models.dart';

void main() {
  // Slots are built with local DateTimes so `.toLocal()` is a no-op and the
  // comparisons are deterministic whatever timezone the test runner is in.
  AvailabilitySlot slot(DateTime start, {int minutes = 30}) => AvailabilitySlot(
    startsAt: start,
    endsAt: start.add(Duration(minutes: minutes)),
    durationMinutes: minutes,
  );

  final picked = DateTime(2026, 6, 20); // a date the patient picked

  group('deriveBookingHint', () {
    test('day with slots is available; no time picked leaves time null', () {
      final hint = deriveBookingHint(
        slots: [slot(DateTime(2026, 6, 20, 9, 0))],
        pickedDate: picked,
      );
      expect(hint.dayAvailable, isTrue);
      expect(hint.preferredTimeAvailable, isNull);
      expect(composeBookingHint(hint), isNull);
    });

    test('day with no slots reports the next open day', () {
      final hint = deriveBookingHint(
        slots: [
          slot(DateTime(2026, 6, 23, 9, 0)),
          slot(DateTime(2026, 6, 22, 10, 0)), // earlier later-day wins
        ],
        pickedDate: picked,
      );
      expect(hint.dayAvailable, isFalse);
      expect(hint.nextAvailableDate, DateTime(2026, 6, 22));

      final msg = composeBookingHint(hint)!;
      expect(msg.tone, BookingHintTone.warning);
      expect(msg.subtitle, contains('Next available'));
    });

    test('unavailable day with no later slots omits the next-open line', () {
      final hint = deriveBookingHint(slots: const [], pickedDate: picked);
      expect(hint.dayAvailable, isFalse);
      expect(hint.nextAvailableDate, isNull);

      final msg = composeBookingHint(hint)!;
      expect(msg.tone, BookingHintTone.warning);
      expect(msg.subtitle, isNot(contains('Next available')));
    });

    test('preferred time inside a slot is available', () {
      final hint = deriveBookingHint(
        slots: [slot(DateTime(2026, 6, 20, 9, 0))],
        pickedDate: picked,
        preferredMinutes: 9 * 60 + 15,
      );
      expect(hint.preferredTimeAvailable, isTrue);
      expect(composeBookingHint(hint), isNull);
    });

    test('preferred time outside every slot is flagged as info', () {
      final hint = deriveBookingHint(
        slots: [slot(DateTime(2026, 6, 20, 9, 0))],
        pickedDate: picked,
        preferredMinutes: 14 * 60, // 2pm, after the 9:00–9:30 slot
      );
      expect(hint.dayAvailable, isTrue);
      expect(hint.preferredTimeAvailable, isFalse);

      final msg = composeBookingHint(hint)!;
      expect(msg.tone, BookingHintTone.info);
    });

    test('slot end is exclusive', () {
      final hint = deriveBookingHint(
        slots: [slot(DateTime(2026, 6, 20, 9, 0))], // 9:00–9:30
        pickedDate: picked,
        preferredMinutes: 9 * 60 + 30, // exactly 9:30 is not covered
      );
      expect(hint.preferredTimeAvailable, isFalse);
    });
  });
}
