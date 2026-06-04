// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fcm_token_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FcmTokenRegistration {

 String get token; String get platform; String? get deviceId;
/// Create a copy of FcmTokenRegistration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FcmTokenRegistrationCopyWith<FcmTokenRegistration> get copyWith => _$FcmTokenRegistrationCopyWithImpl<FcmTokenRegistration>(this as FcmTokenRegistration, _$identity);

  /// Serializes this FcmTokenRegistration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FcmTokenRegistration&&(identical(other.token, token) || other.token == token)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,platform,deviceId);

@override
String toString() {
  return 'FcmTokenRegistration(token: $token, platform: $platform, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class $FcmTokenRegistrationCopyWith<$Res>  {
  factory $FcmTokenRegistrationCopyWith(FcmTokenRegistration value, $Res Function(FcmTokenRegistration) _then) = _$FcmTokenRegistrationCopyWithImpl;
@useResult
$Res call({
 String token, String platform, String? deviceId
});




}
/// @nodoc
class _$FcmTokenRegistrationCopyWithImpl<$Res>
    implements $FcmTokenRegistrationCopyWith<$Res> {
  _$FcmTokenRegistrationCopyWithImpl(this._self, this._then);

  final FcmTokenRegistration _self;
  final $Res Function(FcmTokenRegistration) _then;

/// Create a copy of FcmTokenRegistration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? platform = null,Object? deviceId = freezed,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FcmTokenRegistration].
extension FcmTokenRegistrationPatterns on FcmTokenRegistration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FcmTokenRegistration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FcmTokenRegistration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FcmTokenRegistration value)  $default,){
final _that = this;
switch (_that) {
case _FcmTokenRegistration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FcmTokenRegistration value)?  $default,){
final _that = this;
switch (_that) {
case _FcmTokenRegistration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  String platform,  String? deviceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FcmTokenRegistration() when $default != null:
return $default(_that.token,_that.platform,_that.deviceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  String platform,  String? deviceId)  $default,) {final _that = this;
switch (_that) {
case _FcmTokenRegistration():
return $default(_that.token,_that.platform,_that.deviceId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  String platform,  String? deviceId)?  $default,) {final _that = this;
switch (_that) {
case _FcmTokenRegistration() when $default != null:
return $default(_that.token,_that.platform,_that.deviceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FcmTokenRegistration implements FcmTokenRegistration {
  const _FcmTokenRegistration({required this.token, required this.platform, this.deviceId});
  factory _FcmTokenRegistration.fromJson(Map<String, dynamic> json) => _$FcmTokenRegistrationFromJson(json);

@override final  String token;
@override final  String platform;
@override final  String? deviceId;

/// Create a copy of FcmTokenRegistration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FcmTokenRegistrationCopyWith<_FcmTokenRegistration> get copyWith => __$FcmTokenRegistrationCopyWithImpl<_FcmTokenRegistration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FcmTokenRegistrationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FcmTokenRegistration&&(identical(other.token, token) || other.token == token)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,platform,deviceId);

@override
String toString() {
  return 'FcmTokenRegistration(token: $token, platform: $platform, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class _$FcmTokenRegistrationCopyWith<$Res> implements $FcmTokenRegistrationCopyWith<$Res> {
  factory _$FcmTokenRegistrationCopyWith(_FcmTokenRegistration value, $Res Function(_FcmTokenRegistration) _then) = __$FcmTokenRegistrationCopyWithImpl;
@override @useResult
$Res call({
 String token, String platform, String? deviceId
});




}
/// @nodoc
class __$FcmTokenRegistrationCopyWithImpl<$Res>
    implements _$FcmTokenRegistrationCopyWith<$Res> {
  __$FcmTokenRegistrationCopyWithImpl(this._self, this._then);

  final _FcmTokenRegistration _self;
  final $Res Function(_FcmTokenRegistration) _then;

/// Create a copy of FcmTokenRegistration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? platform = null,Object? deviceId = freezed,}) {
  return _then(_FcmTokenRegistration(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
