import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../patients/presentation/patients_providers.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/section_card.dart';
import '../../data/appointments_repository.dart';
import '../../data/models/appointment_models.dart';
import '../appointment_format.dart';
import '../appointments_providers.dart';
import '../widgets/appointment_status_chip.dart';

/// Re-requests an existing open appointment for a new date (request-first). The
/// patient picks a new date and an optional preferred time — never a final time;
/// the patient and physiotherapist are fixed (the backend keeps them). The
/// current date and the existing reason are prefilled. On success the backend
/// marks the original RESCHEDULED and returns a *new* unscheduled REQUESTED
/// appointment, which this screen returns via `pop` so the detail can navigate
/// to it.
class RescheduleAppointmentScreen extends ConsumerStatefulWidget {
  const RescheduleAppointmentScreen({required this.appointment, super.key});

  final Appointment appointment;

  @override
  ConsumerState<RescheduleAppointmentScreen> createState() =>
      _RescheduleAppointmentScreenState();
}

class _RescheduleAppointmentScreenState
    extends ConsumerState<RescheduleAppointmentScreen> {
  static const int _maxHorizonDays = 90;
  static const int _reasonMaxLength = 280;

  final _reason = TextEditingController();
  final _dayField = TextEditingController();
  final _timeField = TextEditingController();

  DateTime? _day;
  TimeOfDay? _time;

  bool _submitting = false;
  String? _error;

  Appointment get _appt => widget.appointment;

  @override
  void initState() {
    super.initState();
    // Start on the appointment's current day (the scheduled day if it has one,
    // otherwise the requested day) with its reason prefilled.
    final current = _appt.day.toLocal();
    _day = DateTime(current.year, current.month, current.day);
    _dayField.text = formatDateShort(_appt.day);
    if (_appt.reason != null) _reason.text = _appt.reason!;
  }

  @override
  void dispose() {
    _reason.dispose();
    _dayField.dispose();
    _timeField.dispose();
    super.dispose();
  }

  Future<void> _pickDay() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _day ?? today,
      firstDate: today,
      lastDate: today.add(const Duration(days: _maxHorizonDays)),
      helpText: 'New appointment date',
    );
    if (picked == null) return;
    setState(() {
      _day = picked;
      _dayField.text = formatDateShort(picked);
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 9, minute: 0),
      helpText: 'Preferred time (optional)',
    );
    if (picked == null) return;
    setState(() {
      _time = picked;
      _timeField.text = picked.format(context);
    });
  }

  void _clearTime() {
    setState(() {
      _time = null;
      _timeField.clear();
    });
  }

  Future<void> _submit() async {
    if (_day == null) {
      setState(() => _error = 'Pick a date.');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });
    final repo = ref.read(appointmentsRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    final reason = _reason.text.trim();
    final time = _time;
    try {
      final saved = await repo.reschedule(
        _appt.id,
        RescheduleAppointmentRequest(
          requestedDate: _day!,
          preferredTime:
              time == null ? null : wireClockTime(time.hour, time.minute),
          reason: reason.isEmpty ? null : reason,
        ),
      );
      ref.invalidate(appointmentsProvider);
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('New request sent')),
      );
      // Hand the new appointment back to the detail screen so it can replace
      // the now-stale (RESCHEDULED) one it's showing.
      context.pop(saved);
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

    return Scaffold(
      appBar: AppBar(title: const Text('Reschedule')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(HealynSpacing.screenEdge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_error != null) ...[
                ErrorBanner(message: _error!),
                const SizedBox(height: HealynSpacing.s4),
              ],
              _CurrentAppointmentCard(appt: _appt, patientName: patientName),
              const SizedBox(height: HealynSpacing.s6),
              const Text('Request a new date', style: HealynTypography.overline),
              const SizedBox(height: HealynSpacing.s3),
              AppTextField(
                label: 'Date',
                controller: _dayField,
                readOnly: true,
                onTap: _submitting ? null : _pickDay,
                hintText: 'Select a date',
                suffixIcon: const Icon(Icons.calendar_today_outlined),
              ),
              const SizedBox(height: HealynSpacing.s4),
              AppTextField(
                label: 'Preferred time (optional)',
                controller: _timeField,
                readOnly: true,
                onTap: _submitting ? null : _pickTime,
                hintText: 'No preference',
                suffixIcon: _time == null
                    ? const Icon(Icons.schedule_outlined)
                    : IconButton(
                        tooltip: 'Clear time',
                        icon: const Icon(Icons.close),
                        onPressed: _submitting ? null : _clearTime,
                      ),
              ),
              const SizedBox(height: HealynSpacing.s2),
              Text(
                'Your physiotherapist confirms the final date and time.',
                style: HealynTypography.caption.copyWith(
                  color: HealynColors.textSecondary,
                ),
              ),
              const SizedBox(height: HealynSpacing.s4),
              AppTextField(
                label: 'Reason (optional)',
                controller: _reason,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                hintText: 'e.g. Lower back pain follow-up',
                inputFormatters: [
                  LengthLimitingTextInputFormatter(_reasonMaxLength),
                ],
              ),
              const SizedBox(height: HealynSpacing.s7),
              PrimaryButton(
                label: 'Send new request',
                loading: _submitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The appointment being moved, so the patient has context for the new request.
class _CurrentAppointmentCard extends StatelessWidget {
  const _CurrentAppointmentCard({required this.appt, required this.patientName});

  final Appointment appt;
  final String? patientName;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                appt.isScheduled ? 'Current time' : 'Current request',
                style: HealynTypography.caption.copyWith(
                  color: HealynColors.textSecondary,
                ),
              ),
              const Spacer(),
              AppointmentStatusChip(status: appt.status),
            ],
          ),
          const SizedBox(height: HealynSpacing.s2),
          Text(formatAppointmentWhen(appt), style: HealynTypography.bodyStrong),
          if (patientName != null) ...[
            const SizedBox(height: HealynSpacing.s1),
            Text(
              patientName!,
              style: HealynTypography.caption.copyWith(
                color: HealynColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
