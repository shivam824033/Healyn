import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../appointments/data/appointments_repository.dart';
import '../../../appointments/data/models/appointment_models.dart';
import '../../../appointments/presentation/appointment_format.dart';
import '../../../appointments/presentation/appointments_providers.dart';
import '../../../appointments/presentation/widgets/appointment_status_chip.dart';
import '../../../appointments/presentation/widgets/appointment_timeline_section.dart';
import '../../../patients/data/models/patient_models.dart';
import '../../../patients/presentation/patient_format.dart';
import '../../../patients/presentation/patients_providers.dart';
import '../../../patients/presentation/widgets/patient_avatar.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/elevation.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/domain/patient_sex.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/section_card.dart';
import '../physio_appointment_actions.dart';
import '../physio_requests_providers.dart';
import '../physio_schedule_providers.dart';
import '../widgets/assign_time_sheet.dart';
import '../widgets/physio_treatment_note_section.dart';

/// One appointment from the physiotherapist's side, with the actions legal for
/// its current status. Request-first scheduling lives in the assign-time sheet:
/// a REQUESTED appointment is confirmed by *assigning a time* (`POST
/// /{id}/schedule`), a CONFIRMED one can be rescheduled to a new time (`POST
/// /{id}/reschedule`), and a COMPLETED one can spawn a follow-up review (`POST
/// /follow-ups`). The remaining lifecycle moves — reject / start / no-show /
/// complete / cancel — fire `POST /{id}/transitions`; cancellations collect a
/// mandatory note. Links out to the discussion thread; once COMPLETED, the
/// treatment-note section lets the physio write or revise the note.
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
      ref
        ..invalidate(physioScheduleProvider)
        // A confirm/reject moves the appointment out of REQUESTED, so refresh
        // the incoming-requests queue (Today banner + requests screen).
        ..invalidate(physioRequestsProvider)
        // Every transition appends a timeline event; refresh the History section.
        ..invalidate(appointmentTimelineProvider);
      if (!mounted) return;
      setState(() => _appt = updated);
      messenger.showSnackBar(SnackBar(content: Text(_successMessage(action))));
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  /// Confirm a request by assigning its final time (REQUESTED → CONFIRMED).
  /// Prefilled with the requested date and the patient's preferred-time hint.
  Future<void> _openSchedule() async {
    final result = await showAssignTimeSheet(
      context,
      title: 'Set appointment time',
      confirmLabel: 'Confirm appointment',
      initialDay: _appt.requestedDate,
      initialTime: _timeOfDayFrom(_appt.preferredTime),
      excludeAppointmentId: _appt.id,
    );
    if (result == null || !mounted) return;
    await _runScheduling(
      () => ref
          .read(appointmentsRepositoryProvider)
          .schedule(
            _appt.id,
            ScheduleAppointmentRequest(
              scheduledAt: result.scheduledAt,
              durationMinutes: result.durationMinutes,
            ),
          ),
      success: 'Appointment confirmed',
    );
  }

  /// Move a confirmed appointment to a new assigned time. The backend returns
  /// the new appointment (the original becomes RESCHEDULED), so the screen
  /// follows the patient to it.
  Future<void> _openReschedule() async {
    final at = _appt.scheduledAt?.toLocal();
    final result = await showAssignTimeSheet(
      context,
      title: 'Reschedule appointment',
      confirmLabel: 'Confirm new time',
      initialDay: at ?? _appt.requestedDate,
      initialTime: at != null ? TimeOfDay.fromDateTime(at) : null,
      initialDuration: _appt.durationMinutes,
      excludeAppointmentId: _appt.id,
    );
    if (result == null || !mounted) return;
    await _runScheduling(
      () => ref
          .read(appointmentsRepositoryProvider)
          .rescheduleByPhysio(
            _appt.id,
            PhysioRescheduleRequest(
              scheduledAt: result.scheduledAt,
              durationMinutes: result.durationMinutes,
            ),
          ),
      success: 'Appointment rescheduled',
    );
  }

  /// Book a follow-up review for this patient. A fresh appointment, so the
  /// current (completed) one stays on screen; defaults a week out.
  Future<void> _openFollowUp() async {
    final now = DateTime.now();
    final result = await showAssignTimeSheet(
      context,
      title: 'Schedule follow-up review',
      confirmLabel: 'Confirm follow-up',
      initialDay: DateTime(now.year, now.month, now.day + 7),
      showReason: true,
      excludeAppointmentId: _appt.id,
    );
    if (result == null || !mounted) return;
    await _runScheduling(
      () => ref
          .read(appointmentsRepositoryProvider)
          .createFollowUp(
            FollowUpRequest(
              patientId: _appt.patientId,
              scheduledAt: result.scheduledAt,
              durationMinutes: result.durationMinutes,
              reason: result.reason,
            ),
          ),
      success: 'Follow-up scheduled',
      replaceAppt: false,
    );
  }

  /// Runs a scheduling call (schedule / reschedule / follow-up), refreshing the
  /// schedule and requests queues. [replaceAppt] swaps the on-screen appointment
  /// for the returned one (true for schedule/reschedule, which act on it; false
  /// for a follow-up, which creates a separate appointment).
  Future<void> _runScheduling(
    Future<Appointment> Function() call, {
    required String success,
    bool replaceAppt = true,
  }) async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    final messenger = ScaffoldMessenger.of(context);
    try {
      final updated = await call();
      ref
        ..invalidate(physioScheduleProvider)
        ..invalidate(physioRequestsProvider)
        // Scheduling actions append timeline events — a follow-up even appends
        // to the *current* appointment's lineage — so refresh the History section.
        ..invalidate(appointmentTimelineProvider);
      if (!mounted) return;
      setState(() {
        if (replaceAppt) _appt = updated;
      });
      messenger.showSnackBar(SnackBar(content: Text(success)));
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  /// Parses a wire `HH:mm[:ss]` clock string into a [TimeOfDay], or null when
  /// absent/unparseable so the sheet falls back to its default.
  static TimeOfDay? _timeOfDayFrom(String? wire) {
    if (wire == null) return null;
    final parts = wire.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  /// The action buttons for the current status, in display order: the
  /// request-first scheduling buttons (assign time / reschedule / follow-up)
  /// interleaved with the lifecycle transitions from [physioActionsFor].
  List<Widget> _actionButtons() {
    final disabled = _submitting;
    final buttons = <Widget>[];

    // Confirming a request means assigning its time (request-first).
    if (_appt.status == AppointmentStatus.requested) {
      buttons.add(
        _filledAction(
          Icons.event_available_outlined,
          'Set time & confirm',
          disabled ? null : _openSchedule,
        ),
      );
    }

    for (final action in physioActionsFor(_appt.status)) {
      buttons.add(
        _ActionButton(
          action: action,
          onPressed: disabled ? null : () => _onAction(action),
        ),
      );
      // A confirmed visit can be moved to a new time; slot Reschedule right
      // after Start so the destructive no-show / cancel stay at the bottom.
      if (action == PhysioAppointmentAction.start) {
        buttons.add(
          _outlinedAction(
            Icons.event_repeat_outlined,
            'Reschedule',
            disabled ? null : _openReschedule,
          ),
        );
      }
    }

    // A completed visit can spawn a follow-up review.
    if (_appt.status == AppointmentStatus.completed) {
      buttons.add(
        _filledAction(
          Icons.event_repeat_outlined,
          'Schedule follow-up',
          disabled ? null : _openFollowUp,
        ),
      );
    }

    return buttons;
  }

  Widget _filledAction(IconData icon, String label, VoidCallback? onPressed) =>
      ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
      );

  Widget _outlinedAction(IconData icon, String label, VoidCallback? onPressed) =>
      OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: HealynColors.textPrimary,
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: HealynColors.borderSubtle),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final patients = ref.watch(patientsProvider).valueOrNull ?? const [];
    final patient = {for (final p in patients) p.id: p}[_appt.patientId];

    final scheduledAt = _appt.scheduledAt;
    final scheduledEndAt = _appt.scheduledEndAt;
    final preferred = formatClockTime(_appt.preferredTime);
    // The patient now reads as a tappable card above (quick patient access), so
    // it is no longer repeated as a detail row.
    final rows = <(String, String)>[
      if (_appt.isFollowUp) ('Type', 'Follow-up review'),
      ('When', formatDateLong(_appt.day)),
      if (scheduledAt != null)
        (
          'Time',
          scheduledEndAt != null
              ? '${formatTimeOfDay(scheduledAt)} – ${formatTimeOfDay(scheduledEndAt)}'
              : formatTimeOfDay(scheduledAt),
        )
      else
        ('Time', 'Not scheduled yet'),
      if (scheduledAt != null) ('Duration', formatDuration(_appt.durationMinutes)),
      if (scheduledAt == null && preferred != null) ('Preferred time', preferred),
      if (_has(_appt.reason)) ('Reason', _appt.reason!),
    ];
    final cancellation = <(String, String)>[
      if (_appt.cancelReason != null) ('Reason', _appt.cancelReason!.label),
      if (_has(_appt.cancelNote)) ('Note', _appt.cancelNote!),
    ];
    final actionButtons = _actionButtons();

    return Scaffold(
      appBar: const HealynAppBar(title: 'Appointment'),
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
                  if (_appt.appointmentNumber != null) ...[
                    const SizedBox(height: HealynSpacing.s2),
                    Text(
                      _appt.appointmentNumber!,
                      style: HealynTypography.caption.copyWith(
                        color: HealynColors.textMuted,
                      ),
                    ),
                  ],
                  const SizedBox(height: HealynSpacing.s3),
                  Text(
                    formatDateShort(_appt.day),
                    style: HealynTypography.h2,
                  ),
                  const SizedBox(height: HealynSpacing.s1),
                  Text(
                    scheduledAt != null
                        ? formatTimeOfDay(scheduledAt)
                        : 'Not scheduled yet',
                    style: HealynTypography.body.copyWith(
                      color: HealynColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (patient != null) ...[
              const SizedBox(height: HealynSpacing.s6),
              _PatientCard(patient: patient),
            ],
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
            if (_appt.status == AppointmentStatus.completed) ...[
              const SizedBox(height: HealynSpacing.s6),
              PhysioTreatmentNoteSection(appointmentId: _appt.id),
            ],
            if (actionButtons.isNotEmpty) ...[
              const SizedBox(height: HealynSpacing.s7),
              for (var i = 0; i < actionButtons.length; i++) ...[
                if (i > 0) const SizedBox(height: HealynSpacing.s3),
                actionButtons[i],
              ],
            ],
            if (cancellation.isNotEmpty) ...[
              const SizedBox(height: HealynSpacing.s6),
              const _SectionTitle('Cancellation'),
              const SizedBox(height: HealynSpacing.s3),
              _DetailCard(rows: cancellation),
            ],
            const SizedBox(height: HealynSpacing.s6),
            AppointmentTimelineSection(appointmentId: _appt.id),
          ],
        ),
      ),
    );
  }

  String _confirmPrompt(PhysioAppointmentAction action) {
    final when = formatAppointmentWhen(_appt);
    return switch (action) {
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
    PhysioAppointmentAction.reject => Icons.cancel_outlined,
    PhysioAppointmentAction.start => Icons.play_arrow_outlined,
    PhysioAppointmentAction.complete => Icons.task_alt_outlined,
    PhysioAppointmentAction.noShow => Icons.person_off_outlined,
    PhysioAppointmentAction.cancel => Icons.event_busy_outlined,
  };
}

/// A tappable summary of the appointment's patient — the physiotherapist's
/// one-tap jump to the full patient profile + treatment history. Shows the
/// monogram, name and a non-PHI identity line (patient number · age · sex).
class _PatientCard extends StatelessWidget {
  const _PatientCard({required this.patient});

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    final meta = <String>[
      if (patient.patientNumber != null) patient.patientNumber!,
      '${patientAgeInYears(patient.dateOfBirth)}y',
      if (patient.sex != null) patient.sex!.label,
    ].join(' · ');

    return Container(
      decoration: BoxDecoration(
        color: HealynColors.surfaceBase,
        borderRadius: HealynRadii.brLg,
        border: Border.all(color: HealynColors.borderSubtle),
        boxShadow: HealynElevation.e1,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: HealynRadii.brLg,
          onTap: () =>
              context.push('/physio/patients/${patient.id}', extra: patient),
          child: Padding(
            padding: const EdgeInsets.all(HealynSpacing.s4),
            child: Row(
              children: [
                PatientAvatar(name: patient.fullName),
                const SizedBox(width: HealynSpacing.s4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(patient.fullName, style: HealynTypography.bodyStrong),
                      const SizedBox(height: HealynSpacing.s1),
                      Text(
                        meta,
                        style: HealynTypography.caption.copyWith(
                          color: HealynColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: HealynColors.textMuted),
              ],
            ),
          ),
        ),
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
