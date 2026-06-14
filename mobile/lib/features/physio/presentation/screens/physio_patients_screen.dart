import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../patients/data/models/patient_models.dart';
import '../../../patients/presentation/patient_format.dart';
import '../../../patients/presentation/patients_providers.dart';
import '../../../shared/domain/patient_sex.dart';
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

/// The physiotherapist's patient roster (C6, F1.16) — every patient in the
/// practice (`GET /patients` returns the full roster for a physio), name-sorted
/// with a client-side search. Tapping a patient opens their detail + history.
class PhysioPatientsScreen extends ConsumerStatefulWidget {
  const PhysioPatientsScreen({super.key});

  @override
  ConsumerState<PhysioPatientsScreen> createState() =>
      _PhysioPatientsScreenState();
}

class _PhysioPatientsScreenState extends ConsumerState<PhysioPatientsScreen> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patients = ref.watch(patientsProvider);
    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: const HealynAppBar(title: 'Patients'),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                HealynSpacing.screenEdge,
                HealynSpacing.s3,
                HealynSpacing.screenEdge,
                HealynSpacing.s2,
              ),
              child: TextField(
                controller: _search,
                textInputAction: TextInputAction.search,
                onChanged: (v) => setState(() => _query = v.trim()),
                decoration: InputDecoration(
                  hintText: 'Search patients',
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                  border: const OutlineInputBorder(),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear',
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _search.clear();
                            setState(() => _query = '');
                          },
                        ),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(patientsProvider);
                  await ref.read(patientsProvider.future);
                },
                child: HealynStateSwitcher(
                  child: patients.when(
                    loading: () => const HealynListSkeleton(
                      key: ValueKey('patients-loading'),
                      hasFooter: false,
                    ),
                    error: (_, _) => ListView(
                      key: const ValueKey('patients-error'),
                      padding: const EdgeInsets.all(HealynSpacing.screenEdge),
                      children: const [
                        ErrorBanner(
                          message:
                              'Could not load patients. Pull down to retry.',
                        ),
                      ],
                    ),
                    data: (all) => _list(_filterAndSort(all)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Patient> _filterAndSort(List<Patient> all) {
    final q = _query.toLowerCase();
    final filtered = q.isEmpty
        ? [...all]
        : all.where((p) => p.fullName.toLowerCase().contains(q)).toList();
    filtered.sort(
      (a, b) => a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()),
    );
    return filtered;
  }

  Widget _list(List<Patient> patients) {
    if (patients.isEmpty) {
      return _EmptyRoster(
        key: const ValueKey('patients-empty'),
        searching: _query.isNotEmpty,
      );
    }
    return ListView.separated(
      key: const ValueKey('patients-data'),
      padding: const EdgeInsets.all(HealynSpacing.screenEdge),
      itemCount: patients.length,
      separatorBuilder: (_, _) => const SizedBox(height: HealynSpacing.s3),
      // Cap the stagger so rows scrolled into view later reveal immediately.
      itemBuilder: (_, i) => HealynReveal.staggered(
        index: i < 6 ? i : 6,
        child: _PatientTile(patient: patients[i]),
      ),
    );
  }
}

class _PatientTile extends StatelessWidget {
  const _PatientTile({required this.patient});

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    final age = patientAgeInYears(patient.dateOfBirth);
    final sex = patient.sex?.label;
    final subtitle = sex == null ? 'Age $age' : 'Age $age · $sex';
    return HealynListRow(
      leading: HealynAvatar(name: patient.fullName, seed: patient.id, size: 44),
      title: patient.fullName,
      subtitle: subtitle,
      onTap: () =>
          context.push('/physio/patients/${patient.id}', extra: patient),
    );
  }
}

class _EmptyRoster extends StatelessWidget {
  const _EmptyRoster({required this.searching, super.key});

  final bool searching;

  @override
  Widget build(BuildContext context) {
    // A scrollable so pull-to-refresh works with an empty roster.
    return ListView(
      padding: const EdgeInsets.all(HealynSpacing.s8),
      children: [
        const SizedBox(height: HealynSpacing.s8),
        Icon(
          searching ? Icons.search_off : Icons.people_outline,
          size: 48,
          color: HealynColors.textMuted,
        ),
        const SizedBox(height: HealynSpacing.s4),
        Text(
          searching ? 'No matches' : 'No patients yet',
          style: HealynTypography.h3,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: HealynSpacing.s2),
        Text(
          searching
              ? 'No patient matches that search.'
              : 'Patients appear here once they register and book.',
          style: HealynTypography.body.copyWith(
            color: HealynColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
