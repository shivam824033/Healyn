import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../patients/presentation/patients_providers.dart';
import '../../shared/design/colors.dart';
import '../../shared/design/spacing.dart';
import '../../shared/design/typography.dart';
import '../../shared/widgets/section_card.dart';

/// Home tab — the signed-in landing. Greets the primary patient by first name
/// and surfaces what's next. The appointments summary is a placeholder until
/// the appointments slice lands (no fabricated data).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstName = ref.watch(patientsProvider).maybeWhen(
      data: (patients) {
        final me = primaryPatientOf(patients);
        final name = me?.fullName.trim() ?? '';
        return name.isEmpty ? null : name.split(RegExp(r'\s+')).first;
      },
      orElse: () => null,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Healyn')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(HealynSpacing.screenEdge),
          children: [
            Text(
              firstName == null ? 'Welcome back' : 'Hi, $firstName',
              style: HealynTypography.h1,
            ),
            const SizedBox(height: HealynSpacing.s2),
            const Text(
              'Manage your appointments, family, and care in one place.',
              style: HealynTypography.body,
            ),
            const SizedBox(height: HealynSpacing.s7),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.event_outlined,
                        size: 20,
                        color: HealynColors.brandPrimary,
                      ),
                      SizedBox(width: HealynSpacing.s2),
                      Text(
                        'Upcoming appointments',
                        style: HealynTypography.bodyStrong,
                      ),
                    ],
                  ),
                  const SizedBox(height: HealynSpacing.s2),
                  Text(
                    'Nothing scheduled yet.',
                    style: HealynTypography.body.copyWith(
                      color: HealynColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
