import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../patients/presentation/patients_providers.dart';
import 'physio_calendar_providers.dart';
import 'physio_requests_providers.dart';
import 'physio_schedule_providers.dart';
import 'physio_unread_providers.dart';

/// The signed-in physiotherapist app frame: a 4-tab bottom nav over the
/// Today / Patients / Availability / Profile branches (mirrors PatientShell,
/// UI_UX_GUIDELINES §8.1). Each tab keeps its own navigation stack.
class PhysioShell extends ConsumerWidget {
  const PhysioShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => _goBranch(ref, index),
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

  void _goBranch(WidgetRef ref, int index) {
    // Entering Today refreshes the schedule, its activity badges, calendar
    // marks, the requests banner, the unread roll-up, and the patient roster so
    // changes made while away (or on another device) show without a manual pull.
    if (index == 0) {
      ref
        ..invalidate(physioScheduleProvider)
        ..invalidate(physioScheduleActivityProvider)
        ..invalidate(calendarMarkedDaysProvider)
        ..invalidate(physioRequestsProvider)
        ..invalidate(physioUnreadSummaryProvider)
        ..invalidate(patientsProvider);
    }
    navigationShell.goBranch(
      index,
      // Re-tapping the active tab pops it back to that branch's root.
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
