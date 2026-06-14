import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../appointments/presentation/appointments_providers.dart';
import '../../patients/presentation/patients_providers.dart';
import '../../shared/design/colors.dart';

/// The signed-in patient app frame: a 4-tab bottom nav over the
/// Home/Appointments/Family/Profile branches (UI_UX_GUIDELINES §8.1). Each tab
/// keeps its own navigation stack via [StatefulNavigationShell].
class PatientShell extends ConsumerWidget {
  const PatientShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // Tabs swap instantly: the shell is an IndexedStack, so every branch keeps
      // its state and is already built — switching just changes which is shown.
      // We deliberately don't cross-fade. The branches share one IndexedStack
      // (and its GlobalKeys), so a real dissolve between the old and new tab
      // isn't possible; fading the single visible branch in from transparent
      // briefly exposes the background, which reads as a flash/stutter. An
      // instant swap is the smoother, native-feeling choice.
      backgroundColor: HealynColors.surfaceAlt,
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => _goBranch(ref, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: 'Appointments',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Family',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _goBranch(WidgetRef ref, int index) {
    // Entering Home refreshes its roots so a booking/cancel/status-change made
    // elsewhere (another tab, or physio-side) shows without a manual pull (D1);
    // the unread roll-up and next-review cards cascade off these.
    if (index == 0) {
      ref
        ..invalidate(appointmentsProvider)
        ..invalidate(patientsProvider);
    }
    navigationShell.goBranch(
      index,
      // Re-tapping the active tab pops it back to that branch's root.
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
