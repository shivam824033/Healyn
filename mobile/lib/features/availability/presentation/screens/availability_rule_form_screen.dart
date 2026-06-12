import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/field_label.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../data/availability_repository.dart';
import '../availability_format.dart';

/// Weekly working hours in wire day-of-week values, Monday-first for display.
const _dayChoices = <int>[1, 2, 3, 4, 5, 6, 0];

/// Slot lengths offered (minutes). The backend accepts 5–240; these are the
/// common clinic cadences and all divide a typical working day cleanly.
const _slotChoices = <int>[15, 30, 45, 60];

/// A small curated set of IANA timezones (the server validates the id). The
/// clinic default leads; a full picker is a later concern.
const _timezoneChoices = <String>[
  'Asia/Kolkata',
  'Asia/Dubai',
  'Asia/Singapore',
  'Europe/London',
  'America/New_York',
  'America/Los_Angeles',
  'Australia/Sydney',
  'UTC',
];

/// Adds a recurring weekly working-hours rule (C7). The physio picks a day, a
/// start/end time, a slot length and a timezone; the rule is open-ended
/// (effective from today). Start and end must sit on slot-length boundaries from
/// midnight — validated here so the physio sees it before the server's 422.
class AvailabilityRuleFormScreen extends ConsumerStatefulWidget {
  const AvailabilityRuleFormScreen({super.key});

  @override
  ConsumerState<AvailabilityRuleFormScreen> createState() =>
      _AvailabilityRuleFormScreenState();
}

class _AvailabilityRuleFormScreenState
    extends ConsumerState<AvailabilityRuleFormScreen> {
  int _dayOfWeek = 1;
  TimeOfDay _start = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _end = const TimeOfDay(hour: 17, minute: 0);
  int _slotMinutes = 30;
  String _timezone = _timezoneChoices.first;

  bool _submitting = false;
  String? _error;

  int _minutes(TimeOfDay t) => t.hour * 60 + t.minute;

  bool get _endAfterStart => _minutes(_end) > _minutes(_start);

  bool get _aligned =>
      _minutes(_start) % _slotMinutes == 0 &&
      _minutes(_end) % _slotMinutes == 0;

  String? get _validationError {
    if (!_endAfterStart) return 'End time must be after start time.';
    if (!_aligned) {
      return 'Start and end must fall on $_slotMinutes-minute boundaries '
          '(e.g. ${_alignedExample()}).';
    }
    return null;
  }

  String _alignedExample() {
    // First two grid points from 9:00 for the chosen slot length.
    final a = formatClockTime('9:00');
    final b = formatClockTime('9:$_slotMinutes');
    return _slotMinutes >= 60 ? '$a, 10:00 AM' : '$a, $b';
  }

  Future<void> _pickStart() async {
    final picked = await showTimePicker(context: context, initialTime: _start);
    if (picked != null) setState(() => _start = picked);
  }

  Future<void> _pickEnd() async {
    final picked = await showTimePicker(context: context, initialTime: _end);
    if (picked != null) setState(() => _end = picked);
  }

  String _wire(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:'
      '${t.minute.toString().padLeft(2, '0')}:00';

  Future<void> _save() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    final repo = ref.read(availabilityRepositoryProvider);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await repo.createRule(
        dayOfWeek: _dayOfWeek,
        startTime: _wire(_start),
        endTime: _wire(_end),
        slotMinutes: _slotMinutes,
        timezone: _timezone,
        effectiveFrom: DateTime.now(),
      );
      messenger.showSnackBar(
        const SnackBar(content: Text('Working hours added')),
      );
      navigator.pop(true);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final validation = _validationError;
    final canSave = validation == null && !_submitting;
    return Scaffold(
      appBar: const HealynAppBar(title: 'Add working hours'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(HealynSpacing.screenEdge),
          children: [
            if (_error != null) ...[
              ErrorBanner(message: _error!),
              const SizedBox(height: HealynSpacing.s4),
            ],
            const FieldLabel('Day'),
            DropdownButtonFormField<int>(
              initialValue: _dayOfWeek,
              items: [
                for (final d in _dayChoices)
                  DropdownMenuItem(value: d, child: Text(dayOfWeekLabel(d))),
              ],
              onChanged: _submitting
                  ? null
                  : (v) => setState(() => _dayOfWeek = v ?? _dayOfWeek),
            ),
            const SizedBox(height: HealynSpacing.s5),
            Row(
              children: [
                Expanded(
                  child: _TimeField(
                    label: 'Start',
                    value: _start,
                    onTap: _submitting ? null : _pickStart,
                  ),
                ),
                const SizedBox(width: HealynSpacing.s4),
                Expanded(
                  child: _TimeField(
                    label: 'End',
                    value: _end,
                    onTap: _submitting ? null : _pickEnd,
                  ),
                ),
              ],
            ),
            const SizedBox(height: HealynSpacing.s5),
            const FieldLabel('Slot length'),
            DropdownButtonFormField<int>(
              initialValue: _slotMinutes,
              items: [
                for (final m in _slotChoices)
                  DropdownMenuItem(value: m, child: Text('$m minutes')),
              ],
              onChanged: _submitting
                  ? null
                  : (v) => setState(() => _slotMinutes = v ?? _slotMinutes),
            ),
            const SizedBox(height: HealynSpacing.s5),
            const FieldLabel('Timezone'),
            DropdownButtonFormField<String>(
              initialValue: _timezone,
              items: [
                for (final tz in _timezoneChoices)
                  DropdownMenuItem(value: tz, child: Text(tz)),
              ],
              onChanged: _submitting
                  ? null
                  : (v) => setState(() => _timezone = v ?? _timezone),
            ),
            const SizedBox(height: HealynSpacing.s5),
            if (validation != null)
              Text(
                validation,
                style: HealynTypography.caption.copyWith(
                  color: HealynColors.statusDanger,
                ),
              ),
            const SizedBox(height: HealynSpacing.s6),
            PrimaryButton(
              label: 'Add working hours',
              loading: _submitting,
              onPressed: canSave ? _save : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final TimeOfDay value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label),
        InkWell(
          onTap: onTap,
          child: InputDecorator(
            decoration: const InputDecoration(suffixIcon: Icon(Icons.schedule)),
            child: Text(
              formatClockTime('${value.hour}:${value.minute}'),
              style: HealynTypography.body,
            ),
          ),
        ),
      ],
    );
  }
}
