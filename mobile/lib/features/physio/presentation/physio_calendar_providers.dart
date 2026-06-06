import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../appointments/data/appointments_repository.dart';
import 'month_grid.dart';

/// The month shown in the Today calendar, as that month's first day at local
/// midnight. The month arrows step it; [calendarMarkedDaysProvider] refetches
/// its dots when it changes. Distinct from the selected day
/// (`scheduleDayProvider`): paging the calendar doesn't move the roster.
final calendarMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

/// Local days in [calendarMonthProvider]'s grid that hold at least one scheduled
/// appointment — the dot markers. Fetches the whole grid window once (≤ 42 days,
/// within the backend's 62-day cap) and buckets by local day. A failed load
/// degrades to "no dots" so a transient error never blanks the calendar; the
/// screen reads it with `valueOrNull ?? {}`.
final calendarMarkedDaysProvider = FutureProvider.autoDispose<Set<DateTime>>((
  ref,
) async {
  final month = ref.watch(calendarMonthProvider);
  final (from, to) = monthGridRange(month);
  final items = await ref
      .watch(appointmentsRepositoryProvider)
      .calendar(from: from, to: to);
  return {
    for (final a in items)
      if (a.scheduledAt != null) localDayOf(a.scheduledAt!),
  };
});
