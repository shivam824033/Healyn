import 'package:flutter/material.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';

/// Shown while [AuthStatus] is `unknown` (the token store is being read). The
/// router replaces it with /login or /home as soon as the status resolves.
///
/// The Refined Indigo hold screen: the Healyn wordmark centred on the signature
/// brand gradient, with a quiet progress hint below.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(gradient: HealynColors.brandGradient),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Healyn',
              style: HealynTypography.display.copyWith(
                color: HealynColors.textInverse,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: HealynSpacing.s7),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation(
                  HealynColors.textInverse.withValues(alpha: 0.9),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
