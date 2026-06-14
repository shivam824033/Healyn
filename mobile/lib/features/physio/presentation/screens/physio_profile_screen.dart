import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../auth/presentation/widgets/signed_in_devices.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/healyn_avatar.dart';
import '../../../shared/widgets/healyn_section_header.dart';
import '../../../shared/widgets/nav_card.dart';
import '../../../shared/widgets/section_card.dart';
import '../../data/physio_profile_repository.dart';

/// The physiotherapist's profile tab. Identity plus account settings at parity
/// with the patient Profile (D5): notification settings and signed-in devices
/// (with per-device sign-out), then a full sign out.
class PhysioProfileScreen extends ConsumerWidget {
  const PhysioProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: const HealynAppBar(title: 'Profile'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref
              ..invalidate(signedInDevicesProvider)
              ..invalidate(currentSessionIdProvider)
              ..invalidate(physioProfileProvider);
            await ref.read(signedInDevicesProvider.future);
          },
          child: ListView(
            padding: const EdgeInsets.all(HealynSpacing.screenEdge),
            children: [
              const _ProfileSummaryCard(),
              const SizedBox(height: HealynSpacing.s6),
              const HealynSectionHeader(title: 'My profile'),
              const SizedBox(height: HealynSpacing.s3),
              NavCard(
                icon: Icons.badge_outlined,
                label: 'Edit profile & clinic details',
                onTap: () => context.push('/physio/profile/edit'),
              ),
              const SizedBox(height: HealynSpacing.s6),
              const HealynSectionHeader(title: 'Settings'),
              const SizedBox(height: HealynSpacing.s3),
              NavCard(
                icon: Icons.notifications_outlined,
                label: 'Notifications',
                onTap: () => context.push('/notifications/preferences'),
              ),
              const SizedBox(height: HealynSpacing.s6),
              const HealynSectionHeader(title: 'Privacy & data'),
              const SizedBox(height: HealynSpacing.s3),
              NavCard(
                icon: Icons.privacy_tip_outlined,
                label: 'Privacy Policy',
                onTap: () => context.push('/legal/privacy_policy'),
              ),
              const SizedBox(height: HealynSpacing.s3),
              NavCard(
                icon: Icons.description_outlined,
                label: 'Terms of Service',
                onTap: () => context.push('/legal/terms_of_service'),
              ),
              const SizedBox(height: HealynSpacing.s3),
              NavCard(
                icon: Icons.fact_check_outlined,
                label: 'Your consents',
                onTap: () => context.push('/me/consents'),
              ),
              const SizedBox(height: HealynSpacing.s3),
              NavCard(
                icon: Icons.delete_outline,
                label: 'Delete account',
                onTap: () => context.push('/account/deletion'),
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

/// The physiotherapist's identity at the top of the Profile tab: their photo (or
/// initials), name, and qualification, read from the profile. Falls back to a
/// generic label before any detail is entered.
class _ProfileSummaryCard extends ConsumerWidget {
  const _ProfileSummaryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(physioProfileProvider).valueOrNull;
    final name = (profile?.displayName?.trim().isNotEmpty ?? false)
        ? profile!.displayName!.trim()
        : 'Physiotherapist';
    final qualification = profile?.qualification?.trim();
    final avatarUrl = profile?.avatarUrl;

    return SectionCard(
      child: Row(
        children: [
          if (avatarUrl != null && avatarUrl.isNotEmpty)
            ClipOval(
              child: Image.network(
                avatarUrl,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => HealynAvatar(name: name, size: 48),
              ),
            )
          else
            HealynAvatar(name: name, size: 48),
          const SizedBox(width: HealynSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: HealynTypography.bodyStrong),
                if (qualification != null && qualification.isNotEmpty) ...[
                  const SizedBox(height: HealynSpacing.s1),
                  Text(
                    qualification,
                    style: HealynTypography.caption.copyWith(
                      color: HealynColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
