import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/section_card.dart';

/// The physiotherapist's profile tab. Minimal in C1 — identity + sign out — so
/// the physio is never stuck in the app. Richer settings land later.
class PhysioProfileScreen extends ConsumerWidget {
  const PhysioProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(HealynSpacing.screenEdge),
          children: [
            const SectionCard(
              child: Row(
                children: [
                  Icon(
                    Icons.medical_services_outlined,
                    color: HealynColors.brandPrimary,
                  ),
                  SizedBox(width: HealynSpacing.s3),
                  Expanded(
                    child: Text(
                      'Physiotherapist',
                      style: HealynTypography.bodyStrong,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: HealynSpacing.s5),
            OutlinedButton.icon(
              onPressed: () =>
                  ref.read(authControllerProvider.notifier).logout(),
              icon: const Icon(Icons.logout),
              label: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
