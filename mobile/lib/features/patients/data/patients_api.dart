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

  /// The physiotherapist's practice roster, newest-first and cursor-paginated.
  /// [q] (≥2 chars) narrows by patient name or Patient ID; [cursor] continues a
  /// page. Same `/patients` endpoint — the server returns the roster for a physio.
  Future<PatientListResponse> listRoster({
    String? cursor,
    String? q,
    int limit = 20,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/patients',
      queryParameters: <String, dynamic>{
        'cursor': ?cursor,
        'q': ?q,
        'limit': limit,
      },
    );
    return PatientListResponse.fromJson(res.data!);
  }

  /// Adds a family member; returns the created patient.
  Future<Patient> create(CreateFamilyMemberRequest body) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/patients',
      data: body.toJson(),
    );
    return Patient.fromJson(res.data!);
  }

  /// Updates a patient's profile; returns the updated patient.
  Future<Patient> update(String id, UpdatePatientRequest body) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '/patients/$id',
      data: body.toJson(),
    );
    return Patient.fromJson(res.data!);
  }

  /// Removes the account's link to a family member (soft-deletes the patient
  /// when no links remain). The primary patient cannot be removed.
  Future<void> delete(String id) async {
    await _dio.delete<void>('/patients/$id');
  }

  /// The signed-in account's household address, or null when none is set.
  Future<Address?> getAccountAddress() async {
    final res = await _dio.get<Map<String, dynamic>>('/account/address');
    final addr = res.data!['address'];
    return addr == null ? null : Address.fromJson(addr as Map<String, dynamic>);
  }

  /// Creates or replaces the household address; returns the saved address.
  Future<Address> putAccountAddress(Address body) async {
    final res = await _dio.put<Map<String, dynamic>>(
      '/account/address',
      data: body.toJson(),
    );
    return Address.fromJson(res.data!);
  }
}

final patientsApiProvider = Provider<PatientsApi>(
  (ref) => PatientsApi(ref.watch(dioProvider)),
);
