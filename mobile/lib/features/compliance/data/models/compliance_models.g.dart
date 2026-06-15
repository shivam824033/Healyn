// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compliance_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LegalDocument _$LegalDocumentFromJson(Map<String, dynamic> json) =>
    _LegalDocument(
      kind: json['kind'] as String,
      version: json['version'] as String,
      locale: json['locale'] as String,
      title: json['title'] as String,
      bodyMarkdown: json['body_markdown'] as String,
      effectiveAt: json['effective_at'] == null
          ? null
          : DateTime.parse(json['effective_at'] as String),
    );

Map<String, dynamic> _$LegalDocumentToJson(_LegalDocument instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'version': instance.version,
      'locale': instance.locale,
      'title': instance.title,
      'body_markdown': instance.bodyMarkdown,
      'effective_at': ?instance.effectiveAt?.toIso8601String(),
    };

_ConsentView _$ConsentViewFromJson(Map<String, dynamic> json) => _ConsentView(
  id: json['id'] as String,
  consentType: $enumDecode(_$ConsentTypeEnumMap, json['consent_type']),
  patientId: json['patient_id'] as String?,
  granted: json['granted'] as bool? ?? false,
  documentVersion: json['document_version'] as String?,
  grantedAt: json['granted_at'] == null
      ? null
      : DateTime.parse(json['granted_at'] as String),
  withdrawnAt: json['withdrawn_at'] == null
      ? null
      : DateTime.parse(json['withdrawn_at'] as String),
);

Map<String, dynamic> _$ConsentViewToJson(_ConsentView instance) =>
    <String, dynamic>{
      'id': instance.id,
      'consent_type': _$ConsentTypeEnumMap[instance.consentType]!,
      'patient_id': ?instance.patientId,
      'granted': instance.granted,
      'document_version': ?instance.documentVersion,
      'granted_at': ?instance.grantedAt?.toIso8601String(),
      'withdrawn_at': ?instance.withdrawnAt?.toIso8601String(),
    };

const _$ConsentTypeEnumMap = {
  ConsentType.termsOfService: 'TERMS_OF_SERVICE',
  ConsentType.privacyPolicy: 'PRIVACY_POLICY',
  ConsentType.healthDataProcessing: 'HEALTH_DATA_PROCESSING',
  ConsentType.familyMemberAuthority: 'FAMILY_MEMBER_AUTHORITY',
};

_ConsentListResponse _$ConsentListResponseFromJson(Map<String, dynamic> json) =>
    _ConsentListResponse(
      consents:
          (json['consents'] as List<dynamic>?)
              ?.map((e) => ConsentView.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ConsentView>[],
    );

Map<String, dynamic> _$ConsentListResponseToJson(
  _ConsentListResponse instance,
) => <String, dynamic>{
  'consents': instance.consents.map((e) => e.toJson()).toList(),
};

_DeletionRequestView _$DeletionRequestViewFromJson(Map<String, dynamic> json) =>
    _DeletionRequestView(
      status: json['status'] as String,
      requestedAt: json['requested_at'] == null
          ? null
          : DateTime.parse(json['requested_at'] as String),
      purgeAfter: json['purge_after'] == null
          ? null
          : DateTime.parse(json['purge_after'] as String),
    );

Map<String, dynamic> _$DeletionRequestViewToJson(
  _DeletionRequestView instance,
) => <String, dynamic>{
  'status': instance.status,
  'requested_at': ?instance.requestedAt?.toIso8601String(),
  'purge_after': ?instance.purgeAfter?.toIso8601String(),
};
