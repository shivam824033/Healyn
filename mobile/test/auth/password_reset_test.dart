import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:healyn/features/auth/data/auth_api.dart';
import 'package:healyn/features/auth/data/auth_repository.dart';
import 'package:healyn/features/auth/data/models/auth_models.dart';
import 'package:healyn/features/auth/presentation/screens/password_reset_complete_screen.dart';
import 'package:healyn/features/auth/presentation/screens/password_reset_start_screen.dart';
import 'package:healyn/features/shared/device/device_info.dart';
import 'package:healyn/features/shared/network/api_exception.dart';
import 'package:healyn/features/shared/storage/device_identity.dart';
import 'package:healyn/features/shared/storage/token_store.dart';

/// Records the reset calls and returns a fixed challenge id. The overridden
/// methods never touch the super dependencies, so the dummy api/stores are safe.
class _FakeAuthRepo extends AuthRepository {
  _FakeAuthRepo()
    : super(
        AuthApi(Dio()),
        TokenStore(const FlutterSecureStorage()),
        DeviceIdentity(const FlutterSecureStorage()),
        const DeviceInfo(),
      );

  ContactTarget? startedWith;
  ({String challengeId, String code, String newPassword})? completedWith;
  ApiException? startError;

  @override
  Future<String> startPasswordReset(ContactTarget target) async {
    startedWith = target;
    final err = startError;
    if (err != null) throw err;
    return 'chal-1';
  }

  @override
  Future<void> completePasswordReset({
    required String challengeId,
    required String code,
    required String newPassword,
  }) async {
    completedWith = (
      challengeId: challengeId,
      code: code,
      newPassword: newPassword,
    );
  }
}

GoRouter _router() => GoRouter(
  initialLocation: '/password-reset',
  routes: [
    GoRoute(
      path: '/login',
      builder: (_, _) =>
          const Scaffold(body: Center(child: Text('LOGIN SCREEN'))),
    ),
    GoRoute(
      path: '/password-reset',
      builder: (_, _) => const PasswordResetStartScreen(),
      routes: [
        GoRoute(
          path: 'verify',
          builder: (_, state) => PasswordResetCompleteScreen(
            args: state.extra! as PasswordResetCompleteArgs,
          ),
        ),
      ],
    ),
  ],
);

Future<void> _pump(WidgetTester tester, _FakeAuthRepo repo) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [authRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp.router(routerConfig: _router()),
    ),
  );
  await tester.pumpAndSettle();
}

/// Mounts the complete (verify) screen directly with [args], so the start screen
/// isn't left in the navigator underneath it (which would otherwise add its own
/// TextField to the tree). A `/login` route receives the post-reset redirect.
GoRouter _completeRouter(PasswordResetCompleteArgs args) => GoRouter(
  initialLocation: '/verify',
  routes: [
    GoRoute(
      path: '/login',
      builder: (_, _) =>
          const Scaffold(body: Center(child: Text('LOGIN SCREEN'))),
    ),
    GoRoute(
      path: '/verify',
      builder: (_, _) => PasswordResetCompleteScreen(args: args),
    ),
  ],
);

Future<void> _pumpComplete(WidgetTester tester, _FakeAuthRepo repo) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [authRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp.router(
        routerConfig: _completeRouter(
          const PasswordResetCompleteArgs(
            challengeId: 'chal-1',
            target: 'asha@example.com',
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('password reset — start', () {
    testWidgets('blocks an empty contact and does not call the API', (
      tester,
    ) async {
      final repo = _FakeAuthRepo();
      await _pump(tester, repo);

      await tester.tap(find.text('Send code'));
      await tester.pumpAndSettle();

      expect(find.text('Enter your email'), findsOneWidget);
      expect(repo.startedWith, isNull);
    });

    testWidgets('requests a code and advances to the verify step', (
      tester,
    ) async {
      final repo = _FakeAuthRepo();
      await _pump(tester, repo);

      await tester.enterText(
        find.byType(TextField).first,
        'asha@example.com',
      );
      await tester.tap(find.text('Send code'));
      await tester.pumpAndSettle();

      expect(repo.startedWith?.email, 'asha@example.com');
      // Landed on the verify step.
      expect(find.text('Enter your code'), findsOneWidget);
    });

    testWidgets('surfaces an API error without advancing', (tester) async {
      final repo = _FakeAuthRepo()
        ..startError = const ApiException(
          code: 'not_found',
          message: 'No account for that email.',
        );
      await _pump(tester, repo);

      await tester.enterText(find.byType(TextField).first, 'asha@example.com');
      await tester.tap(find.text('Send code'));
      await tester.pumpAndSettle();

      expect(find.text('No account for that email.'), findsOneWidget);
      expect(find.text('Enter your code'), findsNothing);
    });
  });

  group('password reset — complete', () {
    testWidgets('blocks a short code/password and does not call the API', (
      tester,
    ) async {
      final repo = _FakeAuthRepo();
      await _pumpComplete(tester, repo);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Reset password'));
      await tester.pumpAndSettle();

      expect(find.text('Enter the 6-digit code'), findsOneWidget);
      expect(find.text('Use at least 10 characters'), findsOneWidget);
      expect(repo.completedWith, isNull);
    });

    testWidgets('resets the password and returns to sign in', (tester) async {
      final repo = _FakeAuthRepo();
      await _pumpComplete(tester, repo);

      // First field is the code, second is the new password.
      await tester.enterText(find.byType(TextField).at(0), '123456');
      await tester.enterText(find.byType(TextField).at(1), 'newpassword12');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Reset password'));
      await tester.pumpAndSettle();

      expect(repo.completedWith?.challengeId, 'chal-1');
      expect(repo.completedWith?.code, '123456');
      expect(repo.completedWith?.newPassword, 'newpassword12');
      // Back on sign-in with a confirmation.
      expect(find.text('LOGIN SCREEN'), findsOneWidget);
      expect(
        find.text('Password updated. Sign in with your new password.'),
        findsOneWidget,
      );
    });
  });
}
