import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../appointments/data/appointments_repository.dart';
import '../../appointments/data/models/appointment_models.dart';
import '../../discussion/data/discussion_repository.dart';
import '../../discussion/data/models/discussion_models.dart';

/// One appointment thread carrying unread patient messages for the physiotherapist.
class PhysioUnreadThread {
  const PhysioUnreadThread({
    required this.appointment,
    required this.count,
    this.lastMessagePreview,
    this.lastMessageAt,
  });

  final Appointment appointment;
  final int count;

  /// The newest message's text (or 'Attachment' / '' when there is none) — shown
  /// as a preview line. PHI, but in-app only (never a notification).
  final String? lastMessagePreview;
  final DateTime? lastMessageAt;
}

/// The physiotherapist's account-wide unread roll-up: one total across every
/// live thread (not just the selected day) plus the threads carrying unread
/// messages, most-recent activity first.
class PhysioUnreadSummary {
  const PhysioUnreadSummary({required this.total, required this.threads});

  const PhysioUnreadSummary.empty() : total = 0, threads = const [];

  final int total;
  final List<PhysioUnreadThread> threads;
}

/// Statuses fetched for the roll-up — the live + completed threads that can
/// still gain unread messages (cancelled / no-show / rescheduled cannot, and the
/// physio keeps write access on completed). Mirrors the patient roll-up's rule.
const _liveStatusCsv = 'REQUESTED,CONFIRMED,IN_PROGRESS,COMPLETED';

/// Bound on the live appointments scanned in one sweep. Phase 1 has no
/// server-side unread aggregate, so this fans the per-thread `unread-count`
/// calls out across the physio's live appointments (a single page). A very large
/// practice would want a dedicated aggregate endpoint (a Phase 2 enabler).
const _scanLimit = 100;

/// Account-wide unread total + per-thread breakdown for the physiotherapist.
/// Backs the Today "Unread" stat and the Unread Discussions screen. A failed
/// per-thread call degrades to "no unread" for that thread so a transient error
/// under-counts rather than breaking the roll-up.
final physioUnreadSummaryProvider =
    FutureProvider.autoDispose<PhysioUnreadSummary>((ref) async {
  final page = await ref
      .watch(appointmentsRepositoryProvider)
      .list(statusCsv: _liveStatusCsv, limit: _scanLimit);
  final live = page.items;
  if (live.isEmpty) return const PhysioUnreadSummary.empty();

  final repo = ref.watch(discussionRepositoryProvider);
  final scanned = await Future.wait(live.map((a) => _threadFor(repo, a)));

  final threads = scanned.whereType<PhysioUnreadThread>().toList()
    ..sort((a, b) {
      final ad = a.lastMessageAt ?? a.appointment.day;
      final bd = b.lastMessageAt ?? b.appointment.day;
      return bd.compareTo(ad);
    });
  final total = threads.fold<int>(0, (sum, t) => sum + t.count);
  return PhysioUnreadSummary(total: total, threads: threads);
});

Future<PhysioUnreadThread?> _threadFor(
  DiscussionRepository repo,
  Appointment a,
) async {
  final int count;
  try {
    count = await repo.unreadCount(a.id);
  } catch (_) {
    return null;
  }
  if (count <= 0) return null;

  String? preview;
  DateTime? at;
  try {
    final page = await repo.list(a.id, limit: 1);
    if (page.items.isNotEmpty) {
      final newest = page.items.first;
      preview = _preview(newest);
      at = newest.createdAt;
    }
  } catch (_) {
    // Keep the unread badge even if the preview can't be read.
  }
  return PhysioUnreadThread(
    appointment: a,
    count: count,
    lastMessagePreview: preview,
    lastMessageAt: at,
  );
}

String _preview(DiscussionMessage m) {
  final body = m.body?.trim();
  if (body != null && body.isNotEmpty) return body;
  if (m.attachments.isNotEmpty) return 'Attachment';
  return '';
}
