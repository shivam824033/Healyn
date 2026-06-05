import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../availability/data/availability_repository.dart';
import '../../../availability/data/models/availability_models.dart';
import '../../../availability/presentation/availability_format.dart';
import '../../../availability/presentation/availability_providers.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/error_banner.dart';

/// The physiotherapist's availability management (C7, F1.8 enabler): the two
/// stored inputs that compute bookable slots — recurring weekly working hours
/// (rules) and one-off time off (blackouts). Slots themselves are never stored,
/// only these (CLAUDE.md §11). Add via the focused forms; remove with a confirm.
class PhysioAvailabilityScreen extends ConsumerWidget {
  const PhysioAvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rules = ref.watch(availabilityRulesProvider);
    final blackouts = ref.watch(blackoutsProvider);

    Future<void> refresh() async {
      ref
        ..invalidate(availabilityRulesProvider)
        ..invalidate(blackoutsProvider);
      await Future.wait([
        ref.read(availabilityRulesProvider.future),
        ref.read(blackoutsProvider.future),
      ]);
    }

    Future<void> addRule() async {
      final added = await context.push<bool>('/physio/availability/rules/new');
      if (added == true) ref.invalidate(availabilityRulesProvider);
    }

    Future<void> addBlackout() async {
      final added = await context.push<bool>(
        '/physio/availability/blackouts/new',
      );
      if (added == true) ref.invalidate(blackoutsProvider);
    }

    Future<void> removeRule(AvailabilityRule rule) async {
      final messenger = ScaffoldMessenger.of(context);
      final ok = await _confirm(
        context,
        title: 'Remove working hours?',
        message:
            'Patients will no longer be able to book '
            '${dayOfWeekLabel(rule.dayOfWeek)} '
            '${formatTimeRange(rule.startTime, rule.endTime)}. '
            'Existing appointments are unaffected.',
      );
      if (ok != true) return;
      try {
        await ref.read(availabilityRepositoryProvider).deleteRule(rule.id);
        ref.invalidate(availabilityRulesProvider);
        messenger.showSnackBar(
          const SnackBar(content: Text('Working hours removed')),
        );
      } on ApiException catch (e) {
        messenger.showSnackBar(SnackBar(content: Text(e.message)));
      }
    }

    Future<void> removeBlackout(BlackoutWindow b) async {
      final messenger = ScaffoldMessenger.of(context);
      final ok = await _confirm(
        context,
        title: 'Remove time off?',
        message: 'This window will reopen for booking.',
      );
      if (ok != true) return;
      try {
        await ref.read(availabilityRepositoryProvider).deleteBlackout(b.id);
        ref.invalidate(blackoutsProvider);
        messenger.showSnackBar(
          const SnackBar(content: Text('Time off removed')),
        );
      } on ApiException catch (e) {
        messenger.showSnackBar(SnackBar(content: Text(e.message)));
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Availability')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: ListView(
            padding: const EdgeInsets.all(HealynSpacing.screenEdge),
            children: [
              _SectionHeader(title: 'Working hours', onAdd: addRule),
              const SizedBox(height: HealynSpacing.s3),
              _RulesSection(rules: rules, onRemove: removeRule),
              const SizedBox(height: HealynSpacing.s7),
              _SectionHeader(title: 'Time off', onAdd: addBlackout),
              const SizedBox(height: HealynSpacing.s3),
              _BlackoutsSection(blackouts: blackouts, onRemove: removeBlackout),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool?> _confirm(
  BuildContext context, {
  required String title,
  required String message,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: TextButton.styleFrom(foregroundColor: HealynColors.statusDanger),
          child: const Text('Remove'),
        ),
      ],
    ),
  );
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onAdd});

  final String title;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title.toUpperCase(), style: HealynTypography.overline),
        ),
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add'),
        ),
      ],
    );
  }
}

class _RulesSection extends StatelessWidget {
  const _RulesSection({required this.rules, required this.onRemove});

  final AsyncValue<List<AvailabilityRule>> rules;
  final ValueChanged<AvailabilityRule> onRemove;

  @override
  Widget build(BuildContext context) {
    return rules.when(
      loading: () => const _SectionLoading(),
      error: (_, _) => const ErrorBanner(
        message: 'Could not load working hours. Pull down to retry.',
      ),
      data: (all) {
        // Only open-ended rules are active here; archiving sets an end date,
        // which removes the rule from the working-hours list.
        final active = all.where((r) => r.effectiveTo == null).toList()
          ..sort((a, b) {
            final byDay = dayDisplayOrder(
              a.dayOfWeek,
            ).compareTo(dayDisplayOrder(b.dayOfWeek));
            return byDay != 0 ? byDay : a.startTime.compareTo(b.startTime);
          });
        if (active.isEmpty) {
          return const _EmptyHint(
            'No working hours yet. Add your weekly hours so patients can book.',
          );
        }
        return Column(
          children: [
            for (final r in active) ...[
              _RuleCard(rule: r, onRemove: () => onRemove(r)),
              const SizedBox(height: HealynSpacing.s3),
            ],
          ],
        );
      },
    );
  }
}

class _BlackoutsSection extends StatelessWidget {
  const _BlackoutsSection({required this.blackouts, required this.onRemove});

  final AsyncValue<List<BlackoutWindow>> blackouts;
  final ValueChanged<BlackoutWindow> onRemove;

  @override
  Widget build(BuildContext context) {
    return blackouts.when(
      loading: () => const _SectionLoading(),
      error: (_, _) => const ErrorBanner(
        message: 'Could not load time off. Pull down to retry.',
      ),
      data: (all) {
        final sorted = [...all]
          ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
        if (sorted.isEmpty) {
          return const _EmptyHint('No time off scheduled.');
        }
        return Column(
          children: [
            for (final b in sorted) ...[
              _BlackoutCard(blackout: b, onRemove: () => onRemove(b)),
              const SizedBox(height: HealynSpacing.s3),
            ],
          ],
        );
      },
    );
  }
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({required this.rule, required this.onRemove});

  final AvailabilityRule rule;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return _Card(
      onRemove: onRemove,
      removeTooltip: 'Remove working hours',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dayOfWeekLabel(rule.dayOfWeek), style: HealynTypography.bodyStrong),
          const SizedBox(height: HealynSpacing.s1),
          Text(
            formatTimeRange(rule.startTime, rule.endTime),
            style: HealynTypography.body,
          ),
          const SizedBox(height: HealynSpacing.s1),
          Text(
            '${rule.slotMinutes}-min slots · ${rule.timezone}',
            style: HealynTypography.caption.copyWith(
              color: HealynColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BlackoutCard extends StatelessWidget {
  const _BlackoutCard({required this.blackout, required this.onRemove});

  final BlackoutWindow blackout;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final reason = blackout.reason?.trim();
    return _Card(
      onRemove: onRemove,
      removeTooltip: 'Remove time off',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatBlackoutRange(blackout.startsAt, blackout.endsAt),
            style: HealynTypography.bodyStrong,
          ),
          if (reason != null && reason.isNotEmpty) ...[
            const SizedBox(height: HealynSpacing.s1),
            Text(
              reason,
              style: HealynTypography.caption.copyWith(
                color: HealynColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A bordered row card with the content and a trailing delete affordance.
class _Card extends StatelessWidget {
  const _Card({
    required this.child,
    required this.onRemove,
    required this.removeTooltip,
  });

  final Widget child;
  final VoidCallback onRemove;
  final String removeTooltip;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HealynColors.surfaceBase,
        borderRadius: HealynRadii.brLg,
        border: Border.all(color: HealynColors.borderSubtle),
      ),
      padding: const EdgeInsets.fromLTRB(
        HealynSpacing.s4,
        HealynSpacing.s4,
        HealynSpacing.s2,
        HealynSpacing.s4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: child),
          IconButton(
            tooltip: removeTooltip,
            icon: const Icon(Icons.delete_outline, color: HealynColors.textMuted),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(HealynSpacing.s4),
      decoration: BoxDecoration(
        color: HealynColors.surfaceAlt,
        borderRadius: HealynRadii.brLg,
        border: Border.all(color: HealynColors.borderSubtle),
      ),
      child: Text(
        text,
        style: HealynTypography.body.copyWith(color: HealynColors.textSecondary),
      ),
    );
  }
}

class _SectionLoading extends StatelessWidget {
  const _SectionLoading();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: HealynSpacing.s6),
    child: Center(child: CircularProgressIndicator()),
  );
}
