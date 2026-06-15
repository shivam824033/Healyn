import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/shared/push/fcm_messaging.dart';
import 'package:healyn/features/shared/push/fcm_token_api.dart';
import 'package:healyn/features/shared/push/fcm_token_models.dart';
import 'package:healyn/features/shared/push/push_service.dart';
import 'package:healyn/features/shared/storage/device_identity.dart';

/// In-memory [FcmMessaging] so the service logic is exercised without the
/// Firebase plugin or platform channels.
class _FakeMessaging implements FcmMessaging {
  _FakeMessaging({
    this.configured = true,
    this.permitted = true,
    this.token = 'tok-1',
    this.initialMessage,
  });

  bool configured;
  bool permitted;
  String? token;
  final Map<String, String>? initialMessage;
  bool deleted = false;

  final _refresh = StreamController<String>.broadcast();
  final _opened = StreamController<Map<String, String>>.broadcast();

  void emitRefresh(String t) => _refresh.add(t);
  void emitOpened(Map<String, String> data) => _opened.add(data);

  @override
  Future<bool> ensureInitialized() async => configured;

  @override
  Future<bool> requestPermission() async => permitted;

  @override
  Future<String?> getToken() async => token;

  @override
  Stream<String> get onTokenRefresh => _refresh.stream;

  @override
  Future<void> deleteToken() async => deleted = true;

  // No test drives a foreground message; an empty stream satisfies the seam.
  @override
  Stream<Map<String, String>> get onMessage => const Stream.empty();

  @override
  Stream<Map<String, String>> get onMessageOpenedApp => _opened.stream;

  @override
  Future<Map<String, String>?> getInitialMessage() async => initialMessage;
}

class _RecordingTokenApi extends FcmTokenApi {
  _RecordingTokenApi() : super(Dio());
  final List<FcmTokenRegistration> calls = [];
  final List<String> unregistered = [];

  @override
  Future<void> register(FcmTokenRegistration body) async => calls.add(body);

  @override
  Future<void> unregister(String deviceId) async => unregistered.add(deviceId);
}

class _ThrowingTokenApi extends FcmTokenApi {
  _ThrowingTokenApi() : super(Dio());
  @override
  Future<void> unregister(String deviceId) async =>
      throw DioException(requestOptions: RequestOptions(path: '/auth/fcm_tokens'));
}

class _FakeDeviceIdentity extends DeviceIdentity {
  _FakeDeviceIdentity() : super(const FlutterSecureStorage());
  @override
  Future<String> getOrCreate() async => 'device-1';
}

PushService _service(_FakeMessaging messaging, FcmTokenApi api) =>
    PushService(messaging, api, _FakeDeviceIdentity(), 'android');

void main() {
  test('register posts the current token and re-registers on refresh', () async {
    final messaging = _FakeMessaging(token: 'tok-1');
    final api = _RecordingTokenApi();
    await _service(messaging, api).register();

    expect(api.calls, hasLength(1));
    expect(api.calls.single.token, 'tok-1');
    expect(api.calls.single.platform, 'android');
    expect(api.calls.single.deviceId, 'device-1');

    messaging.emitRefresh('tok-2');
    await Future<void>.delayed(const Duration(milliseconds: 1));
    expect(api.calls, hasLength(2));
    expect(api.calls.last.token, 'tok-2');
  });

  test('register is a no-op when Firebase is unconfigured', () async {
    final api = _RecordingTokenApi();
    await _service(_FakeMessaging(configured: false), api).register();
    expect(api.calls, isEmpty);
  });

  test('register is a no-op when permission is denied', () async {
    final api = _RecordingTokenApi();
    await _service(_FakeMessaging(permitted: false), api).register();
    expect(api.calls, isEmpty);
  });

  test('unregister unlinks the token on the backend then deletes it locally', () async {
    final messaging = _FakeMessaging();
    final api = _RecordingTokenApi();
    await _service(messaging, api).unregister();

    expect(api.unregistered, ['device-1']);
    expect(messaging.deleted, isTrue);
  });

  test('unregister still deletes the local token when the backend unlink fails', () async {
    final messaging = _FakeMessaging();
    await _service(messaging, _ThrowingTokenApi()).unregister();
    expect(messaging.deleted, isTrue);
  });

  group('routeForPush', () {
    test('an appointment-lifecycle notification opens the detail, role-scoped', () {
      expect(
        routeForPush(
          {'kind': 'BOOKING_CONFIRMED', 'appointmentId': 'ap1'},
          isPhysio: false,
        ),
        '/appointments/ap1',
      );
      expect(
        routeForPush(
          {'kind': 'BOOKING_REQUESTED', 'appointmentId': 'ap1'},
          isPhysio: true,
        ),
        '/physio/appointments/ap1',
      );
    });

    test('a new-message notification opens the discussion, role-scoped', () {
      expect(
        routeForPush(
          {'kind': 'DISCUSSION_NEW_MESSAGE', 'appointmentId': 'ap1', 'messageId': 'm1'},
          isPhysio: false,
        ),
        '/appointments/ap1/discussion',
      );
      expect(
        routeForPush(
          {'kind': 'DISCUSSION_NEW_MESSAGE', 'appointmentId': 'ap1', 'messageId': 'm1'},
          isPhysio: true,
        ),
        '/physio/appointments/ap1/discussion',
      );
    });

    test('returns null when there is no actionable id', () {
      expect(routeForPush({'kind': 'SOMETHING'}, isPhysio: false), isNull);
      expect(routeForPush({'appointmentId': ''}, isPhysio: true), isNull);
    });
  });

  test('wireTaps delivers the cold-start tap and subsequent taps', () async {
    final messaging = _FakeMessaging(
      initialMessage: {'kind': 'BOOKING_CONFIRMED', 'appointmentId': 'ap-initial'},
    );
    final taps = <Map<String, String>>[];
    await _service(messaging, _RecordingTokenApi()).wireTaps(taps.add);

    expect(taps, hasLength(1));
    expect(taps.single['appointmentId'], 'ap-initial');

    messaging.emitOpened({'kind': 'BOOKING_CONFIRMED', 'appointmentId': 'ap-2'});
    await Future<void>.delayed(const Duration(milliseconds: 1));
    expect(taps, hasLength(2));
    expect(taps.last['appointmentId'], 'ap-2');
  });

  test('wireTaps is inert when push is unconfigured', () async {
    final messaging = _FakeMessaging(
      configured: false,
      initialMessage: {'appointmentId': 'ap-x'},
    );
    final taps = <Map<String, String>>[];
    await _service(messaging, _RecordingTokenApi()).wireTaps(taps.add);
    expect(taps, isEmpty);
  });
}
