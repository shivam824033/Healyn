import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/network/api_exception.dart';
import 'compliance_api.dart';
import 'models/compliance_models.dart';

/// Data access for the compliance surface (legal documents, consent history,
/// account deletion). Maps transport errors to [ApiException]; the UI talks only
/// to this class, never to Dio directly.
class ComplianceRepository {
  ComplianceRepository(this._api);

  final ComplianceApi _api;

  Future<LegalDocument> legalDocument(String kindPath) =>
      _guard(() => _api.legalDocument(kindPath));

  Future<List<ConsentView>> consents() =>
      _guard(() async => (await _api.consents()).consents);

  Future<ConsentView> recordConsent(ConsentType type, {required bool granted}) =>
      _guard(() => _api.recordConsent(type, granted: granted));

  Future<DeletionRequestView?> deletionRequest() =>
      _guard(_api.deletionRequest);

  Future<DeletionRequestView> requestDeletion({
    required String password,
    String? reason,
  }) =>
      _guard(() => _api.requestDeletion(password: password, reason: reason));

  Future<void> cancelDeletion() => _guard(_api.cancelDeletion);

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final complianceRepositoryProvider = Provider<ComplianceRepository>(
  (ref) => ComplianceRepository(ref.watch(complianceApiProvider)),
);
