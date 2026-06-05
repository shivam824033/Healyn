// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'availability_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AvailabilityRule {

 String get id; String get physiotherapistId; int get dayOfWeek; String get startTime; String get endTime; int get slotMinutes; String get timezone; DateTime get effectiveFrom; DateTime? get effectiveTo;
/// Create a copy of AvailabilityRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvailabilityRuleCopyWith<AvailabilityRule> get copyWith => _$AvailabilityRuleCopyWithImpl<AvailabilityRule>(this as AvailabilityRule, _$identity);

  /// Serializes this AvailabilityRule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvailabilityRule&&(identical(other.id, id) || other.id == id)&&(identical(other.physiotherapistId, physiotherapistId) || other.physiotherapistId == physiotherapistId)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.slotMinutes, slotMinutes) || other.slotMinutes == slotMinutes)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.effectiveTo, effectiveTo) || other.effectiveTo == effectiveTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,physiotherapistId,dayOfWeek,startTime,endTime,slotMinutes,timezone,effectiveFrom,effectiveTo);

@override
String toString() {
  return 'AvailabilityRule(id: $id, physiotherapistId: $physiotherapistId, dayOfWeek: $dayOfWeek, startTime: $startTime, endTime: $endTime, slotMinutes: $slotMinutes, timezone: $timezone, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo)';
}


}

/// @nodoc
abstract mixin class $AvailabilityRuleCopyWith<$Res>  {
  factory $AvailabilityRuleCopyWith(AvailabilityRule value, $Res Function(AvailabilityRule) _then) = _$AvailabilityRuleCopyWithImpl;
@useResult
$Res call({
 String id, String physiotherapistId, int dayOfWeek, String startTime, String endTime, int slotMinutes, String timezone, DateTime effectiveFrom, DateTime? effectiveTo
});




}
/// @nodoc
class _$AvailabilityRuleCopyWithImpl<$Res>
    implements $AvailabilityRuleCopyWith<$Res> {
  _$AvailabilityRuleCopyWithImpl(this._self, this._then);

  final AvailabilityRule _self;
  final $Res Function(AvailabilityRule) _then;

/// Create a copy of AvailabilityRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? physiotherapistId = null,Object? dayOfWeek = null,Object? startTime = null,Object? endTime = null,Object? slotMinutes = null,Object? timezone = null,Object? effectiveFrom = null,Object? effectiveTo = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,physiotherapistId: null == physiotherapistId ? _self.physiotherapistId : physiotherapistId // ignore: cast_nullable_to_non_nullable
as String,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,slotMinutes: null == slotMinutes ? _self.slotMinutes : slotMinutes // ignore: cast_nullable_to_non_nullable
as int,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,effectiveTo: freezed == effectiveTo ? _self.effectiveTo : effectiveTo // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AvailabilityRule].
extension AvailabilityRulePatterns on AvailabilityRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvailabilityRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvailabilityRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvailabilityRule value)  $default,){
final _that = this;
switch (_that) {
case _AvailabilityRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvailabilityRule value)?  $default,){
final _that = this;
switch (_that) {
case _AvailabilityRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String physiotherapistId,  int dayOfWeek,  String startTime,  String endTime,  int slotMinutes,  String timezone,  DateTime effectiveFrom,  DateTime? effectiveTo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvailabilityRule() when $default != null:
return $default(_that.id,_that.physiotherapistId,_that.dayOfWeek,_that.startTime,_that.endTime,_that.slotMinutes,_that.timezone,_that.effectiveFrom,_that.effectiveTo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String physiotherapistId,  int dayOfWeek,  String startTime,  String endTime,  int slotMinutes,  String timezone,  DateTime effectiveFrom,  DateTime? effectiveTo)  $default,) {final _that = this;
switch (_that) {
case _AvailabilityRule():
return $default(_that.id,_that.physiotherapistId,_that.dayOfWeek,_that.startTime,_that.endTime,_that.slotMinutes,_that.timezone,_that.effectiveFrom,_that.effectiveTo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String physiotherapistId,  int dayOfWeek,  String startTime,  String endTime,  int slotMinutes,  String timezone,  DateTime effectiveFrom,  DateTime? effectiveTo)?  $default,) {final _that = this;
switch (_that) {
case _AvailabilityRule() when $default != null:
return $default(_that.id,_that.physiotherapistId,_that.dayOfWeek,_that.startTime,_that.endTime,_that.slotMinutes,_that.timezone,_that.effectiveFrom,_that.effectiveTo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AvailabilityRule implements AvailabilityRule {
  const _AvailabilityRule({required this.id, required this.physiotherapistId, required this.dayOfWeek, required this.startTime, required this.endTime, required this.slotMinutes, required this.timezone, required this.effectiveFrom, this.effectiveTo});
  factory _AvailabilityRule.fromJson(Map<String, dynamic> json) => _$AvailabilityRuleFromJson(json);

@override final  String id;
@override final  String physiotherapistId;
@override final  int dayOfWeek;
@override final  String startTime;
@override final  String endTime;
@override final  int slotMinutes;
@override final  String timezone;
@override final  DateTime effectiveFrom;
@override final  DateTime? effectiveTo;

/// Create a copy of AvailabilityRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvailabilityRuleCopyWith<_AvailabilityRule> get copyWith => __$AvailabilityRuleCopyWithImpl<_AvailabilityRule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AvailabilityRuleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvailabilityRule&&(identical(other.id, id) || other.id == id)&&(identical(other.physiotherapistId, physiotherapistId) || other.physiotherapistId == physiotherapistId)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.slotMinutes, slotMinutes) || other.slotMinutes == slotMinutes)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.effectiveTo, effectiveTo) || other.effectiveTo == effectiveTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,physiotherapistId,dayOfWeek,startTime,endTime,slotMinutes,timezone,effectiveFrom,effectiveTo);

@override
String toString() {
  return 'AvailabilityRule(id: $id, physiotherapistId: $physiotherapistId, dayOfWeek: $dayOfWeek, startTime: $startTime, endTime: $endTime, slotMinutes: $slotMinutes, timezone: $timezone, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo)';
}


}

/// @nodoc
abstract mixin class _$AvailabilityRuleCopyWith<$Res> implements $AvailabilityRuleCopyWith<$Res> {
  factory _$AvailabilityRuleCopyWith(_AvailabilityRule value, $Res Function(_AvailabilityRule) _then) = __$AvailabilityRuleCopyWithImpl;
@override @useResult
$Res call({
 String id, String physiotherapistId, int dayOfWeek, String startTime, String endTime, int slotMinutes, String timezone, DateTime effectiveFrom, DateTime? effectiveTo
});




}
/// @nodoc
class __$AvailabilityRuleCopyWithImpl<$Res>
    implements _$AvailabilityRuleCopyWith<$Res> {
  __$AvailabilityRuleCopyWithImpl(this._self, this._then);

  final _AvailabilityRule _self;
  final $Res Function(_AvailabilityRule) _then;

/// Create a copy of AvailabilityRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? physiotherapistId = null,Object? dayOfWeek = null,Object? startTime = null,Object? endTime = null,Object? slotMinutes = null,Object? timezone = null,Object? effectiveFrom = null,Object? effectiveTo = freezed,}) {
  return _then(_AvailabilityRule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,physiotherapistId: null == physiotherapistId ? _self.physiotherapistId : physiotherapistId // ignore: cast_nullable_to_non_nullable
as String,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,slotMinutes: null == slotMinutes ? _self.slotMinutes : slotMinutes // ignore: cast_nullable_to_non_nullable
as int,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,effectiveTo: freezed == effectiveTo ? _self.effectiveTo : effectiveTo // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$RuleListResponse {

 List<AvailabilityRule> get rules;
/// Create a copy of RuleListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RuleListResponseCopyWith<RuleListResponse> get copyWith => _$RuleListResponseCopyWithImpl<RuleListResponse>(this as RuleListResponse, _$identity);

  /// Serializes this RuleListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RuleListResponse&&const DeepCollectionEquality().equals(other.rules, rules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(rules));

@override
String toString() {
  return 'RuleListResponse(rules: $rules)';
}


}

/// @nodoc
abstract mixin class $RuleListResponseCopyWith<$Res>  {
  factory $RuleListResponseCopyWith(RuleListResponse value, $Res Function(RuleListResponse) _then) = _$RuleListResponseCopyWithImpl;
@useResult
$Res call({
 List<AvailabilityRule> rules
});




}
/// @nodoc
class _$RuleListResponseCopyWithImpl<$Res>
    implements $RuleListResponseCopyWith<$Res> {
  _$RuleListResponseCopyWithImpl(this._self, this._then);

  final RuleListResponse _self;
  final $Res Function(RuleListResponse) _then;

/// Create a copy of RuleListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rules = null,}) {
  return _then(_self.copyWith(
rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as List<AvailabilityRule>,
  ));
}

}


/// Adds pattern-matching-related methods to [RuleListResponse].
extension RuleListResponsePatterns on RuleListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RuleListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RuleListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RuleListResponse value)  $default,){
final _that = this;
switch (_that) {
case _RuleListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RuleListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RuleListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AvailabilityRule> rules)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RuleListResponse() when $default != null:
return $default(_that.rules);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AvailabilityRule> rules)  $default,) {final _that = this;
switch (_that) {
case _RuleListResponse():
return $default(_that.rules);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AvailabilityRule> rules)?  $default,) {final _that = this;
switch (_that) {
case _RuleListResponse() when $default != null:
return $default(_that.rules);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RuleListResponse implements RuleListResponse {
  const _RuleListResponse({required final  List<AvailabilityRule> rules}): _rules = rules;
  factory _RuleListResponse.fromJson(Map<String, dynamic> json) => _$RuleListResponseFromJson(json);

 final  List<AvailabilityRule> _rules;
@override List<AvailabilityRule> get rules {
  if (_rules is EqualUnmodifiableListView) return _rules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rules);
}


/// Create a copy of RuleListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RuleListResponseCopyWith<_RuleListResponse> get copyWith => __$RuleListResponseCopyWithImpl<_RuleListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RuleListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RuleListResponse&&const DeepCollectionEquality().equals(other._rules, _rules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_rules));

@override
String toString() {
  return 'RuleListResponse(rules: $rules)';
}


}

/// @nodoc
abstract mixin class _$RuleListResponseCopyWith<$Res> implements $RuleListResponseCopyWith<$Res> {
  factory _$RuleListResponseCopyWith(_RuleListResponse value, $Res Function(_RuleListResponse) _then) = __$RuleListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<AvailabilityRule> rules
});




}
/// @nodoc
class __$RuleListResponseCopyWithImpl<$Res>
    implements _$RuleListResponseCopyWith<$Res> {
  __$RuleListResponseCopyWithImpl(this._self, this._then);

  final _RuleListResponse _self;
  final $Res Function(_RuleListResponse) _then;

/// Create a copy of RuleListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rules = null,}) {
  return _then(_RuleListResponse(
rules: null == rules ? _self._rules : rules // ignore: cast_nullable_to_non_nullable
as List<AvailabilityRule>,
  ));
}


}


/// @nodoc
mixin _$CreateRuleRequest {

 int get dayOfWeek; String get startTime; String get endTime; int get slotMinutes; String get timezone; String get effectiveFrom; String? get effectiveTo;
/// Create a copy of CreateRuleRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateRuleRequestCopyWith<CreateRuleRequest> get copyWith => _$CreateRuleRequestCopyWithImpl<CreateRuleRequest>(this as CreateRuleRequest, _$identity);

  /// Serializes this CreateRuleRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateRuleRequest&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.slotMinutes, slotMinutes) || other.slotMinutes == slotMinutes)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.effectiveTo, effectiveTo) || other.effectiveTo == effectiveTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dayOfWeek,startTime,endTime,slotMinutes,timezone,effectiveFrom,effectiveTo);

@override
String toString() {
  return 'CreateRuleRequest(dayOfWeek: $dayOfWeek, startTime: $startTime, endTime: $endTime, slotMinutes: $slotMinutes, timezone: $timezone, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo)';
}


}

/// @nodoc
abstract mixin class $CreateRuleRequestCopyWith<$Res>  {
  factory $CreateRuleRequestCopyWith(CreateRuleRequest value, $Res Function(CreateRuleRequest) _then) = _$CreateRuleRequestCopyWithImpl;
@useResult
$Res call({
 int dayOfWeek, String startTime, String endTime, int slotMinutes, String timezone, String effectiveFrom, String? effectiveTo
});




}
/// @nodoc
class _$CreateRuleRequestCopyWithImpl<$Res>
    implements $CreateRuleRequestCopyWith<$Res> {
  _$CreateRuleRequestCopyWithImpl(this._self, this._then);

  final CreateRuleRequest _self;
  final $Res Function(CreateRuleRequest) _then;

/// Create a copy of CreateRuleRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dayOfWeek = null,Object? startTime = null,Object? endTime = null,Object? slotMinutes = null,Object? timezone = null,Object? effectiveFrom = null,Object? effectiveTo = freezed,}) {
  return _then(_self.copyWith(
dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,slotMinutes: null == slotMinutes ? _self.slotMinutes : slotMinutes // ignore: cast_nullable_to_non_nullable
as int,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as String,effectiveTo: freezed == effectiveTo ? _self.effectiveTo : effectiveTo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateRuleRequest].
extension CreateRuleRequestPatterns on CreateRuleRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateRuleRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateRuleRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateRuleRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateRuleRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateRuleRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateRuleRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int dayOfWeek,  String startTime,  String endTime,  int slotMinutes,  String timezone,  String effectiveFrom,  String? effectiveTo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateRuleRequest() when $default != null:
return $default(_that.dayOfWeek,_that.startTime,_that.endTime,_that.slotMinutes,_that.timezone,_that.effectiveFrom,_that.effectiveTo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int dayOfWeek,  String startTime,  String endTime,  int slotMinutes,  String timezone,  String effectiveFrom,  String? effectiveTo)  $default,) {final _that = this;
switch (_that) {
case _CreateRuleRequest():
return $default(_that.dayOfWeek,_that.startTime,_that.endTime,_that.slotMinutes,_that.timezone,_that.effectiveFrom,_that.effectiveTo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int dayOfWeek,  String startTime,  String endTime,  int slotMinutes,  String timezone,  String effectiveFrom,  String? effectiveTo)?  $default,) {final _that = this;
switch (_that) {
case _CreateRuleRequest() when $default != null:
return $default(_that.dayOfWeek,_that.startTime,_that.endTime,_that.slotMinutes,_that.timezone,_that.effectiveFrom,_that.effectiveTo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateRuleRequest implements CreateRuleRequest {
  const _CreateRuleRequest({required this.dayOfWeek, required this.startTime, required this.endTime, required this.slotMinutes, required this.timezone, required this.effectiveFrom, this.effectiveTo});
  factory _CreateRuleRequest.fromJson(Map<String, dynamic> json) => _$CreateRuleRequestFromJson(json);

@override final  int dayOfWeek;
@override final  String startTime;
@override final  String endTime;
@override final  int slotMinutes;
@override final  String timezone;
@override final  String effectiveFrom;
@override final  String? effectiveTo;

/// Create a copy of CreateRuleRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateRuleRequestCopyWith<_CreateRuleRequest> get copyWith => __$CreateRuleRequestCopyWithImpl<_CreateRuleRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateRuleRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateRuleRequest&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.slotMinutes, slotMinutes) || other.slotMinutes == slotMinutes)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.effectiveTo, effectiveTo) || other.effectiveTo == effectiveTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dayOfWeek,startTime,endTime,slotMinutes,timezone,effectiveFrom,effectiveTo);

@override
String toString() {
  return 'CreateRuleRequest(dayOfWeek: $dayOfWeek, startTime: $startTime, endTime: $endTime, slotMinutes: $slotMinutes, timezone: $timezone, effectiveFrom: $effectiveFrom, effectiveTo: $effectiveTo)';
}


}

/// @nodoc
abstract mixin class _$CreateRuleRequestCopyWith<$Res> implements $CreateRuleRequestCopyWith<$Res> {
  factory _$CreateRuleRequestCopyWith(_CreateRuleRequest value, $Res Function(_CreateRuleRequest) _then) = __$CreateRuleRequestCopyWithImpl;
@override @useResult
$Res call({
 int dayOfWeek, String startTime, String endTime, int slotMinutes, String timezone, String effectiveFrom, String? effectiveTo
});




}
/// @nodoc
class __$CreateRuleRequestCopyWithImpl<$Res>
    implements _$CreateRuleRequestCopyWith<$Res> {
  __$CreateRuleRequestCopyWithImpl(this._self, this._then);

  final _CreateRuleRequest _self;
  final $Res Function(_CreateRuleRequest) _then;

/// Create a copy of CreateRuleRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dayOfWeek = null,Object? startTime = null,Object? endTime = null,Object? slotMinutes = null,Object? timezone = null,Object? effectiveFrom = null,Object? effectiveTo = freezed,}) {
  return _then(_CreateRuleRequest(
dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,slotMinutes: null == slotMinutes ? _self.slotMinutes : slotMinutes // ignore: cast_nullable_to_non_nullable
as int,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as String,effectiveTo: freezed == effectiveTo ? _self.effectiveTo : effectiveTo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$BlackoutWindow {

 String get id; String get physiotherapistId; DateTime get startsAt; DateTime get endsAt; String? get reason;
/// Create a copy of BlackoutWindow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlackoutWindowCopyWith<BlackoutWindow> get copyWith => _$BlackoutWindowCopyWithImpl<BlackoutWindow>(this as BlackoutWindow, _$identity);

  /// Serializes this BlackoutWindow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlackoutWindow&&(identical(other.id, id) || other.id == id)&&(identical(other.physiotherapistId, physiotherapistId) || other.physiotherapistId == physiotherapistId)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,physiotherapistId,startsAt,endsAt,reason);

@override
String toString() {
  return 'BlackoutWindow(id: $id, physiotherapistId: $physiotherapistId, startsAt: $startsAt, endsAt: $endsAt, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $BlackoutWindowCopyWith<$Res>  {
  factory $BlackoutWindowCopyWith(BlackoutWindow value, $Res Function(BlackoutWindow) _then) = _$BlackoutWindowCopyWithImpl;
@useResult
$Res call({
 String id, String physiotherapistId, DateTime startsAt, DateTime endsAt, String? reason
});




}
/// @nodoc
class _$BlackoutWindowCopyWithImpl<$Res>
    implements $BlackoutWindowCopyWith<$Res> {
  _$BlackoutWindowCopyWithImpl(this._self, this._then);

  final BlackoutWindow _self;
  final $Res Function(BlackoutWindow) _then;

/// Create a copy of BlackoutWindow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? physiotherapistId = null,Object? startsAt = null,Object? endsAt = null,Object? reason = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,physiotherapistId: null == physiotherapistId ? _self.physiotherapistId : physiotherapistId // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BlackoutWindow].
extension BlackoutWindowPatterns on BlackoutWindow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlackoutWindow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlackoutWindow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlackoutWindow value)  $default,){
final _that = this;
switch (_that) {
case _BlackoutWindow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlackoutWindow value)?  $default,){
final _that = this;
switch (_that) {
case _BlackoutWindow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String physiotherapistId,  DateTime startsAt,  DateTime endsAt,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlackoutWindow() when $default != null:
return $default(_that.id,_that.physiotherapistId,_that.startsAt,_that.endsAt,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String physiotherapistId,  DateTime startsAt,  DateTime endsAt,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _BlackoutWindow():
return $default(_that.id,_that.physiotherapistId,_that.startsAt,_that.endsAt,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String physiotherapistId,  DateTime startsAt,  DateTime endsAt,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _BlackoutWindow() when $default != null:
return $default(_that.id,_that.physiotherapistId,_that.startsAt,_that.endsAt,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BlackoutWindow implements BlackoutWindow {
  const _BlackoutWindow({required this.id, required this.physiotherapistId, required this.startsAt, required this.endsAt, this.reason});
  factory _BlackoutWindow.fromJson(Map<String, dynamic> json) => _$BlackoutWindowFromJson(json);

@override final  String id;
@override final  String physiotherapistId;
@override final  DateTime startsAt;
@override final  DateTime endsAt;
@override final  String? reason;

/// Create a copy of BlackoutWindow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlackoutWindowCopyWith<_BlackoutWindow> get copyWith => __$BlackoutWindowCopyWithImpl<_BlackoutWindow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlackoutWindowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlackoutWindow&&(identical(other.id, id) || other.id == id)&&(identical(other.physiotherapistId, physiotherapistId) || other.physiotherapistId == physiotherapistId)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,physiotherapistId,startsAt,endsAt,reason);

@override
String toString() {
  return 'BlackoutWindow(id: $id, physiotherapistId: $physiotherapistId, startsAt: $startsAt, endsAt: $endsAt, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$BlackoutWindowCopyWith<$Res> implements $BlackoutWindowCopyWith<$Res> {
  factory _$BlackoutWindowCopyWith(_BlackoutWindow value, $Res Function(_BlackoutWindow) _then) = __$BlackoutWindowCopyWithImpl;
@override @useResult
$Res call({
 String id, String physiotherapistId, DateTime startsAt, DateTime endsAt, String? reason
});




}
/// @nodoc
class __$BlackoutWindowCopyWithImpl<$Res>
    implements _$BlackoutWindowCopyWith<$Res> {
  __$BlackoutWindowCopyWithImpl(this._self, this._then);

  final _BlackoutWindow _self;
  final $Res Function(_BlackoutWindow) _then;

/// Create a copy of BlackoutWindow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? physiotherapistId = null,Object? startsAt = null,Object? endsAt = null,Object? reason = freezed,}) {
  return _then(_BlackoutWindow(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,physiotherapistId: null == physiotherapistId ? _self.physiotherapistId : physiotherapistId // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$BlackoutListResponse {

 List<BlackoutWindow> get blackouts;
/// Create a copy of BlackoutListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlackoutListResponseCopyWith<BlackoutListResponse> get copyWith => _$BlackoutListResponseCopyWithImpl<BlackoutListResponse>(this as BlackoutListResponse, _$identity);

  /// Serializes this BlackoutListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlackoutListResponse&&const DeepCollectionEquality().equals(other.blackouts, blackouts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(blackouts));

@override
String toString() {
  return 'BlackoutListResponse(blackouts: $blackouts)';
}


}

/// @nodoc
abstract mixin class $BlackoutListResponseCopyWith<$Res>  {
  factory $BlackoutListResponseCopyWith(BlackoutListResponse value, $Res Function(BlackoutListResponse) _then) = _$BlackoutListResponseCopyWithImpl;
@useResult
$Res call({
 List<BlackoutWindow> blackouts
});




}
/// @nodoc
class _$BlackoutListResponseCopyWithImpl<$Res>
    implements $BlackoutListResponseCopyWith<$Res> {
  _$BlackoutListResponseCopyWithImpl(this._self, this._then);

  final BlackoutListResponse _self;
  final $Res Function(BlackoutListResponse) _then;

/// Create a copy of BlackoutListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? blackouts = null,}) {
  return _then(_self.copyWith(
blackouts: null == blackouts ? _self.blackouts : blackouts // ignore: cast_nullable_to_non_nullable
as List<BlackoutWindow>,
  ));
}

}


/// Adds pattern-matching-related methods to [BlackoutListResponse].
extension BlackoutListResponsePatterns on BlackoutListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BlackoutListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BlackoutListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BlackoutListResponse value)  $default,){
final _that = this;
switch (_that) {
case _BlackoutListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BlackoutListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _BlackoutListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BlackoutWindow> blackouts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BlackoutListResponse() when $default != null:
return $default(_that.blackouts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BlackoutWindow> blackouts)  $default,) {final _that = this;
switch (_that) {
case _BlackoutListResponse():
return $default(_that.blackouts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BlackoutWindow> blackouts)?  $default,) {final _that = this;
switch (_that) {
case _BlackoutListResponse() when $default != null:
return $default(_that.blackouts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BlackoutListResponse implements BlackoutListResponse {
  const _BlackoutListResponse({required final  List<BlackoutWindow> blackouts}): _blackouts = blackouts;
  factory _BlackoutListResponse.fromJson(Map<String, dynamic> json) => _$BlackoutListResponseFromJson(json);

 final  List<BlackoutWindow> _blackouts;
@override List<BlackoutWindow> get blackouts {
  if (_blackouts is EqualUnmodifiableListView) return _blackouts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_blackouts);
}


/// Create a copy of BlackoutListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlackoutListResponseCopyWith<_BlackoutListResponse> get copyWith => __$BlackoutListResponseCopyWithImpl<_BlackoutListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlackoutListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlackoutListResponse&&const DeepCollectionEquality().equals(other._blackouts, _blackouts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_blackouts));

@override
String toString() {
  return 'BlackoutListResponse(blackouts: $blackouts)';
}


}

/// @nodoc
abstract mixin class _$BlackoutListResponseCopyWith<$Res> implements $BlackoutListResponseCopyWith<$Res> {
  factory _$BlackoutListResponseCopyWith(_BlackoutListResponse value, $Res Function(_BlackoutListResponse) _then) = __$BlackoutListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<BlackoutWindow> blackouts
});




}
/// @nodoc
class __$BlackoutListResponseCopyWithImpl<$Res>
    implements _$BlackoutListResponseCopyWith<$Res> {
  __$BlackoutListResponseCopyWithImpl(this._self, this._then);

  final _BlackoutListResponse _self;
  final $Res Function(_BlackoutListResponse) _then;

/// Create a copy of BlackoutListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? blackouts = null,}) {
  return _then(_BlackoutListResponse(
blackouts: null == blackouts ? _self._blackouts : blackouts // ignore: cast_nullable_to_non_nullable
as List<BlackoutWindow>,
  ));
}


}


/// @nodoc
mixin _$CreateBlackoutRequest {

 DateTime get startsAt; DateTime get endsAt; String? get reason;
/// Create a copy of CreateBlackoutRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateBlackoutRequestCopyWith<CreateBlackoutRequest> get copyWith => _$CreateBlackoutRequestCopyWithImpl<CreateBlackoutRequest>(this as CreateBlackoutRequest, _$identity);

  /// Serializes this CreateBlackoutRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateBlackoutRequest&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startsAt,endsAt,reason);

@override
String toString() {
  return 'CreateBlackoutRequest(startsAt: $startsAt, endsAt: $endsAt, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $CreateBlackoutRequestCopyWith<$Res>  {
  factory $CreateBlackoutRequestCopyWith(CreateBlackoutRequest value, $Res Function(CreateBlackoutRequest) _then) = _$CreateBlackoutRequestCopyWithImpl;
@useResult
$Res call({
 DateTime startsAt, DateTime endsAt, String? reason
});




}
/// @nodoc
class _$CreateBlackoutRequestCopyWithImpl<$Res>
    implements $CreateBlackoutRequestCopyWith<$Res> {
  _$CreateBlackoutRequestCopyWithImpl(this._self, this._then);

  final CreateBlackoutRequest _self;
  final $Res Function(CreateBlackoutRequest) _then;

/// Create a copy of CreateBlackoutRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startsAt = null,Object? endsAt = null,Object? reason = freezed,}) {
  return _then(_self.copyWith(
startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateBlackoutRequest].
extension CreateBlackoutRequestPatterns on CreateBlackoutRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateBlackoutRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateBlackoutRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateBlackoutRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateBlackoutRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateBlackoutRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateBlackoutRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime startsAt,  DateTime endsAt,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateBlackoutRequest() when $default != null:
return $default(_that.startsAt,_that.endsAt,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime startsAt,  DateTime endsAt,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _CreateBlackoutRequest():
return $default(_that.startsAt,_that.endsAt,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime startsAt,  DateTime endsAt,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _CreateBlackoutRequest() when $default != null:
return $default(_that.startsAt,_that.endsAt,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateBlackoutRequest implements CreateBlackoutRequest {
  const _CreateBlackoutRequest({required this.startsAt, required this.endsAt, this.reason});
  factory _CreateBlackoutRequest.fromJson(Map<String, dynamic> json) => _$CreateBlackoutRequestFromJson(json);

@override final  DateTime startsAt;
@override final  DateTime endsAt;
@override final  String? reason;

/// Create a copy of CreateBlackoutRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateBlackoutRequestCopyWith<_CreateBlackoutRequest> get copyWith => __$CreateBlackoutRequestCopyWithImpl<_CreateBlackoutRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateBlackoutRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateBlackoutRequest&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startsAt,endsAt,reason);

@override
String toString() {
  return 'CreateBlackoutRequest(startsAt: $startsAt, endsAt: $endsAt, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$CreateBlackoutRequestCopyWith<$Res> implements $CreateBlackoutRequestCopyWith<$Res> {
  factory _$CreateBlackoutRequestCopyWith(_CreateBlackoutRequest value, $Res Function(_CreateBlackoutRequest) _then) = __$CreateBlackoutRequestCopyWithImpl;
@override @useResult
$Res call({
 DateTime startsAt, DateTime endsAt, String? reason
});




}
/// @nodoc
class __$CreateBlackoutRequestCopyWithImpl<$Res>
    implements _$CreateBlackoutRequestCopyWith<$Res> {
  __$CreateBlackoutRequestCopyWithImpl(this._self, this._then);

  final _CreateBlackoutRequest _self;
  final $Res Function(_CreateBlackoutRequest) _then;

/// Create a copy of CreateBlackoutRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startsAt = null,Object? endsAt = null,Object? reason = freezed,}) {
  return _then(_CreateBlackoutRequest(
startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
