import 'package:freezed_annotation/freezed_annotation.dart';

/// Biological sex on a patient profile. Wire values are the backend enum names
/// (MALE/FEMALE/OTHER/UNDISCLOSED), mapped here to idiomatic Dart names.
///
/// Shared between the auth (registration) and patients features, so it lives in
/// `shared/domain` rather than in either feature.
enum PatientSex {
  @JsonValue('MALE')
  male,
  @JsonValue('FEMALE')
  female,
  @JsonValue('OTHER')
  other,
  @JsonValue('UNDISCLOSED')
  undisclosed,
}

extension PatientSexLabel on PatientSex {
  String get label => switch (this) {
    PatientSex.male => 'Male',
    PatientSex.female => 'Female',
    PatientSex.other => 'Other',
    PatientSex.undisclosed => 'Prefer not to say',
  };
}
