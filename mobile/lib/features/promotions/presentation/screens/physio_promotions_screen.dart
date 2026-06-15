import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/healyn_skeletons.dart';
import '../../data/models/promotion_models.dart';
import '../../data/promotions_repository.dart';
import '../widgets/promotion_cover.dart';

/// The physiotherapist's promotions manager: list every promotion (active or not),
/// reorder by drag (display priority), toggle visibility, edit, or delete. Reached
/// from the physio Profile. Mutations call the repository and refetch.
class PhysioPromotionsScreen extends ConsumerStatefulWidget {
  const PhysioPromotionsScreen({super.key});

  @override
  ConsumerState<PhysioPromotionsScreen> createState() =>
      _PhysioPromotionsScreenState();
}

class _PhysioPromotionsScreenState
    extends ConsumerState<PhysioPromotionsScreen> {
  bool _busy = false;

  Future<void> _open(String path, {Object? extra}) async {
    final changed = await context.push<bool>(path, extra: extra);
    if (changed == true) ref.invalidate(managedPromotionsProvider);
  }

  Future<void> _toggle(ManagedPromotion p, bool active) async {
    setState(() => _busy = true);
    try {
      await ref.read(promotionsRepositoryProvider).setActive(p.id, active: active);
      ref.invalidate(managedPromotionsProvider);
    } on ApiException catch (e) {
      _toast(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete(ManagedPromotion p) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete promotion?'),
        content: Text('“${p.title}” will no longer be shown to patients.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: HealynColors.statusDanger,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    setState(() => _busy = true);
    try {
      await ref.read(promotionsRepositoryProvider).delete(p.id);
      ref.invalidate(managedPromotionsProvider);
    } on ApiException catch (e) {
      _toast(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // [newIndex] is the final insertion index after the item is removed — the
  // onReorderItem callback already adjusts it, so no off-by-one fix-up here.
  Future<void> _reorder(List<ManagedPromotion> current, int oldIndex, int newIndex) async {
    final next = [...current];
    final moved = next.removeAt(oldIndex);
    next.insert(newIndex, moved);
    setState(() => _busy = true);
    try {
      await ref
          .read(promotionsRepositoryProvider)
          .reorder(next.map((p) => p.id).toList());
      ref.invalidate(managedPromotionsProvider);
    } on ApiException catch (e) {
      _toast(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(managedPromotionsProvider);
    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: HealynAppBar(
        title: 'Clinic promotions',
        actions: [
          IconButton(
            tooltip: 'Add promotion',
            icon: const Icon(Icons.add),
            onPressed: () => _open('/physio/promotions/new'),
          ),
        ],
      ),
      body: SafeArea(
        child: async.when(
          loading: () => const HealynListSkeleton(),
          error: (_, _) => _ErrorState(
            onRetry: () => ref.invalidate(managedPromotionsProvider),
          ),
          data: (promotions) {
            if (promotions.isEmpty) return const _EmptyState();
            return AbsorbPointer(
              absorbing: _busy,
              child: ReorderableListView.builder(
                padding: const EdgeInsets.all(HealynSpacing.screenEdge),
                itemCount: promotions.length,
                onReorderItem: (o, n) => _reorder(promotions, o, n),
                itemBuilder: (context, i) {
                  final p = promotions[i];
                  return Padding(
                    key: ValueKey(p.id),
                    padding: const EdgeInsets.only(bottom: HealynSpacing.s3),
                    child: _PromotionTile(
                      promotion: p,
                      onTap: () => _open('/physio/promotions/${p.id}/edit', extra: p),
                      onToggle: (v) => _toggle(p, v),
                      onDelete: () => _delete(p),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PromotionTile extends StatelessWidget {
  const _PromotionTile({
    required this.promotion,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  final ManagedPromotion promotion;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final status = _statusLabel(promotion);
    return Container(
      decoration: BoxDecoration(
        color: HealynColors.surfaceBase,
        borderRadius: HealynRadii.brLg,
        border: Border.all(color: HealynColors.borderSubtle),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: HealynRadii.brLg,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(HealynSpacing.s3),
            child: Row(
              children: [
                SizedBox(
                  width: 64,
                  child: PromotionCover(
                    url: promotion.coverUrl,
                    aspectRatio: 1,
                    seed: promotion.title,
                    borderRadius: HealynRadii.brMd,
                  ),
                ),
                const SizedBox(width: HealynSpacing.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        promotion.title,
                        style: HealynTypography.bodyStrong,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: HealynSpacing.s1),
                      Text(
                        status,
                        style: HealynTypography.caption.copyWith(
                          color: promotion.active && status == 'Visible'
                              ? HealynColors.statusSuccess
                              : HealynColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: promotion.active,
                  onChanged: onToggle,
                ),
                IconButton(
                  tooltip: 'Delete',
                  icon: const Icon(Icons.delete_outline),
                  color: HealynColors.statusDanger,
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _statusLabel(ManagedPromotion p) {
    if (!p.active) return 'Hidden';
    if (p.isScheduled) return 'Scheduled';
    if (p.isExpired) return 'Expired';
    return 'Visible';
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(HealynSpacing.s6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.campaign_outlined, size: 48, color: HealynColors.textMuted),
            const SizedBox(height: HealynSpacing.s3),
            const Text(
              'No promotions yet',
              style: HealynTypography.bodyStrong,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: HealynSpacing.s2),
            Text(
              'Add service cards, banners, announcements, or health tips for your patients to see on their home screen.',
              style: HealynTypography.body.copyWith(
                color: HealynColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(HealynSpacing.s6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Could not load your promotions.',
              style: HealynTypography.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: HealynSpacing.s3),
            FilledButton.icon(
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
