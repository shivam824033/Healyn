import 'package:flutter/material.dart';

import '../widgets/physio_placeholder.dart';

/// The physiotherapist's patient roster. Placeholder until C6 wires
/// `GET /patients` (all patients) + per-patient history.
class PhysioPatientsScreen extends StatelessWidget {
  const PhysioPatientsScreen({super.key});

  @override
  Widget build(BuildContext context) => const PhysioPlaceholder(
    title: 'Patients',
    icon: Icons.people_outline,
    message: 'Your patient roster lands in the next update.',
  );
}
