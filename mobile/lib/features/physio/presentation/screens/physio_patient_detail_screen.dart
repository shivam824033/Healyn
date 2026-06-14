import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../files/data/url_opener.dart';
import '../../../patients/data/models/patient_models.dart';
import '../../../patients/presentation/patient_format.dart';
import '../../../shared/domain/patient_sex.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/detail_card.dart';
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
    final details = <DetailRowData>[
      DetailRowData(
        'Date of birth',
        '${formatBirthDate(patient.dateOfBirth)} '
            '(age ${patientAgeInYears(patient.dateOfBirth)})',
      ),
      if (patient.sex != null) DetailRowData('Sex', patient.sex!.label),
      if (_has(patient.email))
        DetailRowData('Email', patient.email!, copyable: true),
      if (_has(patient.phoneE164))
        DetailRowData(
          'Phone',
          patient.phoneE164!,
          copyable: true,
          onCall: () => _call(context, ref, patient.phoneE164!),
        ),
    ];
    final medical = <DetailRowData>[
      if (_has(patient.bloodGroup))
        DetailRowData('Blood group', patient.bloodGroup!),
      if (_has(patient.allergies))
        DetailRowData('Allergies', patient.allergies!),
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
            DetailCard(rows: details),
            if (medical.isNotEmpty) ...[
              const SizedBox(height: HealynSpacing.s6),
              const HealynSectionHeader(title: 'Medical'),
              const SizedBox(height: HealynSpacing.s3),
              DetailCard(rows: medical),
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
            const SizedBox(height: HealynSpacing.s3),
            NavCard(
              icon: Icons.folder_outlined,
              label: 'Documents',
              onTap: () => context.push(
                '/physio/patients/${patient.id}/documents',
                extra: patient.fullName,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static bool _has(String? s) => s != null && s.trim().isNotEmpty;

  /// Dials the patient straight from the physio's view via the OS dialer. The
  /// physio can then place the call; we never auto-dial. Falls back to a snackbar
  /// when no dialer is available (e.g. a tablet without telephony).
  static Future<void> _call(
    BuildContext context,
    WidgetRef ref,
    String phoneE164,
  ) async {
    final ok = await ref.read(urlOpenerProvider).open('tel:$phoneE164');
    if (ok || !context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Could not start a call')));
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

