import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../patients/data/models/patient_models.dart';
import '../../../patients/presentation/patient_format.dart';
import '../../../shared/domain/patient_sex.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
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
      appBar: AppBar(title: const Text('Patient')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(HealynSpacing.screenEdge),
          children: [
            _Header(patient: patient),
            const SizedBox(height: HealynSpacing.s6),
            const _SectionTitle('Personal details'),
            const SizedBox(height: HealynSpacing.s3),
            _DetailCard(rows: details),
            if (medical.isNotEmpty) ...[
              const SizedBox(height: HealynSpacing.s6),
              const _SectionTitle('Medical'),
              const SizedBox(height: HealynSpacing.s3),
              _DetailCard(rows: medical),
            ],
            if (_has(patient.notes)) ...[
              const SizedBox(height: HealynSpacing.s6),
              const _SectionTitle('Notes'),
              const SizedBox(height: HealynSpacing.s3),
              SectionCard(
                child: Text(patient.notes!, style: HealynTypography.body),
              ),
            ],
            if (reviewDue != null) ...[
              const SizedBox(height: HealynSpacing.s6),
              const _SectionTitle('Follow-up due'),
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
            const _SectionTitle('History'),
            const SizedBox(height: HealynSpacing.s3),
            _NavCard(
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
            child: Text(patient.fullName, style: HealynTypography.h2),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text.toUpperCase(), style: HealynTypography.overline);
}

class _NavCard extends StatelessWidget {
  const _NavCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(HealynSpacing.s4),
            child: Row(
              children: [
                Icon(icon, size: 20, color: HealynColors.textSecondary),
                const SizedBox(width: HealynSpacing.s3),
                Expanded(child: Text(label, style: HealynTypography.bodyStrong)),
                const Icon(Icons.chevron_right, color: HealynColors.textMuted),
              ],
            ),
          ),
        ),
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
