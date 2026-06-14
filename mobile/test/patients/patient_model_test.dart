import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/patients/data/models/patient_models.dart';
import 'package:healyn/features/shared/domain/patient_sex.dart';

void main() {
  test('parses a patient list from snake_case JSON', () {
    final json = <String, dynamic>{
      'patients': [
        {
          'id': 'a1',
          'full_name': 'Asha Rao',
          'date_of_birth': '1990-05-21',
          'sex': 'FEMALE',
          'phone_e164': '+14155550123',
          'email': 'asha@example.com',
          'blood_group': 'O+',
          'allergies': 'Penicillin',
          'relationship': 'SELF',
          'primary': true,
          'can_manage': true,
          'created_at': '2026-01-01T10:00:00Z',
          'updated_at': '2026-01-02T10:00:00Z',
        },
        {
          'id': 'a2',
          'full_name': 'Kiran Rao',
          'date_of_birth': '2015-03-10',
          'relationship': 'CHILD',
          'primary': false,
          'can_manage': true,
        },
      ],
    };

    final res = PatientListResponse.fromJson(json);
    expect(res.patients, hasLength(2));

    final primary = res.patients.first;
    expect(primary.fullName, 'Asha Rao');
    expect(primary.sex, PatientSex.female);
    expect(primary.dateOfBirth, DateTime(1990, 5, 21));
    expect(primary.relationship, PatientRelationship.self);
    expect(primary.primary, isTrue);
    expect(primary.bloodGroup, 'O+');

    final child = res.patients[1];
    expect(child.sex, isNull);
    expect(child.relationship, PatientRelationship.child);
    expect(child.primary, isFalse);
    expect(child.bloodGroup, isNull);
  });

  test('CreateFamilyMemberRequest serializes to snake_case and omits nulls', () {
    final json = CreateFamilyMemberRequest(
      fullName: 'Kiran Rao',
      dateOfBirth: DateTime(2015, 3, 10),
      relationship: PatientRelationship.child,
      authorityAttested: true,
      sex: PatientSex.male,
      phoneE164: '+14155550123',
    ).toJson();

    expect(json['full_name'], 'Kiran Rao');
    expect(json['date_of_birth'], '2015-03-10');
    expect(json['relationship'], 'CHILD');
    expect(json['authority_attested'], true);
    expect(json['sex'], 'MALE');
    expect(json['phone_e164'], '+14155550123');
    // include_if_null:false — unset optional fields are absent, not null.
    expect(json.containsKey('email'), isFalse);
    expect(json.containsKey('allergies'), isFalse);
  });

  test('UpdatePatientRequest sends blanks to clear and drops null sex', () {
    final json = UpdatePatientRequest(
      fullName: 'Asha Rao',
      dateOfBirth: DateTime(1990, 5, 21),
      sex: null,
      phoneE164: '+14155550123',
      email: '',
      bloodGroup: 'O+',
      allergies: '',
      notes: '',
    ).toJson();

    expect(json['full_name'], 'Asha Rao');
    expect(json['date_of_birth'], '1990-05-21');
    expect(json['phone_e164'], '+14155550123');
    expect(json['blood_group'], 'O+');
    // Blank strings are sent (the backend treats blank as "clear this field").
    expect(json['email'], '');
    expect(json['allergies'], '');
    expect(json['notes'], '');
    // Null sex is omitted (the backend leaves it unchanged).
    expect(json.containsKey('sex'), isFalse);
  });
}
