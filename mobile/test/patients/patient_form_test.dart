import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/patients/data/models/patient_models.dart';
import 'package:healyn/features/patients/data/patients_api.dart';
import 'package:healyn/features/patients/data/patients_repository.dart';
import 'package:healyn/features/patients/presentation/screens/patient_form_screen.dart';

/// Records mutations and never completes them, so submit-path tests can assert
/// what was sent without the screen popping (it pops only after the future
/// resolves). Build/validation paths never touch these.
class _RecordingRepo extends PatientsRepository {
  _RecordingRepo() : super(PatientsApi(Dio()));

  bool createCalled = false;
  bool updateCalled = false;

  @override
  Future<Patient> create(CreateFamilyMemberRequest body) {
    createCalled = true;
    return Completer<Patient>().future;
  }

  @override
  Future<Patient> update(String id, UpdatePatientRequest body) {
    updateCalled = true;
    return Completer<Patient>().future;
  }
}

final _kiran = Patient(
  id: 'p2',
  fullName: 'Kiran Rao',
  dateOfBirth: DateTime(2015, 3, 10),
  relationship: PatientRelationship.child,
);
final _asha = Patient(
  id: 'p1',
  fullName: 'Asha Rao',
  dateOfBirth: DateTime(1990, 5, 21),
  relationship: PatientRelationship.self,
  primary: true,
);

Future<void> _pump(WidgetTester tester, Widget screen, _RecordingRepo repo) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [patientsRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(home: screen),
    ),
  );
}

void main() {
  testWidgets('create form blocks submit and shows errors when empty', (
    tester,
  ) async {
    final repo = _RecordingRepo();
    await _pump(tester, const PatientFormScreen.create(), repo);

    final submit = find.widgetWithText(ElevatedButton, 'Add family member');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();

    expect(find.text('Enter a full name'), findsOneWidget);
    expect(find.text('Choose a relationship'), findsOneWidget);
    expect(repo.createCalled, isFalse);
  });

  testWidgets('edit form prefills and offers Remove for a family member', (
    tester,
  ) async {
    final repo = _RecordingRepo();
    await _pump(tester, PatientFormScreen.edit(patient: _kiran), repo);

    expect(find.text('Edit family member'), findsOneWidget);
    expect(find.text('Kiran Rao'), findsOneWidget); // prefilled name
    expect(find.text('Save changes'), findsOneWidget);
    expect(find.text('Remove family member'), findsOneWidget);
  });

  testWidgets('edit form hides Remove for the primary patient', (tester) async {
    final repo = _RecordingRepo();
    await _pump(tester, PatientFormScreen.edit(patient: _asha), repo);

    expect(find.text('Edit profile'), findsOneWidget);
    expect(find.text('Remove family member'), findsNothing);
  });
}
