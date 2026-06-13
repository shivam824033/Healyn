import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../patients/data/models/patient_models.dart';
import '../../../patients/presentation/widgets/patient_avatar.dart';

/// A tappable patient monogram that jumps the physiotherapist straight to the
/// patient's detail (profile + treatment history) — the quick patient access on
/// every appointment card and the appointment detail. It is its own tap target,
/// so it works nested inside a card whose body opens the *appointment*.
///
/// Pass the resolved [patient] when known so navigation hands it over as `extra`
/// (no refetch); otherwise it routes by [patientId] and the destination resolves
/// the patient from the roster. [name] drives the initials and the a11y label.
class PatientAvatarButton extends StatelessWidget {
  const PatientAvatarButton({
    required this.patientId,
    required this.name,
    this.patient,
    this.radius = 22,
    super.key,
  });

  final String patientId;
  final String? name;
  final Patient? patient;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final display = (name == null || name!.trim().isEmpty) ? 'patient' : name!;
    return Semantics(
      button: true,
      label: 'View $display',
      child: Material(
        type: MaterialType.transparency,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () =>
              context.push('/physio/patients/$patientId', extra: patient),
          child: PatientAvatar(name: name ?? '', radius: radius),
        ),
      ),
    );
  }
}
