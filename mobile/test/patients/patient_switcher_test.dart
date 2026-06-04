import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/patients/data/models/patient_models.dart';
import 'package:healyn/features/patients/presentation/patients_providers.dart';
import 'package:healyn/features/patients/presentation/widgets/patient_switcher.dart';

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
      child: const MaterialApp(
        home: Scaffold(body: PatientSwitcher()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the primary patient as the active context', (
    tester,
  ) async {
    await _pump(tester, [_asha, _kiran]);

    expect(find.text('ACTIVE PATIENT'), findsOneWidget);
    expect(find.text('Asha Rao'), findsOneWidget);
  });

  testWidgets('switching the patient updates the active context', (
    tester,
  ) async {
    await _pump(tester, [_asha, _kiran]);

    await tester.tap(find.text('Asha Rao')); // open the sheet
    await tester.pumpAndSettle();
    expect(find.text('Switch patient'), findsOneWidget);

    await tester.tap(find.text('Kiran Rao')); // pick the family member
    await tester.pumpAndSettle();

    // Sheet closed; the header now reflects the switched context.
    expect(find.text('Switch patient'), findsNothing);
    expect(find.text('Kiran Rao'), findsOneWidget);
    expect(find.text('Asha Rao'), findsNothing);
  });

  testWidgets('does not offer switching with a single patient', (tester) async {
    await _pump(tester, [_asha]);

    expect(find.byIcon(Icons.unfold_more), findsNothing);

    await tester.tap(find.text('Asha Rao'));
    await tester.pumpAndSettle();
    expect(find.text('Switch patient'), findsNothing);
  });
}
