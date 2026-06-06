import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../appointments/data/appointments_repository.dart';
import '../../appointments/data/models/appointment_models.dart';

/// How many upcoming appointments the dashboard asks for. The backend caps this
/// at 50; 30 is the product default ("the next month of work" — F1.12).
const _upcomingLimit = 30;

/// The physiotherapist's next live scheduled appointments from now
/// (CONFIRMED / IN_PROGRESS), ascending — the pushed Upcoming screen. The
/// backend already orders and caps these, so the list is used as-is.
final physioUpcomingProvider = FutureProvider.autoDispose<List<Appointment>>((
  ref,
) async {
  return ref
      .watch(appointmentsRepositoryProvider)
      .upcoming(limit: _upcomingLimit);
});
