import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../appointments/presentation/appointment_format.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';

/// The time a physiotherapist assigned in [showAssignTimeSheet]: a final
/// [scheduledAt] (a local instant built from the picked date + time), a
/// [durationMinutes] length, and — for a follow-up — an optional [reason]. The
/// caller turns this into the relevant request body.
class AssignTimeResult {
  const AssignTimeResult({
    required this.scheduledAt,
    required this.durationMinutes,
    this.reason,
  });

  final DateTime scheduledAt;
  final int durationMinutes;
  final String? reason;
}

/// Common appointment lengths a physiotherapist assigns, in minutes.
const _durations = [30, 45, 60, 90];

/// Opens the assign-time sheet so the physiotherapist can set a date, time, and
/// duration (and, when [showReason], an optional reason). Returns the chosen
/// [AssignTimeResult], or null if dismissed. Prefilled from [initialDay] /
/// [initialTime] / [initialDuration] so the common case is one tap to confirm —
/// the physiotherapist adjusts only what differs.
Future<AssignTimeResult?> showAssignTimeSheet(
  BuildContext context, {
  required String title,
  required String confirmLabel,
  required DateTime initialDay,
  TimeOfDay? initialTime,
  int initialDuration = 45,
  bool showReason = false,
  String? initialReason,
}) {
  return showModalBottomSheet<AssignTimeResult>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _AssignTimeSheet(
      title: title,
      confirmLabel: confirmLabel,
      initialDay: initialDay,
      initialTime: initialTime ?? const TimeOfDay(hour: 9, minute: 0),
      initialDuration: initialDuration,
      showReason: showReason,
      initialReason: initialReason,
    ),
  );
}

class _AssignTimeSheet extends StatefulWidget {
  const _AssignTimeSheet({
    required this.title,
    required this.confirmLabel,
    required this.initialDay,
    required this.initialTime,
    required this.initialDuration,
    required this.showReason,
    this.initialReason,
  });

  final String title;
  final String confirmLabel;
  final DateTime initialDay;
  final TimeOfDay initialTime;
  final int initialDuration;
  final bool showReason;
  final String? initialReason;

  @override
  State<_AssignTimeSheet> createState() => _AssignTimeSheetState();
}

class _AssignTimeSheetState extends State<_AssignTimeSheet> {
  static const int _maxHorizonDays = 180;
  static const int _reasonMaxLength = 280;

  final _dayField = TextEditingController();
  final _timeField = TextEditingController();
  final _reason = TextEditingController();

  late DateTime _day;
  late TimeOfDay _time;
  late int _duration;

  @override
  void initState() {
    super.initState();
    final d = widget.initialDay;
    _day = DateTime(d.year, d.month, d.day);
    _time = widget.initialTime;
    _duration = widget.initialDuration;
    _dayField.text = formatDateShort(_day);
    final reason = widget.initialReason;
    if (reason != null) _reason.text = reason;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // TimeOfDay.format needs a context (locale / 24h), so set it here.
    _timeField.text = _time.format(context);
  }

  @override
  void dispose() {
    _dayField.dispose();
    _timeField.dispose();
    _reason.dispose();
    super.dispose();
  }

  Future<void> _pickDay() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final first = _day.isBefore(today) ? _day : today;
    final picked = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: first,
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
      initialTime: _time,
      helpText: 'Appointment time',
    );
    if (picked == null) return;
    setState(() {
      _time = picked;
      _timeField.text = picked.format(context);
    });
  }

  void _confirm() {
    final scheduledAt = DateTime(
      _day.year,
      _day.month,
      _day.day,
      _time.hour,
      _time.minute,
    );
    final reason = _reason.text.trim();
    Navigator.of(context).pop(
      AssignTimeResult(
        scheduledAt: scheduledAt,
        durationMinutes: _duration,
        reason: reason.isEmpty ? null : reason,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Keep the initial duration selectable even if it isn't a standard length.
    final durations = <int>{..._durations, _duration}.toList()..sort();
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(
        left: HealynSpacing.screenEdge,
        right: HealynSpacing.screenEdge,
        top: HealynSpacing.s2,
        bottom: HealynSpacing.s6 + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.title, style: HealynTypography.h3),
          const SizedBox(height: HealynSpacing.s5),
          AppTextField(
            label: 'Date',
            controller: _dayField,
            readOnly: true,
            onTap: _pickDay,
            suffixIcon: const Icon(Icons.calendar_today_outlined),
          ),
          const SizedBox(height: HealynSpacing.s4),
          AppTextField(
            label: 'Time',
            controller: _timeField,
            readOnly: true,
            onTap: _pickTime,
            suffixIcon: const Icon(Icons.schedule_outlined),
          ),
          const SizedBox(height: HealynSpacing.s4),
          DropdownButtonFormField<int>(
            initialValue: _duration,
            decoration: const InputDecoration(labelText: 'Duration'),
            items: [
              for (final m in durations)
                DropdownMenuItem(value: m, child: Text(formatDuration(m))),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _duration = v);
            },
          ),
          if (widget.showReason) ...[
            const SizedBox(height: HealynSpacing.s4),
            AppTextField(
              label: 'Reason (optional)',
              controller: _reason,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              hintText: 'e.g. Progress review',
              inputFormatters: [
                LengthLimitingTextInputFormatter(_reasonMaxLength),
              ],
            ),
          ],
          const SizedBox(height: HealynSpacing.s6),
          PrimaryButton(label: widget.confirmLabel, onPressed: _confirm),
        ],
      ),
    );
  }
}
