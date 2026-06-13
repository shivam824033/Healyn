import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';
import 'package:healyn/features/auth/domain/auth_status.dart';
import 'package:healyn/features/auth/presentation/controllers/auth_controller.dart';
import 'package:healyn/features/patients/data/models/patient_models.dart';
import 'package:healyn/features/patients/presentation/patients_providers.dart';
import 'package:healyn/features/physio/presentation/physio_calendar_providers.dart';
import 'package:healyn/features/physio/presentation/physio_schedule_providers.dart';
import 'package:healyn/features/shared/auth/account_role.dart';
import 'package:healyn/features/shared/router/app_router.dart';

/// Builds an unsigned JWT carrying [claims] — enough for the client-side claim
/// reader, which never verifies the signature.
String _jwt(Map<String, dynamic> claims) {
  final payload = base64Url.encode(utf8.encode(jsonEncode(claims)));
  return 'header.$payload.signature';
}

/// Returns a fixed [AuthState] without bootstrapping (no token store / push).
class _FakeAuth extends AuthController {
  _FakeAuth(this._state);

  final AuthState _state;

  @override
  AuthState build() => _state;
}

void main() {
  group('accountRoleFromToken', () {
    test('maps the role claim to a role', () {
      expect(
        accountRoleFromToken(_jwt({'role': 'ROLE_PHYSIO'})),
        AccountRole.physio,
      );
      expect(
        accountRoleFromToken(_jwt({'role': 'ROLE_ACCOUNT'})),
        AccountRole.account,
      );
    });

    test('is null for a missing/unknown role or a malformed token', () {
      expect(accountRoleFromToken(_jwt({'sub': 'x'})), isNull);
      expect(accountRoleFromToken(_jwt({'role': 'ROLE_ALIEN'})), isNull);
      expect(accountRoleFromToken('not-a-jwt'), isNull);
    });
  });

  group('role-aware router', () {
    Future<ProviderContainer> pumpPhysio(WidgetTester tester) async {
      // A tall surface so the Today calendar + roster fit under the shell's nav
      // bar and the lazy roster list builds its empty state (default is 800x600).
      tester.view.physicalSize = const Size(1000, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final container = ProviderContainer(
        overrides: [
          authControllerProvider.overrideWith(
            () => _FakeAuth(
              const AuthState(
                status: AuthStatus.authenticated,
                role: AccountRole.physio,
              ),
            ),
          ),
          // Keep the physio Schedule screen off the network so the shell settles.
          physioScheduleProvider.overrideWith((ref) async => <Appointment>[]),
          calendarMarkedDaysProvider.overrideWith((ref) async => <DateTime>{}),
          patientsProvider.overrideWith((ref) => <Patient>[]),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: container.read(routerProvider)),
        ),
      );
      await tester.pumpAndSettle();
      return container;
    }

    testWidgets('lands a physiotherapist in the physio shell', (tester) async {
      await pumpPhysio(tester);

      // The Schedule screen, not a patient screen.
      expect(find.text("Today's schedule"), findsOneWidget);
      expect(find.text('Nothing scheduled'), findsOneWidget);
      // Physio nav, not the patient nav.
      expect(find.text('Availability'), findsOneWidget);
      expect(find.text('Family'), findsNothing);
    });

    testWidgets('bounces a physio away from a patient route', (tester) async {
      final container = await pumpPhysio(tester);

      container.read(routerProvider).go('/home');
      await tester.pumpAndSettle();

      // Redirected back into the physio app rather than the patient Home.
      expect(find.text("Today's schedule"), findsOneWidget);
      expect(find.text('Availability'), findsOneWidget);
    });
  });
}
