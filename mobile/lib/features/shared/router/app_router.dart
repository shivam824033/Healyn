import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/domain/auth_status.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import '../../auth/presentation/screens/login_screen.dart';
import '../../auth/presentation/screens/register_start_screen.dart';
import '../../auth/presentation/screens/register_verify_screen.dart';
import '../../auth/presentation/screens/splash_screen.dart';
import '../../home/presentation/home_screen.dart';

/// The app router. Redirect is driven by [AuthStatus]:
/// - unknown        → splash (`/`) while the token store is read
/// - unauthenticated → forced into the auth area (/login, /register*)
/// - authenticated   → forced out of the auth area into /home
///
/// A [ValueNotifier] bridges Riverpod's auth state to go_router's
/// `refreshListenable` so the redirect re-runs whenever the status changes.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<AuthStatus>(ref.read(authControllerProvider));
  ref.listen<AuthStatus>(
    authControllerProvider,
    (_, next) => refresh.value = next,
  );
  ref.onDispose(refresh.dispose);

  final router = GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final status = ref.read(authControllerProvider);
      final location = state.matchedLocation;
      final inAuthArea =
          location == '/login' || location.startsWith('/register');

      switch (status) {
        case AuthStatus.unknown:
          return location == '/' ? null : '/';
        case AuthStatus.unauthenticated:
          return inAuthArea ? null : '/login';
        case AuthStatus.authenticated:
          return (location == '/' || inAuthArea) ? '/home' : null;
      }
    },
    routes: [
      GoRoute(path: '/', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (_, _) => const RegisterStartScreen(),
        routes: [
          GoRoute(
            path: 'verify',
            builder: (_, state) {
              final args = state.extra;
              if (args is! RegisterVerifyArgs) {
                // Deep-linked / refreshed without the challenge context.
                return const RegisterStartScreen();
              }
              return RegisterVerifyScreen(args: args);
            },
          ),
        ],
      ),
      GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
