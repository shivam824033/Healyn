import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../appointments/data/appointments_repository.dart';
import '../../appointments/data/models/appointment_models.dart';
import '../../discussion/data/discussion_repository.dart';
import '../../discussion/data/models/discussion_models.dart';

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
  // The from/to bound on `scheduled_at` already excludes unscheduled requests,
  // so every row here has a time; sort by `day` to stay null-safe regardless.
  return [...page.items]..sort((a, b) => a.day.compareTo(b.day));
});

/// Whether [day] is the local calendar day "today" — drives the stepper's
/// "Jump to today" affordance.
bool isToday(DateTime day) {
  final now = DateTime.now();
  return day.year == now.year && day.month == now.month && day.day == now.day;
}

/// The discussion activity a schedule row surfaces (C8): unread messages waiting
/// for the physiotherapist and, among those, the files attached to them.
class ScheduleActivity {
  const ScheduleActivity({this.unreadCount = 0, this.pendingFileCount = 0});

  /// Unread messages from the patient side (the physio's own are excluded).
  final int unreadCount;

  /// Files attached to those unread messages — the ones the physio has not yet
  /// opened. Always `0` when there is nothing unread.
  final int pendingFileCount;

  bool get hasUnread => unreadCount > 0;
  bool get hasPendingFiles => pendingFileCount > 0;
  bool get isEmpty => unreadCount == 0 && pendingFileCount == 0;
}

/// How many messages to scan when counting the files attached to unread ones.
/// A day's thread never holds anywhere near this many; one page is enough.
const _activityScanLimit = 100;

/// Per-appointment discussion activity for the appointments on
/// [physioScheduleProvider]'s day, keyed by appointment id (entries with no
/// activity are omitted, so a present key always means "something to show").
///
/// Phase 1 has no server-side aggregate, so this fans the per-thread
/// `unread-count` calls out across the day's *live* appointments (dead states —
/// cancelled / no-show / rescheduled — can't gain messages, so they're skipped).
/// For an appointment that has unread messages it then reads the newest page
/// once and counts the files on the newest [ScheduleActivity.unreadCount]
/// patient-side messages — exactly the unread set, since the read marker only
/// moves forward and the physio's own messages don't count. A failed call
/// degrades to zero so a transient error under-counts rather than breaking the
/// schedule.
final physioScheduleActivityProvider =
    FutureProvider.autoDispose<Map<String, ScheduleActivity>>((ref) async {
      final appointments = await ref.watch(physioScheduleProvider.future);
      final live = appointments.where(_canHaveUnread).toList();
      if (live.isEmpty) return const <String, ScheduleActivity>{};

      final repo = ref.watch(discussionRepositoryProvider);
      final entries = await Future.wait(
        live.map((a) async => MapEntry(a.id, await _activityFor(repo, a.id))),
      );
      return {
        for (final e in entries)
          if (!e.value.isEmpty) e.key: e.value,
      };
    });

Future<ScheduleActivity> _activityFor(
  DiscussionRepository repo,
  String appointmentId,
) async {
  final int unread;
  try {
    unread = await repo.unreadCount(appointmentId);
  } catch (_) {
    return const ScheduleActivity();
  }
  if (unread <= 0) return const ScheduleActivity();

  var files = 0;
  try {
    final page = await repo.list(appointmentId, limit: _activityScanLimit);
    // Newest-first: the newest `unread` patient-side messages are the unread
    // ones. Sum their attachments — the files awaiting the physiotherapist.
    final unreadIncoming = page.items
        .where((m) => m.senderRole == DiscussionSenderRole.patientSide)
        .take(unread);
    for (final m in unreadIncoming) {
      files += m.attachments.length;
    }
  } catch (_) {
    // Keep the unread badge even if the file scan fails.
  }
  return ScheduleActivity(unreadCount: unread, pendingFileCount: files);
}

/// Whether an appointment's thread can still gain unread messages. Mirrors the
/// Home unread roll-up's rule (DISCUSSION_SYSTEM_DESIGN §9) so the two agree.
bool _canHaveUnread(Appointment a) =>
    a.status != AppointmentStatus.cancelled &&
    a.status != AppointmentStatus.noShow &&
    a.status != AppointmentStatus.rescheduled;
