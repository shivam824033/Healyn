import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/network/dio_client.dart';
import 'models/availability_models.dart';

/// Thin transport for the physiotherapist's availability management: the
/// `/availability/rules` and `/availability/blackouts` CRUD endpoints. Returns
/// typed models; DioErrors propagate and are mapped in the repository.
class AvailabilityApi {
  AvailabilityApi(this._dio);

  final Dio _dio;

  Future<List<AvailabilityRule>> listRules() async {
    final res = await _dio.get<Map<String, dynamic>>('/availability/rules');
    return RuleListResponse.fromJson(res.data!).rules;
  }

  Future<AvailabilityRule> createRule(CreateRuleRequest body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/availability/rules',
      data: body.toJson(),
    );
    return AvailabilityRule.fromJson(res.data!);
  }

  Future<void> deleteRule(String id) async {
    await _dio.delete<void>('/availability/rules/$id');
  }

  Future<List<BlackoutWindow>> listBlackouts() async {
    final res = await _dio.get<Map<String, dynamic>>('/availability/blackouts');
    return BlackoutListResponse.fromJson(res.data!).blackouts;
  }

  Future<BlackoutWindow> createBlackout(CreateBlackoutRequest body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/availability/blackouts',
      data: body.toJson(),
    );
    return BlackoutWindow.fromJson(res.data!);
  }

  Future<void> deleteBlackout(String id) async {
    await _dio.delete<void>('/availability/blackouts/$id');
  }
}

final availabilityApiProvider = Provider<AvailabilityApi>(
  (ref) => AvailabilityApi(ref.watch(dioProvider)),
);
