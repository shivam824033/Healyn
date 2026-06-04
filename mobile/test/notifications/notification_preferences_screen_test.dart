import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/notifications/data/models/notification_preferences.dart';
import 'package:healyn/features/notifications/data/notification_preferences_api.dart';
import 'package:healyn/features/notifications/data/notification_preferences_repository.dart';
import 'package:healyn/features/notifications/presentation/screens/notification_preferences_screen.dart';
import 'package:healyn/features/shared/network/api_exception.dart';

/// In-memory stand-in for the repository: records toggles and applies them to a
/// held snapshot, or fails the initial load when [fail] is set.
class _FakeRepo extends NotificationPreferencesRepository {
  _FakeRepo({NotificationPreferences? initial, this.fail = false})
      : _prefs = initial ?? NotificationPreferences.allEnabled,
        super(NotificationPreferencesApi(Dio()));

  NotificationPreferences _prefs;
  final bool fail;
  final List<(NotificationCategory, bool)> calls = [];

  @override
  Future<NotificationPreferences> fetch() async {
    if (fail) {
      throw const ApiException(code: 'boom', message: 'nope', statusCode: 500);
    }
    return _prefs;
  }

  @override
  Future<NotificationPreferences> setCategory(
    NotificationCategory category,
    bool enabled,
  ) async {
    calls.add((category, enabled));
    _prefs = _prefs.withCategory(category, enabled);
    return _prefs;
  }
}

Future<void> _pump(WidgetTester tester, _FakeRepo repo) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        notificationPreferencesRepositoryProvider.overrideWithValue(repo),
      ],
      child: const MaterialApp(home: NotificationPreferencesScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

List<SwitchListTile> _switches(WidgetTester tester) =>
    tester.widgetList<SwitchListTile>(find.byType(SwitchListTile)).toList();

void main() {
  testWidgets('renders one switch per category reflecting the snapshot',
      (tester) async {
    await _pump(
      tester,
      _FakeRepo(
        initial: const NotificationPreferences(
          appointmentUpdates: true,
          appointmentReminders: true,
          messages: false,
          treatmentNotes: true,
        ),
      ),
    );

    final tiles = _switches(tester);
    expect(tiles, hasLength(4));
    // Order follows the screen's category list; "Messages" is the third.
    expect(tiles[2].value, isFalse);
    expect(tiles[0].value, isTrue);
    expect(find.text('Messages'), findsOneWidget);
    expect(find.text('Treatment notes'), findsOneWidget);
  });

  testWidgets('toggling a category persists it and updates the switch',
      (tester) async {
    final repo = _FakeRepo(initial: NotificationPreferences.allEnabled);
    await _pump(tester, repo);

    await tester.tap(find.text('Messages'));
    await tester.pumpAndSettle();

    expect(repo.calls, [(NotificationCategory.messages, false)]);
    expect(_switches(tester)[2].value, isFalse);
  });

  testWidgets('shows an error with a retry when the load fails',
      (tester) async {
    await _pump(tester, _FakeRepo(fail: true));

    expect(find.textContaining('Could not load'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
    expect(find.byType(SwitchListTile), findsNothing);
  });
}
