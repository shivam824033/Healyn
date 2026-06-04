import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/notification_preferences.dart';
import '../data/notification_preferences_repository.dart';

/// Loads the account's push preferences and applies single-category toggles.
/// A toggle is optimistic: the switch flips immediately, the PATCH runs, and the
/// server's snapshot reconciles the state; on failure the previous value is
/// restored and the error rethrown so the screen can surface it.
class NotificationPreferencesController
    extends AutoDisposeAsyncNotifier<NotificationPreferences> {
  @override
  Future<NotificationPreferences> build() {
    return ref.watch(notificationPreferencesRepositoryProvider).fetch();
  }

  Future<void> setCategory(NotificationCategory category, bool enabled) async {
    final previous = state.valueOrNull;
    if (previous == null) return;

    state = AsyncData(previous.withCategory(category, enabled));
    try {
      final updated = await ref
          .read(notificationPreferencesRepositoryProvider)
          .setCategory(category, enabled);
      state = AsyncData(updated);
    } catch (_) {
      state = AsyncData(previous);
      rethrow;
    }
  }
}

final notificationPreferencesControllerProvider = AutoDisposeAsyncNotifierProvider<
    NotificationPreferencesController, NotificationPreferences>(
  NotificationPreferencesController.new,
);
