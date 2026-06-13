import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../patients/data/models/patient_models.dart';
import '../../../patients/presentation/patient_format.dart';
import '../../../shared/domain/patient_sex.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/healyn_section_header.dart';
import '../../../shared/widgets/nav_card.dart';
import '../../../shared/widgets/copyable_id.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../treatment_notes/presentation/next_review_providers.dart';
import '../../../treatment_notes/presentation/treatment_notes_format.dart';

/// One patient as seen by the physiotherapist (C6): identity, demographics and
/// the clinically relevant fields (blood group, allergies, free-text notes),
/// with a link into the full treatment-note history. Read-only — the physio does
/// not edit patient profiles. All clinical text is PHI; never logged.
class PhysioPatientDetailScreen extends ConsumerWidget {
  const PhysioPatientDetailScreen({required this.patient, super.key});

  final Patient patient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewDue = ref.watch(patientNextReviewProvider(patient.id)).valueOrNull;
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

    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: const HealynAppBar(title: 'Patient'),
      body: SafeArea(
        child: ListView(
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
            if (patient.address != null) ...[
              const SizedBox(height: HealynSpacing.s6),
              const HealynSectionHeader(title: 'Address'),
              const SizedBox(height: HealynSpacing.s3),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final line in patient.address!.displayLines)
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
            if (_has(patient.notes)) ...[
              const SizedBox(height: HealynSpacing.s6),
              const HealynSectionHeader(title: 'Notes'),
              const SizedBox(height: HealynSpacing.s3),
              SectionCard(
                child: Text(patient.notes!, style: HealynTypography.body),
              ),
            ],
            if (reviewDue != null) ...[
              const SizedBox(height: HealynSpacing.s6),
              const HealynSectionHeader(title: 'Follow-up due'),
              const SizedBox(height: HealynSpacing.s3),
              SectionCard(
                child: Row(
                  children: [
                    const Icon(
                      Icons.event_repeat_outlined,
                      size: 20,
                      color: HealynColors.brandPrimary,
                    ),
                    const SizedBox(width: HealynSpacing.s3),
                    Expanded(
                      child: Text(
                        formatReviewWhen(reviewDue),
                        style: HealynTypography.body,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: HealynSpacing.s6),
            const HealynSectionHeader(title: 'History'),
            const SizedBox(height: HealynSpacing.s3),
            NavCard(
              icon: Icons.assignment_outlined,
              label: 'Treatment history',
              onTap: () => context.push(
                '/physio/patients/${patient.id}/treatment_notes',
                extra: patient.fullName,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static bool _has(String? s) => s != null && s.trim().isNotEmpty;
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
