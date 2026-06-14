import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/healyn_skeletons.dart';
import '../../../shared/widgets/section_card.dart';
import '../../data/models/compliance_models.dart';
import '../compliance_providers.dart';

/// Read-only consent history (API_STANDARDS §9.9) — the account's demonstrable
/// record of what it agreed to and when, including each legal-document version.
/// Withdrawing the essential consents is the same as erasing the account, so the
/// withdrawal path lives on the account-deletion screen rather than here.
class ConsentsScreen extends ConsumerWidget {
  const ConsentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consents = ref.watch(consentsControllerProvider);
    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: const HealynAppBar(title: 'Your consents'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(consentsControllerProvider);
            await ref.read(consentsControllerProvider.future);
          },
          child: consents.when(
            loading: () => const HealynListSkeleton(
              hasLeading: false,
              hasFooter: false,
              count: 4,
            ),
            error: (_, _) => ListView(
              padding: const EdgeInsets.all(HealynSpacing.screenEdge),
              children: const [
                ErrorBanner(
                  message: 'Could not load your consents. Pull down to retry.',
                ),
              ],
            ),
            data: (list) => _Body(consents: list),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.consents});

  final List<ConsentView> consents;

  @override
  Widget build(BuildContext context) {
    if (consents.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(HealynSpacing.screenEdge),
        children: [
          Text(
            'No consents recorded yet.',
            style: HealynTypography.body.copyWith(
              color: HealynColors.textMuted,
            ),
          ),
        ],
      );
    }
    return ListView(
      padding: const EdgeInsets.all(HealynSpacing.screenEdge),
      children: [
        const Text(
          'A record of what you agreed to, and when. This is kept for your '
          'health data to be processed lawfully.',
          style: HealynTypography.caption,
        ),
        const SizedBox(height: HealynSpacing.s4),
        for (final c in consents) ...[
          _ConsentTile(consent: c),
          const SizedBox(height: HealynSpacing.s3),
        ],
      ],
    );
  }
}

class _ConsentTile extends StatelessWidget {
  const _ConsentTile({required this.consent});

  final ConsentView consent;

  @override
  Widget build(BuildContext context) {
    final when = consent.granted ? consent.grantedAt : consent.withdrawnAt;
    final subtitleParts = <String>[
      if (when != null) _formatDate(when.toLocal()),
      if (consent.documentVersion != null) 'v${consent.documentVersion}',
    ];
    return SectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(consent.consentType.label, style: HealynTypography.bodyStrong),
                if (subtitleParts.isNotEmpty) ...[
                  const SizedBox(height: HealynSpacing.s1),
                  Text(
                    subtitleParts.join(' · '),
                    style: HealynTypography.caption.copyWith(
                      color: HealynColors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: HealynSpacing.s3),
          _StatusChip(granted: consent.granted),
        ],
      ),
    );
  }

  static String _formatDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.granted});

  final bool granted;

  @override
  Widget build(BuildContext context) {
    final color =
        granted ? HealynColors.statusSuccess : HealynColors.textMuted;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HealynSpacing.s2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: HealynRadii.brSm,
      ),
      child: Text(
        granted ? 'Granted' : 'Withdrawn',
        style: HealynTypography.caption.copyWith(color: color),
      ),
    );
  }
}
