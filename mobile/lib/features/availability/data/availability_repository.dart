import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/network/api_exception.dart';
import 'availability_api.dart';
import 'models/availability_models.dart';

/// Data access for availability management. Maps transport errors to
/// [ApiException]; the UI talks only to this class, never to Dio directly.
/// Centralises wire formatting: calendar dates become date-only strings and
/// blackout instants are sent as UTC.
class AvailabilityRepository {
  AvailabilityRepository(this._api);

  final AvailabilityApi _api;

  Future<List<AvailabilityRule>> listRules() => _guard(_api.listRules);

  /// Creates a weekly working-hours rule. [startTime]/[endTime] are `"HH:mm:ss"`
  /// clock strings (aligned on [slotMinutes] from 00:00); [effectiveFrom] and
  /// the optional [effectiveTo] are reduced to date-only on the wire.
  Future<AvailabilityRule> createRule({
    required int dayOfWeek,
    required String startTime,
    required String endTime,
    required int slotMinutes,
    required String timezone,
    required DateTime effectiveFrom,
    DateTime? effectiveTo,
  }) {
    return _guard(
      () => _api.createRule(
        CreateRuleRequest(
          dayOfWeek: dayOfWeek,
          startTime: startTime,
          endTime: endTime,
          slotMinutes: slotMinutes,
          timezone: timezone,
          effectiveFrom: _isoDate(effectiveFrom),
          effectiveTo: effectiveTo == null ? null : _isoDate(effectiveTo),
        ),
      ),
    );
  }

  Future<void> deleteRule(String id) => _guard(() => _api.deleteRule(id));

  Future<List<BlackoutWindow>> listBlackouts() => _guard(_api.listBlackouts);

  /// Creates a time-off window. [startsAt]/[endsAt] are sent as UTC instants;
  /// a blank [reason] is normalised to null so it drops off the wire.
  Future<BlackoutWindow> createBlackout({
    required DateTime startsAt,
    required DateTime endsAt,
    String? reason,
  }) {
    return _guard(
      () => _api.createBlackout(
        CreateBlackoutRequest(
          startsAt: startsAt.toUtc(),
          endsAt: endsAt.toUtc(),
          reason: _clean(reason),
        ),
      ),
    );
  }

  Future<void> deleteBlackout(String id) =>
      _guard(() => _api.deleteBlackout(id));

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Local calendar day as `yyyy-MM-dd` for `LocalDate` wire fields.
  static String _isoDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  static String? _clean(String? s) {
    final t = s?.trim() ?? '';
    return t.isEmpty ? null : t;
  }
}

final availabilityRepositoryProvider = Provider<AvailabilityRepository>(
  (ref) => AvailabilityRepository(ref.watch(availabilityApiProvider)),
);
