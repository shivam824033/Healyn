import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/auth/presentation/screens/splash_screen.dart';
import 'package:healyn/features/shared/design/colors.dart';
import 'package:healyn/features/shared/design/spacing.dart';
import 'package:healyn/features/shared/design/theme.dart';
import 'package:healyn/features/shared/design/typography.dart';
import 'package:healyn/features/shared/widgets/healyn_hero.dart';
import 'package:healyn/features/shared/widgets/section_card.dart';

/// Refined Indigo layout goldens locked at a 360-dp phone width — the narrowest
/// mainstream device — at both the default text size and the largest scaling we
/// support (UI_UX_GUIDELINES §10: layouts must not clip up to 1.3×). Rendering
/// the kit primitives that compose every screen (hero, content card) with
/// deliberately long strings catches the two failure modes the Phase 4 audit
/// could not check statically: horizontal RenderFlex overflow and text clipping
/// under large type. The flutter_test font has fixed glyph metrics, so the
/// goldens are deterministic across machines.
///
/// Update with: `flutter test --update-goldens test/shared/refined_indigo_golden_test.dart`.

// A long name + prose, to stress wrapping/ellipsis at the narrow width.
const _longName = 'Aleksandranda Featherstonehaugh-Worthington';
const _longReason =
    'Persistent lower-back pain after a long-haul flight, worse in the '
    'mornings and when sitting for long stretches at a desk.';

void main() {
  Future<void> pumpAt360(
    WidgetTester tester,
    Widget child, {
    double textScale = 1.0,
  }) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(360, 1400);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: HealynTheme.light(),
        home: child,
        builder: (context, widget) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(textScale)),
          child: widget!,
        ),
      ),
    );
  }

  group('Refined Indigo — 360-dp layout goldens', () {
    testWidgets('hero header — default text size', (tester) async {
      await pumpAt360(tester, const _HeroSample());
      expect(tester.takeException(), isNull); // no overflow
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/hero_360.png'),
      );
    });

    testWidgets('hero header — 1.3× text size does not clip', (tester) async {
      await pumpAt360(tester, const _HeroSample(), textScale: 1.3);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/hero_360_textscale_1_3.png'),
      );
    });

    testWidgets('detail card — default text size', (tester) async {
      await pumpAt360(tester, const _DetailCardSample());
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/detail_card_360.png'),
      );
    });

    testWidgets('detail card — 1.3× text size does not clip', (tester) async {
      await pumpAt360(tester, const _DetailCardSample(), textScale: 1.3);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/detail_card_360_textscale_1_3.png'),
      );
    });

    testWidgets('splash screen', (tester) async {
      await pumpAt360(tester, const SplashScreen());
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/splash_360.png'),
      );
    });
  });
}

/// A hero with a full slate of slots (eyebrow + long title + subtitle + pill +
/// trailing) — the composition most prone to horizontal overflow.
class _HeroSample extends StatelessWidget {
  const _HeroSample();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      body: HealynHero(
        eyebrow: 'Wednesday, 17 September 2026',
        title: 'Aleksandranda Featherstonehaugh-Worthington',
        subtitle: 'Follow-up review · physiotherapy · room 3',
        pill: HealynHeroPill(
          icon: Icons.schedule,
          label: '9:30 AM – 10:15 AM',
        ),
        trailing: Icon(Icons.account_circle, size: 40, color: Colors.white),
      ),
    );
  }
}

/// A detail card of label/value rows with long values — mirrors the appointment
/// and patient detail screens, where a long value must wrap rather than clip.
class _DetailCardSample extends StatelessWidget {
  const _DetailCardSample();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(HealynSpacing.screenEdge),
          child: SectionCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Row(label: 'Patient', value: _longName),
                SizedBox(height: HealynSpacing.s3),
                _Row(label: 'Reason', value: _longReason),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 96,
          child: Text(label, style: HealynTypography.caption),
        ),
        const SizedBox(width: HealynSpacing.s3),
        Expanded(
          child: Text(
            value,
            style: HealynTypography.body,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
