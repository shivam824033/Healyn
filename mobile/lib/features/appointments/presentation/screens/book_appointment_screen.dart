import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../patients/data/models/patient_models.dart';
import '../../../patients/presentation/active_patient_provider.dart';
import '../../../patients/presentation/patients_providers.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../data/appointments_repository.dart';
import '../../data/models/appointment_models.dart';
import '../appointment_format.dart';
import '../appointments_providers.dart';
import '../widgets/slot_picker.dart';

/// Prefill for the booking form, used when it's opened from a "next review"
/// suggestion (D6): the patient to pre-select and the date to pre-fill. The slot
/// is still chosen from live availability — nothing is auto-booked.
class BookAppointmentArgs {
  const BookAppointmentArgs({this.patientId, this.day});

  final String? patientId;
  final DateTime? day;
}

/// Books an appointment: pick the patient, a date, then one of the open slots
/// for that day, with an optional reason. Slots come live from `/availability`,
/// so the chosen time is always one the backend will accept. On success it
/// refreshes the timeline and pops. [initialPatientId] / [initialDay] prefill the
/// form when arriving from a next-review suggestion.
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

  // One key per booking attempt: dedupes retries of the *same* booking (e.g. a
  // lost response) without blocking a genuinely new one on the next screen.
  final String _idempotencyKey = _newIdempotencyKey();
  final _reason = TextEditingController();
  final _dayField = TextEditingController();

  Patient? _patient;
  DateTime? _day;
  List<Slot>? _slots;
  bool _slotsLoading = false;
  String? _slotsError;
  Slot? _selectedSlot;

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
      // Load that day's slots once the first frame is up (setState-safe).
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _loadSlots(d);
      });
    }
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
      helpText: 'Appointment date',
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

  Future<void> _submit(Patient patient) async {
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
      await repo.book(
        BookAppointmentRequest(
          patientId: patient.id,
          scheduledAt: slot.startsAt,
          durationMinutes: slot.durationMinutes,
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
      appBar: AppBar(title: const Text('Book appointment')),
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
    return DropdownButtonFormField<String>(
      initialValue: value.id,
      decoration: const InputDecoration(labelText: 'Patient'),
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
    );
  }

  static String _label(Patient p) {
    if (p.primary) return '${p.fullName} (You)';
    final rel = p.relationship?.label;
    return rel == null ? p.fullName : '${p.fullName} ($rel)';
  }
}
