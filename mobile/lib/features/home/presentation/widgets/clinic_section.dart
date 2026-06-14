import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../files/data/url_opener.dart';
import '../../../physio/data/models/physio_profile_models.dart';
import '../../../physio/data/physio_profile_repository.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/healyn_avatar.dart';
import '../../../shared/widgets/healyn_section_header.dart';
import '../../../shared/widgets/section_card.dart';

const _edge = EdgeInsets.symmetric(horizontal: HealynSpacing.screenEdge);

/// The patient-facing "Your clinic" section at the bottom of Home: who the
/// physiotherapist is, the clinic's details, and any social links they've added.
/// Reads the single physiotherapist profile (`physioProfileProvider`). Renders
/// nothing while loading/failed or when the profile is empty, so Home stays calm.
class ClinicSection extends ConsumerWidget {
  const ClinicSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(physioProfileProvider).valueOrNull;
    if (profile == null || profile.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: HealynSpacing.s5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: _edge,
            child: HealynSectionHeader(title: 'Your clinic'),
          ),
          const SizedBox(height: HealynSpacing.s3),
          if (profile.hasPhysioDetails) ...[
            Padding(padding: _edge, child: _PhysioCard(profile: profile)),
            const SizedBox(height: HealynSpacing.s3),
          ],
          if (profile.hasClinicDetails) ...[
            Padding(padding: _edge, child: _ClinicCard(profile: profile)),
            const SizedBox(height: HealynSpacing.s3),
          ],
          if (profile.hasSocialLinks)
            Padding(padding: _edge, child: _SocialRow(profile: profile)),
        ],
      ),
    );
  }
}

class _PhysioCard extends StatelessWidget {
  const _PhysioCard({required this.profile});

  final PhysioProfile profile;

  @override
  Widget build(BuildContext context) {
    final name = (profile.displayName?.trim().isNotEmpty ?? false)
        ? profile.displayName!.trim()
        : 'Your physiotherapist';
    final meta = <String>[
      if (profile.qualification?.trim().isNotEmpty ?? false)
        profile.qualification!.trim(),
      if (profile.experienceYears != null)
        '${profile.experienceYears} yrs experience',
      if (profile.specialization?.trim().isNotEmpty ?? false)
        profile.specialization!.trim(),
    ];

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Avatar(url: profile.avatarUrl, name: name, size: 56),
              const SizedBox(width: HealynSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: HealynTypography.bodyStrong),
                    if (meta.isNotEmpty) ...[
                      const SizedBox(height: HealynSpacing.s1),
                      Text(
                        meta.join(' · '),
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
          if (profile.bio?.trim().isNotEmpty ?? false) ...[
            const SizedBox(height: HealynSpacing.s3),
            Text(
              profile.bio!.trim(),
              style: HealynTypography.body.copyWith(
                color: HealynColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ClinicCard extends ConsumerWidget {
  const _ClinicCard({required this.profile});

  final PhysioProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phone = profile.clinicContactPhone?.trim();
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (profile.clinicName?.trim().isNotEmpty ?? false)
            Text(profile.clinicName!.trim(), style: HealynTypography.bodyStrong),
          if (profile.clinicAddress?.trim().isNotEmpty ?? false) ...[
            const SizedBox(height: HealynSpacing.s2),
            _IconLine(
              icon: Icons.place_outlined,
              child: Text(
                profile.clinicAddress!.trim(),
                style: HealynTypography.body.copyWith(
                  color: HealynColors.textSecondary,
                ),
              ),
            ),
          ],
          if (phone != null && phone.isNotEmpty) ...[
            const SizedBox(height: HealynSpacing.s2),
            _IconLine(
              icon: Icons.call_outlined,
              child: InkWell(
                onTap: () =>
                    ref.read(urlOpenerProvider).open('tel:$phone'),
                child: Text(
                  phone,
                  style: HealynTypography.body.copyWith(
                    color: HealynColors.brandPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
          if (profile.clinicDescription?.trim().isNotEmpty ?? false) ...[
            const SizedBox(height: HealynSpacing.s3),
            Text(
              profile.clinicDescription!.trim(),
              style: HealynTypography.body.copyWith(
                color: HealynColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SocialRow extends ConsumerWidget {
  const _SocialRow({required this.profile});

  final PhysioProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opener = ref.read(urlOpenerProvider);
    final links = <(IconData, String)>[
      if (profile.instagramUrl?.trim().isNotEmpty ?? false)
        (Icons.camera_alt_outlined, profile.instagramUrl!.trim()),
      if (profile.facebookUrl?.trim().isNotEmpty ?? false)
        (Icons.facebook_outlined, profile.facebookUrl!.trim()),
      if (profile.linkedinUrl?.trim().isNotEmpty ?? false)
        (Icons.work_outline, profile.linkedinUrl!.trim()),
      if (profile.websiteUrl?.trim().isNotEmpty ?? false)
        (Icons.language_outlined, profile.websiteUrl!.trim()),
    ];
    if (links.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: HealynSpacing.s3,
      children: [
        for (final (icon, url) in links)
          _SocialIcon(icon: icon, onTap: () => opener.open(url)),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  const _SocialIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HealynColors.brandPrimarySubtle,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(HealynSpacing.s3),
          child: Icon(icon, size: 22, color: HealynColors.brandPrimary),
        ),
      ),
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.child});

  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: HealynColors.textMuted),
        const SizedBox(width: HealynSpacing.s2),
        Expanded(child: child),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.url, required this.name, this.size = 56});

  final String? url;
  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return HealynAvatar(name: name, size: size);
    }
    return ClipOval(
      child: Image.network(
        url!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => HealynAvatar(name: name, size: size),
      ),
    );
  }
}
