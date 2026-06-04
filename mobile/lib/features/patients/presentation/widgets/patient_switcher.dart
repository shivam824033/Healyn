import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../data/models/patient_models.dart';
import '../active_patient_provider.dart';
import '../patient_format.dart';
import '../patients_providers.dart';

/// The active Patient context selector shown at the top of Home
/// (PATIENT_RELATIONSHIP_MODEL §7). Displays the active patient and, when the
/// account manages more than one, opens a sheet to switch. Switching updates
/// [selectedPatientIdProvider]; patient-scoped feeds that watch
/// [activePatientProvider] then refetch.
class PatientSwitcher extends ConsumerWidget {
  const PatientSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activePatientProvider);
    final patients = ref.watch(patientsProvider).valueOrNull ?? const [];
    if (active == null) return const SizedBox.shrink();
    final canSwitch = patients.length > 1;

    return Container(
      decoration: BoxDecoration(
        color: HealynColors.surfaceBase,
        borderRadius: HealynRadii.brLg,
        border: Border.all(color: HealynColors.borderSubtle),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: HealynRadii.brLg,
          onTap: canSwitch ? () => _openSheet(context, ref, patients, active) : null,
          child: Padding(
            padding: const EdgeInsets.all(HealynSpacing.s4),
            child: Row(
              children: [
                _Avatar(name: active.fullName),
                const SizedBox(width: HealynSpacing.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ACTIVE PATIENT',
                        style: HealynTypography.overline.copyWith(
                          color: HealynColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: HealynSpacing.s1),
                      Text(active.fullName, style: HealynTypography.bodyStrong),
                      Text(
                        _subtitle(active),
                        style: HealynTypography.caption,
                      ),
                    ],
                  ),
                ),
                if (canSwitch)
                  const Icon(
                    Icons.unfold_more,
                    color: HealynColors.textMuted,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openSheet(
    BuildContext context,
    WidgetRef ref,
    List<Patient> patients,
    Patient active,
  ) {
    // Primary first, then family members in their listed order.
    final ordered = [
      ...patients.where((p) => p.primary),
      ...patients.where((p) => !p.primary),
    ];
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                HealynSpacing.screenEdge,
                0,
                HealynSpacing.screenEdge,
                HealynSpacing.s2,
              ),
              child: Text('Switch patient', style: HealynTypography.h3),
            ),
            for (final p in ordered)
              _PatientRow(
                patient: p,
                selected: p.id == active.id,
                onTap: () {
                  ref.read(selectedPatientIdProvider.notifier).select(p.id);
                  Navigator.of(sheetContext).pop();
                },
              ),
            const Divider(height: HealynSpacing.s5),
            ListTile(
              leading: const Icon(
                Icons.person_add_alt_1,
                color: HealynColors.brandPrimary,
              ),
              title: const Text(
                'Add family member',
                style: HealynTypography.bodyStrong,
              ),
              onTap: () {
                Navigator.of(sheetContext).pop();
                context.push('/patients/new');
              },
            ),
            const SizedBox(height: HealynSpacing.s2),
          ],
        ),
      ),
    );
  }

  static String _subtitle(Patient p) {
    if (p.primary) return 'You';
    final rel = p.relationship?.label;
    final age = '${patientAgeInYears(p.dateOfBirth)} yrs';
    return rel == null ? age : '$rel · $age';
  }
}

class _PatientRow extends StatelessWidget {
  const _PatientRow({
    required this.patient,
    required this.selected,
    required this.onTap,
  });

  final Patient patient;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      selected: selected,
      leading: _Avatar(name: patient.fullName),
      title: Text(patient.fullName, style: HealynTypography.bodyStrong),
      subtitle: Text(
        PatientSwitcher._subtitle(patient),
        style: HealynTypography.caption,
      ),
      trailing: selected
          ? const Icon(Icons.check, color: HealynColors.brandPrimary)
          : null,
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: HealynColors.brandPrimarySubtle,
      child: Text(
        patientInitials(name),
        style: HealynTypography.bodyStrong.copyWith(
          color: HealynColors.brandPrimaryHover,
        ),
      ),
    );
  }
}
