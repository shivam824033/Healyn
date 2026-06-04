import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../appointments/data/appointments_repository.dart';
import '../../../appointments/data/models/appointment_models.dart';
import '../../../appointments/presentation/appointment_format.dart';
import '../../../appointments/presentation/widgets/appointment_status_chip.dart';
import '../../../patients/presentation/patients_providers.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/section_card.dart';
import '../physio_appointment_actions.dart';
import '../physio_schedule_providers.dart';

/// One appointment from the physiotherapist's side, with the lifecycle actions
/// legal for its current status (C3): confirm / reject a request, start / mark
/// no-show / cancel a confirmed visit, complete / cancel one in progress. Each
/// fires `POST /appointments/{id}/transitions`; cancellations collect a
/// mandatory note. Discussion (C4) and treatment notes (C5) land later.
class PhysioAppointmentDetailScreen extends ConsumerStatefulWidget {
  const PhysioAppointmentDetailScreen({required this.appointment, super.key});

  final Appointment appointment;

  @override
  ConsumerState<PhysioAppointmentDetailScreen> createState() =>
      _PhysioAppointmentDetailScreenState();
}

class _PhysioAppointmentDetailScreenState
    extends ConsumerState<PhysioAppointmentDetailScreen> {
  late Appointment _appt = widget.appointment;
  bool _submitting = false;
  String? _error;

  Future<void> _onAction(PhysioAppointmentAction action) async {
    String? note;
    if (action.isCancellation) {
      note = await _promptNote(action);
      if (note == null || !mounted) return; // dismissed
    } else {
      final ok = await _confirm(action);
      if (ok != true || !mounted) return;
    }
    await _runTransition(action, note);
  }

  Future<bool?> _confirm(PhysioAppointmentAction action) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${action.label}?'),
        content: Text(_confirmPrompt(action)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Not now'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(action.label),
          ),
        ],
      ),
    );
  }

  /// Collects the mandatory cancellation note. Returns the trimmed note, or null
  /// if the physio backed out. The confirm button stays disabled until the field
  /// has text.
  Future<String?> _promptNote(PhysioAppointmentAction action) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${action.label}?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_confirmPrompt(action)),
            const SizedBox(height: HealynSpacing.s4),
            TextField(
              controller: controller,
              autofocus: true,
              maxLines: 3,
              maxLength: 2000,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Reason (shared with the patient)',
                hintText: 'Why is this appointment being cancelled?',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep it'),
          ),
          ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              final note = controller.text.trim();
              return TextButton(
                onPressed: note.isEmpty
                    ? null
                    : () => Navigator.pop(ctx, note),
                style: TextButton.styleFrom(
                  foregroundColor: HealynColors.statusDanger,
                ),
                child: Text(action.label),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _runTransition(
    PhysioAppointmentAction action,
    String? note,
  ) async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    final repo = ref.read(appointmentsRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final updated = await repo.transition(
        _appt.id,
        to: action.target,
        reason: action.isCancellation
            ? physioCancelReasonFor(_appt.status)
            : null,
        note: note,
      );
      ref.invalidate(physioScheduleProvider);
      if (!mounted) return;
      setState(() => _appt = updated);
      messenger.showSnackBar(SnackBar(content: Text(_successMessage(action))));
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
      if (_appt.cancelReason != null) ('Reason', _appt.cancelReason!.label),
      if (_has(_appt.cancelNote)) ('Note', _appt.cancelNote!),
    ];
    final actions = physioActionsFor(_appt.status);

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
            OutlinedButton.icon(
              onPressed: () => context.push(
                '/physio/appointments/${_appt.id}/discussion',
                extra: _appt,
              ),
              icon: const Icon(Icons.forum_outlined),
              label: const Text('Discussion'),
              style: OutlinedButton.styleFrom(
                foregroundColor: HealynColors.textPrimary,
                minimumSize: const Size.fromHeight(48),
                side: const BorderSide(color: HealynColors.borderSubtle),
              ),
            ),
            if (actions.isNotEmpty) ...[
              const SizedBox(height: HealynSpacing.s7),
              for (var i = 0; i < actions.length; i++) ...[
                if (i > 0) const SizedBox(height: HealynSpacing.s3),
                _ActionButton(
                  action: actions[i],
                  onPressed: _submitting ? null : () => _onAction(actions[i]),
                ),
              ],
            ],
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

  String _confirmPrompt(PhysioAppointmentAction action) {
    final when = formatWhen(_appt.scheduledAt);
    return switch (action) {
      PhysioAppointmentAction.confirm =>
        'Confirm the appointment on $when? The patient will be notified.',
      PhysioAppointmentAction.reject =>
        'Reject the request for $when? The patient will be notified.',
      PhysioAppointmentAction.start => 'Start the session for $when?',
      PhysioAppointmentAction.complete =>
        'Mark the appointment on $when as completed?',
      PhysioAppointmentAction.noShow =>
        'Mark the appointment on $when as a no-show?',
      PhysioAppointmentAction.cancel =>
        'Cancel the appointment on $when? The patient will be notified.',
    };
  }

  String _successMessage(PhysioAppointmentAction action) => switch (action) {
    PhysioAppointmentAction.confirm => 'Appointment confirmed',
    PhysioAppointmentAction.reject => 'Request rejected',
    PhysioAppointmentAction.start => 'Session started',
    PhysioAppointmentAction.complete => 'Appointment completed',
    PhysioAppointmentAction.noShow => 'Marked as no-show',
    PhysioAppointmentAction.cancel => 'Appointment cancelled',
  };

  static bool _has(String? s) => s != null && s.trim().isNotEmpty;
}

/// One lifecycle action: filled for the forward action, outlined otherwise
/// (danger-tinted for cancellations).
class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.action, required this.onPressed});

  final PhysioAppointmentAction action;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(_iconFor(action));
    final label = Text(action.label);
    const minSize = Size.fromHeight(48);

    if (action.isPrimary) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: label,
        style: ElevatedButton.styleFrom(minimumSize: minSize),
      );
    }
    final color = action.isCancellation
        ? HealynColors.statusDanger
        : HealynColors.textPrimary;
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: label,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        minimumSize: minSize,
        side: const BorderSide(color: HealynColors.borderSubtle),
      ),
    );
  }

  static IconData _iconFor(PhysioAppointmentAction action) => switch (action) {
    PhysioAppointmentAction.confirm => Icons.check_circle_outline,
    PhysioAppointmentAction.reject => Icons.cancel_outlined,
    PhysioAppointmentAction.start => Icons.play_arrow_outlined,
    PhysioAppointmentAction.complete => Icons.task_alt_outlined,
    PhysioAppointmentAction.noShow => Icons.person_off_outlined,
    PhysioAppointmentAction.cancel => Icons.event_busy_outlined,
  };
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
