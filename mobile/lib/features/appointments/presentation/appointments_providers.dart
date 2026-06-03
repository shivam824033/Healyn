import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/appointments_repository.dart';
import '../data/models/appointment_models.dart';

/// The account's appointments across all the patients it manages. First page
/// only for now (cursor paging is wired in the repository but the timeline
/// fits a single page in Phase 1); refreshed via
/// `ref.invalidate(appointmentsProvider)` after booking or cancelling.
final appointmentsProvider = FutureProvider.autoDispose<List<Appointment>>(
  (ref) async => (await ref.watch(appointmentsRepositoryProvider).list(
    limit: 50,
  )).items,
);

/// A single appointment by id — used by the detail route when it was opened
/// without the object in `extra` (deep link / refresh).
final appointmentByIdProvider =
    FutureProvider.autoDispose.family<Appointment, String>(
  (ref, id) => ref.watch(appointmentsRepositoryProvider).get(id),
);

/// Open appointments (Requested/Confirmed/In progress), soonest first.
List<Appointment> upcomingOf(List<Appointment> all) {
  final list = all.where((a) => a.status.isActive).toList()
    ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  return list;
}

/// Closed appointments (completed, cancelled, no-show, rescheduled), most
/// recent first.
List<Appointment> pastOf(List<Appointment> all) {
  final list = all.where((a) => !a.status.isActive).toList()
    ..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
  return list;
}
