import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/availability_repository.dart';
import '../data/models/availability_models.dart';

/// The physiotherapist's weekly working-hours rules. Refetched on invalidate
/// (after a rule is added or archived).
final availabilityRulesProvider =
    FutureProvider.autoDispose<List<AvailabilityRule>>(
      (ref) => ref.watch(availabilityRepositoryProvider).listRules(),
    );

/// The physiotherapist's time-off windows. Refetched on invalidate (after a
/// window is added or removed).
final blackoutsProvider = FutureProvider.autoDispose<List<BlackoutWindow>>(
  (ref) => ref.watch(availabilityRepositoryProvider).listBlackouts(),
);
