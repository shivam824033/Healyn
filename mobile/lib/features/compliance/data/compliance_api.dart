import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/network/dio_client.dart';
import 'models/compliance_models.dart';

/// Thin transport over the compliance endpoints (API_STANDARDS §9.9). `/legal/**`
/// is public (no bearer needed — readable during registration); the `/me/*`
/// endpoints use the authenticated [dioProvider]. DioErrors propagate and are
/// mapped to ApiException in the repository.
class ComplianceApi {
  ComplianceApi(this._dio);

  final Dio _dio;

  Future<LegalDocument> legalDocument(String kindPath) async {
    final res = await _dio.get<Map<String, dynamic>>('/legal/$kindPath');
    return LegalDocument.fromJson(res.data!);
  }

  Future<ConsentListResponse> consents() async {
    final res = await _dio.get<Map<String, dynamic>>('/me/consents');
    return ConsentListResponse.fromJson(res.data!);
  }

  Future<ConsentView> recordConsent(ConsentType type, {required bool granted}) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/me/consents',
      data: {'consent_type': _wire(type), 'granted': granted},
    );
    return ConsentView.fromJson(res.data!);
  }

  /// Returns the active deletion request, or null when there is none (the
  /// backend answers `204 No Content`).
  Future<DeletionRequestView?> deletionRequest() async {
    final res = await _dio.get<Map<String, dynamic>>('/me/deletion-request');
    if (res.statusCode == 204 || res.data == null) return null;
    return DeletionRequestView.fromJson(res.data!);
  }

  Future<DeletionRequestView> requestDeletion({
    required String password,
    String? reason,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/me/deletion-request',
      data: {
        'password': password,
        if (reason != null && reason.isNotEmpty) 'reason': reason,
      },
    );
    return DeletionRequestView.fromJson(res.data!);
  }

  Future<void> cancelDeletion() async {
    await _dio.post<void>('/me/deletion-request/cancel');
  }

  /// The backend `ConsentType` wire value (its enum name).
  static String _wire(ConsentType type) => switch (type) {
        ConsentType.termsOfService => 'TERMS_OF_SERVICE',
        ConsentType.privacyPolicy => 'PRIVACY_POLICY',
        ConsentType.healthDataProcessing => 'HEALTH_DATA_PROCESSING',
        ConsentType.familyMemberAuthority => 'FAMILY_MEMBER_AUTHORITY',
      };
}

final complianceApiProvider = Provider<ComplianceApi>(
  (ref) => ComplianceApi(ref.watch(dioProvider)),
);
