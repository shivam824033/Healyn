import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The signed-in physiotherapist app frame: a 4-tab bottom nav over the
/// Today / Patients / Availability / Profile branches (mirrors PatientShell,
/// UI_UX_GUIDELINES §8.1). Each tab keeps its own navigation stack.
class PhysioShell extends StatelessWidget {
  const PhysioShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.today_outlined),
            selectedIcon: Icon(Icons.today),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Patients',
          ),
          NavigationDestination(
            icon: Icon(Icons.schedule_outlined),
            selectedIcon: Icon(Icons.schedule),
            label: 'Availability',
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

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // Re-tapping the active tab pops it back to that branch's root.
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
