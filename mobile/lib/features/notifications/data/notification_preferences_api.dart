import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/network/dio_client.dart';
import 'models/notification_preferences.dart';

/// Thin transport over `/notifications/preferences` (API_STANDARDS §9.8). Uses
/// the authenticated [dioProvider]; both verbs return the full snapshot. The
/// PATCH body is a partial map — an omitted category is left unchanged
/// server-side, so we send only the keys we mean to change. DioErrors propagate
/// and are mapped to [ApiException] in the repository.
class NotificationPreferencesApi {
  NotificationPreferencesApi(this._dio);

  final Dio _dio;

  Future<NotificationPreferences> get() async {
    final res = await _dio.get<Map<String, dynamic>>('/notifications/preferences');
    return NotificationPreferences.fromJson(res.data!);
  }

  Future<NotificationPreferences> patch(Map<String, Object?> body) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '/notifications/preferences',
      data: body,
    );
    return NotificationPreferences.fromJson(res.data!);
  }
}

final notificationPreferencesApiProvider = Provider<NotificationPreferencesApi>(
  (ref) => NotificationPreferencesApi(ref.watch(dioProvider)),
);
