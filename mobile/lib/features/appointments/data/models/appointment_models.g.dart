// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimelineEvent _$TimelineEventFromJson(Map<String, dynamic> json) =>
    _TimelineEvent(
      appointmentId: json['appointment_id'] as String,
      appointmentNumber: json['appointment_number'] as String?,
      eventType: $enumDecode(_$AppointmentEventTypeEnumMap, json['event_type']),
      actorAccountId: json['actor_account_id'] as String?,
      actorRole: $enumDecodeNullable(_$AccountRoleEnumMap, json['actor_role']),
      relatedAppointmentId: json['related_appointment_id'] as String?,
      childKind: $enumDecodeNullable(
        _$AppointmentChildKindEnumMap,
        json['child_kind'],
      ),
      cancelReason: $enumDecodeNullable(
        _$AppointmentCancelReasonEnumMap,
        json['cancel_reason'],
      ),
      occurredAt: DateTime.parse(json['occurred_at'] as String),
    );

Map<String, dynamic> _$TimelineEventToJson(_TimelineEvent instance) =>
    <String, dynamic>{
      'appointment_id': instance.appointmentId,
      'appointment_number': ?instance.appointmentNumber,
      'event_type': _$AppointmentEventTypeEnumMap[instance.eventType]!,
      'actor_account_id': ?instance.actorAccountId,
      'actor_role': ?_$AccountRoleEnumMap[instance.actorRole],
      'related_appointment_id': ?instance.relatedAppointmentId,
      'child_kind': ?_$AppointmentChildKindEnumMap[instance.childKind],
      'cancel_reason': ?_$AppointmentCancelReasonEnumMap[instance.cancelReason],
      'occurred_at': instance.occurredAt.toIso8601String(),
    };

const _$AppointmentEventTypeEnumMap = {
  AppointmentEventType.created: 'CREATED',
  AppointmentEventType.scheduled: 'SCHEDULED',
  AppointmentEventType.started: 'STARTED',
  AppointmentEventType.completed: 'COMPLETED',
  AppointmentEventType.cancelled: 'CANCELLED',
  AppointmentEventType.noShow: 'NO_SHOW',
  AppointmentEventType.rescheduled: 'RESCHEDULED',
  AppointmentEventType.rejected: 'REJECTED',
};

const _$AccountRoleEnumMap = {
  AccountRole.account: 'ROLE_ACCOUNT',
  AccountRole.physio: 'ROLE_PHYSIO',
};

const _$AppointmentChildKindEnumMap = {
  AppointmentChildKind.reschedule: 'RESCHEDULE',
  AppointmentChildKind.followUp: 'FOLLOW_UP',
  AppointmentChildKind.review: 'REVIEW',
  AppointmentChildKind.reopen: 'REOPEN',
};

const _$AppointmentCancelReasonEnumMap = {
  AppointmentCancelReason.patientCancelled: 'PATIENT_CANCELLED',
  AppointmentCancelReason.physioCancelled: 'PHYSIO_CANCELLED',
  AppointmentCancelReason.clinicClosed: 'CLINIC_CLOSED',
  AppointmentCancelReason.other: 'OTHER',
};

_Appointment _$AppointmentFromJson(Map<String, dynamic> json) => _Appointment(
  id: json['id'] as String,
  appointmentNumber: json['appointment_number'] as String?,
  patientId: json['patient_id'] as String,
  bookedByAccountId: json['booked_by_account_id'] as String,
  physiotherapistId: json['physiotherapist_id'] as String,
  requestedDate: const LocalDateConverter().fromJson(
    json['requested_date'] as String,
  ),
  preferredTime: json['preferred_time'] as String?,
  scheduledAt: json['scheduled_at'] == null
      ? null
      : DateTime.parse(json['scheduled_at'] as String),
  scheduledEndAt: json['scheduled_end_at'] == null
      ? null
      : DateTime.parse(json['scheduled_end_at'] as String),
  durationMinutes: (json['duration_minutes'] as num).toInt(),
  status: $enumDecode(_$AppointmentStatusEnumMap, json['status']),
  isFollowUp: json['is_follow_up'] as bool? ?? false,
  reason: json['reason'] as String?,
  cancelReason: $enumDecodeNullable(
    _$AppointmentCancelReasonEnumMap,
    json['cancel_reason'],
  ),
  cancelNote: json['cancel_note'] as String?,
  rescheduledFromId: json['rescheduled_from_id'] as String?,
  rootAppointmentId: json['root_appointment_id'] as String?,
  sourceAppointmentId: json['source_appointment_id'] as String?,
  childKind: $enumDecodeNullable(
    _$AppointmentChildKindEnumMap,
    json['child_kind'],
  ),
  confirmedAt: json['confirmed_at'] == null
      ? null
      : DateTime.parse(json['confirmed_at'] as String),
  startedAt: json['started_at'] == null
      ? null
      : DateTime.parse(json['started_at'] as String),
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  cancelledAt: json['cancelled_at'] == null
      ? null
      : DateTime.parse(json['cancelled_at'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$AppointmentToJson(
  _Appointment instance,
) => <String, dynamic>{
  'id': instance.id,
  'appointment_number': ?instance.appointmentNumber,
  'patient_id': instance.patientId,
  'booked_by_account_id': instance.bookedByAccountId,
  'physiotherapist_id': instance.physiotherapistId,
  'requested_date': const LocalDateConverter().toJson(instance.requestedDate),
  'preferred_time': ?instance.preferredTime,
  'scheduled_at': ?instance.scheduledAt?.toIso8601String(),
  'scheduled_end_at': ?instance.scheduledEndAt?.toIso8601String(),
  'duration_minutes': instance.durationMinutes,
  'status': _$AppointmentStatusEnumMap[instance.status]!,
  'is_follow_up': instance.isFollowUp,
  'reason': ?instance.reason,
  'cancel_reason': ?_$AppointmentCancelReasonEnumMap[instance.cancelReason],
  'cancel_note': ?instance.cancelNote,
  'rescheduled_from_id': ?instance.rescheduledFromId,
  'root_appointment_id': ?instance.rootAppointmentId,
  'source_appointment_id': ?instance.sourceAppointmentId,
  'child_kind': ?_$AppointmentChildKindEnumMap[instance.childKind],
  'confirmed_at': ?instance.confirmedAt?.toIso8601String(),
  'started_at': ?instance.startedAt?.toIso8601String(),
  'completed_at': ?instance.completedAt?.toIso8601String(),
  'cancelled_at': ?instance.cancelledAt?.toIso8601String(),
  'created_at': ?instance.createdAt?.toIso8601String(),
  'updated_at': ?instance.updatedAt?.toIso8601String(),
};

const _$AppointmentStatusEnumMap = {
  AppointmentStatus.requested: 'REQUESTED',
  AppointmentStatus.confirmed: 'CONFIRMED',
  AppointmentStatus.inProgress: 'IN_PROGRESS',
  AppointmentStatus.completed: 'COMPLETED',
  AppointmentStatus.cancelled: 'CANCELLED',
  AppointmentStatus.noShow: 'NO_SHOW',
  AppointmentStatus.rescheduled: 'RESCHEDULED',
  AppointmentStatus.rejected: 'REJECTED',
};

_AppointmentPage _$AppointmentPageFromJson(Map<String, dynamic> json) =>
    _AppointmentPage(
      items: (json['items'] as List<dynamic>)
          .map((e) => Appointment.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$AppointmentPageToJson(_AppointmentPage instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': ?instance.nextCursor,
    };

_BookAppointmentRequest _$BookAppointmentRequestFromJson(
  Map<String, dynamic> json,
) => _BookAppointmentRequest(
  patientId: json['patient_id'] as String,
  requestedDate: const LocalDateConverter().fromJson(
    json['requested_date'] as String,
  ),
  preferredTime: json['preferred_time'] as String?,
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$BookAppointmentRequestToJson(
  _BookAppointmentRequest instance,
) => <String, dynamic>{
  'patient_id': instance.patientId,
  'requested_date': const LocalDateConverter().toJson(instance.requestedDate),
  'preferred_time': ?instance.preferredTime,
  'reason': ?instance.reason,
};

_RescheduleAppointmentRequest _$RescheduleAppointmentRequestFromJson(
  Map<String, dynamic> json,
) => _RescheduleAppointmentRequest(
  requestedDate: const LocalDateConverter().fromJson(
    json['requested_date'] as String,
  ),
  preferredTime: json['preferred_time'] as String?,
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$RescheduleAppointmentRequestToJson(
  _RescheduleAppointmentRequest instance,
) => <String, dynamic>{
  'requested_date': const LocalDateConverter().toJson(instance.requestedDate),
  'preferred_time': ?instance.preferredTime,
  'reason': ?instance.reason,
};

_ScheduleAppointmentRequest _$ScheduleAppointmentRequestFromJson(
  Map<String, dynamic> json,
) => _ScheduleAppointmentRequest(
  scheduledAt: const UtcInstantConverter().fromJson(
    json['scheduled_at'] as String,
  ),
  durationMinutes: (json['duration_minutes'] as num).toInt(),
);

Map<String, dynamic> _$ScheduleAppointmentRequestToJson(
  _ScheduleAppointmentRequest instance,
) => <String, dynamic>{
  'scheduled_at': const UtcInstantConverter().toJson(instance.scheduledAt),
  'duration_minutes': instance.durationMinutes,
};

_FollowUpRequest _$FollowUpRequestFromJson(Map<String, dynamic> json) =>
    _FollowUpRequest(
      patientId: json['patient_id'] as String,
      scheduledAt: const UtcInstantConverter().fromJson(
        json['scheduled_at'] as String,
      ),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$FollowUpRequestToJson(_FollowUpRequest instance) =>
    <String, dynamic>{
      'patient_id': instance.patientId,
      'scheduled_at': const UtcInstantConverter().toJson(instance.scheduledAt),
      'duration_minutes': instance.durationMinutes,
      'reason': ?instance.reason,
    };

_PhysioRescheduleRequest _$PhysioRescheduleRequestFromJson(
  Map<String, dynamic> json,
) => _PhysioRescheduleRequest(
  scheduledAt: const UtcInstantConverter().fromJson(
    json['scheduled_at'] as String,
  ),
  durationMinutes: (json['duration_minutes'] as num).toInt(),
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$PhysioRescheduleRequestToJson(
  _PhysioRescheduleRequest instance,
) => <String, dynamic>{
  'scheduled_at': const UtcInstantConverter().toJson(instance.scheduledAt),
  'duration_minutes': instance.durationMinutes,
  'reason': ?instance.reason,
};

_TransitionRequest _$TransitionRequestFromJson(Map<String, dynamic> json) =>
    _TransitionRequest(
      to: $enumDecode(_$AppointmentStatusEnumMap, json['to']),
      cancelReason: $enumDecodeNullable(
        _$AppointmentCancelReasonEnumMap,
        json['cancel_reason'],
      ),
      cancelNote: json['cancel_note'] as String?,
    );

Map<String, dynamic> _$TransitionRequestToJson(_TransitionRequest instance) =>
    <String, dynamic>{
      'to': _$AppointmentStatusEnumMap[instance.to]!,
      'cancel_reason': ?_$AppointmentCancelReasonEnumMap[instance.cancelReason],
      'cancel_note': ?instance.cancelNote,
    };

_Slot _$SlotFromJson(Map<String, dynamic> json) => _Slot(
  startsAt: DateTime.parse(json['starts_at'] as String),
  endsAt: DateTime.parse(json['ends_at'] as String),
  durationMinutes: (json['duration_minutes'] as num).toInt(),
);

Map<String, dynamic> _$SlotToJson(_Slot instance) => <String, dynamic>{
  'starts_at': instance.startsAt.toIso8601String(),
  'ends_at': instance.endsAt.toIso8601String(),
  'duration_minutes': instance.durationMinutes,
};

_SlotListResponse _$SlotListResponseFromJson(Map<String, dynamic> json) =>
    _SlotListResponse(
      physiotherapistId: json['physiotherapist_id'] as String,
      slots: (json['slots'] as List<dynamic>)
          .map((e) => Slot.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SlotListResponseToJson(_SlotListResponse instance) =>
    <String, dynamic>{
      'physiotherapist_id': instance.physiotherapistId,
      'slots': instance.slots.map((e) => e.toJson()).toList(),
    };
