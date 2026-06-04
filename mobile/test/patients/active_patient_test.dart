import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/patients/data/models/patient_models.dart';
import 'package:healyn/features/patients/presentation/active_patient_provider.dart';
import 'package:healyn/features/patients/presentation/patients_providers.dart';

final _asha = Patient(
  id: 'p1',
  fullName: 'Asha Rao',
  dateOfBirth: DateTime(1990, 5, 21),
  relationship: PatientRelationship.self,
  primary: true,
);
final _kiran = Patient(
  id: 'p2',
  fullName: 'Kiran Rao',
  dateOfBirth: DateTime(2015, 3, 10),
  relationship: PatientRelationship.child,
);

Future<ProviderContainer> _container(List<Patient> patients) async {
  final c = ProviderContainer(
    overrides: [patientsProvider.overrideWith((ref) async => patients)],
  );
  addTearDown(c.dispose);
  await c.read(patientsProvider.future);
  return c;
}

void main() {
  test('defaults to the primary patient', () async {
    final c = await _container([_asha, _kiran]);
    expect(c.read(activePatientProvider)?.id, 'p1');
  });

  test('selecting switches the active patient', () async {
    final c = await _container([_asha, _kiran]);
    c.read(selectedPatientIdProvider.notifier).select('p2');
    expect(c.read(activePatientProvider)?.id, 'p2');
  });

  test('clearing returns to the primary patient', () async {
    final c = await _container([_asha, _kiran]);
    c.read(selectedPatientIdProvider.notifier).select('p2');
    c.read(selectedPatientIdProvider.notifier).clear();
    expect(c.read(activePatientProvider)?.id, 'p1');
  });

  test('a stale selection falls back to the primary patient', () async {
    final c = await _container([_asha, _kiran]);
    c.read(selectedPatientIdProvider.notifier).select('ghost');
    expect(c.read(activePatientProvider)?.id, 'p1');
  });

  test('is null while there are no patients', () async {
    final c = await _container([]);
    expect(c.read(activePatientProvider), isNull);
  });
}
