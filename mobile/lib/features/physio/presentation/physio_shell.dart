import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../patients/presentation/patients_providers.dart';
import '../../shared/design/motion.dart';
import 'physio_calendar_providers.dart';
import 'physio_requests_providers.dart';
import 'physio_schedule_providers.dart';
import 'physio_unread_providers.dart';

/// The signed-in physiotherapist app frame: a 4-tab bottom nav over the
/// Today / Patients / Availability / Profile branches (mirrors PatientShell,
/// UI_UX_GUIDELINES §8.1). Each tab keeps its own navigation stack.
class PhysioShell extends ConsumerStatefulWidget {
  const PhysioShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<PhysioShell> createState() => _PhysioShellState();
}

class _PhysioShellState extends ConsumerState<PhysioShell>
    with SingleTickerProviderStateMixin {
  // A short fade-in runs on each tab switch so the body cross-dissolves rather
  // than swapping instantly (UI_UX_GUIDELINES §7). Mirrors PatientShell: the
  // branches share one IndexedStack state, so an AnimatedSwitcher would
  // duplicate their GlobalKeys — we re-run a single controller instead.
  late final AnimationController _fade = AnimationController(
    vsync: this,
    duration: HealynMotion.standard,
    value: 1,
  );
  late final Animation<double> _opacity = CurvedAnimation(
    parent: _fade,
    curve: HealynMotion.standardCurve,
  );
  late int _index = widget.navigationShell.currentIndex;

  @override
  void didUpdateWidget(PhysioShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = widget.navigationShell.currentIndex;
    if (next != _index) {
      _index = next;
      if (!MediaQuery.of(context).disableAnimations) {
        _fade.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(opacity: _opacity, child: widget.navigationShell),
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
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
    widget.navigationShell.goBranch(
      index,
      // Re-tapping the active tab pops it back to that branch's root.
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}
