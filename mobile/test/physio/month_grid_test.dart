import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/physio/presentation/month_grid.dart';

void main() {
  group('monthGridDays', () {
    test('June 2026 is a clean 5-week grid (the 1st is a Monday)', () {
      final days = monthGridDays(DateTime(2026, 6));

      expect(days.length, 35); // 5 weeks
      expect(days.first, DateTime(2026, 6, 1));
      expect(days.first.weekday, DateTime.monday);
      expect(days.last, DateTime(2026, 7, 5));
      expect(days.last.weekday, DateTime.sunday);
      // Every day of the month is present.
      for (var d = 1; d <= 30; d++) {
        expect(days.contains(DateTime(2026, 6, d)), isTrue, reason: 'day $d');
      }
    });

    test('pads leading days back to the Monday of the prior month', () {
      // 1 May 2026 is a Friday, so the grid opens on Mon 27 Apr.
      final days = monthGridDays(DateTime(2026, 5));

      expect(DateTime(2026, 5, 1).weekday, DateTime.friday);
      expect(days.first, DateTime(2026, 4, 27));
      expect(days.first.weekday, DateTime.monday);
      expect(days.last.weekday, DateTime.sunday);
    });

    test('always spans whole Monday→Sunday weeks, every month of a year', () {
      for (var m = 1; m <= 12; m++) {
        final days = monthGridDays(DateTime(2026, m));
        expect(days.length % 7, 0, reason: 'month $m length');
        expect(days.first.weekday, DateTime.monday, reason: 'month $m start');
        expect(days.last.weekday, DateTime.sunday, reason: 'month $m end');
      }
    });
  });

  group('monthGridWeeks', () {
    test('chunks the grid into rows of seven', () {
      final weeks = monthGridWeeks(DateTime(2026, 6));
      expect(weeks, hasLength(5));
      for (final week in weeks) {
        expect(week, hasLength(7));
      }
      expect(weeks.first.first, DateTime(2026, 6, 1));
      expect(weeks.last.last, DateTime(2026, 7, 5));
    });
  });

  group('monthGridRange', () {
    test('is the half-open window from the first cell to the day after the last',
        () {
      final (from, to) = monthGridRange(DateTime(2026, 6));
      expect(from, DateTime(2026, 6, 1));
      expect(to, DateTime(2026, 7, 6)); // day after Sun 5 Jul
      // The whole grid (≤ 42 days) sits inside the backend's 62-day cap.
      expect(to.difference(from).inDays, lessThanOrEqualTo(62));
    });
  });

  group('isSameDay / localDayOf', () {
    test('isSameDay ignores the time of day', () {
      expect(
        isSameDay(DateTime(2026, 6, 10, 9), DateTime(2026, 6, 10, 23, 59)),
        isTrue,
      );
      expect(isSameDay(DateTime(2026, 6, 10), DateTime(2026, 6, 11)), isFalse);
    });

    test('localDayOf drops the clock time to local midnight', () {
      expect(localDayOf(DateTime(2026, 6, 10, 14, 30)), DateTime(2026, 6, 10));
    });
  });
}
