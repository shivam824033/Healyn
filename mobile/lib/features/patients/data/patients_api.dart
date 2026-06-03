import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/network/dio_client.dart';
import 'models/patient_models.dart';

/// Thin transport over the `/patients` endpoints. Returns typed models;
/// DioErrors propagate and are mapped to ApiException in the repository.
class PatientsApi {
  PatientsApi(this._dio);

  final Dio _dio;

  /// All patients the account can see: the primary patient plus family members.
  Future<PatientListResponse> list() async {
    final res = await _dio.get<Map<String, dynamic>>('/patients');
    return PatientListResponse.fromJson(res.data!);
  }
}

final patientsApiProvider = Provider<PatientsApi>(
  (ref) => PatientsApi(ref.watch(dioProvider)),
);
