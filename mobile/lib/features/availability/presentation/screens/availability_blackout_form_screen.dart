import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../appointments/presentation/appointment_format.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/field_label.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../data/availability_repository.dart';

/// Adds a one-off time-off window (C7): a start and end instant and an optional
/// short reason. The server rejects a window that overlaps an existing one
/// (409); that message is surfaced inline. End must be after start.
class AvailabilityBlackoutFormScreen extends ConsumerStatefulWidget {
  const AvailabilityBlackoutFormScreen({super.key});

  @override
  ConsumerState<AvailabilityBlackoutFormScreen> createState() =>
      _AvailabilityBlackoutFormScreenState();
}

class _AvailabilityBlackoutFormScreenState
    extends ConsumerState<AvailabilityBlackoutFormScreen> {
  late DateTime _start;
  late DateTime _end;
  final _reason = TextEditingController();

  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Default to the next whole hour, one hour long.
    _start = DateTime(now.year, now.month, now.day, now.hour + 1);
    _end = _start.add(const Duration(hours: 1));
  }

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  bool get _endAfterStart => _end.isAfter(_start);

  Future<DateTime?> _pick(DateTime initial) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365 * 2)),
    );
    if (date == null || !mounted) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _pickStart() async {
    final picked = await _pick(_start);
    if (picked == null) return;
    setState(() {
      _start = picked;
      // Keep end after start: nudge it to start + 1h if it fell behind.
      if (!_end.isAfter(_start)) _end = _start.add(const Duration(hours: 1));
    });
  }

  Future<void> _pickEnd() async {
    final picked = await _pick(_end);
    if (picked != null) setState(() => _end = picked);
  }

  Future<void> _save() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    final repo = ref.read(availabilityRepositoryProvider);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await repo.createBlackout(
        startsAt: _start,
        endsAt: _end,
        reason: _reason.text,
      );
      messenger.showSnackBar(const SnackBar(content: Text('Time off added')));
      navigator.pop(true);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSave = _endAfterStart && !_submitting;
    return Scaffold(
      appBar: const HealynAppBar(title: 'Add time off'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(HealynSpacing.screenEdge),
          children: [
            if (_error != null) ...[
              ErrorBanner(message: _error!),
              const SizedBox(height: HealynSpacing.s4),
            ],
            _DateTimeField(
              label: 'From',
              value: _start,
              onTap: _submitting ? null : _pickStart,
            ),
            const SizedBox(height: HealynSpacing.s5),
            _DateTimeField(
              label: 'To',
              value: _end,
              onTap: _submitting ? null : _pickEnd,
            ),
            const SizedBox(height: HealynSpacing.s5),
            const FieldLabel('Reason (optional)'),
            TextField(
              controller: _reason,
              maxLength: 200,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'e.g. Public holiday, leave',
                counterText: '',
              ),
            ),
            const SizedBox(height: HealynSpacing.s3),
            if (!_endAfterStart)
              Text(
                'End must be after start.',
                style: HealynTypography.caption.copyWith(
                  color: HealynColors.statusDanger,
                ),
              ),
            const SizedBox(height: HealynSpacing.s6),
            PrimaryButton(
              label: 'Add time off',
              loading: _submitting,
              onPressed: canSave ? _save : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _DateTimeField extends StatelessWidget {
  const _DateTimeField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final DateTime value;
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
            decoration: const InputDecoration(suffixIcon: Icon(Icons.event)),
            child: Text(formatWhen(value), style: HealynTypography.body),
          ),
        ),
      ],
    );
  }
}
