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
///
/// [patientNumber] is the human-friendly business id (e.g. `PAT-100001`) shown to
/// users; [id] is the technical UUID and is never displayed. Optional only for
/// resilience to older cached payloads — the backend always sends it.
@freezed
abstract class Patient with _$Patient {
  const factory Patient({
    required String id,
    String? patientNumber,
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

/// Body for `POST /patients` — adds a family member the account manages.
/// [relationship] is required and must not be `self`. Mirrors the backend
/// `CreateFamilyMemberRequest`.
@freezed
abstract class CreateFamilyMemberRequest with _$CreateFamilyMemberRequest {
  const factory CreateFamilyMemberRequest({
    required String fullName,
    @LocalDateConverter() required DateTime dateOfBirth,
    required PatientRelationship relationship,
    PatientSex? sex,
    String? phoneE164,
    String? email,
    String? bloodGroup,
    String? allergies,
    String? notes,
  }) = _CreateFamilyMemberRequest;

  factory CreateFamilyMemberRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateFamilyMemberRequestFromJson(json);
}

/// Body for `PATCH /patients/{id}`. The backend leaves a field unchanged when
/// it is absent and clears it when sent blank, so the form sends every editable
/// field explicitly (empty string clears it). [relationship] is not editable.
@freezed
abstract class UpdatePatientRequest with _$UpdatePatientRequest {
  const factory UpdatePatientRequest({
    required String fullName,
    @LocalDateConverter() required DateTime dateOfBirth,
    PatientSex? sex,
    required String phoneE164,
    required String email,
    required String bloodGroup,
    required String allergies,
    required String notes,
  }) = _UpdatePatientRequest;

  factory UpdatePatientRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePatientRequestFromJson(json);
}
