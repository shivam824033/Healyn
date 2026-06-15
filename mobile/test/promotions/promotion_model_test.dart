import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/promotions/data/models/promotion_models.dart';

void main() {
  group('Promotion.fromJson', () {
    test('parses the patient view and maps the CTA action', () {
      final p = Promotion.fromJson(const {
        'id': 'p1',
        'title': 'Sports rehab',
        'short_description': '6-week programme',
        'cta_text': 'Book now',
        'cta_action': 'BOOK_APPOINTMENT',
        'cover_url': 'https://example/cover.jpg',
        'display_order': 2,
      });
      expect(p.title, 'Sports rehab');
      expect(p.ctaAction, PromotionAction.bookAppointment);
      expect(p.hasCta, isTrue);
      expect(p.displayOrder, 2);
    });

    test('falls back to none for an unknown CTA action', () {
      final p = Promotion.fromJson(const {
        'id': 'p1',
        'title': 'Tip',
        'cta_action': 'SOMETHING_NEW',
      });
      expect(p.ctaAction, PromotionAction.none);
      expect(p.hasCta, isFalse);
    });

    test('hasCta is false when the label is blank even with an action', () {
      final p = Promotion.fromJson(const {
        'id': 'p1',
        'title': 'Tip',
        'cta_action': 'CALL_CLINIC',
      });
      expect(p.ctaAction, PromotionAction.callClinic);
      expect(p.hasCta, isFalse);
    });
  });

  group('ManagedPromotion', () {
    test('isScheduled / isExpired reflect the window', () {
      final scheduled = ManagedPromotion.fromJson({
        'id': 'p1',
        'title': 'Future',
        'starts_at': DateTime.now()
            .add(const Duration(days: 2))
            .toUtc()
            .toIso8601String(),
      });
      expect(scheduled.isScheduled, isTrue);
      expect(scheduled.isExpired, isFalse);

      final expired = ManagedPromotion.fromJson({
        'id': 'p2',
        'title': 'Past',
        'ends_at': DateTime.now()
            .subtract(const Duration(days: 1))
            .toUtc()
            .toIso8601String(),
      });
      expect(expired.isExpired, isTrue);
    });
  });
}
