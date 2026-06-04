// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_token_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FcmTokenRegistration _$FcmTokenRegistrationFromJson(
  Map<String, dynamic> json,
) => _FcmTokenRegistration(
  token: json['token'] as String,
  platform: json['platform'] as String,
  deviceId: json['device_id'] as String?,
);

Map<String, dynamic> _$FcmTokenRegistrationToJson(
  _FcmTokenRegistration instance,
) => <String, dynamic>{
  'token': instance.token,
  'platform': instance.platform,
  'device_id': ?instance.deviceId,
};
