import 'package:flutter/material.dart';

import '../widgets/physio_placeholder.dart';

/// The physiotherapist's availability management. Placeholder until C7 wires
/// the availability rules + blackouts CRUD.
class PhysioAvailabilityScreen extends StatelessWidget {
  const PhysioAvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) => const PhysioPlaceholder(
    title: 'Availability',
    icon: Icons.schedule_outlined,
    message: 'Manage your availability and blackouts here in the next update.',
  );
}
