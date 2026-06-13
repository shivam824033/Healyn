import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/healyn_avatar.dart';
import '../../../shared/widgets/healyn_list_row.dart';
import '../../data/models/patient_models.dart';
import '../patient_format.dart';
import '../patients_providers.dart';

/// Family tab — the family member patients this account manages. Adding a family
/// member (P1) is its own slice; this is read-only for now.
class FamilyScreen extends ConsumerWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(patientsProvider);
    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: HealynAppBar(
        title: 'Family',
        actions: [
          IconButton(
            tooltip: 'Add family member',
            icon: const Icon(Icons.person_add_alt_1),
            onPressed: () => context.push('/patients/new'),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(patientsProvider);
            await ref.read(patientsProvider.future);
          },
          child: patients.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => ListView(
              padding: const EdgeInsets.all(HealynSpacing.screenEdge),
              children: const [
                ErrorBanner(
                  message: 'Could not load your family. Pull down to retry.',
                ),
              ],
            ),
            data: (all) {
              final family = familyMembersOf(all);
              if (family.isEmpty) return const _EmptyFamily();
              return ListView.separated(
                padding: const EdgeInsets.all(HealynSpacing.screenEdge),
                itemCount: family.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: HealynSpacing.s3),
                itemBuilder: (_, i) => _FamilyTile(patient: family[i]),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FamilyTile extends StatelessWidget {
  const _FamilyTile({required this.patient});

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    final relationship = patient.relationship?.label;
    final age = patientAgeInYears(patient.dateOfBirth);
    final subtitle = [
      ?relationship,
      '$age yrs',
    ].join(' · ');
    return HealynListRow(
      leading: HealynAvatar(name: patient.fullName, seed: patient.id, size: 44),
      title: patient.fullName,
      subtitle: subtitle,
      onTap: () =>
          context.push('/patients/${patient.id}/edit', extra: patient),
    );
  }
}

class _EmptyFamily extends StatelessWidget {
  const _EmptyFamily();

  @override
  Widget build(BuildContext context) {
    // Inside a scrollable so pull-to-refresh still works with no members.
    return ListView(
      padding: const EdgeInsets.all(HealynSpacing.s8),
      children: [
        const SizedBox(height: HealynSpacing.s8),
        const Icon(
          Icons.people_outline,
          size: 48,
          color: HealynColors.textMuted,
        ),
        const SizedBox(height: HealynSpacing.s4),
        const Text(
          'No family members yet',
          style: HealynTypography.h3,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: HealynSpacing.s2),
        Text(
          'Family members you manage will appear here.',
          style: HealynTypography.body.copyWith(
            color: HealynColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: HealynSpacing.s6),
        Center(
          child: OutlinedButton.icon(
            onPressed: () => context.push('/patients/new'),
            icon: const Icon(Icons.person_add_alt_1),
            label: const Text('Add family member'),
          ),
        ),
      ],
    );
  }
}
