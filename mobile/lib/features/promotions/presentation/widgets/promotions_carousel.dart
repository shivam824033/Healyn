import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/motion.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/healyn_section_header.dart';
import '../../../shared/widgets/healyn_shimmer.dart';
import '../../../shared/widgets/healyn_skeletons.dart';
import '../../data/models/promotion_models.dart';
import '../../data/promotions_repository.dart';
import 'promotion_card.dart';

const _edge = EdgeInsets.symmetric(horizontal: HealynSpacing.screenEdge);

/// Aspect ratio of the banner cover area — a calm, wide 16:9 that holds its
/// height whether or not an image has loaded (no layout shift).
const double _bannerAspect = 16 / 9;

/// Each card shows a peek of the next one.
const double _viewportFraction = 0.9;

/// Fixed height below the cover for the title, description, and CTA pill — keeps
/// the card's Column bounded so it can never overflow the page.
const double _textBlockHeight = 104;

/// The patient Home "From your clinic" section: a horizontal, auto-advancing
/// carousel of active promotions (service cards, banners, announcements, health
/// tips) with pagination dots. Renders nothing while empty so Home stays calm;
/// shows a shimmer skeleton on first load and an inline retry on error.
class PromotionsCarousel extends ConsumerWidget {
  const PromotionsCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(patientPromotionsProvider);
    return async.when(
      loading: () => const _CarouselSkeleton(),
      // On error, stay quiet but offer a retry — Home must not be blocked by a
      // promotions hiccup.
      error: (_, _) => _CarouselError(
        onRetry: () => ref.invalidate(patientPromotionsProvider),
      ),
      data: (promotions) {
        if (promotions.isEmpty) return const SizedBox.shrink();
        return _CarouselBody(promotions: promotions);
      },
    );
  }
}

class _CarouselBody extends StatefulWidget {
  const _CarouselBody({required this.promotions});

  final List<Promotion> promotions;

  @override
  State<_CarouselBody> createState() => _CarouselBodyState();
}

class _CarouselBodyState extends State<_CarouselBody> {
  static const _autoSlide = Duration(seconds: 5);

  final _controller = PageController(viewportFraction: _viewportFraction);
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _restartAutoSlide();
  }

  @override
  void didUpdateWidget(_CarouselBody old) {
    super.didUpdateWidget(old);
    // The set changed under us (refresh) — keep the index in range.
    if (_index >= widget.promotions.length) {
      _index = 0;
    }
    _restartAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// Auto-advance only makes sense with more than one card; a single card stays put.
  void _restartAutoSlide() {
    _timer?.cancel();
    if (widget.promotions.length < 2) return;
    _timer = Timer.periodic(_autoSlide, (_) {
      if (!mounted || !_controller.hasClients) return;
      final next = (_index + 1) % widget.promotions.length;
      _controller.animateToPage(
        next,
        duration: HealynMotion.standard,
        curve: HealynMotion.standardCurve,
      );
    });
  }

  /// A manual swipe should reset the auto-slide clock so it doesn't yank the page
  /// out from under the user immediately after they swipe.
  void _onUserInteraction() => _restartAutoSlide();

  @override
  Widget build(BuildContext context) {
    final items = widget.promotions;
    return Padding(
      padding: const EdgeInsets.only(top: HealynSpacing.s5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: _edge,
            child: HealynSectionHeader(title: 'From your clinic'),
          ),
          const SizedBox(height: HealynSpacing.s3),
          // Size the page to the cover (16:9 of the card width) plus a fixed text
          // block, so the card's Column never overflows regardless of screen width.
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth =
                  constraints.maxWidth * _viewportFraction - HealynSpacing.s4;
              final coverHeight = cardWidth / _bannerAspect;
              final pageHeight = coverHeight + _textBlockHeight;
              return SizedBox(
                height: pageHeight,
                child: NotificationListener<ScrollStartNotification>(
                  onNotification: (_) {
                    _onUserInteraction();
                    return false;
                  },
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: items.length,
                    onPageChanged: (i) => setState(() => _index = i),
                    itemBuilder: (context, i) {
                      final promo = items[i];
                      return Padding(
                        padding: EdgeInsets.only(
                          left:
                              i == 0 ? HealynSpacing.screenEdge : HealynSpacing.s2,
                          right: i == items.length - 1
                              ? HealynSpacing.screenEdge
                              : HealynSpacing.s2,
                          bottom: HealynSpacing.s1,
                        ),
                        child: PromotionCard(
                          promotion: promo,
                          coverAspect: _bannerAspect,
                          onTap: () => context
                              .push('/promotions/${promo.id}', extra: promo),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          if (items.length > 1) ...[
            const SizedBox(height: HealynSpacing.s3),
            _Dots(count: items.length, index: _index),
          ],
        ],
      ),
    );
  }
}

/// Pagination dots — the active dot widens into a pill (state not by color alone,
/// UI_UX_GUIDELINES §10).
class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: HealynMotion.fast,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == index ? 18 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == index
                  ? HealynColors.brandPrimary
                  : HealynColors.borderStrong,
              borderRadius: HealynRadii.brSm,
            ),
          ),
      ],
    );
  }
}

class _CarouselSkeleton extends StatelessWidget {
  const _CarouselSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: HealynSpacing.s5),
      child: Padding(
        padding: _edge,
        child: HealynShimmer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HealynSkeletonLine(widthFactor: 0.45, height: 20),
              SizedBox(height: HealynSpacing.s3),
              AspectRatio(
                aspectRatio: _bannerAspect / 0.62,
                child: _SkeletonBlock(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: HealynColors.skeletonBase,
        borderRadius: HealynRadii.brLg,
      ),
    );
  }
}

class _CarouselError extends StatelessWidget {
  const _CarouselError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: HealynSpacing.s5),
      child: Padding(
        padding: _edge,
        child: Row(
          children: [
            Expanded(
              child: Text(
                "Couldn't load clinic updates.",
                style: HealynTypography.body.copyWith(
                  color: HealynColors.textSecondary,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
