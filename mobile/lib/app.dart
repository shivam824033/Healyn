import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/shared/design/theme.dart';
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
    // A tapped push deep-links to the appointment it references (IDs only).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pushServiceProvider).wireTaps(_goTo);
    });
  }

  void _goTo(String route) {
    if (mounted) ref.read(routerProvider).go(route);
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
