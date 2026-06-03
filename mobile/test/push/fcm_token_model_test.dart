import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/shared/push/fcm_token_models.dart';

void main() {
  test('FcmTokenRegistration serializes to snake_case', () {
    final json = const FcmTokenRegistration(
      token: 'tok-1',
      platform: 'android',
      deviceId: 'dev-1',
    ).toJson();

    expect(json['token'], 'tok-1');
    expect(json['platform'], 'android');
    // device_id matches the backend's snake_case wire (record component deviceId).
    expect(json['device_id'], 'dev-1');
  });

  test('FcmTokenRegistration omits a null deviceId', () {
    final json = const FcmTokenRegistration(
      token: 'tok-1',
      platform: 'ios',
    ).toJson();
    // include_if_null:false — an unset deviceId is absent, not null.
    expect(json.containsKey('device_id'), isFalse);
  });
}
