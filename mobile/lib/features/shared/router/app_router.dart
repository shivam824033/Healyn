import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../appointments/presentation/screens/appointments_screen.dart';
import '../../auth/domain/auth_status.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import '../../auth/presentation/screens/login_screen.dart';
import '../../auth/presentation/screens/register_start_screen.dart';
import '../../auth/presentation/screens/register_verify_screen.dart';
import '../../auth/presentation/screens/splash_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../patient_shell/presentation/patient_shell.dart';
import '../../patients/data/models/patient_models.dart';
import '../../patients/presentation/patients_providers.dart';
import '../../patients/presentation/screens/family_screen.dart';
import '../../patients/presentation/screens/patient_form_screen.dart';
import '../../patients/presentation/screens/profile_screen.dart';

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
      // The authenticated patient app: a 4-tab bottom-nav shell. Each branch
      // keeps its own back stack (UI_UX_GUIDELINES §8.1).
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) =>
            PatientShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/appointments',
                builder: (_, _) => const AppointmentsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/family',
                builder: (_, _) => const FamilyScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (_, _) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      // Patient create/edit forms live outside the shell so they cover the
      // bottom nav as a focused sub-flow (pushed, not switched).
      GoRoute(
        path: '/patients/new',
        builder: (_, _) => const PatientFormScreen.create(),
      ),
      GoRoute(
        path: '/patients/:id/edit',
        builder: (_, state) {
          final extra = state.extra;
          if (extra is Patient) {
            return PatientFormScreen.edit(patient: extra);
          }
          // No object passed (e.g. a refresh) — resolve it from the list.
          return _EditPatientRoute(id: state.pathParameters['id']!);
        },
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

/// Resolves the patient to edit from [patientsProvider] when the route was
/// entered without the [Patient] object in `extra` (deep link / refresh).
class _EditPatientRoute extends ConsumerWidget {
  const _EditPatientRoute({required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(patientsProvider);
    return patients.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) => Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Could not load this patient.')),
      ),
      data: (all) {
        for (final p in all) {
          if (p.id == id) return PatientFormScreen.edit(patient: p);
        }
        return Scaffold(
          appBar: AppBar(),
          body: const Center(child: Text('Patient not found.')),
        );
      },
    );
  }
}
