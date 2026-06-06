import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/shared/design/colors.dart';
import 'package:healyn/features/shared/widgets/app_bar.dart';

void main() {
  group('HealynAppBar (premium gradient header)', () {
    testWidgets('renders the title over the brand gradient', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: HealynAppBar(title: 'Schedule'),
            body: SizedBox.shrink(),
          ),
        ),
      );

      expect(find.text('Schedule'), findsOneWidget);

      // The indigo gradient lives in the AppBar's flexibleSpace — its presence
      // (and non-zero size) is what makes the header visible.
      final gradientBox = find.byWidgetPredicate(
        (w) =>
            w is DecoratedBox &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).gradient ==
                HealynColors.brandGradient,
      );
      expect(gradientBox, findsOneWidget);
      expect(tester.getSize(gradientBox).height, greaterThan(0));
    });

    testWidgets('reserves the standard toolbar height', (tester) async {
      const bar = HealynAppBar(title: 'X');
      expect(bar.preferredSize.height, kToolbarHeight);
    });

    testWidgets('renders a custom titleWidget and actions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: HealynAppBar(
              titleWidget: const Text('Custom'),
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
              ],
            ),
            body: const SizedBox.shrink(),
          ),
        ),
      );

      expect(find.text('Custom'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}
