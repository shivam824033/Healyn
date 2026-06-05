import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../appointments/data/appointments_repository.dart';
import '../../appointments/data/models/appointment_models.dart';

/// Upper bound on the incoming-requests fetch. The pending queue is small in
/// Phase 1 (one physiotherapist), so a single page always covers it; the
/// requests surface does not paginate.
const _requestsFetchLimit = 50;

/// The physiotherapist's pending incoming requests — REQUESTED appointments from
/// now forward, earliest first. Surfaced as a banner on Today and a dedicated
/// requests screen, each tapping into the appointment detail to confirm or
/// reject (F1.11). The list endpoint already filters by status + from, so no
/// backend change is needed. Invalidated after a confirm/reject so the count
/// drops without a manual refresh.
final physioRequestsProvider = FutureProvider.autoDispose<List<Appointment>>((
  ref,
) async {
  final page = await ref
      .watch(appointmentsRepositoryProvider)
      .list(
        statusCsv: 'REQUESTED',
        from: DateTime.now(),
        limit: _requestsFetchLimit,
      );
  return [...page.items]..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
});
