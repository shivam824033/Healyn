import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/patient_models.dart';
import '../data/patients_repository.dart';

/// Every patient linked to the signed-in account — the primary patient plus any
/// family members. Shared by the Family and Profile tabs so the list is fetched
/// once and refreshed via `ref.invalidate(patientsProvider)`.
final patientsProvider = FutureProvider.autoDispose<List<Patient>>(
  (ref) => ref.watch(patientsRepositoryProvider).list(),
);

/// The account's own (primary) patient, or null if the list is empty.
Patient? primaryPatientOf(List<Patient> patients) {
  for (final p in patients) {
    if (p.primary) return p;
  }
  return patients.isEmpty ? null : patients.first;
}

/// Patients other than the account's own — i.e. the managed family members.
List<Patient> familyMembersOf(List<Patient> patients) =>
    patients.where((p) => !p.primary).toList();

/// The signed-in account's household address (shared across all its patients),
/// or null when none is set. Backs the Profile address section and its edit form.
final accountAddressProvider = FutureProvider.autoDispose<Address?>(
  (ref) => ref.watch(patientsRepositoryProvider).accountAddress(),
);
