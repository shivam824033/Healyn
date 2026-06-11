import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:healyn/features/patients/data/models/patient_models.dart';
import 'package:healyn/features/physio/presentation/widgets/patient_avatar_button.dart';

final _asha = Patient(
  id: 'pt1',
  fullName: 'Asha Rao',
  dateOfBirth: DateTime(1990, 5, 21),
  relationship: PatientRelationship.self,
  primary: true,
);

/// A router that renders the button at `/` and a marker at the patient detail,
/// so a tap can be asserted to have navigated there.
GoRouter _router(Widget home) => GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, _) => Scaffold(body: Center(child: home))),
    GoRoute(
      path: '/physio/patients/:id',
      builder: (_, state) =>
          Scaffold(body: Text('detail ${state.pathParameters['id']}')),
    ),
  ],
);

void main() {
  testWidgets('shows the patient monogram from the name', (tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: _router(
          const PatientAvatarButton(patientId: 'pt1', name: 'Asha Rao'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('AR'), findsOneWidget);
  });

  testWidgets('tapping the monogram opens that patient\'s detail', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: _router(
          PatientAvatarButton(patientId: 'pt1', name: 'Asha Rao', patient: _asha),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('AR'));
    await tester.pumpAndSettle();

    expect(find.text('detail pt1'), findsOneWidget);
  });

  testWidgets('falls back to a placeholder monogram and still routes by id when '
      'the patient is unresolved', (tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: _router(
          const PatientAvatarButton(patientId: 'pt9', name: null),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('?'), findsOneWidget);

    await tester.tap(find.text('?'));
    await tester.pumpAndSettle();

    expect(find.text('detail pt9'), findsOneWidget);
  });
}
