// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appointment_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimelineEvent {

 String get appointmentId; String? get appointmentNumber; AppointmentEventType get eventType; String? get actorAccountId; AccountRole? get actorRole; String? get relatedAppointmentId; AppointmentChildKind? get childKind; AppointmentCancelReason? get cancelReason; DateTime get occurredAt;
/// Create a copy of TimelineEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimelineEventCopyWith<TimelineEvent> get copyWith => _$TimelineEventCopyWithImpl<TimelineEvent>(this as TimelineEvent, _$identity);

  /// Serializes this TimelineEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimelineEvent&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.appointmentNumber, appointmentNumber) || other.appointmentNumber == appointmentNumber)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.actorAccountId, actorAccountId) || other.actorAccountId == actorAccountId)&&(identical(other.actorRole, actorRole) || other.actorRole == actorRole)&&(identical(other.relatedAppointmentId, relatedAppointmentId) || other.relatedAppointmentId == relatedAppointmentId)&&(identical(other.childKind, childKind) || other.childKind == childKind)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appointmentId,appointmentNumber,eventType,actorAccountId,actorRole,relatedAppointmentId,childKind,cancelReason,occurredAt);

@override
String toString() {
  return 'TimelineEvent(appointmentId: $appointmentId, appointmentNumber: $appointmentNumber, eventType: $eventType, actorAccountId: $actorAccountId, actorRole: $actorRole, relatedAppointmentId: $relatedAppointmentId, childKind: $childKind, cancelReason: $cancelReason, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class $TimelineEventCopyWith<$Res>  {
  factory $TimelineEventCopyWith(TimelineEvent value, $Res Function(TimelineEvent) _then) = _$TimelineEventCopyWithImpl;
@useResult
$Res call({
 String appointmentId, String? appointmentNumber, AppointmentEventType eventType, String? actorAccountId, AccountRole? actorRole, String? relatedAppointmentId, AppointmentChildKind? childKind, AppointmentCancelReason? cancelReason, DateTime occurredAt
});




}
/// @nodoc
class _$TimelineEventCopyWithImpl<$Res>
    implements $TimelineEventCopyWith<$Res> {
  _$TimelineEventCopyWithImpl(this._self, this._then);

  final TimelineEvent _self;
  final $Res Function(TimelineEvent) _then;

/// Create a copy of TimelineEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appointmentId = null,Object? appointmentNumber = freezed,Object? eventType = null,Object? actorAccountId = freezed,Object? actorRole = freezed,Object? relatedAppointmentId = freezed,Object? childKind = freezed,Object? cancelReason = freezed,Object? occurredAt = null,}) {
  return _then(_self.copyWith(
appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,appointmentNumber: freezed == appointmentNumber ? _self.appointmentNumber : appointmentNumber // ignore: cast_nullable_to_non_nullable
as String?,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as AppointmentEventType,actorAccountId: freezed == actorAccountId ? _self.actorAccountId : actorAccountId // ignore: cast_nullable_to_non_nullable
as String?,actorRole: freezed == actorRole ? _self.actorRole : actorRole // ignore: cast_nullable_to_non_nullable
as AccountRole?,relatedAppointmentId: freezed == relatedAppointmentId ? _self.relatedAppointmentId : relatedAppointmentId // ignore: cast_nullable_to_non_nullable
as String?,childKind: freezed == childKind ? _self.childKind : childKind // ignore: cast_nullable_to_non_nullable
as AppointmentChildKind?,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as AppointmentCancelReason?,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TimelineEvent].
extension TimelineEventPatterns on TimelineEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimelineEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimelineEvent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimelineEvent value)  $default,){
final _that = this;
switch (_that) {
case _TimelineEvent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimelineEvent value)?  $default,){
final _that = this;
switch (_that) {
case _TimelineEvent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String appointmentId,  String? appointmentNumber,  AppointmentEventType eventType,  String? actorAccountId,  AccountRole? actorRole,  String? relatedAppointmentId,  AppointmentChildKind? childKind,  AppointmentCancelReason? cancelReason,  DateTime occurredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimelineEvent() when $default != null:
return $default(_that.appointmentId,_that.appointmentNumber,_that.eventType,_that.actorAccountId,_that.actorRole,_that.relatedAppointmentId,_that.childKind,_that.cancelReason,_that.occurredAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String appointmentId,  String? appointmentNumber,  AppointmentEventType eventType,  String? actorAccountId,  AccountRole? actorRole,  String? relatedAppointmentId,  AppointmentChildKind? childKind,  AppointmentCancelReason? cancelReason,  DateTime occurredAt)  $default,) {final _that = this;
switch (_that) {
case _TimelineEvent():
return $default(_that.appointmentId,_that.appointmentNumber,_that.eventType,_that.actorAccountId,_that.actorRole,_that.relatedAppointmentId,_that.childKind,_that.cancelReason,_that.occurredAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String appointmentId,  String? appointmentNumber,  AppointmentEventType eventType,  String? actorAccountId,  AccountRole? actorRole,  String? relatedAppointmentId,  AppointmentChildKind? childKind,  AppointmentCancelReason? cancelReason,  DateTime occurredAt)?  $default,) {final _that = this;
switch (_that) {
case _TimelineEvent() when $default != null:
return $default(_that.appointmentId,_that.appointmentNumber,_that.eventType,_that.actorAccountId,_that.actorRole,_that.relatedAppointmentId,_that.childKind,_that.cancelReason,_that.occurredAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimelineEvent implements TimelineEvent {
  const _TimelineEvent({required this.appointmentId, this.appointmentNumber, required this.eventType, this.actorAccountId, this.actorRole, this.relatedAppointmentId, this.childKind, this.cancelReason, required this.occurredAt});
  factory _TimelineEvent.fromJson(Map<String, dynamic> json) => _$TimelineEventFromJson(json);

@override final  String appointmentId;
@override final  String? appointmentNumber;
@override final  AppointmentEventType eventType;
@override final  String? actorAccountId;
@override final  AccountRole? actorRole;
@override final  String? relatedAppointmentId;
@override final  AppointmentChildKind? childKind;
@override final  AppointmentCancelReason? cancelReason;
@override final  DateTime occurredAt;

/// Create a copy of TimelineEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimelineEventCopyWith<_TimelineEvent> get copyWith => __$TimelineEventCopyWithImpl<_TimelineEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimelineEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimelineEvent&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.appointmentNumber, appointmentNumber) || other.appointmentNumber == appointmentNumber)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.actorAccountId, actorAccountId) || other.actorAccountId == actorAccountId)&&(identical(other.actorRole, actorRole) || other.actorRole == actorRole)&&(identical(other.relatedAppointmentId, relatedAppointmentId) || other.relatedAppointmentId == relatedAppointmentId)&&(identical(other.childKind, childKind) || other.childKind == childKind)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appointmentId,appointmentNumber,eventType,actorAccountId,actorRole,relatedAppointmentId,childKind,cancelReason,occurredAt);

@override
String toString() {
  return 'TimelineEvent(appointmentId: $appointmentId, appointmentNumber: $appointmentNumber, eventType: $eventType, actorAccountId: $actorAccountId, actorRole: $actorRole, relatedAppointmentId: $relatedAppointmentId, childKind: $childKind, cancelReason: $cancelReason, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class _$TimelineEventCopyWith<$Res> implements $TimelineEventCopyWith<$Res> {
  factory _$TimelineEventCopyWith(_TimelineEvent value, $Res Function(_TimelineEvent) _then) = __$TimelineEventCopyWithImpl;
@override @useResult
$Res call({
 String appointmentId, String? appointmentNumber, AppointmentEventType eventType, String? actorAccountId, AccountRole? actorRole, String? relatedAppointmentId, AppointmentChildKind? childKind, AppointmentCancelReason? cancelReason, DateTime occurredAt
});




}
/// @nodoc
class __$TimelineEventCopyWithImpl<$Res>
    implements _$TimelineEventCopyWith<$Res> {
  __$TimelineEventCopyWithImpl(this._self, this._then);

  final _TimelineEvent _self;
  final $Res Function(_TimelineEvent) _then;

/// Create a copy of TimelineEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appointmentId = null,Object? appointmentNumber = freezed,Object? eventType = null,Object? actorAccountId = freezed,Object? actorRole = freezed,Object? relatedAppointmentId = freezed,Object? childKind = freezed,Object? cancelReason = freezed,Object? occurredAt = null,}) {
  return _then(_TimelineEvent(
appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,appointmentNumber: freezed == appointmentNumber ? _self.appointmentNumber : appointmentNumber // ignore: cast_nullable_to_non_nullable
as String?,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as AppointmentEventType,actorAccountId: freezed == actorAccountId ? _self.actorAccountId : actorAccountId // ignore: cast_nullable_to_non_nullable
as String?,actorRole: freezed == actorRole ? _self.actorRole : actorRole // ignore: cast_nullable_to_non_nullable
as AccountRole?,relatedAppointmentId: freezed == relatedAppointmentId ? _self.relatedAppointmentId : relatedAppointmentId // ignore: cast_nullable_to_non_nullable
as String?,childKind: freezed == childKind ? _self.childKind : childKind // ignore: cast_nullable_to_non_nullable
as AppointmentChildKind?,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as AppointmentCancelReason?,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Appointment {

 String get id; String? get appointmentNumber; String get patientId; String get bookedByAccountId; String get physiotherapistId;@LocalDateConverter() DateTime get requestedDate; String? get preferredTime; DateTime? get scheduledAt; DateTime? get scheduledEndAt; int get durationMinutes; AppointmentStatus get status; bool get isFollowUp; String? get reason; AppointmentCancelReason? get cancelReason; String? get cancelNote; String? get rescheduledFromId; String? get rootAppointmentId; String? get sourceAppointmentId; AppointmentChildKind? get childKind; DateTime? get confirmedAt; DateTime? get startedAt; DateTime? get completedAt; DateTime? get cancelledAt; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentCopyWith<Appointment> get copyWith => _$AppointmentCopyWithImpl<Appointment>(this as Appointment, _$identity);

  /// Serializes this Appointment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Appointment&&(identical(other.id, id) || other.id == id)&&(identical(other.appointmentNumber, appointmentNumber) || other.appointmentNumber == appointmentNumber)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.bookedByAccountId, bookedByAccountId) || other.bookedByAccountId == bookedByAccountId)&&(identical(other.physiotherapistId, physiotherapistId) || other.physiotherapistId == physiotherapistId)&&(identical(other.requestedDate, requestedDate) || other.requestedDate == requestedDate)&&(identical(other.preferredTime, preferredTime) || other.preferredTime == preferredTime)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.scheduledEndAt, scheduledEndAt) || other.scheduledEndAt == scheduledEndAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.status, status) || other.status == status)&&(identical(other.isFollowUp, isFollowUp) || other.isFollowUp == isFollowUp)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.cancelNote, cancelNote) || other.cancelNote == cancelNote)&&(identical(other.rescheduledFromId, rescheduledFromId) || other.rescheduledFromId == rescheduledFromId)&&(identical(other.rootAppointmentId, rootAppointmentId) || other.rootAppointmentId == rootAppointmentId)&&(identical(other.sourceAppointmentId, sourceAppointmentId) || other.sourceAppointmentId == sourceAppointmentId)&&(identical(other.childKind, childKind) || other.childKind == childKind)&&(identical(other.confirmedAt, confirmedAt) || other.confirmedAt == confirmedAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,appointmentNumber,patientId,bookedByAccountId,physiotherapistId,requestedDate,preferredTime,scheduledAt,scheduledEndAt,durationMinutes,status,isFollowUp,reason,cancelReason,cancelNote,rescheduledFromId,rootAppointmentId,sourceAppointmentId,childKind,confirmedAt,startedAt,completedAt,cancelledAt,createdAt,updatedAt]);

@override
String toString() {
  return 'Appointment(id: $id, appointmentNumber: $appointmentNumber, patientId: $patientId, bookedByAccountId: $bookedByAccountId, physiotherapistId: $physiotherapistId, requestedDate: $requestedDate, preferredTime: $preferredTime, scheduledAt: $scheduledAt, scheduledEndAt: $scheduledEndAt, durationMinutes: $durationMinutes, status: $status, isFollowUp: $isFollowUp, reason: $reason, cancelReason: $cancelReason, cancelNote: $cancelNote, rescheduledFromId: $rescheduledFromId, rootAppointmentId: $rootAppointmentId, sourceAppointmentId: $sourceAppointmentId, childKind: $childKind, confirmedAt: $confirmedAt, startedAt: $startedAt, completedAt: $completedAt, cancelledAt: $cancelledAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AppointmentCopyWith<$Res>  {
  factory $AppointmentCopyWith(Appointment value, $Res Function(Appointment) _then) = _$AppointmentCopyWithImpl;
@useResult
$Res call({
 String id, String? appointmentNumber, String patientId, String bookedByAccountId, String physiotherapistId,@LocalDateConverter() DateTime requestedDate, String? preferredTime, DateTime? scheduledAt, DateTime? scheduledEndAt, int durationMinutes, AppointmentStatus status, bool isFollowUp, String? reason, AppointmentCancelReason? cancelReason, String? cancelNote, String? rescheduledFromId, String? rootAppointmentId, String? sourceAppointmentId, AppointmentChildKind? childKind, DateTime? confirmedAt, DateTime? startedAt, DateTime? completedAt, DateTime? cancelledAt, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$AppointmentCopyWithImpl<$Res>
    implements $AppointmentCopyWith<$Res> {
  _$AppointmentCopyWithImpl(this._self, this._then);

  final Appointment _self;
  final $Res Function(Appointment) _then;

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? appointmentNumber = freezed,Object? patientId = null,Object? bookedByAccountId = null,Object? physiotherapistId = null,Object? requestedDate = null,Object? preferredTime = freezed,Object? scheduledAt = freezed,Object? scheduledEndAt = freezed,Object? durationMinutes = null,Object? status = null,Object? isFollowUp = null,Object? reason = freezed,Object? cancelReason = freezed,Object? cancelNote = freezed,Object? rescheduledFromId = freezed,Object? rootAppointmentId = freezed,Object? sourceAppointmentId = freezed,Object? childKind = freezed,Object? confirmedAt = freezed,Object? startedAt = freezed,Object? completedAt = freezed,Object? cancelledAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,appointmentNumber: freezed == appointmentNumber ? _self.appointmentNumber : appointmentNumber // ignore: cast_nullable_to_non_nullable
as String?,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,bookedByAccountId: null == bookedByAccountId ? _self.bookedByAccountId : bookedByAccountId // ignore: cast_nullable_to_non_nullable
as String,physiotherapistId: null == physiotherapistId ? _self.physiotherapistId : physiotherapistId // ignore: cast_nullable_to_non_nullable
as String,requestedDate: null == requestedDate ? _self.requestedDate : requestedDate // ignore: cast_nullable_to_non_nullable
as DateTime,preferredTime: freezed == preferredTime ? _self.preferredTime : preferredTime // ignore: cast_nullable_to_non_nullable
as String?,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,scheduledEndAt: freezed == scheduledEndAt ? _self.scheduledEndAt : scheduledEndAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AppointmentStatus,isFollowUp: null == isFollowUp ? _self.isFollowUp : isFollowUp // ignore: cast_nullable_to_non_nullable
as bool,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as AppointmentCancelReason?,cancelNote: freezed == cancelNote ? _self.cancelNote : cancelNote // ignore: cast_nullable_to_non_nullable
as String?,rescheduledFromId: freezed == rescheduledFromId ? _self.rescheduledFromId : rescheduledFromId // ignore: cast_nullable_to_non_nullable
as String?,rootAppointmentId: freezed == rootAppointmentId ? _self.rootAppointmentId : rootAppointmentId // ignore: cast_nullable_to_non_nullable
as String?,sourceAppointmentId: freezed == sourceAppointmentId ? _self.sourceAppointmentId : sourceAppointmentId // ignore: cast_nullable_to_non_nullable
as String?,childKind: freezed == childKind ? _self.childKind : childKind // ignore: cast_nullable_to_non_nullable
as AppointmentChildKind?,confirmedAt: freezed == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Appointment].
extension AppointmentPatterns on Appointment {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Appointment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Appointment() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Appointment value)  $default,){
final _that = this;
switch (_that) {
case _Appointment():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Appointment value)?  $default,){
final _that = this;
switch (_that) {
case _Appointment() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? appointmentNumber,  String patientId,  String bookedByAccountId,  String physiotherapistId, @LocalDateConverter()  DateTime requestedDate,  String? preferredTime,  DateTime? scheduledAt,  DateTime? scheduledEndAt,  int durationMinutes,  AppointmentStatus status,  bool isFollowUp,  String? reason,  AppointmentCancelReason? cancelReason,  String? cancelNote,  String? rescheduledFromId,  String? rootAppointmentId,  String? sourceAppointmentId,  AppointmentChildKind? childKind,  DateTime? confirmedAt,  DateTime? startedAt,  DateTime? completedAt,  DateTime? cancelledAt,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Appointment() when $default != null:
return $default(_that.id,_that.appointmentNumber,_that.patientId,_that.bookedByAccountId,_that.physiotherapistId,_that.requestedDate,_that.preferredTime,_that.scheduledAt,_that.scheduledEndAt,_that.durationMinutes,_that.status,_that.isFollowUp,_that.reason,_that.cancelReason,_that.cancelNote,_that.rescheduledFromId,_that.rootAppointmentId,_that.sourceAppointmentId,_that.childKind,_that.confirmedAt,_that.startedAt,_that.completedAt,_that.cancelledAt,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? appointmentNumber,  String patientId,  String bookedByAccountId,  String physiotherapistId, @LocalDateConverter()  DateTime requestedDate,  String? preferredTime,  DateTime? scheduledAt,  DateTime? scheduledEndAt,  int durationMinutes,  AppointmentStatus status,  bool isFollowUp,  String? reason,  AppointmentCancelReason? cancelReason,  String? cancelNote,  String? rescheduledFromId,  String? rootAppointmentId,  String? sourceAppointmentId,  AppointmentChildKind? childKind,  DateTime? confirmedAt,  DateTime? startedAt,  DateTime? completedAt,  DateTime? cancelledAt,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Appointment():
return $default(_that.id,_that.appointmentNumber,_that.patientId,_that.bookedByAccountId,_that.physiotherapistId,_that.requestedDate,_that.preferredTime,_that.scheduledAt,_that.scheduledEndAt,_that.durationMinutes,_that.status,_that.isFollowUp,_that.reason,_that.cancelReason,_that.cancelNote,_that.rescheduledFromId,_that.rootAppointmentId,_that.sourceAppointmentId,_that.childKind,_that.confirmedAt,_that.startedAt,_that.completedAt,_that.cancelledAt,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? appointmentNumber,  String patientId,  String bookedByAccountId,  String physiotherapistId, @LocalDateConverter()  DateTime requestedDate,  String? preferredTime,  DateTime? scheduledAt,  DateTime? scheduledEndAt,  int durationMinutes,  AppointmentStatus status,  bool isFollowUp,  String? reason,  AppointmentCancelReason? cancelReason,  String? cancelNote,  String? rescheduledFromId,  String? rootAppointmentId,  String? sourceAppointmentId,  AppointmentChildKind? childKind,  DateTime? confirmedAt,  DateTime? startedAt,  DateTime? completedAt,  DateTime? cancelledAt,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Appointment() when $default != null:
return $default(_that.id,_that.appointmentNumber,_that.patientId,_that.bookedByAccountId,_that.physiotherapistId,_that.requestedDate,_that.preferredTime,_that.scheduledAt,_that.scheduledEndAt,_that.durationMinutes,_that.status,_that.isFollowUp,_that.reason,_that.cancelReason,_that.cancelNote,_that.rescheduledFromId,_that.rootAppointmentId,_that.sourceAppointmentId,_that.childKind,_that.confirmedAt,_that.startedAt,_that.completedAt,_that.cancelledAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Appointment implements Appointment {
  const _Appointment({required this.id, this.appointmentNumber, required this.patientId, required this.bookedByAccountId, required this.physiotherapistId, @LocalDateConverter() required this.requestedDate, this.preferredTime, this.scheduledAt, this.scheduledEndAt, required this.durationMinutes, required this.status, this.isFollowUp = false, this.reason, this.cancelReason, this.cancelNote, this.rescheduledFromId, this.rootAppointmentId, this.sourceAppointmentId, this.childKind, this.confirmedAt, this.startedAt, this.completedAt, this.cancelledAt, this.createdAt, this.updatedAt});
  factory _Appointment.fromJson(Map<String, dynamic> json) => _$AppointmentFromJson(json);

@override final  String id;
@override final  String? appointmentNumber;
@override final  String patientId;
@override final  String bookedByAccountId;
@override final  String physiotherapistId;
@override@LocalDateConverter() final  DateTime requestedDate;
@override final  String? preferredTime;
@override final  DateTime? scheduledAt;
@override final  DateTime? scheduledEndAt;
@override final  int durationMinutes;
@override final  AppointmentStatus status;
@override@JsonKey() final  bool isFollowUp;
@override final  String? reason;
@override final  AppointmentCancelReason? cancelReason;
@override final  String? cancelNote;
@override final  String? rescheduledFromId;
@override final  String? rootAppointmentId;
@override final  String? sourceAppointmentId;
@override final  AppointmentChildKind? childKind;
@override final  DateTime? confirmedAt;
@override final  DateTime? startedAt;
@override final  DateTime? completedAt;
@override final  DateTime? cancelledAt;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentCopyWith<_Appointment> get copyWith => __$AppointmentCopyWithImpl<_Appointment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppointmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Appointment&&(identical(other.id, id) || other.id == id)&&(identical(other.appointmentNumber, appointmentNumber) || other.appointmentNumber == appointmentNumber)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.bookedByAccountId, bookedByAccountId) || other.bookedByAccountId == bookedByAccountId)&&(identical(other.physiotherapistId, physiotherapistId) || other.physiotherapistId == physiotherapistId)&&(identical(other.requestedDate, requestedDate) || other.requestedDate == requestedDate)&&(identical(other.preferredTime, preferredTime) || other.preferredTime == preferredTime)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.scheduledEndAt, scheduledEndAt) || other.scheduledEndAt == scheduledEndAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.status, status) || other.status == status)&&(identical(other.isFollowUp, isFollowUp) || other.isFollowUp == isFollowUp)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.cancelNote, cancelNote) || other.cancelNote == cancelNote)&&(identical(other.rescheduledFromId, rescheduledFromId) || other.rescheduledFromId == rescheduledFromId)&&(identical(other.rootAppointmentId, rootAppointmentId) || other.rootAppointmentId == rootAppointmentId)&&(identical(other.sourceAppointmentId, sourceAppointmentId) || other.sourceAppointmentId == sourceAppointmentId)&&(identical(other.childKind, childKind) || other.childKind == childKind)&&(identical(other.confirmedAt, confirmedAt) || other.confirmedAt == confirmedAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,appointmentNumber,patientId,bookedByAccountId,physiotherapistId,requestedDate,preferredTime,scheduledAt,scheduledEndAt,durationMinutes,status,isFollowUp,reason,cancelReason,cancelNote,rescheduledFromId,rootAppointmentId,sourceAppointmentId,childKind,confirmedAt,startedAt,completedAt,cancelledAt,createdAt,updatedAt]);

@override
String toString() {
  return 'Appointment(id: $id, appointmentNumber: $appointmentNumber, patientId: $patientId, bookedByAccountId: $bookedByAccountId, physiotherapistId: $physiotherapistId, requestedDate: $requestedDate, preferredTime: $preferredTime, scheduledAt: $scheduledAt, scheduledEndAt: $scheduledEndAt, durationMinutes: $durationMinutes, status: $status, isFollowUp: $isFollowUp, reason: $reason, cancelReason: $cancelReason, cancelNote: $cancelNote, rescheduledFromId: $rescheduledFromId, rootAppointmentId: $rootAppointmentId, sourceAppointmentId: $sourceAppointmentId, childKind: $childKind, confirmedAt: $confirmedAt, startedAt: $startedAt, completedAt: $completedAt, cancelledAt: $cancelledAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AppointmentCopyWith<$Res> implements $AppointmentCopyWith<$Res> {
  factory _$AppointmentCopyWith(_Appointment value, $Res Function(_Appointment) _then) = __$AppointmentCopyWithImpl;
@override @useResult
$Res call({
 String id, String? appointmentNumber, String patientId, String bookedByAccountId, String physiotherapistId,@LocalDateConverter() DateTime requestedDate, String? preferredTime, DateTime? scheduledAt, DateTime? scheduledEndAt, int durationMinutes, AppointmentStatus status, bool isFollowUp, String? reason, AppointmentCancelReason? cancelReason, String? cancelNote, String? rescheduledFromId, String? rootAppointmentId, String? sourceAppointmentId, AppointmentChildKind? childKind, DateTime? confirmedAt, DateTime? startedAt, DateTime? completedAt, DateTime? cancelledAt, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$AppointmentCopyWithImpl<$Res>
    implements _$AppointmentCopyWith<$Res> {
  __$AppointmentCopyWithImpl(this._self, this._then);

  final _Appointment _self;
  final $Res Function(_Appointment) _then;

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? appointmentNumber = freezed,Object? patientId = null,Object? bookedByAccountId = null,Object? physiotherapistId = null,Object? requestedDate = null,Object? preferredTime = freezed,Object? scheduledAt = freezed,Object? scheduledEndAt = freezed,Object? durationMinutes = null,Object? status = null,Object? isFollowUp = null,Object? reason = freezed,Object? cancelReason = freezed,Object? cancelNote = freezed,Object? rescheduledFromId = freezed,Object? rootAppointmentId = freezed,Object? sourceAppointmentId = freezed,Object? childKind = freezed,Object? confirmedAt = freezed,Object? startedAt = freezed,Object? completedAt = freezed,Object? cancelledAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Appointment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,appointmentNumber: freezed == appointmentNumber ? _self.appointmentNumber : appointmentNumber // ignore: cast_nullable_to_non_nullable
as String?,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,bookedByAccountId: null == bookedByAccountId ? _self.bookedByAccountId : bookedByAccountId // ignore: cast_nullable_to_non_nullable
as String,physiotherapistId: null == physiotherapistId ? _self.physiotherapistId : physiotherapistId // ignore: cast_nullable_to_non_nullable
as String,requestedDate: null == requestedDate ? _self.requestedDate : requestedDate // ignore: cast_nullable_to_non_nullable
as DateTime,preferredTime: freezed == preferredTime ? _self.preferredTime : preferredTime // ignore: cast_nullable_to_non_nullable
as String?,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,scheduledEndAt: freezed == scheduledEndAt ? _self.scheduledEndAt : scheduledEndAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AppointmentStatus,isFollowUp: null == isFollowUp ? _self.isFollowUp : isFollowUp // ignore: cast_nullable_to_non_nullable
as bool,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as AppointmentCancelReason?,cancelNote: freezed == cancelNote ? _self.cancelNote : cancelNote // ignore: cast_nullable_to_non_nullable
as String?,rescheduledFromId: freezed == rescheduledFromId ? _self.rescheduledFromId : rescheduledFromId // ignore: cast_nullable_to_non_nullable
as String?,rootAppointmentId: freezed == rootAppointmentId ? _self.rootAppointmentId : rootAppointmentId // ignore: cast_nullable_to_non_nullable
as String?,sourceAppointmentId: freezed == sourceAppointmentId ? _self.sourceAppointmentId : sourceAppointmentId // ignore: cast_nullable_to_non_nullable
as String?,childKind: freezed == childKind ? _self.childKind : childKind // ignore: cast_nullable_to_non_nullable
as AppointmentChildKind?,confirmedAt: freezed == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AppointmentSuggestion {

 String get appointmentId; String? get appointmentNumber; String get patientId; String? get patientName; String? get patientNumber; AppointmentStatus get status; DateTime? get scheduledAt;@LocalDateConverter() DateTime get requestedDate;
/// Create a copy of AppointmentSuggestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentSuggestionCopyWith<AppointmentSuggestion> get copyWith => _$AppointmentSuggestionCopyWithImpl<AppointmentSuggestion>(this as AppointmentSuggestion, _$identity);

  /// Serializes this AppointmentSuggestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentSuggestion&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.appointmentNumber, appointmentNumber) || other.appointmentNumber == appointmentNumber)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.patientNumber, patientNumber) || other.patientNumber == patientNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.requestedDate, requestedDate) || other.requestedDate == requestedDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appointmentId,appointmentNumber,patientId,patientName,patientNumber,status,scheduledAt,requestedDate);

@override
String toString() {
  return 'AppointmentSuggestion(appointmentId: $appointmentId, appointmentNumber: $appointmentNumber, patientId: $patientId, patientName: $patientName, patientNumber: $patientNumber, status: $status, scheduledAt: $scheduledAt, requestedDate: $requestedDate)';
}


}

/// @nodoc
abstract mixin class $AppointmentSuggestionCopyWith<$Res>  {
  factory $AppointmentSuggestionCopyWith(AppointmentSuggestion value, $Res Function(AppointmentSuggestion) _then) = _$AppointmentSuggestionCopyWithImpl;
@useResult
$Res call({
 String appointmentId, String? appointmentNumber, String patientId, String? patientName, String? patientNumber, AppointmentStatus status, DateTime? scheduledAt,@LocalDateConverter() DateTime requestedDate
});




}
/// @nodoc
class _$AppointmentSuggestionCopyWithImpl<$Res>
    implements $AppointmentSuggestionCopyWith<$Res> {
  _$AppointmentSuggestionCopyWithImpl(this._self, this._then);

  final AppointmentSuggestion _self;
  final $Res Function(AppointmentSuggestion) _then;

/// Create a copy of AppointmentSuggestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appointmentId = null,Object? appointmentNumber = freezed,Object? patientId = null,Object? patientName = freezed,Object? patientNumber = freezed,Object? status = null,Object? scheduledAt = freezed,Object? requestedDate = null,}) {
  return _then(_self.copyWith(
appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,appointmentNumber: freezed == appointmentNumber ? _self.appointmentNumber : appointmentNumber // ignore: cast_nullable_to_non_nullable
as String?,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,patientName: freezed == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String?,patientNumber: freezed == patientNumber ? _self.patientNumber : patientNumber // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AppointmentStatus,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,requestedDate: null == requestedDate ? _self.requestedDate : requestedDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AppointmentSuggestion].
extension AppointmentSuggestionPatterns on AppointmentSuggestion {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppointmentSuggestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppointmentSuggestion() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppointmentSuggestion value)  $default,){
final _that = this;
switch (_that) {
case _AppointmentSuggestion():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppointmentSuggestion value)?  $default,){
final _that = this;
switch (_that) {
case _AppointmentSuggestion() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String appointmentId,  String? appointmentNumber,  String patientId,  String? patientName,  String? patientNumber,  AppointmentStatus status,  DateTime? scheduledAt, @LocalDateConverter()  DateTime requestedDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppointmentSuggestion() when $default != null:
return $default(_that.appointmentId,_that.appointmentNumber,_that.patientId,_that.patientName,_that.patientNumber,_that.status,_that.scheduledAt,_that.requestedDate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String appointmentId,  String? appointmentNumber,  String patientId,  String? patientName,  String? patientNumber,  AppointmentStatus status,  DateTime? scheduledAt, @LocalDateConverter()  DateTime requestedDate)  $default,) {final _that = this;
switch (_that) {
case _AppointmentSuggestion():
return $default(_that.appointmentId,_that.appointmentNumber,_that.patientId,_that.patientName,_that.patientNumber,_that.status,_that.scheduledAt,_that.requestedDate);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String appointmentId,  String? appointmentNumber,  String patientId,  String? patientName,  String? patientNumber,  AppointmentStatus status,  DateTime? scheduledAt, @LocalDateConverter()  DateTime requestedDate)?  $default,) {final _that = this;
switch (_that) {
case _AppointmentSuggestion() when $default != null:
return $default(_that.appointmentId,_that.appointmentNumber,_that.patientId,_that.patientName,_that.patientNumber,_that.status,_that.scheduledAt,_that.requestedDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppointmentSuggestion implements AppointmentSuggestion {
  const _AppointmentSuggestion({required this.appointmentId, this.appointmentNumber, required this.patientId, this.patientName, this.patientNumber, required this.status, this.scheduledAt, @LocalDateConverter() required this.requestedDate});
  factory _AppointmentSuggestion.fromJson(Map<String, dynamic> json) => _$AppointmentSuggestionFromJson(json);

@override final  String appointmentId;
@override final  String? appointmentNumber;
@override final  String patientId;
@override final  String? patientName;
@override final  String? patientNumber;
@override final  AppointmentStatus status;
@override final  DateTime? scheduledAt;
@override@LocalDateConverter() final  DateTime requestedDate;

/// Create a copy of AppointmentSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentSuggestionCopyWith<_AppointmentSuggestion> get copyWith => __$AppointmentSuggestionCopyWithImpl<_AppointmentSuggestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppointmentSuggestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppointmentSuggestion&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.appointmentNumber, appointmentNumber) || other.appointmentNumber == appointmentNumber)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.patientNumber, patientNumber) || other.patientNumber == patientNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.requestedDate, requestedDate) || other.requestedDate == requestedDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appointmentId,appointmentNumber,patientId,patientName,patientNumber,status,scheduledAt,requestedDate);

@override
String toString() {
  return 'AppointmentSuggestion(appointmentId: $appointmentId, appointmentNumber: $appointmentNumber, patientId: $patientId, patientName: $patientName, patientNumber: $patientNumber, status: $status, scheduledAt: $scheduledAt, requestedDate: $requestedDate)';
}


}

/// @nodoc
abstract mixin class _$AppointmentSuggestionCopyWith<$Res> implements $AppointmentSuggestionCopyWith<$Res> {
  factory _$AppointmentSuggestionCopyWith(_AppointmentSuggestion value, $Res Function(_AppointmentSuggestion) _then) = __$AppointmentSuggestionCopyWithImpl;
@override @useResult
$Res call({
 String appointmentId, String? appointmentNumber, String patientId, String? patientName, String? patientNumber, AppointmentStatus status, DateTime? scheduledAt,@LocalDateConverter() DateTime requestedDate
});




}
/// @nodoc
class __$AppointmentSuggestionCopyWithImpl<$Res>
    implements _$AppointmentSuggestionCopyWith<$Res> {
  __$AppointmentSuggestionCopyWithImpl(this._self, this._then);

  final _AppointmentSuggestion _self;
  final $Res Function(_AppointmentSuggestion) _then;

/// Create a copy of AppointmentSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appointmentId = null,Object? appointmentNumber = freezed,Object? patientId = null,Object? patientName = freezed,Object? patientNumber = freezed,Object? status = null,Object? scheduledAt = freezed,Object? requestedDate = null,}) {
  return _then(_AppointmentSuggestion(
appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,appointmentNumber: freezed == appointmentNumber ? _self.appointmentNumber : appointmentNumber // ignore: cast_nullable_to_non_nullable
as String?,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,patientName: freezed == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String?,patientNumber: freezed == patientNumber ? _self.patientNumber : patientNumber // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AppointmentStatus,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,requestedDate: null == requestedDate ? _self.requestedDate : requestedDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$AppointmentPage {

 List<Appointment> get items; String? get nextCursor;
/// Create a copy of AppointmentPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentPageCopyWith<AppointmentPage> get copyWith => _$AppointmentPageCopyWithImpl<AppointmentPage>(this as AppointmentPage, _$identity);

  /// Serializes this AppointmentPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextCursor);

@override
String toString() {
  return 'AppointmentPage(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $AppointmentPageCopyWith<$Res>  {
  factory $AppointmentPageCopyWith(AppointmentPage value, $Res Function(AppointmentPage) _then) = _$AppointmentPageCopyWithImpl;
@useResult
$Res call({
 List<Appointment> items, String? nextCursor
});




}
/// @nodoc
class _$AppointmentPageCopyWithImpl<$Res>
    implements $AppointmentPageCopyWith<$Res> {
  _$AppointmentPageCopyWithImpl(this._self, this._then);

  final AppointmentPage _self;
  final $Res Function(AppointmentPage) _then;

/// Create a copy of AppointmentPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Appointment>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppointmentPage].
extension AppointmentPagePatterns on AppointmentPage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppointmentPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppointmentPage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppointmentPage value)  $default,){
final _that = this;
switch (_that) {
case _AppointmentPage():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppointmentPage value)?  $default,){
final _that = this;
switch (_that) {
case _AppointmentPage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Appointment> items,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppointmentPage() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Appointment> items,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _AppointmentPage():
return $default(_that.items,_that.nextCursor);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Appointment> items,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _AppointmentPage() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppointmentPage implements AppointmentPage {
  const _AppointmentPage({required final  List<Appointment> items, this.nextCursor}): _items = items;
  factory _AppointmentPage.fromJson(Map<String, dynamic> json) => _$AppointmentPageFromJson(json);

 final  List<Appointment> _items;
@override List<Appointment> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String? nextCursor;

/// Create a copy of AppointmentPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentPageCopyWith<_AppointmentPage> get copyWith => __$AppointmentPageCopyWithImpl<_AppointmentPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppointmentPageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppointmentPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);

@override
String toString() {
  return 'AppointmentPage(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$AppointmentPageCopyWith<$Res> implements $AppointmentPageCopyWith<$Res> {
  factory _$AppointmentPageCopyWith(_AppointmentPage value, $Res Function(_AppointmentPage) _then) = __$AppointmentPageCopyWithImpl;
@override @useResult
$Res call({
 List<Appointment> items, String? nextCursor
});




}
/// @nodoc
class __$AppointmentPageCopyWithImpl<$Res>
    implements _$AppointmentPageCopyWith<$Res> {
  __$AppointmentPageCopyWithImpl(this._self, this._then);

  final _AppointmentPage _self;
  final $Res Function(_AppointmentPage) _then;

/// Create a copy of AppointmentPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_AppointmentPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Appointment>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$BookAppointmentRequest {

 String get patientId;@LocalDateConverter() DateTime get requestedDate; String? get preferredTime; String? get reason;
/// Create a copy of BookAppointmentRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookAppointmentRequestCopyWith<BookAppointmentRequest> get copyWith => _$BookAppointmentRequestCopyWithImpl<BookAppointmentRequest>(this as BookAppointmentRequest, _$identity);

  /// Serializes this BookAppointmentRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookAppointmentRequest&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.requestedDate, requestedDate) || other.requestedDate == requestedDate)&&(identical(other.preferredTime, preferredTime) || other.preferredTime == preferredTime)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,patientId,requestedDate,preferredTime,reason);

@override
String toString() {
  return 'BookAppointmentRequest(patientId: $patientId, requestedDate: $requestedDate, preferredTime: $preferredTime, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $BookAppointmentRequestCopyWith<$Res>  {
  factory $BookAppointmentRequestCopyWith(BookAppointmentRequest value, $Res Function(BookAppointmentRequest) _then) = _$BookAppointmentRequestCopyWithImpl;
@useResult
$Res call({
 String patientId,@LocalDateConverter() DateTime requestedDate, String? preferredTime, String? reason
});




}
/// @nodoc
class _$BookAppointmentRequestCopyWithImpl<$Res>
    implements $BookAppointmentRequestCopyWith<$Res> {
  _$BookAppointmentRequestCopyWithImpl(this._self, this._then);

  final BookAppointmentRequest _self;
  final $Res Function(BookAppointmentRequest) _then;

/// Create a copy of BookAppointmentRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? patientId = null,Object? requestedDate = null,Object? preferredTime = freezed,Object? reason = freezed,}) {
  return _then(_self.copyWith(
patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,requestedDate: null == requestedDate ? _self.requestedDate : requestedDate // ignore: cast_nullable_to_non_nullable
as DateTime,preferredTime: freezed == preferredTime ? _self.preferredTime : preferredTime // ignore: cast_nullable_to_non_nullable
as String?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookAppointmentRequest].
extension BookAppointmentRequestPatterns on BookAppointmentRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookAppointmentRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookAppointmentRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookAppointmentRequest value)  $default,){
final _that = this;
switch (_that) {
case _BookAppointmentRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookAppointmentRequest value)?  $default,){
final _that = this;
switch (_that) {
case _BookAppointmentRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String patientId, @LocalDateConverter()  DateTime requestedDate,  String? preferredTime,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookAppointmentRequest() when $default != null:
return $default(_that.patientId,_that.requestedDate,_that.preferredTime,_that.reason);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String patientId, @LocalDateConverter()  DateTime requestedDate,  String? preferredTime,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _BookAppointmentRequest():
return $default(_that.patientId,_that.requestedDate,_that.preferredTime,_that.reason);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String patientId, @LocalDateConverter()  DateTime requestedDate,  String? preferredTime,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _BookAppointmentRequest() when $default != null:
return $default(_that.patientId,_that.requestedDate,_that.preferredTime,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookAppointmentRequest implements BookAppointmentRequest {
  const _BookAppointmentRequest({required this.patientId, @LocalDateConverter() required this.requestedDate, this.preferredTime, this.reason});
  factory _BookAppointmentRequest.fromJson(Map<String, dynamic> json) => _$BookAppointmentRequestFromJson(json);

@override final  String patientId;
@override@LocalDateConverter() final  DateTime requestedDate;
@override final  String? preferredTime;
@override final  String? reason;

/// Create a copy of BookAppointmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookAppointmentRequestCopyWith<_BookAppointmentRequest> get copyWith => __$BookAppointmentRequestCopyWithImpl<_BookAppointmentRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookAppointmentRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookAppointmentRequest&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.requestedDate, requestedDate) || other.requestedDate == requestedDate)&&(identical(other.preferredTime, preferredTime) || other.preferredTime == preferredTime)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,patientId,requestedDate,preferredTime,reason);

@override
String toString() {
  return 'BookAppointmentRequest(patientId: $patientId, requestedDate: $requestedDate, preferredTime: $preferredTime, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$BookAppointmentRequestCopyWith<$Res> implements $BookAppointmentRequestCopyWith<$Res> {
  factory _$BookAppointmentRequestCopyWith(_BookAppointmentRequest value, $Res Function(_BookAppointmentRequest) _then) = __$BookAppointmentRequestCopyWithImpl;
@override @useResult
$Res call({
 String patientId,@LocalDateConverter() DateTime requestedDate, String? preferredTime, String? reason
});




}
/// @nodoc
class __$BookAppointmentRequestCopyWithImpl<$Res>
    implements _$BookAppointmentRequestCopyWith<$Res> {
  __$BookAppointmentRequestCopyWithImpl(this._self, this._then);

  final _BookAppointmentRequest _self;
  final $Res Function(_BookAppointmentRequest) _then;

/// Create a copy of BookAppointmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? patientId = null,Object? requestedDate = null,Object? preferredTime = freezed,Object? reason = freezed,}) {
  return _then(_BookAppointmentRequest(
patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,requestedDate: null == requestedDate ? _self.requestedDate : requestedDate // ignore: cast_nullable_to_non_nullable
as DateTime,preferredTime: freezed == preferredTime ? _self.preferredTime : preferredTime // ignore: cast_nullable_to_non_nullable
as String?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RescheduleAppointmentRequest {

@LocalDateConverter() DateTime get requestedDate; String? get preferredTime; String? get reason;
/// Create a copy of RescheduleAppointmentRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RescheduleAppointmentRequestCopyWith<RescheduleAppointmentRequest> get copyWith => _$RescheduleAppointmentRequestCopyWithImpl<RescheduleAppointmentRequest>(this as RescheduleAppointmentRequest, _$identity);

  /// Serializes this RescheduleAppointmentRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RescheduleAppointmentRequest&&(identical(other.requestedDate, requestedDate) || other.requestedDate == requestedDate)&&(identical(other.preferredTime, preferredTime) || other.preferredTime == preferredTime)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestedDate,preferredTime,reason);

@override
String toString() {
  return 'RescheduleAppointmentRequest(requestedDate: $requestedDate, preferredTime: $preferredTime, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $RescheduleAppointmentRequestCopyWith<$Res>  {
  factory $RescheduleAppointmentRequestCopyWith(RescheduleAppointmentRequest value, $Res Function(RescheduleAppointmentRequest) _then) = _$RescheduleAppointmentRequestCopyWithImpl;
@useResult
$Res call({
@LocalDateConverter() DateTime requestedDate, String? preferredTime, String? reason
});




}
/// @nodoc
class _$RescheduleAppointmentRequestCopyWithImpl<$Res>
    implements $RescheduleAppointmentRequestCopyWith<$Res> {
  _$RescheduleAppointmentRequestCopyWithImpl(this._self, this._then);

  final RescheduleAppointmentRequest _self;
  final $Res Function(RescheduleAppointmentRequest) _then;

/// Create a copy of RescheduleAppointmentRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requestedDate = null,Object? preferredTime = freezed,Object? reason = freezed,}) {
  return _then(_self.copyWith(
requestedDate: null == requestedDate ? _self.requestedDate : requestedDate // ignore: cast_nullable_to_non_nullable
as DateTime,preferredTime: freezed == preferredTime ? _self.preferredTime : preferredTime // ignore: cast_nullable_to_non_nullable
as String?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RescheduleAppointmentRequest].
extension RescheduleAppointmentRequestPatterns on RescheduleAppointmentRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RescheduleAppointmentRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RescheduleAppointmentRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RescheduleAppointmentRequest value)  $default,){
final _that = this;
switch (_that) {
case _RescheduleAppointmentRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RescheduleAppointmentRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RescheduleAppointmentRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@LocalDateConverter()  DateTime requestedDate,  String? preferredTime,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RescheduleAppointmentRequest() when $default != null:
return $default(_that.requestedDate,_that.preferredTime,_that.reason);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@LocalDateConverter()  DateTime requestedDate,  String? preferredTime,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _RescheduleAppointmentRequest():
return $default(_that.requestedDate,_that.preferredTime,_that.reason);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@LocalDateConverter()  DateTime requestedDate,  String? preferredTime,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _RescheduleAppointmentRequest() when $default != null:
return $default(_that.requestedDate,_that.preferredTime,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RescheduleAppointmentRequest implements RescheduleAppointmentRequest {
  const _RescheduleAppointmentRequest({@LocalDateConverter() required this.requestedDate, this.preferredTime, this.reason});
  factory _RescheduleAppointmentRequest.fromJson(Map<String, dynamic> json) => _$RescheduleAppointmentRequestFromJson(json);

@override@LocalDateConverter() final  DateTime requestedDate;
@override final  String? preferredTime;
@override final  String? reason;

/// Create a copy of RescheduleAppointmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RescheduleAppointmentRequestCopyWith<_RescheduleAppointmentRequest> get copyWith => __$RescheduleAppointmentRequestCopyWithImpl<_RescheduleAppointmentRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RescheduleAppointmentRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RescheduleAppointmentRequest&&(identical(other.requestedDate, requestedDate) || other.requestedDate == requestedDate)&&(identical(other.preferredTime, preferredTime) || other.preferredTime == preferredTime)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requestedDate,preferredTime,reason);

@override
String toString() {
  return 'RescheduleAppointmentRequest(requestedDate: $requestedDate, preferredTime: $preferredTime, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$RescheduleAppointmentRequestCopyWith<$Res> implements $RescheduleAppointmentRequestCopyWith<$Res> {
  factory _$RescheduleAppointmentRequestCopyWith(_RescheduleAppointmentRequest value, $Res Function(_RescheduleAppointmentRequest) _then) = __$RescheduleAppointmentRequestCopyWithImpl;
@override @useResult
$Res call({
@LocalDateConverter() DateTime requestedDate, String? preferredTime, String? reason
});




}
/// @nodoc
class __$RescheduleAppointmentRequestCopyWithImpl<$Res>
    implements _$RescheduleAppointmentRequestCopyWith<$Res> {
  __$RescheduleAppointmentRequestCopyWithImpl(this._self, this._then);

  final _RescheduleAppointmentRequest _self;
  final $Res Function(_RescheduleAppointmentRequest) _then;

/// Create a copy of RescheduleAppointmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requestedDate = null,Object? preferredTime = freezed,Object? reason = freezed,}) {
  return _then(_RescheduleAppointmentRequest(
requestedDate: null == requestedDate ? _self.requestedDate : requestedDate // ignore: cast_nullable_to_non_nullable
as DateTime,preferredTime: freezed == preferredTime ? _self.preferredTime : preferredTime // ignore: cast_nullable_to_non_nullable
as String?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ScheduleAppointmentRequest {

@UtcInstantConverter() DateTime get scheduledAt; int get durationMinutes;
/// Create a copy of ScheduleAppointmentRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleAppointmentRequestCopyWith<ScheduleAppointmentRequest> get copyWith => _$ScheduleAppointmentRequestCopyWithImpl<ScheduleAppointmentRequest>(this as ScheduleAppointmentRequest, _$identity);

  /// Serializes this ScheduleAppointmentRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleAppointmentRequest&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scheduledAt,durationMinutes);

@override
String toString() {
  return 'ScheduleAppointmentRequest(scheduledAt: $scheduledAt, durationMinutes: $durationMinutes)';
}


}

/// @nodoc
abstract mixin class $ScheduleAppointmentRequestCopyWith<$Res>  {
  factory $ScheduleAppointmentRequestCopyWith(ScheduleAppointmentRequest value, $Res Function(ScheduleAppointmentRequest) _then) = _$ScheduleAppointmentRequestCopyWithImpl;
@useResult
$Res call({
@UtcInstantConverter() DateTime scheduledAt, int durationMinutes
});




}
/// @nodoc
class _$ScheduleAppointmentRequestCopyWithImpl<$Res>
    implements $ScheduleAppointmentRequestCopyWith<$Res> {
  _$ScheduleAppointmentRequestCopyWithImpl(this._self, this._then);

  final ScheduleAppointmentRequest _self;
  final $Res Function(ScheduleAppointmentRequest) _then;

/// Create a copy of ScheduleAppointmentRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scheduledAt = null,Object? durationMinutes = null,}) {
  return _then(_self.copyWith(
scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleAppointmentRequest].
extension ScheduleAppointmentRequestPatterns on ScheduleAppointmentRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleAppointmentRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleAppointmentRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleAppointmentRequest value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleAppointmentRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleAppointmentRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleAppointmentRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@UtcInstantConverter()  DateTime scheduledAt,  int durationMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleAppointmentRequest() when $default != null:
return $default(_that.scheduledAt,_that.durationMinutes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@UtcInstantConverter()  DateTime scheduledAt,  int durationMinutes)  $default,) {final _that = this;
switch (_that) {
case _ScheduleAppointmentRequest():
return $default(_that.scheduledAt,_that.durationMinutes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@UtcInstantConverter()  DateTime scheduledAt,  int durationMinutes)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleAppointmentRequest() when $default != null:
return $default(_that.scheduledAt,_that.durationMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleAppointmentRequest implements ScheduleAppointmentRequest {
  const _ScheduleAppointmentRequest({@UtcInstantConverter() required this.scheduledAt, required this.durationMinutes});
  factory _ScheduleAppointmentRequest.fromJson(Map<String, dynamic> json) => _$ScheduleAppointmentRequestFromJson(json);

@override@UtcInstantConverter() final  DateTime scheduledAt;
@override final  int durationMinutes;

/// Create a copy of ScheduleAppointmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleAppointmentRequestCopyWith<_ScheduleAppointmentRequest> get copyWith => __$ScheduleAppointmentRequestCopyWithImpl<_ScheduleAppointmentRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleAppointmentRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleAppointmentRequest&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scheduledAt,durationMinutes);

@override
String toString() {
  return 'ScheduleAppointmentRequest(scheduledAt: $scheduledAt, durationMinutes: $durationMinutes)';
}


}

/// @nodoc
abstract mixin class _$ScheduleAppointmentRequestCopyWith<$Res> implements $ScheduleAppointmentRequestCopyWith<$Res> {
  factory _$ScheduleAppointmentRequestCopyWith(_ScheduleAppointmentRequest value, $Res Function(_ScheduleAppointmentRequest) _then) = __$ScheduleAppointmentRequestCopyWithImpl;
@override @useResult
$Res call({
@UtcInstantConverter() DateTime scheduledAt, int durationMinutes
});




}
/// @nodoc
class __$ScheduleAppointmentRequestCopyWithImpl<$Res>
    implements _$ScheduleAppointmentRequestCopyWith<$Res> {
  __$ScheduleAppointmentRequestCopyWithImpl(this._self, this._then);

  final _ScheduleAppointmentRequest _self;
  final $Res Function(_ScheduleAppointmentRequest) _then;

/// Create a copy of ScheduleAppointmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scheduledAt = null,Object? durationMinutes = null,}) {
  return _then(_ScheduleAppointmentRequest(
scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$FollowUpRequest {

 String get patientId;@UtcInstantConverter() DateTime get scheduledAt; int get durationMinutes; String? get reason;
/// Create a copy of FollowUpRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FollowUpRequestCopyWith<FollowUpRequest> get copyWith => _$FollowUpRequestCopyWithImpl<FollowUpRequest>(this as FollowUpRequest, _$identity);

  /// Serializes this FollowUpRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowUpRequest&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,patientId,scheduledAt,durationMinutes,reason);

@override
String toString() {
  return 'FollowUpRequest(patientId: $patientId, scheduledAt: $scheduledAt, durationMinutes: $durationMinutes, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $FollowUpRequestCopyWith<$Res>  {
  factory $FollowUpRequestCopyWith(FollowUpRequest value, $Res Function(FollowUpRequest) _then) = _$FollowUpRequestCopyWithImpl;
@useResult
$Res call({
 String patientId,@UtcInstantConverter() DateTime scheduledAt, int durationMinutes, String? reason
});




}
/// @nodoc
class _$FollowUpRequestCopyWithImpl<$Res>
    implements $FollowUpRequestCopyWith<$Res> {
  _$FollowUpRequestCopyWithImpl(this._self, this._then);

  final FollowUpRequest _self;
  final $Res Function(FollowUpRequest) _then;

/// Create a copy of FollowUpRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? patientId = null,Object? scheduledAt = null,Object? durationMinutes = null,Object? reason = freezed,}) {
  return _then(_self.copyWith(
patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FollowUpRequest].
extension FollowUpRequestPatterns on FollowUpRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FollowUpRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FollowUpRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FollowUpRequest value)  $default,){
final _that = this;
switch (_that) {
case _FollowUpRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FollowUpRequest value)?  $default,){
final _that = this;
switch (_that) {
case _FollowUpRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String patientId, @UtcInstantConverter()  DateTime scheduledAt,  int durationMinutes,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FollowUpRequest() when $default != null:
return $default(_that.patientId,_that.scheduledAt,_that.durationMinutes,_that.reason);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String patientId, @UtcInstantConverter()  DateTime scheduledAt,  int durationMinutes,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _FollowUpRequest():
return $default(_that.patientId,_that.scheduledAt,_that.durationMinutes,_that.reason);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String patientId, @UtcInstantConverter()  DateTime scheduledAt,  int durationMinutes,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _FollowUpRequest() when $default != null:
return $default(_that.patientId,_that.scheduledAt,_that.durationMinutes,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FollowUpRequest implements FollowUpRequest {
  const _FollowUpRequest({required this.patientId, @UtcInstantConverter() required this.scheduledAt, required this.durationMinutes, this.reason});
  factory _FollowUpRequest.fromJson(Map<String, dynamic> json) => _$FollowUpRequestFromJson(json);

@override final  String patientId;
@override@UtcInstantConverter() final  DateTime scheduledAt;
@override final  int durationMinutes;
@override final  String? reason;

/// Create a copy of FollowUpRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FollowUpRequestCopyWith<_FollowUpRequest> get copyWith => __$FollowUpRequestCopyWithImpl<_FollowUpRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FollowUpRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FollowUpRequest&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,patientId,scheduledAt,durationMinutes,reason);

@override
String toString() {
  return 'FollowUpRequest(patientId: $patientId, scheduledAt: $scheduledAt, durationMinutes: $durationMinutes, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$FollowUpRequestCopyWith<$Res> implements $FollowUpRequestCopyWith<$Res> {
  factory _$FollowUpRequestCopyWith(_FollowUpRequest value, $Res Function(_FollowUpRequest) _then) = __$FollowUpRequestCopyWithImpl;
@override @useResult
$Res call({
 String patientId,@UtcInstantConverter() DateTime scheduledAt, int durationMinutes, String? reason
});




}
/// @nodoc
class __$FollowUpRequestCopyWithImpl<$Res>
    implements _$FollowUpRequestCopyWith<$Res> {
  __$FollowUpRequestCopyWithImpl(this._self, this._then);

  final _FollowUpRequest _self;
  final $Res Function(_FollowUpRequest) _then;

/// Create a copy of FollowUpRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? patientId = null,Object? scheduledAt = null,Object? durationMinutes = null,Object? reason = freezed,}) {
  return _then(_FollowUpRequest(
patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PhysioRescheduleRequest {

@UtcInstantConverter() DateTime get scheduledAt; int get durationMinutes; String? get reason;
/// Create a copy of PhysioRescheduleRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhysioRescheduleRequestCopyWith<PhysioRescheduleRequest> get copyWith => _$PhysioRescheduleRequestCopyWithImpl<PhysioRescheduleRequest>(this as PhysioRescheduleRequest, _$identity);

  /// Serializes this PhysioRescheduleRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhysioRescheduleRequest&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scheduledAt,durationMinutes,reason);

@override
String toString() {
  return 'PhysioRescheduleRequest(scheduledAt: $scheduledAt, durationMinutes: $durationMinutes, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $PhysioRescheduleRequestCopyWith<$Res>  {
  factory $PhysioRescheduleRequestCopyWith(PhysioRescheduleRequest value, $Res Function(PhysioRescheduleRequest) _then) = _$PhysioRescheduleRequestCopyWithImpl;
@useResult
$Res call({
@UtcInstantConverter() DateTime scheduledAt, int durationMinutes, String? reason
});




}
/// @nodoc
class _$PhysioRescheduleRequestCopyWithImpl<$Res>
    implements $PhysioRescheduleRequestCopyWith<$Res> {
  _$PhysioRescheduleRequestCopyWithImpl(this._self, this._then);

  final PhysioRescheduleRequest _self;
  final $Res Function(PhysioRescheduleRequest) _then;

/// Create a copy of PhysioRescheduleRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scheduledAt = null,Object? durationMinutes = null,Object? reason = freezed,}) {
  return _then(_self.copyWith(
scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PhysioRescheduleRequest].
extension PhysioRescheduleRequestPatterns on PhysioRescheduleRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhysioRescheduleRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhysioRescheduleRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhysioRescheduleRequest value)  $default,){
final _that = this;
switch (_that) {
case _PhysioRescheduleRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhysioRescheduleRequest value)?  $default,){
final _that = this;
switch (_that) {
case _PhysioRescheduleRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@UtcInstantConverter()  DateTime scheduledAt,  int durationMinutes,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhysioRescheduleRequest() when $default != null:
return $default(_that.scheduledAt,_that.durationMinutes,_that.reason);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@UtcInstantConverter()  DateTime scheduledAt,  int durationMinutes,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _PhysioRescheduleRequest():
return $default(_that.scheduledAt,_that.durationMinutes,_that.reason);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@UtcInstantConverter()  DateTime scheduledAt,  int durationMinutes,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _PhysioRescheduleRequest() when $default != null:
return $default(_that.scheduledAt,_that.durationMinutes,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PhysioRescheduleRequest implements PhysioRescheduleRequest {
  const _PhysioRescheduleRequest({@UtcInstantConverter() required this.scheduledAt, required this.durationMinutes, this.reason});
  factory _PhysioRescheduleRequest.fromJson(Map<String, dynamic> json) => _$PhysioRescheduleRequestFromJson(json);

@override@UtcInstantConverter() final  DateTime scheduledAt;
@override final  int durationMinutes;
@override final  String? reason;

/// Create a copy of PhysioRescheduleRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhysioRescheduleRequestCopyWith<_PhysioRescheduleRequest> get copyWith => __$PhysioRescheduleRequestCopyWithImpl<_PhysioRescheduleRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhysioRescheduleRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhysioRescheduleRequest&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scheduledAt,durationMinutes,reason);

@override
String toString() {
  return 'PhysioRescheduleRequest(scheduledAt: $scheduledAt, durationMinutes: $durationMinutes, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$PhysioRescheduleRequestCopyWith<$Res> implements $PhysioRescheduleRequestCopyWith<$Res> {
  factory _$PhysioRescheduleRequestCopyWith(_PhysioRescheduleRequest value, $Res Function(_PhysioRescheduleRequest) _then) = __$PhysioRescheduleRequestCopyWithImpl;
@override @useResult
$Res call({
@UtcInstantConverter() DateTime scheduledAt, int durationMinutes, String? reason
});




}
/// @nodoc
class __$PhysioRescheduleRequestCopyWithImpl<$Res>
    implements _$PhysioRescheduleRequestCopyWith<$Res> {
  __$PhysioRescheduleRequestCopyWithImpl(this._self, this._then);

  final _PhysioRescheduleRequest _self;
  final $Res Function(_PhysioRescheduleRequest) _then;

/// Create a copy of PhysioRescheduleRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scheduledAt = null,Object? durationMinutes = null,Object? reason = freezed,}) {
  return _then(_PhysioRescheduleRequest(
scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TransitionRequest {

 AppointmentStatus get to; AppointmentCancelReason? get cancelReason; String? get cancelNote;
/// Create a copy of TransitionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransitionRequestCopyWith<TransitionRequest> get copyWith => _$TransitionRequestCopyWithImpl<TransitionRequest>(this as TransitionRequest, _$identity);

  /// Serializes this TransitionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransitionRequest&&(identical(other.to, to) || other.to == to)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.cancelNote, cancelNote) || other.cancelNote == cancelNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,to,cancelReason,cancelNote);

@override
String toString() {
  return 'TransitionRequest(to: $to, cancelReason: $cancelReason, cancelNote: $cancelNote)';
}


}

/// @nodoc
abstract mixin class $TransitionRequestCopyWith<$Res>  {
  factory $TransitionRequestCopyWith(TransitionRequest value, $Res Function(TransitionRequest) _then) = _$TransitionRequestCopyWithImpl;
@useResult
$Res call({
 AppointmentStatus to, AppointmentCancelReason? cancelReason, String? cancelNote
});




}
/// @nodoc
class _$TransitionRequestCopyWithImpl<$Res>
    implements $TransitionRequestCopyWith<$Res> {
  _$TransitionRequestCopyWithImpl(this._self, this._then);

  final TransitionRequest _self;
  final $Res Function(TransitionRequest) _then;

/// Create a copy of TransitionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? to = null,Object? cancelReason = freezed,Object? cancelNote = freezed,}) {
  return _then(_self.copyWith(
to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as AppointmentStatus,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as AppointmentCancelReason?,cancelNote: freezed == cancelNote ? _self.cancelNote : cancelNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransitionRequest].
extension TransitionRequestPatterns on TransitionRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransitionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransitionRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransitionRequest value)  $default,){
final _that = this;
switch (_that) {
case _TransitionRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransitionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _TransitionRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppointmentStatus to,  AppointmentCancelReason? cancelReason,  String? cancelNote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransitionRequest() when $default != null:
return $default(_that.to,_that.cancelReason,_that.cancelNote);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppointmentStatus to,  AppointmentCancelReason? cancelReason,  String? cancelNote)  $default,) {final _that = this;
switch (_that) {
case _TransitionRequest():
return $default(_that.to,_that.cancelReason,_that.cancelNote);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppointmentStatus to,  AppointmentCancelReason? cancelReason,  String? cancelNote)?  $default,) {final _that = this;
switch (_that) {
case _TransitionRequest() when $default != null:
return $default(_that.to,_that.cancelReason,_that.cancelNote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransitionRequest implements TransitionRequest {
  const _TransitionRequest({required this.to, this.cancelReason, this.cancelNote});
  factory _TransitionRequest.fromJson(Map<String, dynamic> json) => _$TransitionRequestFromJson(json);

@override final  AppointmentStatus to;
@override final  AppointmentCancelReason? cancelReason;
@override final  String? cancelNote;

/// Create a copy of TransitionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransitionRequestCopyWith<_TransitionRequest> get copyWith => __$TransitionRequestCopyWithImpl<_TransitionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransitionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransitionRequest&&(identical(other.to, to) || other.to == to)&&(identical(other.cancelReason, cancelReason) || other.cancelReason == cancelReason)&&(identical(other.cancelNote, cancelNote) || other.cancelNote == cancelNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,to,cancelReason,cancelNote);

@override
String toString() {
  return 'TransitionRequest(to: $to, cancelReason: $cancelReason, cancelNote: $cancelNote)';
}


}

/// @nodoc
abstract mixin class _$TransitionRequestCopyWith<$Res> implements $TransitionRequestCopyWith<$Res> {
  factory _$TransitionRequestCopyWith(_TransitionRequest value, $Res Function(_TransitionRequest) _then) = __$TransitionRequestCopyWithImpl;
@override @useResult
$Res call({
 AppointmentStatus to, AppointmentCancelReason? cancelReason, String? cancelNote
});




}
/// @nodoc
class __$TransitionRequestCopyWithImpl<$Res>
    implements _$TransitionRequestCopyWith<$Res> {
  __$TransitionRequestCopyWithImpl(this._self, this._then);

  final _TransitionRequest _self;
  final $Res Function(_TransitionRequest) _then;

/// Create a copy of TransitionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? to = null,Object? cancelReason = freezed,Object? cancelNote = freezed,}) {
  return _then(_TransitionRequest(
to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as AppointmentStatus,cancelReason: freezed == cancelReason ? _self.cancelReason : cancelReason // ignore: cast_nullable_to_non_nullable
as AppointmentCancelReason?,cancelNote: freezed == cancelNote ? _self.cancelNote : cancelNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Slot {

 DateTime get startsAt; DateTime get endsAt; int get durationMinutes;
/// Create a copy of Slot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlotCopyWith<Slot> get copyWith => _$SlotCopyWithImpl<Slot>(this as Slot, _$identity);

  /// Serializes this Slot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Slot&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startsAt,endsAt,durationMinutes);

@override
String toString() {
  return 'Slot(startsAt: $startsAt, endsAt: $endsAt, durationMinutes: $durationMinutes)';
}


}

/// @nodoc
abstract mixin class $SlotCopyWith<$Res>  {
  factory $SlotCopyWith(Slot value, $Res Function(Slot) _then) = _$SlotCopyWithImpl;
@useResult
$Res call({
 DateTime startsAt, DateTime endsAt, int durationMinutes
});




}
/// @nodoc
class _$SlotCopyWithImpl<$Res>
    implements $SlotCopyWith<$Res> {
  _$SlotCopyWithImpl(this._self, this._then);

  final Slot _self;
  final $Res Function(Slot) _then;

/// Create a copy of Slot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startsAt = null,Object? endsAt = null,Object? durationMinutes = null,}) {
  return _then(_self.copyWith(
startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Slot].
extension SlotPatterns on Slot {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Slot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Slot() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Slot value)  $default,){
final _that = this;
switch (_that) {
case _Slot():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Slot value)?  $default,){
final _that = this;
switch (_that) {
case _Slot() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime startsAt,  DateTime endsAt,  int durationMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Slot() when $default != null:
return $default(_that.startsAt,_that.endsAt,_that.durationMinutes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime startsAt,  DateTime endsAt,  int durationMinutes)  $default,) {final _that = this;
switch (_that) {
case _Slot():
return $default(_that.startsAt,_that.endsAt,_that.durationMinutes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime startsAt,  DateTime endsAt,  int durationMinutes)?  $default,) {final _that = this;
switch (_that) {
case _Slot() when $default != null:
return $default(_that.startsAt,_that.endsAt,_that.durationMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Slot implements Slot {
  const _Slot({required this.startsAt, required this.endsAt, required this.durationMinutes});
  factory _Slot.fromJson(Map<String, dynamic> json) => _$SlotFromJson(json);

@override final  DateTime startsAt;
@override final  DateTime endsAt;
@override final  int durationMinutes;

/// Create a copy of Slot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SlotCopyWith<_Slot> get copyWith => __$SlotCopyWithImpl<_Slot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SlotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Slot&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startsAt,endsAt,durationMinutes);

@override
String toString() {
  return 'Slot(startsAt: $startsAt, endsAt: $endsAt, durationMinutes: $durationMinutes)';
}


}

/// @nodoc
abstract mixin class _$SlotCopyWith<$Res> implements $SlotCopyWith<$Res> {
  factory _$SlotCopyWith(_Slot value, $Res Function(_Slot) _then) = __$SlotCopyWithImpl;
@override @useResult
$Res call({
 DateTime startsAt, DateTime endsAt, int durationMinutes
});




}
/// @nodoc
class __$SlotCopyWithImpl<$Res>
    implements _$SlotCopyWith<$Res> {
  __$SlotCopyWithImpl(this._self, this._then);

  final _Slot _self;
  final $Res Function(_Slot) _then;

/// Create a copy of Slot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startsAt = null,Object? endsAt = null,Object? durationMinutes = null,}) {
  return _then(_Slot(
startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SlotListResponse {

 String get physiotherapistId; List<Slot> get slots;
/// Create a copy of SlotListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlotListResponseCopyWith<SlotListResponse> get copyWith => _$SlotListResponseCopyWithImpl<SlotListResponse>(this as SlotListResponse, _$identity);

  /// Serializes this SlotListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SlotListResponse&&(identical(other.physiotherapistId, physiotherapistId) || other.physiotherapistId == physiotherapistId)&&const DeepCollectionEquality().equals(other.slots, slots));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,physiotherapistId,const DeepCollectionEquality().hash(slots));

@override
String toString() {
  return 'SlotListResponse(physiotherapistId: $physiotherapistId, slots: $slots)';
}


}

/// @nodoc
abstract mixin class $SlotListResponseCopyWith<$Res>  {
  factory $SlotListResponseCopyWith(SlotListResponse value, $Res Function(SlotListResponse) _then) = _$SlotListResponseCopyWithImpl;
@useResult
$Res call({
 String physiotherapistId, List<Slot> slots
});




}
/// @nodoc
class _$SlotListResponseCopyWithImpl<$Res>
    implements $SlotListResponseCopyWith<$Res> {
  _$SlotListResponseCopyWithImpl(this._self, this._then);

  final SlotListResponse _self;
  final $Res Function(SlotListResponse) _then;

/// Create a copy of SlotListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? physiotherapistId = null,Object? slots = null,}) {
  return _then(_self.copyWith(
physiotherapistId: null == physiotherapistId ? _self.physiotherapistId : physiotherapistId // ignore: cast_nullable_to_non_nullable
as String,slots: null == slots ? _self.slots : slots // ignore: cast_nullable_to_non_nullable
as List<Slot>,
  ));
}

}


/// Adds pattern-matching-related methods to [SlotListResponse].
extension SlotListResponsePatterns on SlotListResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SlotListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SlotListResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SlotListResponse value)  $default,){
final _that = this;
switch (_that) {
case _SlotListResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SlotListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SlotListResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String physiotherapistId,  List<Slot> slots)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SlotListResponse() when $default != null:
return $default(_that.physiotherapistId,_that.slots);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String physiotherapistId,  List<Slot> slots)  $default,) {final _that = this;
switch (_that) {
case _SlotListResponse():
return $default(_that.physiotherapistId,_that.slots);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String physiotherapistId,  List<Slot> slots)?  $default,) {final _that = this;
switch (_that) {
case _SlotListResponse() when $default != null:
return $default(_that.physiotherapistId,_that.slots);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SlotListResponse implements SlotListResponse {
  const _SlotListResponse({required this.physiotherapistId, required final  List<Slot> slots}): _slots = slots;
  factory _SlotListResponse.fromJson(Map<String, dynamic> json) => _$SlotListResponseFromJson(json);

@override final  String physiotherapistId;
 final  List<Slot> _slots;
@override List<Slot> get slots {
  if (_slots is EqualUnmodifiableListView) return _slots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slots);
}


/// Create a copy of SlotListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SlotListResponseCopyWith<_SlotListResponse> get copyWith => __$SlotListResponseCopyWithImpl<_SlotListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SlotListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SlotListResponse&&(identical(other.physiotherapistId, physiotherapistId) || other.physiotherapistId == physiotherapistId)&&const DeepCollectionEquality().equals(other._slots, _slots));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,physiotherapistId,const DeepCollectionEquality().hash(_slots));

@override
String toString() {
  return 'SlotListResponse(physiotherapistId: $physiotherapistId, slots: $slots)';
}


}

/// @nodoc
abstract mixin class _$SlotListResponseCopyWith<$Res> implements $SlotListResponseCopyWith<$Res> {
  factory _$SlotListResponseCopyWith(_SlotListResponse value, $Res Function(_SlotListResponse) _then) = __$SlotListResponseCopyWithImpl;
@override @useResult
$Res call({
 String physiotherapistId, List<Slot> slots
});




}
/// @nodoc
class __$SlotListResponseCopyWithImpl<$Res>
    implements _$SlotListResponseCopyWith<$Res> {
  __$SlotListResponseCopyWithImpl(this._self, this._then);

  final _SlotListResponse _self;
  final $Res Function(_SlotListResponse) _then;

/// Create a copy of SlotListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? physiotherapistId = null,Object? slots = null,}) {
  return _then(_SlotListResponse(
physiotherapistId: null == physiotherapistId ? _self.physiotherapistId : physiotherapistId // ignore: cast_nullable_to_non_nullable
as String,slots: null == slots ? _self._slots : slots // ignore: cast_nullable_to_non_nullable
as List<Slot>,
  ));
}


}

// dart format on
