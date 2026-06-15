import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/promotions/data/models/promotion_models.dart';
import 'package:healyn/features/promotions/data/promotions_repository.dart';
import 'package:healyn/features/promotions/presentation/widgets/promotions_carousel.dart';

Promotion _promo(String id, String title, {String? cta}) => Promotion(
      id: id,
      title: title,
      shortDescription: 'About $title',
      ctaText: cta,
      ctaAction:
          cta == null ? PromotionAction.none : PromotionAction.bookAppointment,
    );

Future<void> _pump(WidgetTester tester, List<Promotion> promotions) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        patientPromotionsProvider.overrideWith((ref) async => promotions),
      ],
      child: const MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: PromotionsCarousel())),
      ),
    ),
  );
  await tester.pump(); // resolve the future
}

void main() {
  testWidgets('renders the section header and the first card on data', (tester) async {
    await _pump(tester, [
      _promo('p1', 'Sports rehab', cta: 'Book now'),
      _promo('p2', 'Posture clinic'),
    ]);

    expect(find.text('From your clinic'), findsOneWidget);
    expect(find.text('Sports rehab'), findsOneWidget);
    // The CTA pill label shows for a promotion with an action.
    expect(find.text('Book now'), findsOneWidget);
  });

  testWidgets('renders nothing when there are no promotions', (tester) async {
    await _pump(tester, const []);

    expect(find.text('From your clinic'), findsNothing);
    expect(find.byType(PromotionsCarousel), findsOneWidget); // mounted, but empty
  });

  testWidgets('shows pagination dots only with more than one promotion', (tester) async {
    await _pump(tester, [_promo('p1', 'Only one')]);
    // A single promotion: header + card, but no auto-advance dots.
    expect(find.text('Only one'), findsOneWidget);
  });
}
