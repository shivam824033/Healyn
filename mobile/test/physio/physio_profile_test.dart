import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/auth/data/auth_api.dart';
import 'package:healyn/features/auth/data/auth_repository.dart';
import 'package:healyn/features/auth/data/models/auth_models.dart';
import 'package:healyn/features/physio/presentation/screens/physio_profile_screen.dart';
import 'package:healyn/features/shared/device/device_info.dart';
import 'package:healyn/features/shared/storage/device_identity.dart';
import 'package:healyn/features/shared/storage/token_store.dart';

/// Serves a fixed session list + current id for the devices section.
class _FakeAuthRepo extends AuthRepository {
  _FakeAuthRepo()
    : super(
        AuthApi(Dio()),
        TokenStore(const FlutterSecureStorage()),
        DeviceIdentity(const FlutterSecureStorage()),
        const DeviceInfo(),
      );

  @override
  Future<List<SessionView>> listSessions() async => [
    SessionView(
      id: 's1',
      deviceId: 'dev-1',
      deviceLabel: 'Clinic iPad',
      issuedAt: DateTime(2026, 6, 1, 9),
      lastSeenAt: DateTime(2026, 6, 4, 14, 30),
      expiresAt: DateTime(2026, 7, 1, 9),
    ),
  ];

  @override
  Future<String?> currentSessionId() async => 's1';
}

void main() {
  testWidgets('physio Profile has notifications + signed-in devices parity', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_FakeAuthRepo()),
        ],
        child: const MaterialApp(home: PhysioProfileScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Identity, the notifications entry, and the devices section all render.
    expect(find.text('Physiotherapist'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('SIGNED-IN DEVICES'), findsOneWidget);
    expect(find.text('Clinic iPad'), findsOneWidget);
    expect(find.text('This device'), findsOneWidget);
  });
}
