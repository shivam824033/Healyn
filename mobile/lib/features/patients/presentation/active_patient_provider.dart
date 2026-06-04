import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/patient_models.dart';
import 'patients_providers.dart';

/// The currently-selected patient id, or `null` to follow the primary patient.
/// This is the raw selection; read [activePatientProvider] for the resolved
/// [Patient]. Held in memory for the session (PATIENT_RELATIONSHIP_MODEL §7);
/// it deliberately does not persist, so a fresh launch starts on the primary.
class SelectedPatientId extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String patientId) => state = patientId;

  /// Back to the primary patient (e.g. after the active family member is
  /// removed, or on a fresh context).
  void clear() => state = null;
}

final selectedPatientIdProvider =
    NotifierProvider<SelectedPatientId, String?>(SelectedPatientId.new);

/// The active Patient context — the patient every patient-scoped screen reads
/// from (PATIENT_RELATIONSHIP_MODEL §7). Resolves the selection against the
/// live [patientsProvider] list, so a stale id (a removed family member, or one
/// left over from a previous account) can never leak: it silently falls back to
/// the primary patient. Null only while the list is loading or empty.
final activePatientProvider = Provider<Patient?>((ref) {
  final patients = ref.watch(patientsProvider).valueOrNull;
  if (patients == null || patients.isEmpty) return null;
  final selectedId = ref.watch(selectedPatientIdProvider);
  if (selectedId != null) {
    for (final p in patients) {
      if (p.id == selectedId) return p;
    }
  }
  return primaryPatientOf(patients);
});
