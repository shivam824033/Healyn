// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Patient _$PatientFromJson(Map<String, dynamic> json) => _Patient(
  id: json['id'] as String,
  patientNumber: json['patient_number'] as String?,
  fullName: json['full_name'] as String,
  dateOfBirth: const LocalDateConverter().fromJson(
    json['date_of_birth'] as String,
  ),
  sex: $enumDecodeNullable(_$PatientSexEnumMap, json['sex']),
  phoneE164: json['phone_e164'] as String?,
  email: json['email'] as String?,
  bloodGroup: json['blood_group'] as String?,
  allergies: json['allergies'] as String?,
  notes: json['notes'] as String?,
  relationship: $enumDecodeNullable(
    _$PatientRelationshipEnumMap,
    json['relationship'],
  ),
  primary: json['primary'] as bool? ?? false,
  canManage: json['can_manage'] as bool? ?? false,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$PatientToJson(_Patient instance) => <String, dynamic>{
  'id': instance.id,
  'patient_number': ?instance.patientNumber,
  'full_name': instance.fullName,
  'date_of_birth': const LocalDateConverter().toJson(instance.dateOfBirth),
  'sex': ?_$PatientSexEnumMap[instance.sex],
  'phone_e164': ?instance.phoneE164,
  'email': ?instance.email,
  'blood_group': ?instance.bloodGroup,
  'allergies': ?instance.allergies,
  'notes': ?instance.notes,
  'relationship': ?_$PatientRelationshipEnumMap[instance.relationship],
  'primary': instance.primary,
  'can_manage': instance.canManage,
  'created_at': ?instance.createdAt?.toIso8601String(),
  'updated_at': ?instance.updatedAt?.toIso8601String(),
};

const _$PatientSexEnumMap = {
  PatientSex.male: 'MALE',
  PatientSex.female: 'FEMALE',
  PatientSex.other: 'OTHER',
  PatientSex.undisclosed: 'UNDISCLOSED',
};

const _$PatientRelationshipEnumMap = {
  PatientRelationship.self: 'SELF',
  PatientRelationship.spouse: 'SPOUSE',
  PatientRelationship.parent: 'PARENT',
  PatientRelationship.child: 'CHILD',
  PatientRelationship.sibling: 'SIBLING',
  PatientRelationship.guardianOf: 'GUARDIAN_OF',
  PatientRelationship.other: 'OTHER',
};

_PatientListResponse _$PatientListResponseFromJson(Map<String, dynamic> json) =>
    _PatientListResponse(
      patients: (json['patients'] as List<dynamic>)
          .map((e) => Patient.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PatientListResponseToJson(
  _PatientListResponse instance,
) => <String, dynamic>{
  'patients': instance.patients.map((e) => e.toJson()).toList(),
};

_CreateFamilyMemberRequest _$CreateFamilyMemberRequestFromJson(
  Map<String, dynamic> json,
) => _CreateFamilyMemberRequest(
  fullName: json['full_name'] as String,
  dateOfBirth: const LocalDateConverter().fromJson(
    json['date_of_birth'] as String,
  ),
  relationship: $enumDecode(_$PatientRelationshipEnumMap, json['relationship']),
  sex: $enumDecodeNullable(_$PatientSexEnumMap, json['sex']),
  phoneE164: json['phone_e164'] as String?,
  email: json['email'] as String?,
  bloodGroup: json['blood_group'] as String?,
  allergies: json['allergies'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$CreateFamilyMemberRequestToJson(
  _CreateFamilyMemberRequest instance,
) => <String, dynamic>{
  'full_name': instance.fullName,
  'date_of_birth': const LocalDateConverter().toJson(instance.dateOfBirth),
  'relationship': _$PatientRelationshipEnumMap[instance.relationship]!,
  'sex': ?_$PatientSexEnumMap[instance.sex],
  'phone_e164': ?instance.phoneE164,
  'email': ?instance.email,
  'blood_group': ?instance.bloodGroup,
  'allergies': ?instance.allergies,
  'notes': ?instance.notes,
};

_UpdatePatientRequest _$UpdatePatientRequestFromJson(
  Map<String, dynamic> json,
) => _UpdatePatientRequest(
  fullName: json['full_name'] as String,
  dateOfBirth: const LocalDateConverter().fromJson(
    json['date_of_birth'] as String,
  ),
  sex: $enumDecodeNullable(_$PatientSexEnumMap, json['sex']),
  phoneE164: json['phone_e164'] as String,
  email: json['email'] as String,
  bloodGroup: json['blood_group'] as String,
  allergies: json['allergies'] as String,
  notes: json['notes'] as String,
);

Map<String, dynamic> _$UpdatePatientRequestToJson(
  _UpdatePatientRequest instance,
) => <String, dynamic>{
  'full_name': instance.fullName,
  'date_of_birth': const LocalDateConverter().toJson(instance.dateOfBirth),
  'sex': ?_$PatientSexEnumMap[instance.sex],
  'phone_e164': instance.phoneE164,
  'email': instance.email,
  'blood_group': instance.bloodGroup,
  'allergies': instance.allergies,
  'notes': instance.notes,
};
