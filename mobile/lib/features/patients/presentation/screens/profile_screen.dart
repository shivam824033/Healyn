import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../auth/presentation/widgets/signed_in_devices.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/domain/patient_sex.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/healyn_section_header.dart';
import '../../../shared/widgets/nav_card.dart';
import '../../../shared/widgets/copyable_id.dart';
import '../../../shared/widgets/section_card.dart';
import '../../data/models/patient_models.dart';
import '../patient_format.dart';
import '../patients_providers.dart';

/// Profile tab — the account's own (primary) patient, plus account actions.
/// Editing the profile (PATCH) is a later slice; this is read-only for now.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(patientsProvider);
    final list = patients.valueOrNull;
    final me = (list == null || list.isEmpty) ? null : primaryPatientOf(list);
    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: HealynAppBar(
        title: 'Profile',
        actions: [
          if (me != null)
            IconButton(
              tooltip: 'Edit profile',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () =>
                  context.push('/patients/${me.id}/edit', extra: me),
            ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(patientsProvider);
            ref.invalidate(signedInDevicesProvider);
            await ref.read(patientsProvider.future);
          },
          child: patients.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => ListView(
              padding: const EdgeInsets.all(HealynSpacing.screenEdge),
              children: const [
                ErrorBanner(
                  message: 'Could not load your profile. Pull down to retry.',
                ),
              ],
            ),
            data: (all) {
              final me = primaryPatientOf(all);
              if (me == null) {
                return ListView(
                  padding: const EdgeInsets.all(HealynSpacing.screenEdge),
                  children: const [
                    ErrorBanner(message: 'No patient profile found.'),
                  ],
                );
              }
              return _ProfileBody(patient: me);
            },
          ),
        ),
      ),
    );
  }
}

class _ProfileBody extends ConsumerWidget {
  const _ProfileBody({required this.patient});

  final Patient patient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = <(String, String)>[
      (
        'Date of birth',
        '${formatBirthDate(patient.dateOfBirth)} '
            '(age ${patientAgeInYears(patient.dateOfBirth)})',
      ),
      if (patient.sex != null) ('Sex', patient.sex!.label),
      if (_has(patient.email)) ('Email', patient.email!),
      if (_has(patient.phoneE164)) ('Phone', patient.phoneE164!),
    ];
    final medical = <(String, String)>[
      if (_has(patient.bloodGroup)) ('Blood group', patient.bloodGroup!),
      if (_has(patient.allergies)) ('Allergies', patient.allergies!),
    ];

    return ListView(
      padding: const EdgeInsets.all(HealynSpacing.screenEdge),
      children: [
        _Header(patient: patient),
        const SizedBox(height: HealynSpacing.s6),
        const HealynSectionHeader(title: 'Personal details'),
        const SizedBox(height: HealynSpacing.s3),
        _DetailCard(rows: details),
        if (medical.isNotEmpty) ...[
          const SizedBox(height: HealynSpacing.s6),
          const HealynSectionHeader(title: 'Medical'),
          const SizedBox(height: HealynSpacing.s3),
          _DetailCard(rows: medical),
        ],
        const SizedBox(height: HealynSpacing.s6),
        _AddressSection(address: patient.address),
        const SizedBox(height: HealynSpacing.s6),
        const HealynSectionHeader(title: 'Care'),
        const SizedBox(height: HealynSpacing.s3),
        NavCard(
          icon: Icons.assignment_outlined,
          label: 'Treatment history',
          onTap: () => context.push(
            '/patients/${patient.id}/treatment_notes',
            extra: patient.fullName,
          ),
        ),
        const SizedBox(height: HealynSpacing.s6),
        const HealynSectionHeader(title: 'Settings'),
        const SizedBox(height: HealynSpacing.s3),
        NavCard(
          icon: Icons.notifications_outlined,
          label: 'Notifications',
          onTap: () => context.push('/notifications/preferences'),
        ),
        const SizedBox(height: HealynSpacing.s6),
        const SignedInDevicesSection(),
        const SizedBox(height: HealynSpacing.s6),
        OutlinedButton.icon(
          onPressed: () =>
              ref.read(authControllerProvider.notifier).logout(),
          icon: const Icon(Icons.logout),
          label: const Text('Sign out'),
          style: OutlinedButton.styleFrom(
            foregroundColor: HealynColors.statusDanger,
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: HealynColors.borderSubtle),
          ),
        ),
      ],
    );
  }

  static bool _has(String? s) => s != null && s.trim().isNotEmpty;
}

/// The account's household address — shared across the family and visible to the
/// physiotherapist. Edited via the household-address form (the same address for
/// every patient on the account, so it is not part of the per-patient edit).
class _AddressSection extends StatelessWidget {
  const _AddressSection({required this.address});

  final Address? address;

  @override
  Widget build(BuildContext context) {
    final addr = address;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HealynSectionHeader(
          title: 'Address',
          trailing: TextButton(
            onPressed: () =>
                context.push('/account/address/edit', extra: addr),
            child: Text(addr == null ? 'Add' : 'Edit'),
          ),
        ),
        const SizedBox(height: HealynSpacing.s3),
        SectionCard(
          child: addr == null
              ? Text(
                  'No address added yet.',
                  style: HealynTypography.body.copyWith(
                    color: HealynColors.textMuted,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final line in addr.displayLines)
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: HealynSpacing.s1,
                        ),
                        child: Text(line, style: HealynTypography.body),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.patient});

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: HealynColors.brandPrimarySubtle,
            child: Text(
              patientInitials(patient.fullName),
              style: HealynTypography.h3.copyWith(
                color: HealynColors.brandPrimaryHover,
              ),
            ),
          ),
          const SizedBox(width: HealynSpacing.s4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(patient.fullName, style: HealynTypography.h2),
                if (patient.patientNumber != null) ...[
                  const SizedBox(height: HealynSpacing.s1),
                  CopyableId(value: patient.patientNumber!),
                ],
                const SizedBox(height: HealynSpacing.s1),
                Text(
                  'Primary patient',
                  style: HealynTypography.caption.copyWith(
                    color: HealynColors.brandPrimaryHover,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const Divider(height: HealynSpacing.s5),
            _DetailRow(label: rows[i].$1, value: rows[i].$2),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(label, style: HealynTypography.caption),
        ),
        const SizedBox(width: HealynSpacing.s3),
        Expanded(child: Text(value, style: HealynTypography.body)),
      ],
    );
  }
}

