import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../appointments/data/models/appointment_models.dart';
import '../../appointments/presentation/appointments_providers.dart';
import '../../appointments/presentation/screens/appointment_detail_screen.dart';
import '../../appointments/presentation/screens/appointments_screen.dart';
import '../../appointments/presentation/screens/book_appointment_screen.dart';
import '../../appointments/presentation/screens/reschedule_appointment_screen.dart';
import '../../discussion/presentation/screens/discussion_screen.dart';
import '../../discussion/presentation/screens/unread_discussions_screen.dart';
import '../../auth/domain/auth_status.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import '../../auth/presentation/screens/login_screen.dart';
import '../../auth/presentation/screens/register_start_screen.dart';
import '../../auth/presentation/screens/register_verify_screen.dart';
import '../../auth/presentation/screens/splash_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../notifications/presentation/screens/notification_preferences_screen.dart';
import '../../patient_shell/presentation/patient_shell.dart';
import '../../physio/presentation/physio_shell.dart';
import '../../physio/presentation/screens/physio_appointment_detail_screen.dart';
import '../../physio/presentation/screens/physio_availability_screen.dart';
import '../../physio/presentation/screens/physio_patients_screen.dart';
import '../../physio/presentation/screens/physio_profile_screen.dart';
import '../../physio/presentation/screens/physio_today_screen.dart';
import '../auth/account_role.dart';
import '../../patients/data/models/patient_models.dart';
import '../../patients/presentation/patients_providers.dart';
import '../../patients/presentation/screens/family_screen.dart';
import '../../patients/presentation/screens/patient_form_screen.dart';
import '../../patients/presentation/screens/profile_screen.dart';
import '../../treatment_notes/presentation/screens/treatment_notes_timeline_screen.dart';

/// The app router. Redirect is driven by [AuthState]:
/// - unknown        → splash (`/`) while the token store is read
/// - unauthenticated → forced into the auth area (/login, /register*)
/// - authenticated   → landed in the role's app and kept there: a
///   physiotherapist in `/physio/*`, every other account in the patient app.
///
/// A [ValueNotifier] bridges Riverpod's auth state to go_router's
/// `refreshListenable` so the redirect re-runs whenever it changes.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<AuthState>(ref.read(authControllerProvider));
  ref.listen<AuthState>(
    authControllerProvider,
    (_, next) => refresh.value = next,
  );
  ref.onDispose(refresh.dispose);

  final router = GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final session = ref.read(authControllerProvider);
      final location = state.matchedLocation;
      final inAuthArea =
          location == '/login' || location.startsWith('/register');

      switch (session.status) {
        case AuthStatus.unknown:
          return location == '/' ? null : '/';
        case AuthStatus.unauthenticated:
          return inAuthArea ? null : '/login';
        case AuthStatus.authenticated:
          final isPhysio = session.role == AccountRole.physio;
          final inPhysioArea =
              location == '/physio' || location.startsWith('/physio/');
          if (location == '/' || inAuthArea) {
            return isPhysio ? '/physio/today' : '/home';
          }
          // Keep each role in its own app.
          if (isPhysio && !inPhysioArea) return '/physio/today';
          if (!isPhysio && inPhysioArea) return '/home';
          return null;
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
      // The authenticated physiotherapist app: its own 4-tab shell under
      // /physio/*. The redirect keeps a physio in here and others out.
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) =>
            PhysioShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/physio/today',
                builder: (_, _) => const PhysioTodayScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/physio/patients',
                builder: (_, _) => const PhysioPatientsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/physio/availability',
                builder: (_, _) => const PhysioAvailabilityScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/physio/profile',
                builder: (_, _) => const PhysioProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      // The physiotherapist's appointment detail, pushed over the physio shell.
      // Under /physio/* so the redirect keeps non-physios out. `discussion` is
      // matched before the bare detail so it isn't captured as a detail view.
      GoRoute(
        path: '/physio/appointments/:id/discussion',
        builder: (_, state) {
          final extra = state.extra;
          if (extra is Appointment) {
            return DiscussionScreen(
              appointment: extra,
              viewer: DiscussionViewer.physio,
            );
          }
          // No object passed (notification deep link / refresh) — fetch by id.
          return _PhysioDiscussionRoute(id: state.pathParameters['id']!);
        },
      ),
      GoRoute(
        path: '/physio/appointments/:id',
        builder: (_, state) {
          final extra = state.extra;
          if (extra is Appointment) {
            return PhysioAppointmentDetailScreen(appointment: extra);
          }
          // No object passed (deep link / refresh) — fetch it by id.
          return _PhysioAppointmentDetailRoute(id: state.pathParameters['id']!);
        },
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
      // A patient's treatment-note history. `extra` carries the patient's name
      // for the app-bar subtitle; absent on a refresh, which is fine.
      GoRoute(
        path: '/patients/:id/treatment_notes',
        builder: (_, state) => TreatmentNotesTimelineScreen(
          patientId: state.pathParameters['id']!,
          patientName: state.extra is String ? state.extra as String : null,
        ),
      ),
      // Account notification settings, reached from Profile.
      GoRoute(
        path: '/notifications/preferences',
        builder: (_, _) => const NotificationPreferencesScreen(),
      ),
      // Index of appointments with unread messages, reached from Home.
      GoRoute(
        path: '/discussions/unread',
        builder: (_, _) => const UnreadDiscussionsScreen(),
      ),
      // Appointment booking + detail also live outside the shell. `book` is
      // matched before `:id` so it isn't captured as an appointment id.
      GoRoute(
        path: '/appointments/book',
        builder: (_, _) => const BookAppointmentScreen(),
      ),
      GoRoute(
        path: '/appointments/:id/reschedule',
        builder: (_, state) {
          final extra = state.extra;
          if (extra is Appointment) {
            return RescheduleAppointmentScreen(appointment: extra);
          }
          // No object passed (deep link / refresh) — fetch it by id first.
          return _RescheduleRoute(id: state.pathParameters['id']!);
        },
      ),
      GoRoute(
        path: '/appointments/:id/discussion',
        builder: (_, state) {
          final extra = state.extra;
          if (extra is Appointment) {
            return DiscussionScreen(appointment: extra);
          }
          // No object passed (push from a notification tap / refresh) — the
          // thread needs the appointment for its status, so fetch it by id.
          return _DiscussionRoute(id: state.pathParameters['id']!);
        },
      ),
      GoRoute(
        path: '/appointments/:id',
        builder: (_, state) {
          final extra = state.extra;
          if (extra is Appointment) {
            return AppointmentDetailScreen(appointment: extra);
          }
          // No object passed (deep link / refresh) — fetch it by id.
          return _AppointmentDetailRoute(id: state.pathParameters['id']!);
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

/// Fetches the appointment to show when the detail route was entered without
/// the [Appointment] object in `extra` (deep link / refresh).
class _AppointmentDetailRoute extends ConsumerWidget {
  const _AppointmentDetailRoute({required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointment = ref.watch(appointmentByIdProvider(id));
    return appointment.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) => Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Could not load this appointment.')),
      ),
      data: (a) => AppointmentDetailScreen(appointment: a),
    );
  }
}

/// Fetches the appointment to reschedule when the route was entered without the
/// [Appointment] object in `extra` (deep link / refresh).
class _RescheduleRoute extends ConsumerWidget {
  const _RescheduleRoute({required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointment = ref.watch(appointmentByIdProvider(id));
    return appointment.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) => Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Could not load this appointment.')),
      ),
      data: (a) => RescheduleAppointmentScreen(appointment: a),
    );
  }
}

/// Fetches the appointment for the physiotherapist's detail when the route was
/// entered without the [Appointment] in `extra` (deep link / refresh).
class _PhysioAppointmentDetailRoute extends ConsumerWidget {
  const _PhysioAppointmentDetailRoute({required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointment = ref.watch(appointmentByIdProvider(id));
    return appointment.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) => Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Could not load this appointment.')),
      ),
      data: (a) => PhysioAppointmentDetailScreen(appointment: a),
    );
  }
}

/// Fetches the appointment whose discussion to open when the route was entered
/// without the [Appointment] in `extra` (e.g. a notification deep link).
class _DiscussionRoute extends ConsumerWidget {
  const _DiscussionRoute({required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointment = ref.watch(appointmentByIdProvider(id));
    return appointment.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) => Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Could not load this appointment.')),
      ),
      data: (a) => DiscussionScreen(appointment: a),
    );
  }
}

/// Like [_DiscussionRoute] but opens the thread from the physiotherapist's side
/// (a notification deep link into a physio thread).
class _PhysioDiscussionRoute extends ConsumerWidget {
  const _PhysioDiscussionRoute({required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointment = ref.watch(appointmentByIdProvider(id));
    return appointment.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) => Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Could not load this appointment.')),
      ),
      data: (a) =>
          DiscussionScreen(appointment: a, viewer: DiscussionViewer.physio),
    );
  }
}
