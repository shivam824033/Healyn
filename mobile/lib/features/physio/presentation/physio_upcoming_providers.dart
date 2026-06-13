import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../appointments/data/appointments_repository.dart';
import '../../appointments/data/models/appointment_models.dart';
import '../../appointments/presentation/appointments_providers.dart';
import '../../treatment_notes/data/treatment_notes_repository.dart';

/// Page size for the physiotherapist's appointments list. Matches the patient
/// timeline; older appointments page in via [PhysioAppointmentsNotifier.loadMore].
const _pageSize = 20;

/// The physiotherapist's appointments-list filter. Kept separate from the
/// patient [appointmentFilterProvider] so the two screens don't share a
/// selection. Defaults to [AppointmentStatusFilter.upcoming] — the screen's
/// primary job is the next live appointments; other statuses are a chip away.
final physioAppointmentFilterProvider = StateProvider<AppointmentListFilter>(
  (ref) => const AppointmentListFilter(status: AppointmentStatusFilter.upcoming),
);

/// The physiotherapist's appointments across all their patients, newest-schedule
/// first from the backend cursor, narrowed by [physioAppointmentFilterProvider].
/// Mirrors the patient [appointmentsProvider]; the backend scopes the list to
/// the physiotherapist's own appointments by JWT role. Re-runs (cursor reset)
/// whenever the filter changes; [loadMore] appends older pages.
class PhysioAppointmentsNotifier
    extends AutoDisposeAsyncNotifier<AppointmentsState> {
  String? _nextCursor;

  @override
  Future<AppointmentsState> build() async {
    final filter = ref.watch(physioAppointmentFilterProvider);
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
      final filter = ref.read(physioAppointmentFilterProvider);
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

final physioAppointmentsProvider =
    AutoDisposeAsyncNotifierProvider<
      PhysioAppointmentsNotifier,
      AppointmentsState
    >(PhysioAppointmentsNotifier.new);

/// The ids of the loaded physio appointments that already have a treatment note.
/// Only completed appointments can have one, so only those are asked about. Drives
/// the "note added / pending" chip and the "Needs note" filter, and refetches
/// whenever the appointments list changes (filter, paging). An error surfaces as
/// loading/null at the call site, so the UI omits the chip rather than mislabel.
final physioNoteStatusProvider = FutureProvider.autoDispose<Set<String>>((
  ref,
) async {
  final state = await ref.watch(physioAppointmentsProvider.future);
  final completedIds = [
    for (final a in state.items)
      if (a.status == AppointmentStatus.completed) a.id,
  ];
  if (completedIds.isEmpty) return const <String>{};
  return ref
      .watch(treatmentNotesRepositoryProvider)
      .appointmentsWithNotes(completedIds);
});
