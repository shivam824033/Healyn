import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/shared/widgets/card_header.dart';

Future<void> _pump(WidgetTester tester, Widget child) =>
    tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));

void main() {
  testWidgets('renders the icon and title', (tester) async {
    await _pump(
      tester,
      const CardHeader(
        icon: Icons.event_outlined,
        title: 'Upcoming appointments',
      ),
    );

    expect(find.byIcon(Icons.event_outlined), findsOneWidget);
    expect(find.text('Upcoming appointments'), findsOneWidget);
  });

  testWidgets('shows the trailing widget only when provided', (tester) async {
    await _pump(
      tester,
      const CardHeader(icon: Icons.inbox_outlined, title: 'Requests'),
    );
    expect(find.text('3'), findsNothing);

    await _pump(
      tester,
      const CardHeader(
        icon: Icons.inbox_outlined,
        title: 'Requests',
        trailing: Text('3'),
      ),
    );
    expect(find.text('3'), findsOneWidget);
  });
}
