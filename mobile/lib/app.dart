import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/shared/design/theme.dart';
import 'features/shared/router/app_router.dart';

/// Root widget: a router-driven MaterialApp themed from the design tokens.
class HealynApp extends ConsumerWidget {
  const HealynApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Healyn',
      debugShowCheckedModeBanner: false,
      theme: HealynTheme.light(),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
