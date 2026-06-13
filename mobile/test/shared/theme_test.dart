import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/shared/design/colors.dart';
import 'package:healyn/features/shared/design/theme.dart';

void main() {
  group('brand palette (UI_UX_GUIDELINES §2.1)', () {
    test('is the premium indigo, not the legacy teal', () {
      expect(HealynColors.brandPrimary, const Color(0xFF3B4AA0));
      expect(HealynColors.brandPrimaryHover, const Color(0xFF2E3A82));
      expect(HealynColors.brandPrimarySubtle, const Color(0xFFECEDF9));
    });
  });

  group('HealynTheme.light()', () {
    test('drives the color scheme and primary button from the brand token', () {
      final theme = HealynTheme.light();

      expect(theme.colorScheme.primary, HealynColors.brandPrimary);
      expect(theme.colorScheme.primaryContainer, HealynColors.brandPrimarySubtle);

      final buttonBg = theme.elevatedButtonTheme.style!.backgroundColor!
          .resolve(<WidgetState>{});
      expect(buttonBg, HealynColors.brandPrimary);
    });
  });
}
