import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../files/data/url_opener.dart';
import '../../../physio/data/physio_profile_repository.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../data/models/promotion_models.dart';
import '../widgets/promotion_cover.dart';

/// The patient details screen for a promotion: the full cover, title, complete
/// description, and an optional booking/contact action. Reached by tapping a card
/// in the Home carousel.
class PromotionDetailsScreen extends ConsumerWidget {
  const PromotionDetailsScreen({required this.promotion, super.key});

  final Promotion promotion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasLong = promotion.longDescription?.trim().isNotEmpty ?? false;
    final hasShort = promotion.shortDescription?.trim().isNotEmpty ?? false;
    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: const HealynAppBar(),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          PromotionCover(
            url: promotion.coverUrl,
            aspectRatio: 16 / 9,
            seed: promotion.title,
            category: promotion.serviceCategory,
          ),
          Padding(
            padding: const EdgeInsets.all(HealynSpacing.screenEdge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(promotion.title, style: HealynTypography.h1),
                if (hasShort) ...[
                  const SizedBox(height: HealynSpacing.s2),
                  Text(
                    promotion.shortDescription!.trim(),
                    style: HealynTypography.body.copyWith(
                      color: HealynColors.textSecondary,
                    ),
                  ),
                ],
                if (hasLong) ...[
                  const SizedBox(height: HealynSpacing.s4),
                  Text(
                    promotion.longDescription!.trim(),
                    style: HealynTypography.body,
                  ),
                ],
                const SizedBox(height: HealynSpacing.s6),
                _CtaButton(promotion: promotion),
                const SizedBox(height: HealynSpacing.s8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Renders the promotion's call-to-action as a primary button, performing the
/// in-app action. Renders nothing for [PromotionAction.none].
class _CtaButton extends ConsumerWidget {
  const _CtaButton({required this.promotion});

  final Promotion promotion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (promotion.ctaAction == PromotionAction.none) {
      return const SizedBox.shrink();
    }
    final label = (promotion.ctaText?.trim().isNotEmpty ?? false)
        ? promotion.ctaText!.trim()
        : _defaultLabel(promotion.ctaAction);

    return FilledButton.icon(
      onPressed: () => _perform(context, ref),
      icon: Icon(_icon(promotion.ctaAction)),
      label: Text(label),
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
    );
  }

  void _perform(BuildContext context, WidgetRef ref) {
    switch (promotion.ctaAction) {
      case PromotionAction.bookAppointment:
        context.push('/appointments/book');
      case PromotionAction.callClinic:
        final phone = ref
            .read(physioProfileProvider)
            .valueOrNull
            ?.clinicContactPhone
            ?.trim();
        if (phone != null && phone.isNotEmpty) {
          ref.read(urlOpenerProvider).open('tel:$phone');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No clinic number is available yet.')),
          );
        }
      case PromotionAction.none:
        break;
    }
  }

  static String _defaultLabel(PromotionAction action) => switch (action) {
        PromotionAction.bookAppointment => 'Book appointment',
        PromotionAction.callClinic => 'Call the clinic',
        PromotionAction.none => '',
      };

  static IconData _icon(PromotionAction action) => switch (action) {
        PromotionAction.bookAppointment => Icons.event_available_outlined,
        PromotionAction.callClinic => Icons.call_outlined,
        PromotionAction.none => Icons.arrow_forward,
      };
}
