import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../appointments/data/appointments_repository.dart';
import '../../../appointments/data/models/appointment_models.dart';
import '../../../appointments/presentation/appointment_format.dart';
import '../../../appointments/presentation/widgets/slot_picker.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';

/// The time a physiotherapist assigned in [showAssignTimeSheet]: a final
/// [scheduledAt] (the chosen open slot's start instant), a [durationMinutes]
/// length, and — for a follow-up — an optional [reason]. The caller turns this
/// into the relevant request body.
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

/// Common appointment lengths a physiotherapist assigns, in minutes. The grid
/// itself is 15-minute, so a visit occupies `duration / 15` consecutive cells.
const _durations = [15, 30, 45, 60, 90];

/// Opens the assign-time sheet so the physiotherapist can pick a date, choose
/// one of that day's open time slots, and set a duration (and, when [showReason],
/// an optional reason). Returns the chosen [AssignTimeResult], or null if
/// dismissed. Prefilled from [initialDay] / [initialTime] / [initialDuration] so
/// the common case is: open, tap the highlighted slot, confirm.
Future<AssignTimeResult?> showAssignTimeSheet(
  BuildContext context, {
  required String title,
  required String confirmLabel,
  required DateTime initialDay,
  TimeOfDay? initialTime,
  int initialDuration = 45,
  bool showReason = false,
  String? initialReason,
  String? excludeAppointmentId,
}) {
  return showModalBottomSheet<AssignTimeResult>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _AssignTimeSheet(
      title: title,
      confirmLabel: confirmLabel,
      initialDay: initialDay,
      initialTime: initialTime,
      initialDuration: initialDuration,
      showReason: showReason,
      initialReason: initialReason,
      excludeAppointmentId: excludeAppointmentId,
    ),
  );
}

class _AssignTimeSheet extends ConsumerStatefulWidget {
  const _AssignTimeSheet({
    required this.title,
    required this.confirmLabel,
    required this.initialDay,
    required this.initialTime,
    required this.initialDuration,
    required this.showReason,
    this.initialReason,
    this.excludeAppointmentId,
  });

  final String title;
  final String confirmLabel;
  final DateTime initialDay;
  final TimeOfDay? initialTime;
  final int initialDuration;
  final bool showReason;
  final String? initialReason;

  /// The appointment being rescheduled, if any — excluded from the day's booked
  /// slots so it never flags its own current time as taken.
  final String? excludeAppointmentId;

  @override
  ConsumerState<_AssignTimeSheet> createState() => _AssignTimeSheetState();
}

class _AssignTimeSheetState extends ConsumerState<_AssignTimeSheet> {
  static const int _maxHorizonDays = 180;
  static const int _reasonMaxLength = 280;

  final _dayField = TextEditingController();
  final _reason = TextEditingController();

  late DateTime _day;
  late int _duration;

  /// The day's 15-minute grid cells, or null until the first load settles.
  List<Slot>? _slots;
  bool _slotsLoading = false;
  String? _slotsError;

  /// The picked *start* cell. The chosen [_duration] paints the occupied range
  /// from here (see [_selectedStarts]); reducing it releases trailing cells.
  Slot? _selected;

  /// Time spans already taken on [_day] (excluding the appointment being
  /// rescheduled). Their covered cells render as non-selectable "booked" chips.
  List<BookedRange> _bookedRanges = const [];

  @override
  void initState() {
    super.initState();
    final d = widget.initialDay;
    _day = DateTime(d.year, d.month, d.day);
    _duration = widget.initialDuration;
    _dayField.text = formatDateShort(_day);
    final reason = widget.initialReason;
    if (reason != null) _reason.text = reason;
    _loadSlots();
  }

  @override
  void dispose() {
    _dayField.dispose();
    _reason.dispose();
    super.dispose();
  }

  /// Fetches the open slots for [_day], clearing any prior selection. When the
  /// sheet opened with a preferred/current [widget.initialTime], the matching
  /// slot is pre-selected so the common case is one tap to confirm.
  Future<void> _loadSlots() async {
    setState(() {
      _slotsLoading = true;
      _slotsError = null;
      _selected = null;
      _slots = null;
      _bookedRanges = const [];
    });
    final repo = ref.read(appointmentsRepositoryProvider);
    try {
      final slots = await repo.slotsFor(_day);
      // Booked context is an enhancement: never let it fail the slot load.
      var booked = const <BookedRange>[];
      try {
        booked = await repo.bookedRangesFor(
          _day,
          excludeAppointmentId: widget.excludeAppointmentId,
        );
      } on ApiException {
        booked = const [];
      }
      if (!mounted) return;
      setState(() {
        _slots = slots;
        _bookedRanges = booked;
        _selected = _matchInitialTime(slots, booked);
        _slotsLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _slotsError = e.message;
        _slotsLoading = false;
      });
    }
  }

  /// The cell whose local start time equals the sheet's initial time, if any —
  /// used to pre-highlight the patient's preferred time or, on reschedule, the
  /// booking's current start (its own range is excluded, so it stays open).
  /// Booked cells are skipped: a taken time is never pre-selected.
  Slot? _matchInitialTime(List<Slot> slots, List<BookedRange> booked) {
    final t = widget.initialTime;
    if (t == null) return null;
    for (final s in slots) {
      if (booked.any((r) => r.covers(s.startsAt))) continue;
      final local = s.startsAt.toLocal();
      if (local.hour == t.hour && local.minute == t.minute) return s;
    }
    return null;
  }

  List<Slot> get _slotList => _slots ?? const [];

  /// Cells a different appointment occupies (every covered cell of every booked
  /// range that falls on the visible grid), greyed out in the picker.
  Set<DateTime> get _bookedStarts => {
    for (final s in _slotList)
      if (_bookedRanges.any((r) => r.covers(s.startsAt))) s.startsAt,
  };

  /// The cells the current start + duration occupy — the visit's range. Empty
  /// until a start is picked. Shrinks the moment the duration is reduced.
  Set<DateTime> get _selectedStarts {
    final sel = _selected;
    if (sel == null) return const {};
    final end = sel.startsAt.add(Duration(minutes: _duration));
    return {
      for (final s in _slotList)
        if (!s.startsAt.isBefore(sel.startsAt) && s.startsAt.isBefore(end))
          s.startsAt,
    };
  }

  /// Whether the chosen range `[start, start + duration)` overlaps a booked one.
  /// Computed against the booked ranges directly (half-open, like the backend),
  /// so it catches an overlap even where the run extends past the visible grid.
  bool get _hasConflict {
    final sel = _selected;
    if (sel == null) return false;
    final start = sel.startsAt;
    final end = start.add(Duration(minutes: _duration));
    return _bookedRanges.any(
      (r) => r.start.isBefore(end) && r.end.isAfter(start),
    );
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
      _day = DateTime(picked.year, picked.month, picked.day);
      _dayField.text = formatDateShort(_day);
    });
    await _loadSlots();
  }

  void _confirm() {
    final slot = _selected;
    if (slot == null || _hasConflict) return;
    final reason = _reason.text.trim();
    Navigator.of(context).pop(
      AssignTimeResult(
        scheduledAt: slot.startsAt,
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
      child: SingleChildScrollView(
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
            SlotPicker(
              label: 'Available times',
              day: _day,
              loading: _slotsLoading,
              error: _slotsError,
              slots: _slots,
              selectedStarts: _selectedStarts,
              enabled: true,
              onSelected: (s) => setState(() => _selected = s),
              onRetry: _loadSlots,
              bookedStarts: _bookedStarts,
              hasConflict: _hasConflict,
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
            if (_selected != null) ...[
              const SizedBox(height: HealynSpacing.s2),
              Text(
                'Occupies ${formatTimeOfDay(_selected!.startsAt)} – '
                '${formatTimeOfDay(_selected!.startsAt.add(Duration(minutes: _duration)))}',
                style: HealynTypography.caption.copyWith(
                  color: HealynColors.textSecondary,
                ),
              ),
            ],
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
            PrimaryButton(
              label: widget.confirmLabel,
              onPressed: (_selected == null || _hasConflict) ? null : _confirm,
            ),
          ],
        ),
      ),
    );
  }
}
