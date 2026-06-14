import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/widgets/healyn_state_switcher.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/healyn_avatar.dart';
import '../../../shared/widgets/healyn_list_row.dart';
import '../../../shared/widgets/healyn_reveal.dart';
import '../../../shared/widgets/healyn_skeletons.dart';
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
          child: HealynStateSwitcher(
            child: patients.when(
              loading: () => const HealynListSkeleton(
                key: ValueKey('family-loading'),
                hasFooter: false,
              ),
              error: (_, _) => ListView(
                key: const ValueKey('family-error'),
                padding: const EdgeInsets.all(HealynSpacing.screenEdge),
                children: const [
                  ErrorBanner(
                    message: 'Could not load your family. Pull down to retry.',
                  ),
                ],
              ),
              data: (all) {
                final family = familyMembersOf(all);
                if (family.isEmpty) {
                  return const _EmptyFamily(key: ValueKey('family-empty'));
                }
                return ListView.separated(
                  key: const ValueKey('family-data'),
                  padding: const EdgeInsets.all(HealynSpacing.screenEdge),
                  itemCount: family.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: HealynSpacing.s3),
                  // Cap the stagger so rows scrolled into view later (lazily
                  // built) reveal immediately rather than after a long delay.
                  itemBuilder: (_, i) => HealynReveal.staggered(
                    index: i < 6 ? i : 6,
                    child: _FamilyTile(patient: family[i]),
                  ),
                );
              },
            ),
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
      trailing: IconButton(
        tooltip: 'Documents',
        icon: const Icon(
          Icons.folder_outlined,
          color: HealynColors.textMuted,
        ),
        onPressed: () => context.push(
          '/patients/${patient.id}/documents',
          extra: patient.fullName,
        ),
      ),
      onTap: () =>
          context.push('/patients/${patient.id}/edit', extra: patient),
    );
  }
}

class _EmptyFamily extends StatelessWidget {
  const _EmptyFamily({super.key});

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
