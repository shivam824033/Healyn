import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../appointments/presentation/appointments_providers.dart';
import '../../patients/presentation/patients_providers.dart';
import '../../shared/design/motion.dart';

/// The signed-in patient app frame: a 4-tab bottom nav over the
/// Home/Appointments/Family/Profile branches (UI_UX_GUIDELINES §8.1). Each tab
/// keeps its own navigation stack via [StatefulNavigationShell].
class PatientShell extends ConsumerStatefulWidget {
  const PatientShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<PatientShell> createState() => _PatientShellState();
}

class _PatientShellState extends ConsumerState<PatientShell>
    with SingleTickerProviderStateMixin {
  // A short fade-in runs on each tab switch so the body cross-dissolves rather
  // than swapping instantly (UI_UX_GUIDELINES §7). The shell's branches share a
  // single state (an IndexedStack), so wrapping it in an AnimatedSwitcher would
  // duplicate the branches' GlobalKeys — instead we re-run this one controller.
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
  void didUpdateWidget(PatientShell oldWidget) {
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

  void _goBranch(int index) {
    // Entering Home refreshes its roots so a booking/cancel/status-change made
    // elsewhere (another tab, or physio-side) shows without a manual pull (D1);
    // the unread roll-up and next-review cards cascade off these.
    if (index == 0) {
      ref
        ..invalidate(appointmentsProvider)
        ..invalidate(patientsProvider);
    }
    widget.navigationShell.goBranch(
      index,
      // Re-tapping the active tab pops it back to that branch's root.
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}
