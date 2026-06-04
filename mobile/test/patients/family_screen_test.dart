import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/patients/data/models/patient_models.dart';
import 'package:healyn/features/patients/presentation/patients_providers.dart';
import 'package:healyn/features/patients/presentation/screens/family_screen.dart';

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

Future<void> _pump(WidgetTester tester, List<Patient> patients) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [patientsProvider.overrideWith((ref) async => patients)],
      child: const MaterialApp(home: FamilyScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('lists family members and excludes the primary patient', (
    tester,
  ) async {
    await _pump(tester, [_asha, _kiran]);

    expect(find.text('Kiran Rao'), findsOneWidget);
    expect(find.text('Asha Rao'), findsNothing);
  });

  testWidgets('shows an empty state when there are no family members', (
    tester,
  ) async {
    await _pump(tester, [_asha]);

    expect(find.text('No family members yet'), findsOneWidget);
  });
}
