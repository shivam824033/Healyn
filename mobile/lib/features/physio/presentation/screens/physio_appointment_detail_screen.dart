import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../appointments/data/models/appointment_models.dart';
import '../../../appointments/presentation/appointment_format.dart';
import '../../../appointments/presentation/widgets/appointment_status_chip.dart';
import '../../../patients/presentation/patients_providers.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/section_card.dart';

/// Read-only view of one appointment from the physiotherapist's side (C2). The
/// write actions (confirm / start / complete / no-show / cancel), discussion,
/// and treatment-note authoring land in later chunks; here it only surfaces the
/// appointment so the schedule is tappable.
class PhysioAppointmentDetailScreen extends ConsumerWidget {
  const PhysioAppointmentDetailScreen({required this.appointment, super.key});

  final Appointment appointment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(patientsProvider).valueOrNull ?? const [];
    final patientName = {
      for (final p in patients) p.id: p.fullName,
    }[appointment.patientId];

    final rows = <(String, String)>[
      if (patientName != null) ('Patient', patientName),
      ('When', formatDateLong(appointment.scheduledAt)),
      (
        'Time',
        '${formatTimeOfDay(appointment.scheduledAt)} – '
            '${formatTimeOfDay(appointment.scheduledEndAt)}',
      ),
      ('Duration', formatDuration(appointment.durationMinutes)),
      if (_has(appointment.reason)) ('Reason', appointment.reason!),
    ];
    final cancellation = <(String, String)>[
      if (appointment.cancelReason != null)
        ('Reason', appointment.cancelReason!.label),
      if (_has(appointment.cancelNote)) ('Note', appointment.cancelNote!),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Appointment')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(HealynSpacing.screenEdge),
          children: [
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppointmentStatusChip(status: appointment.status),
                  const SizedBox(height: HealynSpacing.s3),
                  Text(
                    formatDateShort(appointment.scheduledAt),
                    style: HealynTypography.h2,
                  ),
                  const SizedBox(height: HealynSpacing.s1),
                  Text(
                    formatTimeOfDay(appointment.scheduledAt),
                    style: HealynTypography.body.copyWith(
                      color: HealynColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: HealynSpacing.s6),
            const _SectionTitle('Details'),
            const SizedBox(height: HealynSpacing.s3),
            _DetailCard(rows: rows),
            if (cancellation.isNotEmpty) ...[
              const SizedBox(height: HealynSpacing.s6),
              const _SectionTitle('Cancellation'),
              const SizedBox(height: HealynSpacing.s3),
              _DetailCard(rows: cancellation),
            ],
          ],
        ),
      ),
    );
  }

  static bool _has(String? s) => s != null && s.trim().isNotEmpty;
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text.toUpperCase(), style: HealynTypography.overline);
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
