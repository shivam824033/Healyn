import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/presentation/appointment_format.dart';
import 'package:healyn/features/physio/presentation/widgets/month_calendar.dart';

Future<void> _pump(
  WidgetTester tester, {
  required DateTime month,
  required DateTime selectedDay,
  Set<DateTime> markedDays = const {},
  ValueChanged<DateTime>? onSelectDay,
  VoidCallback? onPrevMonth,
  VoidCallback? onNextMonth,
  VoidCallback? onToday,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: MonthCalendar(
          month: month,
          selectedDay: selectedDay,
          markedDays: markedDays,
          onSelectDay: onSelectDay ?? (_) {},
          onPrevMonth: onPrevMonth ?? () {},
          onNextMonth: onNextMonth ?? () {},
          onToday: onToday,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('renders the month label and the days of the month', (
    tester,
  ) async {
    await _pump(
      tester,
      month: DateTime(2026, 6),
      selectedDay: DateTime(2026, 6, 10),
    );

    expect(find.text(formatMonthYear(DateTime(2026, 6))), findsOneWidget);
    // Days 6–30 are unique to June here; 1–5 also appear as trailing July cells.
    expect(find.text('15'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
  });

  testWidgets('a marked day exposes a "has appointments" semantics hint', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await _pump(
      tester,
      month: DateTime(2026, 6),
      selectedDay: DateTime(2026, 6, 10),
      markedDays: {DateTime(2026, 6, 15)},
    );

    expect(find.bySemanticsLabel(RegExp('has appointments')), findsOneWidget);
    handle.dispose();
  });

  testWidgets('tapping a day reports that exact local date', (tester) async {
    DateTime? picked;
    await _pump(
      tester,
      month: DateTime(2026, 6),
      selectedDay: DateTime(2026, 6, 10),
      onSelectDay: (d) => picked = d,
    );

    await tester.tap(find.text('15'));
    expect(picked, DateTime(2026, 6, 15));
  });

  testWidgets('the month arrows fire their callbacks', (tester) async {
    var prev = 0;
    var next = 0;
    await _pump(
      tester,
      month: DateTime(2026, 6),
      selectedDay: DateTime(2026, 6, 10),
      onPrevMonth: () => prev++,
      onNextMonth: () => next++,
    );

    await tester.tap(find.byTooltip('Previous month'));
    await tester.tap(find.byTooltip('Next month'));

    expect(prev, 1);
    expect(next, 1);
  });

  testWidgets('the Today shortcut shows only when provided and fires', (
    tester,
  ) async {
    await _pump(
      tester,
      month: DateTime(2026, 6),
      selectedDay: DateTime(2026, 6, 10),
    );
    expect(find.text('Today'), findsNothing);

    var todays = 0;
    await _pump(
      tester,
      month: DateTime(2026, 6),
      selectedDay: DateTime(2026, 6, 10),
      onToday: () => todays++,
    );
    expect(find.text('Today'), findsOneWidget);

    await tester.tap(find.text('Today'));
    expect(todays, 1);
  });
}
