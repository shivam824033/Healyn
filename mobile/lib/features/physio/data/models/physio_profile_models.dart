import 'package:freezed_annotation/freezed_annotation.dart';

part 'physio_profile_models.freezed.dart';
part 'physio_profile_models.g.dart';

/// The single physiotherapist's public profile (the backend `ProfileView`). Read
/// by patients to learn who their physiotherapist is and how to reach the clinic;
/// edited by the physiotherapist. Every field is optional — the profile fills in
/// progressively. [avatarUrl] is a short-lived presigned URL; never persist it.
@freezed
abstract class PhysioProfile with _$PhysioProfile {
  const PhysioProfile._();

  const factory PhysioProfile({
    String? displayName,
    String? qualification,
    int? experienceYears,
    String? specialization,
    String? bio,
    String? clinicName,
    String? clinicAddress,
    String? clinicContactPhone,
    String? clinicDescription,
    String? instagramUrl,
    String? facebookUrl,
    String? linkedinUrl,
    String? websiteUrl,
    String? avatarUrl,
  }) = _PhysioProfile;

  factory PhysioProfile.fromJson(Map<String, dynamic> json) =>
      _$PhysioProfileFromJson(json);

  bool _has(String? s) => s != null && s.trim().isNotEmpty;

  /// Whether the physiotherapist has filled in any personal/professional detail.
  bool get hasPhysioDetails =>
      _has(displayName) ||
      _has(qualification) ||
      experienceYears != null ||
      _has(specialization) ||
      _has(bio) ||
      _has(avatarUrl);

  /// Whether any clinic detail is set.
  bool get hasClinicDetails =>
      _has(clinicName) ||
      _has(clinicAddress) ||
      _has(clinicContactPhone) ||
      _has(clinicDescription);

  /// Whether any social/website link is set.
  bool get hasSocialLinks =>
      _has(instagramUrl) ||
      _has(facebookUrl) ||
      _has(linkedinUrl) ||
      _has(websiteUrl);

  /// True when nothing at all is set — the patient home hides the whole section.
  bool get isEmpty =>
      !hasPhysioDetails && !hasClinicDetails && !hasSocialLinks;
}

/// Body for `PATCH /physio/profile`. The backend leaves a null field unchanged and
/// clears a blank one, so the editor sends every field explicitly (empty string
/// clears it); [experienceYears] is sent as a number or null.
@freezed
abstract class UpdatePhysioProfileRequest with _$UpdatePhysioProfileRequest {
  const factory UpdatePhysioProfileRequest({
    required String displayName,
    required String qualification,
    int? experienceYears,
    required String specialization,
    required String bio,
    required String clinicName,
    required String clinicAddress,
    required String clinicContactPhone,
    required String clinicDescription,
    required String instagramUrl,
    required String facebookUrl,
    required String linkedinUrl,
    required String websiteUrl,
  }) = _UpdatePhysioProfileRequest;

  factory UpdatePhysioProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePhysioProfileRequestFromJson(json);
}

/// The presigned-PUT instruction for an avatar upload (`POST .../avatar/presign`).
@freezed
abstract class AvatarPresign with _$AvatarPresign {
  const factory AvatarPresign({
    required String objectKey,
    required String url,
    required String contentType,
    required int expiresInSeconds,
  }) = _AvatarPresign;

  factory AvatarPresign.fromJson(Map<String, dynamic> json) =>
      _$AvatarPresignFromJson(json);
}
