import 'package:freezed_annotation/freezed_annotation.dart';

part 'fcm_token_models.freezed.dart';
part 'fcm_token_models.g.dart';

/// Body for `POST /auth/fcm_tokens`. The backend upserts idempotently on [token]
/// (rebinding it to the caller's account on re-login) and keys the device by
/// [deviceId]. Wire is snake_case (`device_id`) via the global `field_rename`.
@freezed
abstract class FcmTokenRegistration with _$FcmTokenRegistration {
  const factory FcmTokenRegistration({
    required String token,
    required String platform,
    String? deviceId,
  }) = _FcmTokenRegistration;

  factory FcmTokenRegistration.fromJson(Map<String, dynamic> json) =>
      _$FcmTokenRegistrationFromJson(json);
}
