import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../appointments/data/models/appointment_models.dart';
import '../../appointments/presentation/appointments_providers.dart';
import '../data/discussion_repository.dart';

/// One appointment that carries unread messages for the signed-in account.
class UnreadThread {
  const UnreadThread({required this.appointment, required this.count});

  final Appointment appointment;
  final int count;
}

/// The account-wide unread roll-up surfaced on Home (DISCUSSION_SYSTEM_DESIGN
/// §9): a single total plus the appointments that carry unread messages — an
/// index, never a merged feed.
class UnreadSummary {
  const UnreadSummary({required this.total, required this.threads});

  const UnreadSummary.empty() : total = 0, threads = const [];

  final int total;
  final List<UnreadThread> threads;
}

/// Whether an appointment's thread can still gain unread messages. Dead states
/// (cancelled / no-show / rescheduled) are skipped to bound the fan-out; the
/// physio retains write on COMPLETED, so those stay in.
bool _hasLiveThread(Appointment a) =>
    a.status != AppointmentStatus.cancelled &&
    a.status != AppointmentStatus.noShow &&
    a.status != AppointmentStatus.rescheduled;

/// Aggregates per-appointment unread counts across the account's appointments.
///
/// Phase 1 has no server-side aggregate endpoint, so this fans out the
/// per-thread `unread-count` calls in parallel over the loaded appointments
/// (a small set for a patient account). A failed count is treated as 0 so a
/// transient error under-counts rather than breaking Home.
final unreadSummaryProvider = FutureProvider.autoDispose<UnreadSummary>((
  ref,
) async {
  final state = await ref.watch(appointmentsProvider.future);
  final live = state.items.where(_hasLiveThread).toList();
  if (live.isEmpty) return const UnreadSummary.empty();

  final repo = ref.watch(discussionRepositoryProvider);
  final counts = await Future.wait(
    live.map((a) async {
      try {
        return await repo.unreadCount(a.id);
      } catch (_) {
        return 0;
      }
    }),
  );

  final threads = <UnreadThread>[];
  var total = 0;
  for (var i = 0; i < live.length; i++) {
    final count = counts[i];
    if (count > 0) {
      threads.add(UnreadThread(appointment: live[i], count: count));
      total += count;
    }
  }
  threads.sort(
    (a, b) => a.appointment.day.compareTo(b.appointment.day),
  );
  return UnreadSummary(total: total, threads: threads);
});
