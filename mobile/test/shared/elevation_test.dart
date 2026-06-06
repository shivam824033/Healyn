import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/shared/design/elevation.dart';

void main() {
  group('HealynElevation (UI_UX_GUIDELINES §4.4)', () {
    test('e0 is a flat surface (no shadow)', () {
      expect(HealynElevation.e0, isEmpty);
    });

    test('cards and modals carry the documented shadow layers', () {
      expect(HealynElevation.e1, hasLength(2));
      expect(HealynElevation.e2, hasLength(2));
      expect(HealynElevation.e3, hasLength(1));

      // e1: a crisp 1px contact shadow over a soft ambient lift (0 1px 2px / 0 2px 8px).
      expect(HealynElevation.e1[0].offset, const Offset(0, 1));
      expect(HealynElevation.e1[0].blurRadius, 2);
      expect(HealynElevation.e1[1].blurRadius, 8);

      // e3 (modal): 0 12px 32px — the deepest lift.
      expect(HealynElevation.e3.single.offset, const Offset(0, 12));
      expect(HealynElevation.e3.single.blurRadius, 32);
    });

    test('lift grows from card to sheet to modal', () {
      double maxBlur(List<BoxShadow> s) =>
          s.map((b) => b.blurRadius).fold(0, (a, b) => a > b ? a : b);

      expect(maxBlur(HealynElevation.e1), lessThan(maxBlur(HealynElevation.e2)));
      expect(maxBlur(HealynElevation.e2), lessThan(maxBlur(HealynElevation.e3)));
    });

    test('shadows are a translucent ink, never opaque', () {
      for (final shadow in [
        ...HealynElevation.e1,
        ...HealynElevation.e2,
        ...HealynElevation.e3,
      ]) {
        expect(shadow.color.a, lessThan(1.0));
      }
    });
  });
}
