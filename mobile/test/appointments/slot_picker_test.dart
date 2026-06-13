import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';
import 'package:healyn/features/appointments/presentation/widgets/slot_picker.dart';

Slot _slot(int hour) => Slot(
  startsAt: DateTime.utc(2026, 6, 10, hour),
  endsAt: DateTime.utc(2026, 6, 10, hour, 45),
  durationMinutes: 45,
);

Widget _host(Widget child) =>
    MaterialApp(home: Scaffold(body: SingleChildScrollView(child: child)));

void main() {
  testWidgets('open slots are selectable chips, booked ones are not', (
    tester,
  ) async {
    Slot? picked;
    final open = _slot(9);
    final booked = _slot(11);

    await tester.pumpWidget(
      _host(
        SlotPicker(
          label: 'Available times',
          day: DateTime.utc(2026, 6, 10),
          loading: false,
          error: null,
          slots: [open, booked],
          selected: null,
          enabled: true,
          onSelected: (s) => picked = s,
          onRetry: () {},
          bookedStarts: {booked.startsAt},
        ),
      ),
    );

    // Both times render; the booked one is flagged and explained.
    expect(find.text(formatLocal(open.startsAt)), findsOneWidget);
    expect(find.text(formatLocal(booked.startsAt)), findsOneWidget);
    expect(find.byIcon(Icons.event_busy), findsOneWidget);
    expect(find.text('Amber times are already booked.'), findsOneWidget);

    // The booked time is a plain Chip (not a ChoiceChip), so it can't be picked.
    await tester.tap(find.text(formatLocal(booked.startsAt)));
    await tester.pump();
    expect(picked, isNull);

    // The open time selects.
    await tester.tap(find.text(formatLocal(open.startsAt)));
    await tester.pump();
    expect(picked, open);
  });

  testWidgets('no booked legend when nothing is taken', (tester) async {
    await tester.pumpWidget(
      _host(
        SlotPicker(
          label: 'Available times',
          day: DateTime.utc(2026, 6, 10),
          loading: false,
          error: null,
          slots: [_slot(9)],
          selected: null,
          enabled: true,
          onSelected: (_) {},
          onRetry: () {},
        ),
      ),
    );

    expect(find.byIcon(Icons.event_busy), findsNothing);
    expect(find.text('Amber times are already booked.'), findsNothing);
  });
}

/// The chip label is the slot's local clock time (see appointment_format).
String formatLocal(DateTime instant) {
  final t = instant.toLocal();
  final hour12 = t.hour % 12 == 0 ? 12 : t.hour % 12;
  final minute = t.minute.toString().padLeft(2, '0');
  final period = t.hour < 12 ? 'AM' : 'PM';
  return '$hour12:$minute $period';
}
