import 'package:freezed_annotation/freezed_annotation.dart';

part 'availability_models.freezed.dart';
part 'availability_models.g.dart';

/// A recurring weekly working-hours rule. Slots are computed from these rules
/// (minus blackouts and booked appointments) — a rule is the stored thing, a
/// slot is not (CLAUDE.md §11). [dayOfWeek] is `0=Sun … 6=Sat` (the backend's
/// `date.getDayOfWeek().getValue() % 7` convention). [startTime]/[endTime] are
/// wire clock strings `"HH:mm[:ss]"` in [timezone] (an IANA id); format them via
/// `availability_format.dart`. [effectiveFrom]/[effectiveTo] are calendar days
/// (date-only on the wire); a null [effectiveTo] means open-ended. Archiving a
/// rule sets [effectiveTo] rather than deleting it.
@freezed
abstract class AvailabilityRule with _$AvailabilityRule {
  const factory AvailabilityRule({
    required String id,
    required String physiotherapistId,
    required int dayOfWeek,
    required String startTime,
    required String endTime,
    required int slotMinutes,
    required String timezone,
    required DateTime effectiveFrom,
    DateTime? effectiveTo,
  }) = _AvailabilityRule;

  factory AvailabilityRule.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityRuleFromJson(json);
}

/// Response of `GET /availability/rules`.
@freezed
abstract class RuleListResponse with _$RuleListResponse {
  const factory RuleListResponse({required List<AvailabilityRule> rules}) =
      _RuleListResponse;

  factory RuleListResponse.fromJson(Map<String, dynamic> json) =>
      _$RuleListResponseFromJson(json);
}

/// Body for `POST /availability/rules`. [startTime]/[endTime] are `"HH:mm:ss"`
/// and must align on [slotMinutes] boundaries from 00:00 (the server rejects
/// misaligned times). [effectiveFrom]/[effectiveTo] are `"yyyy-MM-dd"`; a null
/// [effectiveTo] (omitted on the wire) means open-ended.
@freezed
abstract class CreateRuleRequest with _$CreateRuleRequest {
  const factory CreateRuleRequest({
    required int dayOfWeek,
    required String startTime,
    required String endTime,
    required int slotMinutes,
    required String timezone,
    required String effectiveFrom,
    String? effectiveTo,
  }) = _CreateRuleRequest;

  factory CreateRuleRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateRuleRequestFromJson(json);
}

/// A single computed open slot from `GET /availability` — working hours minus
/// blackouts (booked appointments are intentionally not subtracted, since
/// booking is request-first and the physiotherapist finalises the time).
/// [startsAt]/[endsAt] are instants (UTC on the wire); call `.toLocal()` before
/// comparing against a locally-picked date or time.
@freezed
abstract class AvailabilitySlot with _$AvailabilitySlot {
  const factory AvailabilitySlot({
    required DateTime startsAt,
    required DateTime endsAt,
    required int durationMinutes,
  }) = _AvailabilitySlot;

  factory AvailabilitySlot.fromJson(Map<String, dynamic> json) =>
      _$AvailabilitySlotFromJson(json);
}

/// Response of `GET /availability` — the open slots for one physiotherapist over
/// the requested date range.
@freezed
abstract class SlotListResponse with _$SlotListResponse {
  const factory SlotListResponse({
    required String physiotherapistId,
    required List<AvailabilitySlot> slots,
  }) = _SlotListResponse;

  factory SlotListResponse.fromJson(Map<String, dynamic> json) =>
      _$SlotListResponseFromJson(json);
}

/// A one-off block of time the physiotherapist is unavailable (holiday, leave).
/// [startsAt]/[endsAt] are instants (UTC on the wire); call `.toLocal()` before
/// formatting. [reason] is optional free text — short, non-clinical.
@freezed
abstract class BlackoutWindow with _$BlackoutWindow {
  const factory BlackoutWindow({
    required String id,
    required String physiotherapistId,
    required DateTime startsAt,
    required DateTime endsAt,
    String? reason,
  }) = _BlackoutWindow;

  factory BlackoutWindow.fromJson(Map<String, dynamic> json) =>
      _$BlackoutWindowFromJson(json);
}

/// Response of `GET /availability/blackouts`.
@freezed
abstract class BlackoutListResponse with _$BlackoutListResponse {
  const factory BlackoutListResponse({
    required List<BlackoutWindow> blackouts,
  }) = _BlackoutListResponse;

  factory BlackoutListResponse.fromJson(Map<String, dynamic> json) =>
      _$BlackoutListResponseFromJson(json);
}

/// Body for `POST /availability/blackouts`. [startsAt]/[endsAt] are sent as UTC
/// instants; [reason] is optional (omitted when null). The server rejects a
/// window that overlaps an existing one (409 `availability.blackout_overlap`).
@freezed
abstract class CreateBlackoutRequest with _$CreateBlackoutRequest {
  const factory CreateBlackoutRequest({
    required DateTime startsAt,
    required DateTime endsAt,
    String? reason,
  }) = _CreateBlackoutRequest;

  factory CreateBlackoutRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBlackoutRequestFromJson(json);
}
