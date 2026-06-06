import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../auth/presentation/widgets/signed_in_devices.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/nav_card.dart';
import '../../../shared/widgets/section_card.dart';

/// The physiotherapist's profile tab. Identity plus account settings at parity
/// with the patient Profile (D5): notification settings and signed-in devices
/// (with per-device sign-out), then a full sign out.
class PhysioProfileScreen extends ConsumerWidget {
  const PhysioProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const HealynAppBar(title: 'Profile'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref
              ..invalidate(signedInDevicesProvider)
              ..invalidate(currentSessionIdProvider);
            await ref.read(signedInDevicesProvider.future);
          },
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
              const SizedBox(height: HealynSpacing.s6),
              const Text('SETTINGS', style: HealynTypography.overline),
              const SizedBox(height: HealynSpacing.s3),
              NavCard(
                icon: Icons.notifications_outlined,
                label: 'Notifications',
                onTap: () => context.push('/notifications/preferences'),
              ),
              const SizedBox(height: HealynSpacing.s6),
              const SignedInDevicesSection(),
              const SizedBox(height: HealynSpacing.s6),
              OutlinedButton.icon(
                onPressed: () =>
                    ref.read(authControllerProvider.notifier).logout(),
                icon: const Icon(Icons.logout),
                label: const Text('Sign out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: HealynColors.statusDanger,
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: HealynColors.borderSubtle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
