import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../patients/data/models/patient_models.dart';
import '../../../patients/presentation/active_patient_provider.dart';
import '../../../patients/presentation/patients_providers.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/field_label.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../data/appointments_repository.dart';
import '../../data/models/appointment_models.dart';
import '../appointment_format.dart';
import '../appointments_providers.dart';

/// Prefill for the booking form, used when it's opened from a "next review"
/// suggestion (D6): the patient to pre-select and the date to pre-fill. Nothing
/// is auto-requested — the patient still confirms the request.
class BookAppointmentArgs {
  const BookAppointmentArgs({this.patientId, this.day});

  final String? patientId;
  final DateTime? day;
}

/// Requests an appointment (request-first): pick the patient and a date, with an
/// optional preferred time and reason. The patient never picks a final time —
/// the physiotherapist confirms the date and assigns the time afterwards. On
/// success it refreshes the timeline and pops. [initialPatientId] / [initialDay]
/// prefill the form when arriving from a next-review suggestion.
class BookAppointmentScreen extends ConsumerStatefulWidget {
  const BookAppointmentScreen({this.initialPatientId, this.initialDay, super.key});

  final String? initialPatientId;
  final DateTime? initialDay;

  @override
  ConsumerState<BookAppointmentScreen> createState() =>
      _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends ConsumerState<BookAppointmentScreen> {
  static const int _maxHorizonDays = 90;
  static const int _reasonMaxLength = 280;

  // One key per booking attempt: dedupes retries of the *same* request (e.g. a
  // lost response) without blocking a genuinely new one on the next screen.
  final String _idempotencyKey = _newIdempotencyKey();
  final _reason = TextEditingController();
  final _dayField = TextEditingController();
  final _timeField = TextEditingController();

  Patient? _patient;
  DateTime? _day;
  TimeOfDay? _time;

  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final day = widget.initialDay;
    if (day != null) {
      final d = DateTime(day.year, day.month, day.day);
      _day = d;
      _dayField.text = formatDateShort(d);
    }
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
      helpText: 'Appointment date',
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

  Future<void> _submit(Patient patient) async {
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
      await repo.book(
        BookAppointmentRequest(
          patientId: patient.id,
          requestedDate: _day!,
          preferredTime:
              time == null ? null : wireClockTime(time.hour, time.minute),
          reason: reason.isEmpty ? null : reason,
        ),
        idempotencyKey: _idempotencyKey,
      );
      ref.invalidate(appointmentsProvider);
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Appointment requested')),
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
    final patients = ref.watch(patientsProvider);
    return Scaffold(
      appBar: const HealynAppBar(title: 'Request appointment'),
      body: SafeArea(
        child: patients.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => ListView(
            padding: const EdgeInsets.all(HealynSpacing.screenEdge),
            children: const [
              ErrorBanner(
                message: 'Could not load your patients. Go back and retry.',
              ),
            ],
          ),
          data: (all) {
            if (all.isEmpty) {
              return ListView(
                padding: const EdgeInsets.all(HealynSpacing.screenEdge),
                children: const [
                  ErrorBanner(message: 'No patient profile found.'),
                ],
              );
            }
            // Prefer an explicit pick, then a prefilled patient (next-review
            // suggestion), then the active Patient context, so booking from a
            // switched family member or a suggestion pre-selects the right one.
            Patient? prefilled;
            if (widget.initialPatientId != null) {
              for (final p in all) {
                if (p.id == widget.initialPatientId) {
                  prefilled = p;
                  break;
                }
              }
            }
            final selected =
                _patient ??
                prefilled ??
                ref.watch(activePatientProvider) ??
                all.first;
            return _form(all, selected);
          },
        ),
      ),
    );
  }

  Widget _form(List<Patient> patients, Patient selected) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(HealynSpacing.screenEdge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_error != null) ...[
            ErrorBanner(message: _error!),
            const SizedBox(height: HealynSpacing.s4),
          ],
          _PatientField(
            patients: patients,
            value: selected,
            enabled: !_submitting,
            onChanged: (p) => setState(() => _patient = p),
          ),
          const SizedBox(height: HealynSpacing.s4),
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
            label: 'Request appointment',
            loading: _submitting,
            onPressed: () => _submit(selected),
          ),
        ],
      ),
    );
  }

  static String _newIdempotencyKey() {
    final rng = Random.secure();
    return List<int>.generate(16, (_) => rng.nextInt(256))
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
  }
}

class _PatientField extends StatelessWidget {
  const _PatientField({
    required this.patients,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final List<Patient> patients;
  final Patient value;
  final bool enabled;
  final ValueChanged<Patient> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const FieldLabel('Patient'),
        DropdownButtonFormField<String>(
          initialValue: value.id,
          items: patients
              .map(
                (p) => DropdownMenuItem(
                  value: p.id,
                  child: Text(_label(p)),
                ),
              )
              .toList(),
          onChanged: enabled
              ? (id) {
                  if (id == null) return;
                  onChanged(patients.firstWhere((p) => p.id == id));
                }
              : null,
        ),
      ],
    );
  }

  static String _label(Patient p) {
    if (p.primary) return '${p.fullName} (You)';
    final rel = p.relationship?.label;
    return rel == null ? p.fullName : '${p.fullName} ($rel)';
  }
}
