import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/network/api_exception.dart';
import 'models/notification_preferences.dart';
import 'notification_preferences_api.dart';

/// Data access for notification preferences. Maps transport errors to
/// [ApiException]; the UI talks only to this class, never to Dio directly.
class NotificationPreferencesRepository {
  NotificationPreferencesRepository(this._api);

  final NotificationPreferencesApi _api;

  Future<NotificationPreferences> fetch() async {
    try {
      return await _api.get();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Flip a single [category] and return the resulting full snapshot. Sends only
  /// that category, so the others are left at whatever the server holds.
  Future<NotificationPreferences> setCategory(
    NotificationCategory category,
    bool enabled,
  ) async {
    try {
      return await _api.patch({category.wireKey: enabled});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final notificationPreferencesRepositoryProvider =
    Provider<NotificationPreferencesRepository>(
  (ref) => NotificationPreferencesRepository(
    ref.watch(notificationPreferencesApiProvider),
  ),
);
