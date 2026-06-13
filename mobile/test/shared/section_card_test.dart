import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/shared/design/elevation.dart';
import 'package:healyn/features/shared/widgets/section_card.dart';

void main() {
  testWidgets('lifts on a soft e1 shadow while keeping its hairline border', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SectionCard(child: Text('Body'))),
      ),
    );

    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(SectionCard),
        matching: find.byType(Container),
      ),
    );
    final decoration = container.decoration! as BoxDecoration;

    expect(decoration.boxShadow, HealynElevation.e1);
    expect(decoration.border, isNotNull);
    expect(find.text('Body'), findsOneWidget);
  });
}
