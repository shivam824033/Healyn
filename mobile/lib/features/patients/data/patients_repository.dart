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

  /// One cursor page of the physiotherapist's practice roster (newest-first).
  /// [q] (≥2 chars) narrows by patient name or Patient ID.
  Future<PatientListResponse> listRoster({
    String? cursor,
    String? q,
    int limit = 20,
  }) async {
    return _guard(() => _api.listRoster(cursor: cursor, q: q, limit: limit));
  }

  Future<Patient> create(CreateFamilyMemberRequest body) async {
    return _guard(() => _api.create(body));
  }

  Future<Patient> update(String id, UpdatePatientRequest body) async {
    return _guard(() => _api.update(id, body));
  }

  Future<void> remove(String id) async {
    return _guard(() => _api.delete(id));
  }

  Future<Address?> accountAddress() async {
    return _guard(() => _api.getAccountAddress());
  }

  Future<Address> saveAccountAddress(Address body) async {
    return _guard(() => _api.putAccountAddress(body));
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
