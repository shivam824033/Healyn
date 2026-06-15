// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Promotion _$PromotionFromJson(Map<String, dynamic> json) => _Promotion(
  id: json['id'] as String,
  title: json['title'] as String,
  shortDescription: json['short_description'] as String?,
  longDescription: json['long_description'] as String?,
  serviceCategory: json['service_category'] as String?,
  ctaText: json['cta_text'] as String?,
  ctaAction:
      $enumDecodeNullable(
        _$PromotionActionEnumMap,
        json['cta_action'],
        unknownValue: PromotionAction.none,
      ) ??
      PromotionAction.none,
  coverUrl: json['cover_url'] as String?,
  displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PromotionToJson(_Promotion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'short_description': ?instance.shortDescription,
      'long_description': ?instance.longDescription,
      'service_category': ?instance.serviceCategory,
      'cta_text': ?instance.ctaText,
      'cta_action': _$PromotionActionEnumMap[instance.ctaAction]!,
      'cover_url': ?instance.coverUrl,
      'display_order': instance.displayOrder,
    };

const _$PromotionActionEnumMap = {
  PromotionAction.none: 'NONE',
  PromotionAction.bookAppointment: 'BOOK_APPOINTMENT',
  PromotionAction.callClinic: 'CALL_CLINIC',
};

_ManagedPromotion _$ManagedPromotionFromJson(Map<String, dynamic> json) =>
    _ManagedPromotion(
      id: json['id'] as String,
      title: json['title'] as String,
      shortDescription: json['short_description'] as String?,
      longDescription: json['long_description'] as String?,
      serviceCategory: json['service_category'] as String?,
      ctaText: json['cta_text'] as String?,
      ctaAction:
          $enumDecodeNullable(
            _$PromotionActionEnumMap,
            json['cta_action'],
            unknownValue: PromotionAction.none,
          ) ??
          PromotionAction.none,
      coverUrl: json['cover_url'] as String?,
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
      active: json['active'] as bool? ?? true,
      startsAt: json['starts_at'] == null
          ? null
          : DateTime.parse(json['starts_at'] as String),
      endsAt: json['ends_at'] == null
          ? null
          : DateTime.parse(json['ends_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ManagedPromotionToJson(_ManagedPromotion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'short_description': ?instance.shortDescription,
      'long_description': ?instance.longDescription,
      'service_category': ?instance.serviceCategory,
      'cta_text': ?instance.ctaText,
      'cta_action': _$PromotionActionEnumMap[instance.ctaAction]!,
      'cover_url': ?instance.coverUrl,
      'display_order': instance.displayOrder,
      'active': instance.active,
      'starts_at': ?instance.startsAt?.toIso8601String(),
      'ends_at': ?instance.endsAt?.toIso8601String(),
      'created_at': ?instance.createdAt?.toIso8601String(),
      'updated_at': ?instance.updatedAt?.toIso8601String(),
    };

_CreatePromotionRequest _$CreatePromotionRequestFromJson(
  Map<String, dynamic> json,
) => _CreatePromotionRequest(
  title: json['title'] as String,
  shortDescription: json['short_description'] as String?,
  longDescription: json['long_description'] as String?,
  serviceCategory: json['service_category'] as String?,
  ctaText: json['cta_text'] as String?,
  ctaAction: $enumDecode(_$PromotionActionEnumMap, json['cta_action']),
  startsAt: json['starts_at'] == null
      ? null
      : DateTime.parse(json['starts_at'] as String),
  endsAt: json['ends_at'] == null
      ? null
      : DateTime.parse(json['ends_at'] as String),
  active: json['active'] as bool?,
);

Map<String, dynamic> _$CreatePromotionRequestToJson(
  _CreatePromotionRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'short_description': ?instance.shortDescription,
  'long_description': ?instance.longDescription,
  'service_category': ?instance.serviceCategory,
  'cta_text': ?instance.ctaText,
  'cta_action': _$PromotionActionEnumMap[instance.ctaAction]!,
  'starts_at': ?instance.startsAt?.toIso8601String(),
  'ends_at': ?instance.endsAt?.toIso8601String(),
  'active': ?instance.active,
};

_UpdatePromotionRequest _$UpdatePromotionRequestFromJson(
  Map<String, dynamic> json,
) => _UpdatePromotionRequest(
  title: json['title'] as String,
  shortDescription: json['short_description'] as String,
  longDescription: json['long_description'] as String,
  serviceCategory: json['service_category'] as String,
  ctaText: json['cta_text'] as String,
  ctaAction: $enumDecode(_$PromotionActionEnumMap, json['cta_action']),
  startsAt: json['starts_at'] == null
      ? null
      : DateTime.parse(json['starts_at'] as String),
  endsAt: json['ends_at'] == null
      ? null
      : DateTime.parse(json['ends_at'] as String),
);

Map<String, dynamic> _$UpdatePromotionRequestToJson(
  _UpdatePromotionRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'short_description': instance.shortDescription,
  'long_description': instance.longDescription,
  'service_category': instance.serviceCategory,
  'cta_text': instance.ctaText,
  'cta_action': _$PromotionActionEnumMap[instance.ctaAction]!,
  'starts_at': ?instance.startsAt?.toIso8601String(),
  'ends_at': ?instance.endsAt?.toIso8601String(),
};

_CoverPresign _$CoverPresignFromJson(Map<String, dynamic> json) =>
    _CoverPresign(
      objectKey: json['object_key'] as String,
      url: json['url'] as String,
      contentType: json['content_type'] as String,
      expiresInSeconds: (json['expires_in_seconds'] as num).toInt(),
    );

Map<String, dynamic> _$CoverPresignToJson(_CoverPresign instance) =>
    <String, dynamic>{
      'object_key': instance.objectKey,
      'url': instance.url,
      'content_type': instance.contentType,
      'expires_in_seconds': instance.expiresInSeconds,
    };
