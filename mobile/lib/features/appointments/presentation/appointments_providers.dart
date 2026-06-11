import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/appointments_repository.dart';
import '../data/models/appointment_models.dart';

/// Page size for the appointments timeline. Most patients fit one page; older
/// appointments page in via [AppointmentsNotifier.loadMore].
const _pageSize = 20;

/// The accumulated appointments list plus its cursor-paging state.
class AppointmentsState {
  const AppointmentsState({
    required this.items,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  final List<Appointment> items;

  /// Another page is available from the backend cursor.
  final bool hasMore;

  /// A [AppointmentsNotifier.loadMore] call is in flight.
  final bool isLoadingMore;

  AppointmentsState copyWith({
    List<Appointment>? items,
    bool? hasMore,
    bool? isLoadingMore,
  }) => AppointmentsState(
    items: items ?? this.items,
    hasMore: hasMore ?? this.hasMore,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );
}

/// The account's appointments across all the patients it manages, newest-first
/// from the backend cursor. The first page loads in [build]; [loadMore] appends
/// older pages. Refreshed via `ref.invalidate(appointmentsProvider)` after
/// booking, cancelling, or rescheduling.
class AppointmentsNotifier extends AutoDisposeAsyncNotifier<AppointmentsState> {
  String? _nextCursor;

  @override
  Future<AppointmentsState> build() async {
    final page = await ref
        .watch(appointmentsRepositoryProvider)
        .list(limit: _pageSize);
    _nextCursor = page.nextCursor;
    return AppointmentsState(items: page.items, hasMore: _nextCursor != null);
  }

  /// Appends the next cursor page. No-op while a page is in flight, when there
  /// is no more to load, or before the first page has settled.
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null ||
        !current.hasMore ||
        current.isLoadingMore ||
        _nextCursor == null) {
      return;
    }
    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final page = await ref
          .read(appointmentsRepositoryProvider)
          .list(cursor: _nextCursor, limit: _pageSize);
      _nextCursor = page.nextCursor;
      state = AsyncData(
        AppointmentsState(
          items: [...current.items, ...page.items],
          hasMore: _nextCursor != null,
        ),
      );
    } catch (_) {
      // Keep what we already have; just clear the spinner so the user can retry.
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }
}

final appointmentsProvider =
    AutoDisposeAsyncNotifierProvider<AppointmentsNotifier, AppointmentsState>(
      AppointmentsNotifier.new,
    );

/// A single appointment by id — used by the detail route when it was opened
/// without the object in `extra` (deep link / refresh).
final appointmentByIdProvider =
    FutureProvider.autoDispose.family<Appointment, String>(
      (ref, id) => ref.watch(appointmentsRepositoryProvider).get(id),
    );

/// The lineage-wide event timeline of one appointment, oldest first — the
/// History section on the detail screens. Keyed by the appointment being
/// viewed; the backend expands to its whole lineage. Invalidate the family
/// after any lifecycle action so the section reflects the event just recorded.
final appointmentTimelineProvider =
    FutureProvider.autoDispose.family<List<TimelineEvent>, String>(
      (ref, id) => ref.watch(appointmentsRepositoryProvider).timeline(id),
    );

/// Open appointments (Requested/Confirmed/In progress), soonest first. Sorts by
/// [AppointmentX.day] so unscheduled requests (no [Appointment.scheduledAt])
/// order by their requested date.
List<Appointment> upcomingOf(List<Appointment> all) {
  final list = all.where((a) => a.status.isActive).toList()
    ..sort((a, b) => a.day.compareTo(b.day));
  return list;
}

/// The single soonest open appointment across [all] — the account's next
/// upcoming appointment regardless of which managed patient it's for. Null when
/// nothing is open. Home uses this so a booking made for a family member still
/// surfaces, not only one for the active patient.
Appointment? nextUpcomingOf(List<Appointment> all) {
  final upcoming = upcomingOf(all);
  return upcoming.isEmpty ? null : upcoming.first;
}

/// Closed appointments (completed, cancelled, no-show, rescheduled), most
/// recent first. Sorts by [AppointmentX.day] so a request rejected before it was
/// ever scheduled still orders by its requested date.
List<Appointment> pastOf(List<Appointment> all) {
  final list = all.where((a) => !a.status.isActive).toList()
    ..sort((a, b) => b.day.compareTo(a.day));
  return list;
}
