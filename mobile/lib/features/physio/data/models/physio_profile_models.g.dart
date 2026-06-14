// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'physio_profile_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PhysioProfile _$PhysioProfileFromJson(Map<String, dynamic> json) =>
    _PhysioProfile(
      displayName: json['display_name'] as String?,
      qualification: json['qualification'] as String?,
      experienceYears: (json['experience_years'] as num?)?.toInt(),
      specialization: json['specialization'] as String?,
      bio: json['bio'] as String?,
      clinicName: json['clinic_name'] as String?,
      clinicAddress: json['clinic_address'] as String?,
      clinicContactPhone: json['clinic_contact_phone'] as String?,
      clinicDescription: json['clinic_description'] as String?,
      instagramUrl: json['instagram_url'] as String?,
      facebookUrl: json['facebook_url'] as String?,
      linkedinUrl: json['linkedin_url'] as String?,
      websiteUrl: json['website_url'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$PhysioProfileToJson(_PhysioProfile instance) =>
    <String, dynamic>{
      'display_name': ?instance.displayName,
      'qualification': ?instance.qualification,
      'experience_years': ?instance.experienceYears,
      'specialization': ?instance.specialization,
      'bio': ?instance.bio,
      'clinic_name': ?instance.clinicName,
      'clinic_address': ?instance.clinicAddress,
      'clinic_contact_phone': ?instance.clinicContactPhone,
      'clinic_description': ?instance.clinicDescription,
      'instagram_url': ?instance.instagramUrl,
      'facebook_url': ?instance.facebookUrl,
      'linkedin_url': ?instance.linkedinUrl,
      'website_url': ?instance.websiteUrl,
      'avatar_url': ?instance.avatarUrl,
    };

_UpdatePhysioProfileRequest _$UpdatePhysioProfileRequestFromJson(
  Map<String, dynamic> json,
) => _UpdatePhysioProfileRequest(
  displayName: json['display_name'] as String,
  qualification: json['qualification'] as String,
  experienceYears: (json['experience_years'] as num?)?.toInt(),
  specialization: json['specialization'] as String,
  bio: json['bio'] as String,
  clinicName: json['clinic_name'] as String,
  clinicAddress: json['clinic_address'] as String,
  clinicContactPhone: json['clinic_contact_phone'] as String,
  clinicDescription: json['clinic_description'] as String,
  instagramUrl: json['instagram_url'] as String,
  facebookUrl: json['facebook_url'] as String,
  linkedinUrl: json['linkedin_url'] as String,
  websiteUrl: json['website_url'] as String,
);

Map<String, dynamic> _$UpdatePhysioProfileRequestToJson(
  _UpdatePhysioProfileRequest instance,
) => <String, dynamic>{
  'display_name': instance.displayName,
  'qualification': instance.qualification,
  'experience_years': ?instance.experienceYears,
  'specialization': instance.specialization,
  'bio': instance.bio,
  'clinic_name': instance.clinicName,
  'clinic_address': instance.clinicAddress,
  'clinic_contact_phone': instance.clinicContactPhone,
  'clinic_description': instance.clinicDescription,
  'instagram_url': instance.instagramUrl,
  'facebook_url': instance.facebookUrl,
  'linkedin_url': instance.linkedinUrl,
  'website_url': instance.websiteUrl,
};

_AvatarPresign _$AvatarPresignFromJson(Map<String, dynamic> json) =>
    _AvatarPresign(
      objectKey: json['object_key'] as String,
      url: json['url'] as String,
      contentType: json['content_type'] as String,
      expiresInSeconds: (json['expires_in_seconds'] as num).toInt(),
    );

Map<String, dynamic> _$AvatarPresignToJson(_AvatarPresign instance) =>
    <String, dynamic>{
      'object_key': instance.objectKey,
      'url': instance.url,
      'content_type': instance.contentType,
      'expires_in_seconds': instance.expiresInSeconds,
    };
