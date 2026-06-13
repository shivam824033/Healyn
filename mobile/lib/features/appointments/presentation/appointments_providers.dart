import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/appointments_repository.dart';
import '../data/models/appointment_models.dart';

/// Page size for the appointments timeline. Most patients fit one page; older
/// appointments page in via [AppointmentsNotifier.loadMore].
const _pageSize = 20;

/// The status group a filter chip narrows the list to. Single-select: each maps
/// to the backend `status` CSV (or none for [all]). [upcoming] groups the live
/// states; the terminal states each stand alone.
enum AppointmentStatusFilter {
  all,
  upcoming,
  completed,
  cancelled,
  rejected;

  String get label => switch (this) {
    AppointmentStatusFilter.all => 'All',
    AppointmentStatusFilter.upcoming => 'Upcoming',
    AppointmentStatusFilter.completed => 'Completed',
    AppointmentStatusFilter.cancelled => 'Cancelled',
    AppointmentStatusFilter.rejected => 'Rejected',
  };

  /// The backend `status` CSV this filter sends, or null for no status filter.
  String? get statusCsv => switch (this) {
    AppointmentStatusFilter.all => null,
    AppointmentStatusFilter.upcoming => 'REQUESTED,CONFIRMED,IN_PROGRESS',
    AppointmentStatusFilter.completed => 'COMPLETED',
    AppointmentStatusFilter.cancelled => 'CANCELLED',
    AppointmentStatusFilter.rejected => 'REJECTED',
  };
}

/// The current appointment-list filter: a status group plus orthogonal toggles
/// (follow-ups-only, and — physio side only — needs-treatment-note-only). Drives
/// [appointmentsProvider] — changing it reloads the first page (the cursor
/// resets). [needsNoteOnly] is applied client-side (the backend list can't filter
/// on note existence), so it never reaches the wire.
class AppointmentListFilter {
  const AppointmentListFilter({
    this.status = AppointmentStatusFilter.all,
    this.followUpOnly = false,
    this.needsNoteOnly = false,
  });

  final AppointmentStatusFilter status;
  final bool followUpOnly;

  /// Physio-only: narrow completed appointments to those still missing a
  /// treatment note. Filtered in the UI, not the query.
  final bool needsNoteOnly;

  bool get isDefault =>
      status == AppointmentStatusFilter.all && !followUpOnly && !needsNoteOnly;

  AppointmentListFilter copyWith({
    AppointmentStatusFilter? status,
    bool? followUpOnly,
    bool? needsNoteOnly,
  }) => AppointmentListFilter(
    status: status ?? this.status,
    followUpOnly: followUpOnly ?? this.followUpOnly,
    needsNoteOnly: needsNoteOnly ?? this.needsNoteOnly,
  );

  @override
  bool operator ==(Object other) =>
      other is AppointmentListFilter &&
      other.status == status &&
      other.followUpOnly == followUpOnly &&
      other.needsNoteOnly == needsNoteOnly;

  @override
  int get hashCode => Object.hash(status, followUpOnly, needsNoteOnly);
}

/// The selected filter for the appointments list. Persists across navigation so
/// returning to the tab keeps the chosen view.
final appointmentFilterProvider = StateProvider<AppointmentListFilter>(
  (ref) => const AppointmentListFilter(),
);

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
    // Re-runs whenever the filter changes, reloading the first page (cursor reset).
    final filter = ref.watch(appointmentFilterProvider);
    final page = await ref
        .watch(appointmentsRepositoryProvider)
        .list(
          statusCsv: filter.status.statusCsv,
          isFollowUp: filter.followUpOnly ? true : null,
          limit: _pageSize,
        );
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
      final filter = ref.read(appointmentFilterProvider);
      final page = await ref
          .read(appointmentsRepositoryProvider)
          .list(
            statusCsv: filter.status.statusCsv,
            isFollowUp: filter.followUpOnly ? true : null,
            cursor: _nextCursor,
            limit: _pageSize,
          );
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

/// The shortest term the backend will search — anything shorter returns nothing,
/// so the UI skips the round-trip entirely. Mirrors the server-side guard.
const appointmentSearchMinLength = 2;

/// Global appointment-search results for the header autocomplete, keyed by the
/// (already-debounced) query. Returns an empty list below
/// [appointmentSearchMinLength] without hitting the network; autoDispose so the
/// cache clears when the search field closes, and the family caches per-term so
/// re-typing a prefix is instant.
final appointmentSearchProvider =
    FutureProvider.autoDispose.family<List<AppointmentSuggestion>, String>((
      ref,
      query,
    ) async {
      final q = query.trim();
      if (q.length < appointmentSearchMinLength) return const [];
      return ref.watch(appointmentsRepositoryProvider).search(q);
    });

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
