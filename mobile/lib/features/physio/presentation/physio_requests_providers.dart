import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../appointments/data/appointments_repository.dart';
import '../../appointments/data/models/appointment_models.dart';

/// Upper bound on the incoming-requests fetch. The pending queue is small in
/// Phase 1 (one physiotherapist), so a single page always covers it; the
/// requests surface does not paginate.
const _requestsFetchLimit = 50;

/// The physiotherapist's pending incoming requests — REQUESTED appointments,
/// earliest requested date first. Surfaced as a banner on Today and a dedicated
/// requests screen, each tapping into the appointment detail to schedule or
/// reject (F1.11). Request-first: a REQUESTED appointment has no scheduled time
/// yet, so this filters by status only — a `from` bound on `scheduled_at` would
/// drop every unscheduled request. Invalidated after a schedule/reject so the
/// count drops without a manual refresh.
final physioRequestsProvider = FutureProvider.autoDispose<List<Appointment>>((
  ref,
) async {
  final page = await ref
      .watch(appointmentsRepositoryProvider)
      .list(statusCsv: 'REQUESTED', limit: _requestsFetchLimit);
  return [...page.items]..sort((a, b) {
    final byDate = a.requestedDate.compareTo(b.requestedDate);
    if (byDate != 0) return byDate;
    // Within a day, a stated preferred time comes before "no preference".
    return (a.preferredTime ?? '99:99').compareTo(b.preferredTime ?? '99:99');
  });
});
