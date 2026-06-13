import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/section_card.dart';
import '../../data/models/notification_preferences.dart';
import '../notification_preferences_providers.dart';

/// Notification settings (API_STANDARDS §9.8) — one switch per push category.
/// Reached from Profile. Toggling is optimistic and persisted immediately; the
/// account is opted in to everything by default, so every switch starts on.
class NotificationPreferencesScreen extends ConsumerWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(notificationPreferencesControllerProvider);
    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: const HealynAppBar(title: 'Notifications'),
      body: SafeArea(
        child: prefs.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => ListView(
            padding: const EdgeInsets.all(HealynSpacing.screenEdge),
            children: [
              const ErrorBanner(
                message: 'Could not load your notification settings.',
              ),
              const SizedBox(height: HealynSpacing.s4),
              OutlinedButton(
                onPressed: () => ref.invalidate(
                  notificationPreferencesControllerProvider,
                ),
                child: const Text('Try again'),
              ),
            ],
          ),
          data: (data) => _Body(prefs: data),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.prefs});

  final NotificationPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(HealynSpacing.screenEdge),
      children: [
        const Text(
          'Choose which push notifications this account receives.',
          style: HealynTypography.caption,
        ),
        const SizedBox(height: HealynSpacing.s4),
        SectionCard(
          // A transparent Material under the card's colored surface so the
          // switch tiles' ink/splashes have somewhere to paint.
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              children: [
                for (var i = 0; i < _categories.length; i++) ...[
                  if (i > 0) const Divider(height: HealynSpacing.s2),
                  _CategorySwitch(
                    meta: _categories[i],
                    value: prefs.enabled(_categories[i].category),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CategorySwitch extends ConsumerWidget {
  const _CategorySwitch({required this.meta, required this.value});

  final _CategoryMeta meta;
  final bool value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      activeThumbColor: HealynColors.brandPrimary,
      title: Text(meta.label, style: HealynTypography.bodyStrong),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: HealynSpacing.s1),
        child: Text(meta.description, style: HealynTypography.caption),
      ),
      value: value,
      onChanged: (next) => _toggle(context, ref, next),
    );
  }

  Future<void> _toggle(BuildContext context, WidgetRef ref, bool next) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(notificationPreferencesControllerProvider.notifier)
          .setCategory(meta.category, next);
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}

/// Display copy for each category. Uses canonical vocabulary (CLAUDE.md §3):
/// Appointment, Discussion, Physiotherapist, Treatment Note.
class _CategoryMeta {
  const _CategoryMeta(this.category, this.label, this.description);

  final NotificationCategory category;
  final String label;
  final String description;
}

const _categories = <_CategoryMeta>[
  _CategoryMeta(
    NotificationCategory.appointmentUpdates,
    'Appointment updates',
    'When an appointment is requested, confirmed, or cancelled.',
  ),
  _CategoryMeta(
    NotificationCategory.appointmentReminders,
    'Appointment reminders',
    'Reminders before an upcoming appointment.',
  ),
  _CategoryMeta(
    NotificationCategory.messages,
    'Messages',
    'New replies in an appointment discussion.',
  ),
  _CategoryMeta(
    NotificationCategory.treatmentNotes,
    'Treatment notes',
    'When your physiotherapist adds a treatment note.',
  ),
];
