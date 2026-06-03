import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/domain/patient_sex.dart';
import '../../../shared/network/json_converters.dart';

part 'patient_models.freezed.dart';
part 'patient_models.g.dart';

/// How a patient relates to the signed-in account. Wire values are the backend
/// enum names. `guardianOf` means the account is the legal guardian — the
/// patient is shown as a dependent.
enum PatientRelationship {
  @JsonValue('SELF')
  self,
  @JsonValue('SPOUSE')
  spouse,
  @JsonValue('PARENT')
  parent,
  @JsonValue('CHILD')
  child,
  @JsonValue('SIBLING')
  sibling,
  @JsonValue('GUARDIAN_OF')
  guardianOf,
  @JsonValue('OTHER')
  other,
}

extension PatientRelationshipLabel on PatientRelationship {
  String get label => switch (this) {
    PatientRelationship.self => 'Self',
    PatientRelationship.spouse => 'Spouse',
    PatientRelationship.parent => 'Parent',
    PatientRelationship.child => 'Child',
    PatientRelationship.sibling => 'Sibling',
    PatientRelationship.guardianOf => 'Dependent',
    PatientRelationship.other => 'Other',
  };
}

/// A patient linked to the account — either the primary patient ([primary] is
/// true, [relationship] is `self`) or a family member. Mirrors the backend
/// `PatientView`. Clinical fields ([allergies], [notes]) are PHI; never log them.
@freezed
abstract class Patient with _$Patient {
  const factory Patient({
    required String id,
    required String fullName,
    @LocalDateConverter() required DateTime dateOfBirth,
    PatientSex? sex,
    String? phoneE164,
    String? email,
    String? bloodGroup,
    String? allergies,
    String? notes,
    PatientRelationship? relationship,
    @Default(false) bool primary,
    @Default(false) bool canManage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Patient;

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);
}

@freezed
abstract class PatientListResponse with _$PatientListResponse {
  const factory PatientListResponse({required List<Patient> patients}) =
      _PatientListResponse;

  factory PatientListResponse.fromJson(Map<String, dynamic> json) =>
      _$PatientListResponseFromJson(json);
}
