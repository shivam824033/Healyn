import 'package:flutter/material.dart';

import '../widgets/physio_placeholder.dart';

/// The physiotherapist's landing: today's schedule. Placeholder until C2 wires
/// `GET /appointments?from=&to=` into a day timeline.
class PhysioTodayScreen extends StatelessWidget {
  const PhysioTodayScreen({super.key});

  @override
  Widget build(BuildContext context) => const PhysioPlaceholder(
    title: 'Today',
    icon: Icons.today_outlined,
    message: "Today's schedule lands in the next update.",
  );
}
