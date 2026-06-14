import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../patients/presentation/patients_providers.dart';
import '../../shared/design/colors.dart';
import 'physio_calendar_providers.dart';
import 'physio_requests_providers.dart';
import 'physio_schedule_providers.dart';
import 'physio_unread_providers.dart';
import 'physio_upcoming_providers.dart';

/// The signed-in physiotherapist app frame: a 4-tab bottom nav over the
/// Today / Patients / Appointments / Profile branches (mirrors PatientShell,
/// UI_UX_GUIDELINES §8.1). Each tab keeps its own navigation stack.
class PhysioShell extends ConsumerWidget {
  const PhysioShell({required this.navigationShell, super.key});

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
            icon: Icon(Icons.today_outlined),
            selectedIcon: Icon(Icons.today),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'Appointments',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Patients',
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
    // Entering Appointments refetches the list so bookings/status changes made
    // elsewhere show without a manual pull.
    if (index == 2) {
      ref.invalidate(physioAppointmentsProvider);
    }
    navigationShell.goBranch(
      index,
      // Re-tapping the active tab pops it back to that branch's root.
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
