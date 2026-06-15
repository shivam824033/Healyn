// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'availability_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AvailabilityRule _$AvailabilityRuleFromJson(Map<String, dynamic> json) =>
    _AvailabilityRule(
      id: json['id'] as String,
      physiotherapistId: json['physiotherapist_id'] as String,
      dayOfWeek: (json['day_of_week'] as num).toInt(),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      slotMinutes: (json['slot_minutes'] as num).toInt(),
      timezone: json['timezone'] as String,
      effectiveFrom: DateTime.parse(json['effective_from'] as String),
      effectiveTo: json['effective_to'] == null
          ? null
          : DateTime.parse(json['effective_to'] as String),
    );

Map<String, dynamic> _$AvailabilityRuleToJson(_AvailabilityRule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'physiotherapist_id': instance.physiotherapistId,
      'day_of_week': instance.dayOfWeek,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'slot_minutes': instance.slotMinutes,
      'timezone': instance.timezone,
      'effective_from': instance.effectiveFrom.toIso8601String(),
      'effective_to': ?instance.effectiveTo?.toIso8601String(),
    };

_RuleListResponse _$RuleListResponseFromJson(Map<String, dynamic> json) =>
    _RuleListResponse(
      rules: (json['rules'] as List<dynamic>)
          .map((e) => AvailabilityRule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RuleListResponseToJson(_RuleListResponse instance) =>
    <String, dynamic>{'rules': instance.rules.map((e) => e.toJson()).toList()};

_CreateRuleRequest _$CreateRuleRequestFromJson(Map<String, dynamic> json) =>
    _CreateRuleRequest(
      dayOfWeek: (json['day_of_week'] as num).toInt(),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      slotMinutes: (json['slot_minutes'] as num).toInt(),
      timezone: json['timezone'] as String,
      effectiveFrom: json['effective_from'] as String,
      effectiveTo: json['effective_to'] as String?,
    );

Map<String, dynamic> _$CreateRuleRequestToJson(_CreateRuleRequest instance) =>
    <String, dynamic>{
      'day_of_week': instance.dayOfWeek,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'slot_minutes': instance.slotMinutes,
      'timezone': instance.timezone,
      'effective_from': instance.effectiveFrom,
      'effective_to': ?instance.effectiveTo,
    };

_AvailabilitySlot _$AvailabilitySlotFromJson(Map<String, dynamic> json) =>
    _AvailabilitySlot(
      startsAt: DateTime.parse(json['starts_at'] as String),
      endsAt: DateTime.parse(json['ends_at'] as String),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
    );

Map<String, dynamic> _$AvailabilitySlotToJson(_AvailabilitySlot instance) =>
    <String, dynamic>{
      'starts_at': instance.startsAt.toIso8601String(),
      'ends_at': instance.endsAt.toIso8601String(),
      'duration_minutes': instance.durationMinutes,
    };

_SlotListResponse _$SlotListResponseFromJson(Map<String, dynamic> json) =>
    _SlotListResponse(
      physiotherapistId: json['physiotherapist_id'] as String,
      slots: (json['slots'] as List<dynamic>)
          .map((e) => AvailabilitySlot.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SlotListResponseToJson(_SlotListResponse instance) =>
    <String, dynamic>{
      'physiotherapist_id': instance.physiotherapistId,
      'slots': instance.slots.map((e) => e.toJson()).toList(),
    };

_BlackoutWindow _$BlackoutWindowFromJson(Map<String, dynamic> json) =>
    _BlackoutWindow(
      id: json['id'] as String,
      physiotherapistId: json['physiotherapist_id'] as String,
      startsAt: DateTime.parse(json['starts_at'] as String),
      endsAt: DateTime.parse(json['ends_at'] as String),
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$BlackoutWindowToJson(_BlackoutWindow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'physiotherapist_id': instance.physiotherapistId,
      'starts_at': instance.startsAt.toIso8601String(),
      'ends_at': instance.endsAt.toIso8601String(),
      'reason': ?instance.reason,
    };

_BlackoutListResponse _$BlackoutListResponseFromJson(
  Map<String, dynamic> json,
) => _BlackoutListResponse(
  blackouts: (json['blackouts'] as List<dynamic>)
      .map((e) => BlackoutWindow.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BlackoutListResponseToJson(
  _BlackoutListResponse instance,
) => <String, dynamic>{
  'blackouts': instance.blackouts.map((e) => e.toJson()).toList(),
};

_CreateBlackoutRequest _$CreateBlackoutRequestFromJson(
  Map<String, dynamic> json,
) => _CreateBlackoutRequest(
  startsAt: DateTime.parse(json['starts_at'] as String),
  endsAt: DateTime.parse(json['ends_at'] as String),
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$CreateBlackoutRequestToJson(
  _CreateBlackoutRequest instance,
) => <String, dynamic>{
  'starts_at': instance.startsAt.toIso8601String(),
  'ends_at': instance.endsAt.toIso8601String(),
  'reason': ?instance.reason,
};
