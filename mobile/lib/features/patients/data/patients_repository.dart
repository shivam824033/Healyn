import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/network/api_exception.dart';
import 'models/patient_models.dart';
import 'patients_api.dart';

/// Patient reads for the signed-in account. Maps transport errors to
/// [ApiException]; the UI talks only to this class, never to Dio directly.
class PatientsRepository {
  PatientsRepository(this._api);

  final PatientsApi _api;

  Future<List<Patient>> list() async {
    return _guard(() async => (await _api.list()).patients);
  }

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final patientsRepositoryProvider = Provider<PatientsRepository>(
  (ref) => PatientsRepository(ref.watch(patientsApiProvider)),
);
