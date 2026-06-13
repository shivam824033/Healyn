import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/auth/domain/auth_status.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/shared/auth/account_role.dart';
import 'features/shared/design/theme.dart';
import 'features/shared/push/local_notifications.dart';
import 'features/shared/push/push_service.dart';
import 'features/shared/router/app_router.dart';

/// Root widget: a router-driven MaterialApp themed from the design tokens. Also
/// wires notification taps to navigation (inert when push is unconfigured).
class HealynApp extends ConsumerStatefulWidget {
  const HealynApp({super.key});

  @override
  ConsumerState<HealynApp> createState() => _HealynAppState();
}

class _HealynAppState extends ConsumerState<HealynApp> {
  @override
  void initState() {
    super.initState();
    // A tapped push deep-links to the appointment (detail) or its discussion,
    // scoped to the signed-in role (IDs only — Hard Rule #4). Data-only messages
    // are delivered as local notifications, so their taps arrive via this
    // handler; the FCM streams + cold-start launch data are wired below for
    // completeness.
    onNotificationTap = _routeFromData;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _wireNotificationTaps();
    });
  }

  Future<void> _wireNotificationTaps() async {
    await ref.read(pushServiceProvider).wireTaps(_routeFromData);
    final launch = await notificationLaunchData();
    if (launch != null) _routeFromData(launch);
  }

  /// Resolves a tapped notification's payload to a role-scoped route and pushes
  /// it over the landing screen, so Back returns there. Ignored when not signed
  /// in (the redirect owns the auth area).
  void _routeFromData(Map<String, String> data) {
    if (!mounted) return;
    final session = ref.read(authControllerProvider);
    if (session.status != AuthStatus.authenticated) return;
    final isPhysio = session.role == AccountRole.physio;
    final route = routeForPush(data, isPhysio: isPhysio);
    if (route != null) ref.read(routerProvider).push(route);
  }

  @override
  void dispose() {
    onNotificationTap = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Healyn',
      debugShowCheckedModeBanner: false,
      theme: HealynTheme.light(),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
