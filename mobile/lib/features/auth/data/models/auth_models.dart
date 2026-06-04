import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/domain/patient_sex.dart';
import '../../../shared/network/json_converters.dart';

// PatientSex and LocalDateConverter moved to shared/ (also used by the patients
// feature). Re-exported so existing `import auth_models.dart` consumers are
// unaffected.
export '../../../shared/domain/patient_sex.dart';
export '../../../shared/network/json_converters.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

/// Exactly one of [email] / [phone] is set (the backend enforces the xor).
@freezed
abstract class ContactTarget with _$ContactTarget {
  const factory ContactTarget({String? email, String? phone}) = _ContactTarget;

  factory ContactTarget.fromJson(Map<String, dynamic> json) =>
      _$ContactTargetFromJson(json);
}

@freezed
abstract class DeviceRequest with _$DeviceRequest {
  const factory DeviceRequest({
    required String deviceId,
    String? deviceLabel,
    String? fcmToken,
  }) = _DeviceRequest;

  factory DeviceRequest.fromJson(Map<String, dynamic> json) =>
      _$DeviceRequestFromJson(json);
}

@freezed
abstract class PrimaryPatientProfile with _$PrimaryPatientProfile {
  const factory PrimaryPatientProfile({
    required String fullName,
    @LocalDateConverter() required DateTime dateOfBirth,
    PatientSex? sex,
  }) = _PrimaryPatientProfile;

  factory PrimaryPatientProfile.fromJson(Map<String, dynamic> json) =>
      _$PrimaryPatientProfileFromJson(json);
}

@freezed
abstract class RegisterStartRequest with _$RegisterStartRequest {
  const factory RegisterStartRequest({required ContactTarget target}) =
      _RegisterStartRequest;

  factory RegisterStartRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterStartRequestFromJson(json);
}

@freezed
abstract class RegisterCompleteRequest with _$RegisterCompleteRequest {
  const factory RegisterCompleteRequest({
    required String challengeId,
    required String code,
    required String password,
    required DeviceRequest device,
    required PrimaryPatientProfile profile,
  }) = _RegisterCompleteRequest;

  factory RegisterCompleteRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterCompleteRequestFromJson(json);
}

@freezed
abstract class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String emailOrPhone,
    required String password,
    required DeviceRequest device,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

@freezed
abstract class ChallengeResponse with _$ChallengeResponse {
  const factory ChallengeResponse({required String challengeId}) =
      _ChallengeResponse;

  factory ChallengeResponse.fromJson(Map<String, dynamic> json) =>
      _$ChallengeResponseFromJson(json);
}

@freezed
abstract class TokenResponse with _$TokenResponse {
  const factory TokenResponse({
    required String sessionId,
    required String accessToken,
    required DateTime accessTokenExpiresAt,
    required String refreshToken,
    required DateTime refreshTokenExpiresAt,
  }) = _TokenResponse;

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);
}

@freezed
abstract class SessionView with _$SessionView {
  const factory SessionView({
    required String id,
    required String deviceId,
    String? deviceLabel,
    required DateTime issuedAt,
    required DateTime lastSeenAt,
    required DateTime expiresAt,
  }) = _SessionView;

  factory SessionView.fromJson(Map<String, dynamic> json) =>
      _$SessionViewFromJson(json);
}

@freezed
abstract class SessionListResponse with _$SessionListResponse {
  const factory SessionListResponse({required List<SessionView> sessions}) =
      _SessionListResponse;

  factory SessionListResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionListResponseFromJson(json);
}
