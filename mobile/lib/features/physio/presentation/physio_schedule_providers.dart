import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../appointments/data/appointments_repository.dart';
import '../../appointments/data/models/appointment_models.dart';

/// Upper bound on a single day's appointments fetched for the schedule. A day
/// never holds anywhere near this many, so one page is always enough; the
/// physiotherapist schedule does not paginate within a day in Phase 1.
const _dayFetchLimit = 50;

/// The calendar day shown on the physiotherapist's schedule, at local midnight.
/// The day stepper moves it; [physioScheduleProvider] refetches when it changes.
final scheduleDayProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

/// The physiotherapist's appointments for [scheduleDayProvider], earliest first.
/// The window is the local calendar day `[00:00, next 00:00)`, sent to the
/// backend as instants (it filters `scheduledAt >= from && < to`). A physio's
/// `GET /appointments` spans every patient, so this is the whole day's roster.
final physioScheduleProvider = FutureProvider.autoDispose<List<Appointment>>((
  ref,
) async {
  final day = ref.watch(scheduleDayProvider);
  final from = day;
  final to = DateTime(day.year, day.month, day.day + 1);
  final page = await ref
      .watch(appointmentsRepositoryProvider)
      .list(from: from, to: to, limit: _dayFetchLimit);
  return [...page.items]..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
});

/// Whether [day] is the local calendar day "today" — drives the stepper's
/// "Jump to today" affordance.
bool isToday(DateTime day) {
  final now = DateTime.now();
  return day.year == now.year && day.month == now.month && day.day == now.day;
}
