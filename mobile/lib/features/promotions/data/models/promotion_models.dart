import 'package:freezed_annotation/freezed_annotation.dart';

part 'promotion_models.freezed.dart';
part 'promotion_models.g.dart';

/// The closed set of call-to-action behaviours (mirrors the backend
/// `PromotionAction`). All are in-app — no external marketing links.
enum PromotionAction {
  @JsonValue('NONE')
  none,
  @JsonValue('BOOK_APPOINTMENT')
  bookAppointment,
  @JsonValue('CALL_CLINIC')
  callClinic,
}

/// A clinic promotion as a patient sees it (`GET /promotions`). Only patient-safe
/// fields — no visibility flag, schedule window, or audit timestamps. [coverUrl] is
/// a short-lived presigned URL; never persist it.
@freezed
abstract class Promotion with _$Promotion {
  const Promotion._();

  const factory Promotion({
    required String id,
    required String title,
    String? shortDescription,
    String? longDescription,
    String? serviceCategory,
    String? ctaText,
    @JsonKey(unknownEnumValue: PromotionAction.none)
    @Default(PromotionAction.none)
    PromotionAction ctaAction,
    String? coverUrl,
    @Default(0) int displayOrder,
  }) = _Promotion;

  factory Promotion.fromJson(Map<String, dynamic> json) =>
      _$PromotionFromJson(json);

  bool _has(String? s) => s != null && s.trim().isNotEmpty;

  /// Whether this promotion has a CTA button to render.
  bool get hasCta => ctaAction != PromotionAction.none && _has(ctaText);
}

/// A clinic promotion as the physiotherapist manages it (`GET /promotions/manage`
/// and the mutating responses). Adds the management fields on top of the patient
/// view.
@freezed
abstract class ManagedPromotion with _$ManagedPromotion {
  const ManagedPromotion._();

  const factory ManagedPromotion({
    required String id,
    required String title,
    String? shortDescription,
    String? longDescription,
    String? serviceCategory,
    String? ctaText,
    @JsonKey(unknownEnumValue: PromotionAction.none)
    @Default(PromotionAction.none)
    PromotionAction ctaAction,
    String? coverUrl,
    @Default(0) int displayOrder,
    @Default(true) bool active,
    DateTime? startsAt,
    DateTime? endsAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ManagedPromotion;

  factory ManagedPromotion.fromJson(Map<String, dynamic> json) =>
      _$ManagedPromotionFromJson(json);

  /// Whether the schedule window has fully elapsed (display-only hint for the
  /// management list; the server is the source of truth for visibility).
  bool get isExpired => endsAt != null && endsAt!.isBefore(DateTime.now());

  /// Whether the start is still in the future.
  bool get isScheduled => startsAt != null && startsAt!.isAfter(DateTime.now());
}

/// Body for `POST /promotions`. Mirrors the backend `CreateRequest`; nulls are
/// omitted by the package-wide json config so optional fields drop out.
@freezed
abstract class CreatePromotionRequest with _$CreatePromotionRequest {
  const factory CreatePromotionRequest({
    required String title,
    String? shortDescription,
    String? longDescription,
    String? serviceCategory,
    String? ctaText,
    required PromotionAction ctaAction,
    DateTime? startsAt,
    DateTime? endsAt,
    bool? active,
  }) = _CreatePromotionRequest;

  factory CreatePromotionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePromotionRequestFromJson(json);
}

/// Body for `PATCH /promotions/{id}` — replace semantics for the content/schedule
/// fields. Visibility is changed via the activate endpoint, not here.
@freezed
abstract class UpdatePromotionRequest with _$UpdatePromotionRequest {
  const factory UpdatePromotionRequest({
    required String title,
    required String shortDescription,
    required String longDescription,
    required String serviceCategory,
    required String ctaText,
    required PromotionAction ctaAction,
    DateTime? startsAt,
    DateTime? endsAt,
  }) = _UpdatePromotionRequest;

  factory UpdatePromotionRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePromotionRequestFromJson(json);
}

/// The presigned-PUT instruction for a cover upload (`POST .../cover/presign`).
@freezed
abstract class CoverPresign with _$CoverPresign {
  const factory CoverPresign({
    required String objectKey,
    required String url,
    required String contentType,
    required int expiresInSeconds,
  }) = _CoverPresign;

  factory CoverPresign.fromJson(Map<String, dynamic> json) =>
      _$CoverPresignFromJson(json);
}
