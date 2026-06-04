import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../patients/presentation/patients_providers.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../treatment_notes/presentation/widgets/treatment_note_section.dart';
import '../../data/appointments_repository.dart';
import '../../data/models/appointment_models.dart';
import '../appointment_format.dart';
import '../appointments_providers.dart';
import '../widgets/appointment_status_chip.dart';

/// Read view of one appointment, with the patient's write actions while it is
/// still open (Requested or Confirmed): reschedule to a new time, or cancel.
/// Reschedule creates a new appointment server-side, so on success this screen
/// is replaced by the new appointment's detail; cancel refreshes and pops.
class AppointmentDetailScreen extends ConsumerStatefulWidget {
  const AppointmentDetailScreen({required this.appointment, super.key});

  final Appointment appointment;

  @override
  ConsumerState<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState
    extends ConsumerState<AppointmentDetailScreen> {
  bool _submitting = false;
  String? _error;

  Appointment get _appt => widget.appointment;

  Future<void> _reschedule() async {
    // The reschedule screen returns the *new* appointment the backend created.
    // The one we're showing is now RESCHEDULED, so replace it with the new one.
    final saved = await context.push<Appointment>(
      '/appointments/${_appt.id}/reschedule',
      extra: _appt,
    );
    if (saved != null && mounted) {
      context.pushReplacement('/appointments/${saved.id}', extra: saved);
    }
  }

  Future<void> _cancel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel appointment?'),
        content: Text(
          'Your appointment on ${formatWhen(_appt.scheduledAt)} will be '
          'cancelled.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep it'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: HealynColors.statusDanger,
            ),
            child: const Text('Cancel appointment'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() {
      _submitting = true;
      _error = null;
    });
    final repo = ref.read(appointmentsRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await repo.cancel(_appt.id);
      ref.invalidate(appointmentsProvider);
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Appointment cancelled')),
      );
      context.pop();
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final patients = ref.watch(patientsProvider).valueOrNull ?? const [];
    final patientName = {
      for (final p in patients) p.id: p.fullName,
    }[_appt.patientId];

    final rows = <(String, String)>[
      if (patientName != null) ('Patient', patientName),
      ('When', formatDateLong(_appt.scheduledAt)),
      (
        'Time',
        '${formatTimeOfDay(_appt.scheduledAt)} – '
            '${formatTimeOfDay(_appt.scheduledEndAt)}',
      ),
      ('Duration', formatDuration(_appt.durationMinutes)),
      if (_has(_appt.reason)) ('Reason', _appt.reason!),
    ];
    final cancellation = <(String, String)>[
      if (_appt.cancelReason != null)
        ('Reason', _appt.cancelReason!.label),
      if (_has(_appt.cancelNote)) ('Note', _appt.cancelNote!),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Appointment')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(HealynSpacing.screenEdge),
          children: [
            if (_error != null) ...[
              ErrorBanner(message: _error!),
              const SizedBox(height: HealynSpacing.s4),
            ],
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppointmentStatusChip(status: _appt.status),
                  const SizedBox(height: HealynSpacing.s3),
                  Text(
                    formatDateShort(_appt.scheduledAt),
                    style: HealynTypography.h2,
                  ),
                  const SizedBox(height: HealynSpacing.s1),
                  Text(
                    formatTimeOfDay(_appt.scheduledAt),
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
            const SizedBox(height: HealynSpacing.s6),
            ElevatedButton.icon(
              onPressed: () => context.push(
                '/appointments/${_appt.id}/discussion',
                extra: _appt,
              ),
              icon: const Icon(Icons.forum_outlined),
              label: const Text('Discussion'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            if (_appt.status == AppointmentStatus.completed) ...[
              const SizedBox(height: HealynSpacing.s6),
              TreatmentNoteSection(appointmentId: _appt.id),
            ],
            if (cancellation.isNotEmpty) ...[
              const SizedBox(height: HealynSpacing.s6),
              const _SectionTitle('Cancellation'),
              const SizedBox(height: HealynSpacing.s3),
              _DetailCard(rows: cancellation),
            ],
            if (_appt.status.isReschedulableByPatient) ...[
              const SizedBox(height: HealynSpacing.s7),
              OutlinedButton.icon(
                onPressed: _submitting ? null : _reschedule,
                icon: const Icon(Icons.event_repeat_outlined),
                label: const Text('Reschedule'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: HealynColors.brandPrimary,
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: HealynColors.borderSubtle),
                ),
              ),
            ],
            if (_appt.status.isCancellableByPatient) ...[
              const SizedBox(height: HealynSpacing.s3),
              OutlinedButton.icon(
                onPressed: _submitting ? null : _cancel,
                icon: const Icon(Icons.event_busy_outlined),
                label: const Text('Cancel appointment'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: HealynColors.statusDanger,
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: HealynColors.borderSubtle),
                ),
              ),
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
