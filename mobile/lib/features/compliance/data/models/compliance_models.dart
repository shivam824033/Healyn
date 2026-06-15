import 'package:freezed_annotation/freezed_annotation.dart';

part 'compliance_models.freezed.dart';
part 'compliance_models.g.dart';

/// A kind of consent Healyn records (API_STANDARDS §9.9). The first three are
/// account-level (captured at registration, re-grantable / withdrawable here);
/// [familyMemberAuthority] is per managed patient and is captured at family-add.
/// Wire values are the backend enum names.
enum ConsentType {
  @JsonValue('TERMS_OF_SERVICE')
  termsOfService('Terms of Service'),
  @JsonValue('PRIVACY_POLICY')
  privacyPolicy('Privacy Policy'),
  @JsonValue('HEALTH_DATA_PROCESSING')
  healthDataProcessing('Health-data processing'),
  @JsonValue('FAMILY_MEMBER_AUTHORITY')
  familyMemberAuthority('Family-member authority');

  const ConsentType(this.label);

  /// Human-readable name for the consent row.
  final String label;
}

/// A legal document kind addressable at `GET /legal/{kind}`. [path] is the
/// case-insensitive path segment the backend expects (e.g. `privacy_policy`).
enum LegalDocumentKind {
  privacyPolicy('privacy_policy', 'Privacy Policy'),
  termsOfService('terms_of_service', 'Terms of Service');

  const LegalDocumentKind(this.path, this.title);

  final String path;
  final String title;

  static LegalDocumentKind? fromPath(String path) {
    for (final k in values) {
      if (k.path == path) return k;
    }
    return null;
  }
}

/// A versioned Privacy Policy / Terms document (API_STANDARDS §9.9). [bodyMarkdown]
/// is the document text; it is rendered as plain selectable text for now.
@freezed
abstract class LegalDocument with _$LegalDocument {
  const factory LegalDocument({
    required String kind,
    required String version,
    required String locale,
    required String title,
    required String bodyMarkdown,
    DateTime? effectiveAt,
  }) = _LegalDocument;

  factory LegalDocument.fromJson(Map<String, dynamic> json) =>
      _$LegalDocumentFromJson(json);
}

/// One consent record in the account's history. [patientId] is set only for
/// [ConsentType.familyMemberAuthority]; [documentVersion] is the legal-document
/// version the account agreed to (null for non-document consents).
@freezed
abstract class ConsentView with _$ConsentView {
  const factory ConsentView({
    required String id,
    required ConsentType consentType,
    String? patientId,
    @Default(false) bool granted,
    String? documentVersion,
    DateTime? grantedAt,
    DateTime? withdrawnAt,
  }) = _ConsentView;

  factory ConsentView.fromJson(Map<String, dynamic> json) =>
      _$ConsentViewFromJson(json);
}

@freezed
abstract class ConsentListResponse with _$ConsentListResponse {
  const factory ConsentListResponse({
    @Default(<ConsentView>[]) List<ConsentView> consents,
  }) = _ConsentListResponse;

  factory ConsentListResponse.fromJson(Map<String, dynamic> json) =>
      _$ConsentListResponseFromJson(json);
}

/// The state of the account's active deletion / erasure request (API_STANDARDS
/// §9.9). [status] mirrors the backend `deletion_request_status` name
/// (`REQUESTED` while in the grace window). [purgeAfter] is when the scheduled
/// anonymization sweep becomes due.
@freezed
abstract class DeletionRequestView with _$DeletionRequestView {
  const factory DeletionRequestView({
    required String status,
    DateTime? requestedAt,
    DateTime? purgeAfter,
  }) = _DeletionRequestView;

  factory DeletionRequestView.fromJson(Map<String, dynamic> json) =>
      _$DeletionRequestViewFromJson(json);
}
