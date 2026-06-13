import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/auth/data/auth_api.dart';
import 'package:healyn/features/auth/data/auth_repository.dart';
import 'package:healyn/features/auth/data/models/auth_models.dart';
import 'package:healyn/features/auth/presentation/widgets/signed_in_devices.dart';
import 'package:healyn/features/shared/device/device_info.dart';
import 'package:healyn/features/shared/storage/device_identity.dart';
import 'package:healyn/features/shared/storage/token_store.dart';

/// Serves a fixed session list + current id and records per-device revokes.
/// The overridden methods never touch the super dependencies.
class _FakeAuthRepo extends AuthRepository {
  _FakeAuthRepo({required this.sessions, required this.currentId})
    : super(
        AuthApi(Dio()),
        TokenStore(const FlutterSecureStorage()),
        DeviceIdentity(const FlutterSecureStorage()),
        const DeviceInfo(),
      );

  List<SessionView> sessions;
  final String? currentId;
  final List<String> revoked = [];

  @override
  Future<List<SessionView>> listSessions() async => sessions;

  @override
  Future<String?> currentSessionId() async => currentId;

  @override
  Future<void> revokeSession(String id) async {
    revoked.add(id);
    sessions = sessions.where((s) => s.id != id).toList();
  }
}

SessionView _session(String id, String label) => SessionView(
  id: id,
  deviceId: 'dev-$id',
  deviceLabel: label,
  issuedAt: DateTime(2026, 6, 1, 9),
  lastSeenAt: DateTime(2026, 6, 4, 14, 30),
  expiresAt: DateTime(2026, 7, 1, 9),
);

Future<void> _pump(WidgetTester tester, _FakeAuthRepo repo) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [authRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(
        home: Scaffold(
          body: ListView(children: const [SignedInDevicesSection()]),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('marks the current device and guards it from sign-out', (
    tester,
  ) async {
    final repo = _FakeAuthRepo(
      sessions: [
        _session('s1', 'This phone'),
        _session('s2', 'Old tablet'),
      ],
      currentId: 's1',
    );
    await _pump(tester, repo);

    expect(find.text('This phone'), findsOneWidget);
    expect(find.text('Old tablet'), findsOneWidget);
    // Only the current device is badged; only the other offers sign-out.
    expect(find.text('This device'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Sign out'), findsOneWidget);
  });

  testWidgets('signs out another device after confirmation', (tester) async {
    final repo = _FakeAuthRepo(
      sessions: [
        _session('s1', 'This phone'),
        _session('s2', 'Old tablet'),
      ],
      currentId: 's1',
    );
    await _pump(tester, repo);

    // Open the confirm dialog from the (only) sign-out button.
    await tester.tap(find.widgetWithText(TextButton, 'Sign out'));
    await tester.pumpAndSettle();
    expect(find.text('Sign out this device?'), findsOneWidget);

    // Confirm via the dialog's button.
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(TextButton, 'Sign out'),
      ),
    );
    await tester.pumpAndSettle();

    expect(repo.revoked, ['s2']);
    // The list refreshed: the revoked device is gone, confirmation shown.
    expect(find.text('Old tablet'), findsNothing);
    expect(find.text('Signed out that device'), findsOneWidget);
  });

  testWidgets('keeps the device when the confirm is cancelled', (tester) async {
    final repo = _FakeAuthRepo(
      sessions: [_session('s1', 'This phone'), _session('s2', 'Old tablet')],
      currentId: 's1',
    );
    await _pump(tester, repo);

    await tester.tap(find.widgetWithText(TextButton, 'Sign out'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();

    expect(repo.revoked, isEmpty);
    expect(find.text('Old tablet'), findsOneWidget);
  });
}
