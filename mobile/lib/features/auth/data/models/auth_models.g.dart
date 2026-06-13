// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContactTarget _$ContactTargetFromJson(Map<String, dynamic> json) =>
    _ContactTarget(
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$ContactTargetToJson(_ContactTarget instance) =>
    <String, dynamic>{'email': ?instance.email, 'phone': ?instance.phone};

_DeviceRequest _$DeviceRequestFromJson(Map<String, dynamic> json) =>
    _DeviceRequest(
      deviceId: json['device_id'] as String,
      deviceLabel: json['device_label'] as String?,
      fcmToken: json['fcm_token'] as String?,
    );

Map<String, dynamic> _$DeviceRequestToJson(_DeviceRequest instance) =>
    <String, dynamic>{
      'device_id': instance.deviceId,
      'device_label': ?instance.deviceLabel,
      'fcm_token': ?instance.fcmToken,
    };

_PrimaryPatientProfile _$PrimaryPatientProfileFromJson(
  Map<String, dynamic> json,
) => _PrimaryPatientProfile(
  fullName: json['full_name'] as String,
  dateOfBirth: const LocalDateConverter().fromJson(
    json['date_of_birth'] as String,
  ),
  sex: $enumDecodeNullable(_$PatientSexEnumMap, json['sex']),
);

Map<String, dynamic> _$PrimaryPatientProfileToJson(
  _PrimaryPatientProfile instance,
) => <String, dynamic>{
  'full_name': instance.fullName,
  'date_of_birth': const LocalDateConverter().toJson(instance.dateOfBirth),
  'sex': ?_$PatientSexEnumMap[instance.sex],
};

const _$PatientSexEnumMap = {
  PatientSex.male: 'MALE',
  PatientSex.female: 'FEMALE',
  PatientSex.other: 'OTHER',
  PatientSex.undisclosed: 'UNDISCLOSED',
};

_RegisterStartRequest _$RegisterStartRequestFromJson(
  Map<String, dynamic> json,
) => _RegisterStartRequest(
  target: ContactTarget.fromJson(json['target'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RegisterStartRequestToJson(
  _RegisterStartRequest instance,
) => <String, dynamic>{'target': instance.target.toJson()};

_RegisterCompleteRequest _$RegisterCompleteRequestFromJson(
  Map<String, dynamic> json,
) => _RegisterCompleteRequest(
  challengeId: json['challenge_id'] as String,
  code: json['code'] as String,
  password: json['password'] as String,
  device: DeviceRequest.fromJson(json['device'] as Map<String, dynamic>),
  profile: PrimaryPatientProfile.fromJson(
    json['profile'] as Map<String, dynamic>,
  ),
  address: Address.fromJson(json['address'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RegisterCompleteRequestToJson(
  _RegisterCompleteRequest instance,
) => <String, dynamic>{
  'challenge_id': instance.challengeId,
  'code': instance.code,
  'password': instance.password,
  'device': instance.device.toJson(),
  'profile': instance.profile.toJson(),
  'address': instance.address.toJson(),
};

_PasswordResetStartRequest _$PasswordResetStartRequestFromJson(
  Map<String, dynamic> json,
) => _PasswordResetStartRequest(
  target: ContactTarget.fromJson(json['target'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PasswordResetStartRequestToJson(
  _PasswordResetStartRequest instance,
) => <String, dynamic>{'target': instance.target.toJson()};

_PasswordResetCompleteRequest _$PasswordResetCompleteRequestFromJson(
  Map<String, dynamic> json,
) => _PasswordResetCompleteRequest(
  challengeId: json['challenge_id'] as String,
  code: json['code'] as String,
  newPassword: json['new_password'] as String,
);

Map<String, dynamic> _$PasswordResetCompleteRequestToJson(
  _PasswordResetCompleteRequest instance,
) => <String, dynamic>{
  'challenge_id': instance.challengeId,
  'code': instance.code,
  'new_password': instance.newPassword,
};

_LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) =>
    _LoginRequest(
      emailOrPhone: json['email_or_phone'] as String,
      password: json['password'] as String,
      device: DeviceRequest.fromJson(json['device'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginRequestToJson(_LoginRequest instance) =>
    <String, dynamic>{
      'email_or_phone': instance.emailOrPhone,
      'password': instance.password,
      'device': instance.device.toJson(),
    };

_ChallengeResponse _$ChallengeResponseFromJson(Map<String, dynamic> json) =>
    _ChallengeResponse(challengeId: json['challenge_id'] as String);

Map<String, dynamic> _$ChallengeResponseToJson(_ChallengeResponse instance) =>
    <String, dynamic>{'challenge_id': instance.challengeId};

_TokenResponse _$TokenResponseFromJson(Map<String, dynamic> json) =>
    _TokenResponse(
      sessionId: json['session_id'] as String,
      accessToken: json['access_token'] as String,
      accessTokenExpiresAt: DateTime.parse(
        json['access_token_expires_at'] as String,
      ),
      refreshToken: json['refresh_token'] as String,
      refreshTokenExpiresAt: DateTime.parse(
        json['refresh_token_expires_at'] as String,
      ),
    );

Map<String, dynamic> _$TokenResponseToJson(
  _TokenResponse instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'access_token': instance.accessToken,
  'access_token_expires_at': instance.accessTokenExpiresAt.toIso8601String(),
  'refresh_token': instance.refreshToken,
  'refresh_token_expires_at': instance.refreshTokenExpiresAt.toIso8601String(),
};

_SessionView _$SessionViewFromJson(Map<String, dynamic> json) => _SessionView(
  id: json['id'] as String,
  deviceId: json['device_id'] as String,
  deviceLabel: json['device_label'] as String?,
  issuedAt: DateTime.parse(json['issued_at'] as String),
  lastSeenAt: DateTime.parse(json['last_seen_at'] as String),
  expiresAt: DateTime.parse(json['expires_at'] as String),
);

Map<String, dynamic> _$SessionViewToJson(_SessionView instance) =>
    <String, dynamic>{
      'id': instance.id,
      'device_id': instance.deviceId,
      'device_label': ?instance.deviceLabel,
      'issued_at': instance.issuedAt.toIso8601String(),
      'last_seen_at': instance.lastSeenAt.toIso8601String(),
      'expires_at': instance.expiresAt.toIso8601String(),
    };

_SessionListResponse _$SessionListResponseFromJson(Map<String, dynamic> json) =>
    _SessionListResponse(
      sessions: (json['sessions'] as List<dynamic>)
          .map((e) => SessionView.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SessionListResponseToJson(
  _SessionListResponse instance,
) => <String, dynamic>{
  'sessions': instance.sessions.map((e) => e.toJson()).toList(),
};
