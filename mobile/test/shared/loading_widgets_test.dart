import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/shared/widgets/healyn_loader.dart';
import 'package:healyn/features/shared/widgets/healyn_reveal.dart';
import 'package:healyn/features/shared/widgets/healyn_shimmer.dart';
import 'package:healyn/features/shared/widgets/healyn_skeletons.dart';

void main() {
  group('HealynReveal', () {
    testWidgets('renders its child and settles at rest (finite entrance)', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HealynReveal(child: Text('hello')),
          ),
        ),
      );

      // Present from the first frame (mid-fade), and the one-shot animation
      // completes — pumpAndSettle would hang on an endless animation.
      expect(find.text('hello'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('staggered factory delays by index without dropping the child', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                HealynReveal.staggered(index: 0, child: const Text('a')),
                HealynReveal.staggered(index: 3, child: const Text('b')),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('a'), findsOneWidget);
      expect(find.text('b'), findsOneWidget);
    });
  });

  testWidgets('HealynShimmer builds over a skeleton tree', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HealynShimmer(
            child: Column(
              children: [
                HealynSwitcherSkeleton(),
                HealynListRowSkeleton(),
                HealynSkeletonLine(widthFactor: 0.5),
              ],
            ),
          ),
        ),
      ),
    );

    // The shimmer loops forever, so pump a few frames rather than settling.
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(HealynShimmer), findsOneWidget);
    expect(find.byType(HealynListRowSkeleton), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('HealynPulseLoader builds and animates', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: HealynPulseLoader()),
      ),
    );

    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(HealynPulseLoader), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
