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
import '../widgets/slot_picker.dart';

/// Moves an existing appointment to a new time. Same shape as booking — pick a
/// date then a live slot — but the patient and physiotherapist are fixed (the
/// backend keeps them), so there's no patient picker. The current date and the
/// existing reason are prefilled. On success the backend marks the original
/// RESCHEDULED and returns a *new* appointment, which this screen returns via
/// `pop` so the detail can navigate to it.
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

  DateTime? _day;
  List<Slot>? _slots;
  bool _slotsLoading = false;
  String? _slotsError;
  Slot? _selectedSlot;

  bool _submitting = false;
  String? _error;

  Appointment get _appt => widget.appointment;

  @override
  void initState() {
    super.initState();
    // Start on the appointment's current day with its reason prefilled, then
    // load that day's open slots (the current time won't be among them — it's
    // still booked by this appointment — so the user picks a new one).
    final current = _appt.scheduledAt.toLocal();
    _day = DateTime(current.year, current.month, current.day);
    _dayField.text = formatDateShort(_appt.scheduledAt);
    if (_appt.reason != null) _reason.text = _appt.reason!;
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSlots(_day!));
  }

  @override
  void dispose() {
    _reason.dispose();
    _dayField.dispose();
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
      _selectedSlot = null;
      _slots = null;
    });
    await _loadSlots(picked);
  }

  Future<void> _loadSlots(DateTime day) async {
    setState(() {
      _slotsLoading = true;
      _slotsError = null;
    });
    try {
      final slots = await ref.read(appointmentsRepositoryProvider).slotsFor(day);
      if (!mounted) return;
      setState(() => _slots = slots);
    } on ApiException catch (e) {
      if (mounted) setState(() => _slotsError = e.message);
    } finally {
      if (mounted) setState(() => _slotsLoading = false);
    }
  }

  Future<void> _submit() async {
    if (_day == null) {
      setState(() => _error = 'Pick a date.');
      return;
    }
    if (_selectedSlot == null) {
      setState(() => _error = 'Choose a time slot.');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });
    final repo = ref.read(appointmentsRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    final slot = _selectedSlot!;
    final reason = _reason.text.trim();
    try {
      final saved = await repo.reschedule(
        _appt.id,
        RescheduleAppointmentRequest(
          scheduledAt: slot.startsAt,
          durationMinutes: slot.durationMinutes,
          reason: reason.isEmpty ? null : reason,
        ),
      );
      ref.invalidate(appointmentsProvider);
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Appointment rescheduled')),
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
              const Text('Pick a new time', style: HealynTypography.overline),
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
              SlotPicker(
                label: 'Time',
                day: _day,
                loading: _slotsLoading,
                error: _slotsError,
                slots: _slots,
                selected: _selectedSlot,
                enabled: !_submitting,
                onSelected: (s) => setState(() => _selectedSlot = s),
                onRetry: _day == null ? null : () => _loadSlots(_day!),
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
                label: 'Reschedule appointment',
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

/// The appointment being moved, so the patient has context for the new time.
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
                'Current time',
                style: HealynTypography.caption.copyWith(
                  color: HealynColors.textSecondary,
                ),
              ),
              const Spacer(),
              AppointmentStatusChip(status: appt.status),
            ],
          ),
          const SizedBox(height: HealynSpacing.s2),
          Text(formatWhen(appt.scheduledAt), style: HealynTypography.bodyStrong),
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
