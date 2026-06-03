// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContactTarget {

 String? get email; String? get phone;
/// Create a copy of ContactTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactTargetCopyWith<ContactTarget> get copyWith => _$ContactTargetCopyWithImpl<ContactTarget>(this as ContactTarget, _$identity);

  /// Serializes this ContactTarget to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactTarget&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,phone);

@override
String toString() {
  return 'ContactTarget(email: $email, phone: $phone)';
}


}

/// @nodoc
abstract mixin class $ContactTargetCopyWith<$Res>  {
  factory $ContactTargetCopyWith(ContactTarget value, $Res Function(ContactTarget) _then) = _$ContactTargetCopyWithImpl;
@useResult
$Res call({
 String? email, String? phone
});




}
/// @nodoc
class _$ContactTargetCopyWithImpl<$Res>
    implements $ContactTargetCopyWith<$Res> {
  _$ContactTargetCopyWithImpl(this._self, this._then);

  final ContactTarget _self;
  final $Res Function(ContactTarget) _then;

/// Create a copy of ContactTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = freezed,Object? phone = freezed,}) {
  return _then(_self.copyWith(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactTarget].
extension ContactTargetPatterns on ContactTarget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactTarget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactTarget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactTarget value)  $default,){
final _that = this;
switch (_that) {
case _ContactTarget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactTarget value)?  $default,){
final _that = this;
switch (_that) {
case _ContactTarget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? email,  String? phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactTarget() when $default != null:
return $default(_that.email,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? email,  String? phone)  $default,) {final _that = this;
switch (_that) {
case _ContactTarget():
return $default(_that.email,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? email,  String? phone)?  $default,) {final _that = this;
switch (_that) {
case _ContactTarget() when $default != null:
return $default(_that.email,_that.phone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContactTarget implements ContactTarget {
  const _ContactTarget({this.email, this.phone});
  factory _ContactTarget.fromJson(Map<String, dynamic> json) => _$ContactTargetFromJson(json);

@override final  String? email;
@override final  String? phone;

/// Create a copy of ContactTarget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactTargetCopyWith<_ContactTarget> get copyWith => __$ContactTargetCopyWithImpl<_ContactTarget>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactTargetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactTarget&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,phone);

@override
String toString() {
  return 'ContactTarget(email: $email, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$ContactTargetCopyWith<$Res> implements $ContactTargetCopyWith<$Res> {
  factory _$ContactTargetCopyWith(_ContactTarget value, $Res Function(_ContactTarget) _then) = __$ContactTargetCopyWithImpl;
@override @useResult
$Res call({
 String? email, String? phone
});




}
/// @nodoc
class __$ContactTargetCopyWithImpl<$Res>
    implements _$ContactTargetCopyWith<$Res> {
  __$ContactTargetCopyWithImpl(this._self, this._then);

  final _ContactTarget _self;
  final $Res Function(_ContactTarget) _then;

/// Create a copy of ContactTarget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = freezed,Object? phone = freezed,}) {
  return _then(_ContactTarget(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DeviceRequest {

 String get deviceId; String? get deviceLabel; String? get fcmToken;
/// Create a copy of DeviceRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceRequestCopyWith<DeviceRequest> get copyWith => _$DeviceRequestCopyWithImpl<DeviceRequest>(this as DeviceRequest, _$identity);

  /// Serializes this DeviceRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceRequest&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.deviceLabel, deviceLabel) || other.deviceLabel == deviceLabel)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,deviceLabel,fcmToken);

@override
String toString() {
  return 'DeviceRequest(deviceId: $deviceId, deviceLabel: $deviceLabel, fcmToken: $fcmToken)';
}


}

/// @nodoc
abstract mixin class $DeviceRequestCopyWith<$Res>  {
  factory $DeviceRequestCopyWith(DeviceRequest value, $Res Function(DeviceRequest) _then) = _$DeviceRequestCopyWithImpl;
@useResult
$Res call({
 String deviceId, String? deviceLabel, String? fcmToken
});




}
/// @nodoc
class _$DeviceRequestCopyWithImpl<$Res>
    implements $DeviceRequestCopyWith<$Res> {
  _$DeviceRequestCopyWithImpl(this._self, this._then);

  final DeviceRequest _self;
  final $Res Function(DeviceRequest) _then;

/// Create a copy of DeviceRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = null,Object? deviceLabel = freezed,Object? fcmToken = freezed,}) {
  return _then(_self.copyWith(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,deviceLabel: freezed == deviceLabel ? _self.deviceLabel : deviceLabel // ignore: cast_nullable_to_non_nullable
as String?,fcmToken: freezed == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceRequest].
extension DeviceRequestPatterns on DeviceRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceRequest value)  $default,){
final _that = this;
switch (_that) {
case _DeviceRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceRequest value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deviceId,  String? deviceLabel,  String? fcmToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceRequest() when $default != null:
return $default(_that.deviceId,_that.deviceLabel,_that.fcmToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deviceId,  String? deviceLabel,  String? fcmToken)  $default,) {final _that = this;
switch (_that) {
case _DeviceRequest():
return $default(_that.deviceId,_that.deviceLabel,_that.fcmToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deviceId,  String? deviceLabel,  String? fcmToken)?  $default,) {final _that = this;
switch (_that) {
case _DeviceRequest() when $default != null:
return $default(_that.deviceId,_that.deviceLabel,_that.fcmToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeviceRequest implements DeviceRequest {
  const _DeviceRequest({required this.deviceId, this.deviceLabel, this.fcmToken});
  factory _DeviceRequest.fromJson(Map<String, dynamic> json) => _$DeviceRequestFromJson(json);

@override final  String deviceId;
@override final  String? deviceLabel;
@override final  String? fcmToken;

/// Create a copy of DeviceRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceRequestCopyWith<_DeviceRequest> get copyWith => __$DeviceRequestCopyWithImpl<_DeviceRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceRequest&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.deviceLabel, deviceLabel) || other.deviceLabel == deviceLabel)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,deviceLabel,fcmToken);

@override
String toString() {
  return 'DeviceRequest(deviceId: $deviceId, deviceLabel: $deviceLabel, fcmToken: $fcmToken)';
}


}

/// @nodoc
abstract mixin class _$DeviceRequestCopyWith<$Res> implements $DeviceRequestCopyWith<$Res> {
  factory _$DeviceRequestCopyWith(_DeviceRequest value, $Res Function(_DeviceRequest) _then) = __$DeviceRequestCopyWithImpl;
@override @useResult
$Res call({
 String deviceId, String? deviceLabel, String? fcmToken
});




}
/// @nodoc
class __$DeviceRequestCopyWithImpl<$Res>
    implements _$DeviceRequestCopyWith<$Res> {
  __$DeviceRequestCopyWithImpl(this._self, this._then);

  final _DeviceRequest _self;
  final $Res Function(_DeviceRequest) _then;

/// Create a copy of DeviceRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? deviceLabel = freezed,Object? fcmToken = freezed,}) {
  return _then(_DeviceRequest(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,deviceLabel: freezed == deviceLabel ? _self.deviceLabel : deviceLabel // ignore: cast_nullable_to_non_nullable
as String?,fcmToken: freezed == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PrimaryPatientProfile {

 String get fullName;@LocalDateConverter() DateTime get dateOfBirth; PatientSex? get sex;
/// Create a copy of PrimaryPatientProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrimaryPatientProfileCopyWith<PrimaryPatientProfile> get copyWith => _$PrimaryPatientProfileCopyWithImpl<PrimaryPatientProfile>(this as PrimaryPatientProfile, _$identity);

  /// Serializes this PrimaryPatientProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrimaryPatientProfile&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.sex, sex) || other.sex == sex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fullName,dateOfBirth,sex);

@override
String toString() {
  return 'PrimaryPatientProfile(fullName: $fullName, dateOfBirth: $dateOfBirth, sex: $sex)';
}


}

/// @nodoc
abstract mixin class $PrimaryPatientProfileCopyWith<$Res>  {
  factory $PrimaryPatientProfileCopyWith(PrimaryPatientProfile value, $Res Function(PrimaryPatientProfile) _then) = _$PrimaryPatientProfileCopyWithImpl;
@useResult
$Res call({
 String fullName,@LocalDateConverter() DateTime dateOfBirth, PatientSex? sex
});




}
/// @nodoc
class _$PrimaryPatientProfileCopyWithImpl<$Res>
    implements $PrimaryPatientProfileCopyWith<$Res> {
  _$PrimaryPatientProfileCopyWithImpl(this._self, this._then);

  final PrimaryPatientProfile _self;
  final $Res Function(PrimaryPatientProfile) _then;

/// Create a copy of PrimaryPatientProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fullName = null,Object? dateOfBirth = null,Object? sex = freezed,}) {
  return _then(_self.copyWith(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as PatientSex?,
  ));
}

}


/// Adds pattern-matching-related methods to [PrimaryPatientProfile].
extension PrimaryPatientProfilePatterns on PrimaryPatientProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrimaryPatientProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrimaryPatientProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrimaryPatientProfile value)  $default,){
final _that = this;
switch (_that) {
case _PrimaryPatientProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrimaryPatientProfile value)?  $default,){
final _that = this;
switch (_that) {
case _PrimaryPatientProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fullName, @LocalDateConverter()  DateTime dateOfBirth,  PatientSex? sex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrimaryPatientProfile() when $default != null:
return $default(_that.fullName,_that.dateOfBirth,_that.sex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fullName, @LocalDateConverter()  DateTime dateOfBirth,  PatientSex? sex)  $default,) {final _that = this;
switch (_that) {
case _PrimaryPatientProfile():
return $default(_that.fullName,_that.dateOfBirth,_that.sex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fullName, @LocalDateConverter()  DateTime dateOfBirth,  PatientSex? sex)?  $default,) {final _that = this;
switch (_that) {
case _PrimaryPatientProfile() when $default != null:
return $default(_that.fullName,_that.dateOfBirth,_that.sex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrimaryPatientProfile implements PrimaryPatientProfile {
  const _PrimaryPatientProfile({required this.fullName, @LocalDateConverter() required this.dateOfBirth, this.sex});
  factory _PrimaryPatientProfile.fromJson(Map<String, dynamic> json) => _$PrimaryPatientProfileFromJson(json);

@override final  String fullName;
@override@LocalDateConverter() final  DateTime dateOfBirth;
@override final  PatientSex? sex;

/// Create a copy of PrimaryPatientProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrimaryPatientProfileCopyWith<_PrimaryPatientProfile> get copyWith => __$PrimaryPatientProfileCopyWithImpl<_PrimaryPatientProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrimaryPatientProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrimaryPatientProfile&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.sex, sex) || other.sex == sex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fullName,dateOfBirth,sex);

@override
String toString() {
  return 'PrimaryPatientProfile(fullName: $fullName, dateOfBirth: $dateOfBirth, sex: $sex)';
}


}

/// @nodoc
abstract mixin class _$PrimaryPatientProfileCopyWith<$Res> implements $PrimaryPatientProfileCopyWith<$Res> {
  factory _$PrimaryPatientProfileCopyWith(_PrimaryPatientProfile value, $Res Function(_PrimaryPatientProfile) _then) = __$PrimaryPatientProfileCopyWithImpl;
@override @useResult
$Res call({
 String fullName,@LocalDateConverter() DateTime dateOfBirth, PatientSex? sex
});




}
/// @nodoc
class __$PrimaryPatientProfileCopyWithImpl<$Res>
    implements _$PrimaryPatientProfileCopyWith<$Res> {
  __$PrimaryPatientProfileCopyWithImpl(this._self, this._then);

  final _PrimaryPatientProfile _self;
  final $Res Function(_PrimaryPatientProfile) _then;

/// Create a copy of PrimaryPatientProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fullName = null,Object? dateOfBirth = null,Object? sex = freezed,}) {
  return _then(_PrimaryPatientProfile(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as PatientSex?,
  ));
}


}


/// @nodoc
mixin _$RegisterStartRequest {

 ContactTarget get target;
/// Create a copy of RegisterStartRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterStartRequestCopyWith<RegisterStartRequest> get copyWith => _$RegisterStartRequestCopyWithImpl<RegisterStartRequest>(this as RegisterStartRequest, _$identity);

  /// Serializes this RegisterStartRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterStartRequest&&(identical(other.target, target) || other.target == target));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,target);

@override
String toString() {
  return 'RegisterStartRequest(target: $target)';
}


}

/// @nodoc
abstract mixin class $RegisterStartRequestCopyWith<$Res>  {
  factory $RegisterStartRequestCopyWith(RegisterStartRequest value, $Res Function(RegisterStartRequest) _then) = _$RegisterStartRequestCopyWithImpl;
@useResult
$Res call({
 ContactTarget target
});


$ContactTargetCopyWith<$Res> get target;

}
/// @nodoc
class _$RegisterStartRequestCopyWithImpl<$Res>
    implements $RegisterStartRequestCopyWith<$Res> {
  _$RegisterStartRequestCopyWithImpl(this._self, this._then);

  final RegisterStartRequest _self;
  final $Res Function(RegisterStartRequest) _then;

/// Create a copy of RegisterStartRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? target = null,}) {
  return _then(_self.copyWith(
target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as ContactTarget,
  ));
}
/// Create a copy of RegisterStartRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactTargetCopyWith<$Res> get target {
  
  return $ContactTargetCopyWith<$Res>(_self.target, (value) {
    return _then(_self.copyWith(target: value));
  });
}
}


/// Adds pattern-matching-related methods to [RegisterStartRequest].
extension RegisterStartRequestPatterns on RegisterStartRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterStartRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterStartRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterStartRequest value)  $default,){
final _that = this;
switch (_that) {
case _RegisterStartRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterStartRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterStartRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ContactTarget target)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterStartRequest() when $default != null:
return $default(_that.target);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ContactTarget target)  $default,) {final _that = this;
switch (_that) {
case _RegisterStartRequest():
return $default(_that.target);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ContactTarget target)?  $default,) {final _that = this;
switch (_that) {
case _RegisterStartRequest() when $default != null:
return $default(_that.target);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegisterStartRequest implements RegisterStartRequest {
  const _RegisterStartRequest({required this.target});
  factory _RegisterStartRequest.fromJson(Map<String, dynamic> json) => _$RegisterStartRequestFromJson(json);

@override final  ContactTarget target;

/// Create a copy of RegisterStartRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterStartRequestCopyWith<_RegisterStartRequest> get copyWith => __$RegisterStartRequestCopyWithImpl<_RegisterStartRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegisterStartRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterStartRequest&&(identical(other.target, target) || other.target == target));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,target);

@override
String toString() {
  return 'RegisterStartRequest(target: $target)';
}


}

/// @nodoc
abstract mixin class _$RegisterStartRequestCopyWith<$Res> implements $RegisterStartRequestCopyWith<$Res> {
  factory _$RegisterStartRequestCopyWith(_RegisterStartRequest value, $Res Function(_RegisterStartRequest) _then) = __$RegisterStartRequestCopyWithImpl;
@override @useResult
$Res call({
 ContactTarget target
});


@override $ContactTargetCopyWith<$Res> get target;

}
/// @nodoc
class __$RegisterStartRequestCopyWithImpl<$Res>
    implements _$RegisterStartRequestCopyWith<$Res> {
  __$RegisterStartRequestCopyWithImpl(this._self, this._then);

  final _RegisterStartRequest _self;
  final $Res Function(_RegisterStartRequest) _then;

/// Create a copy of RegisterStartRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? target = null,}) {
  return _then(_RegisterStartRequest(
target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as ContactTarget,
  ));
}

/// Create a copy of RegisterStartRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContactTargetCopyWith<$Res> get target {
  
  return $ContactTargetCopyWith<$Res>(_self.target, (value) {
    return _then(_self.copyWith(target: value));
  });
}
}


/// @nodoc
mixin _$RegisterCompleteRequest {

 String get challengeId; String get code; String get password; DeviceRequest get device; PrimaryPatientProfile get profile;
/// Create a copy of RegisterCompleteRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterCompleteRequestCopyWith<RegisterCompleteRequest> get copyWith => _$RegisterCompleteRequestCopyWithImpl<RegisterCompleteRequest>(this as RegisterCompleteRequest, _$identity);

  /// Serializes this RegisterCompleteRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterCompleteRequest&&(identical(other.challengeId, challengeId) || other.challengeId == challengeId)&&(identical(other.code, code) || other.code == code)&&(identical(other.password, password) || other.password == password)&&(identical(other.device, device) || other.device == device)&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,challengeId,code,password,device,profile);

@override
String toString() {
  return 'RegisterCompleteRequest(challengeId: $challengeId, code: $code, password: $password, device: $device, profile: $profile)';
}


}

/// @nodoc
abstract mixin class $RegisterCompleteRequestCopyWith<$Res>  {
  factory $RegisterCompleteRequestCopyWith(RegisterCompleteRequest value, $Res Function(RegisterCompleteRequest) _then) = _$RegisterCompleteRequestCopyWithImpl;
@useResult
$Res call({
 String challengeId, String code, String password, DeviceRequest device, PrimaryPatientProfile profile
});


$DeviceRequestCopyWith<$Res> get device;$PrimaryPatientProfileCopyWith<$Res> get profile;

}
/// @nodoc
class _$RegisterCompleteRequestCopyWithImpl<$Res>
    implements $RegisterCompleteRequestCopyWith<$Res> {
  _$RegisterCompleteRequestCopyWithImpl(this._self, this._then);

  final RegisterCompleteRequest _self;
  final $Res Function(RegisterCompleteRequest) _then;

/// Create a copy of RegisterCompleteRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? challengeId = null,Object? code = null,Object? password = null,Object? device = null,Object? profile = null,}) {
  return _then(_self.copyWith(
challengeId: null == challengeId ? _self.challengeId : challengeId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceRequest,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as PrimaryPatientProfile,
  ));
}
/// Create a copy of RegisterCompleteRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceRequestCopyWith<$Res> get device {
  
  return $DeviceRequestCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}/// Create a copy of RegisterCompleteRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PrimaryPatientProfileCopyWith<$Res> get profile {
  
  return $PrimaryPatientProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [RegisterCompleteRequest].
extension RegisterCompleteRequestPatterns on RegisterCompleteRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterCompleteRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterCompleteRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterCompleteRequest value)  $default,){
final _that = this;
switch (_that) {
case _RegisterCompleteRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterCompleteRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterCompleteRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String challengeId,  String code,  String password,  DeviceRequest device,  PrimaryPatientProfile profile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterCompleteRequest() when $default != null:
return $default(_that.challengeId,_that.code,_that.password,_that.device,_that.profile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String challengeId,  String code,  String password,  DeviceRequest device,  PrimaryPatientProfile profile)  $default,) {final _that = this;
switch (_that) {
case _RegisterCompleteRequest():
return $default(_that.challengeId,_that.code,_that.password,_that.device,_that.profile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String challengeId,  String code,  String password,  DeviceRequest device,  PrimaryPatientProfile profile)?  $default,) {final _that = this;
switch (_that) {
case _RegisterCompleteRequest() when $default != null:
return $default(_that.challengeId,_that.code,_that.password,_that.device,_that.profile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegisterCompleteRequest implements RegisterCompleteRequest {
  const _RegisterCompleteRequest({required this.challengeId, required this.code, required this.password, required this.device, required this.profile});
  factory _RegisterCompleteRequest.fromJson(Map<String, dynamic> json) => _$RegisterCompleteRequestFromJson(json);

@override final  String challengeId;
@override final  String code;
@override final  String password;
@override final  DeviceRequest device;
@override final  PrimaryPatientProfile profile;

/// Create a copy of RegisterCompleteRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterCompleteRequestCopyWith<_RegisterCompleteRequest> get copyWith => __$RegisterCompleteRequestCopyWithImpl<_RegisterCompleteRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegisterCompleteRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterCompleteRequest&&(identical(other.challengeId, challengeId) || other.challengeId == challengeId)&&(identical(other.code, code) || other.code == code)&&(identical(other.password, password) || other.password == password)&&(identical(other.device, device) || other.device == device)&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,challengeId,code,password,device,profile);

@override
String toString() {
  return 'RegisterCompleteRequest(challengeId: $challengeId, code: $code, password: $password, device: $device, profile: $profile)';
}


}

/// @nodoc
abstract mixin class _$RegisterCompleteRequestCopyWith<$Res> implements $RegisterCompleteRequestCopyWith<$Res> {
  factory _$RegisterCompleteRequestCopyWith(_RegisterCompleteRequest value, $Res Function(_RegisterCompleteRequest) _then) = __$RegisterCompleteRequestCopyWithImpl;
@override @useResult
$Res call({
 String challengeId, String code, String password, DeviceRequest device, PrimaryPatientProfile profile
});


@override $DeviceRequestCopyWith<$Res> get device;@override $PrimaryPatientProfileCopyWith<$Res> get profile;

}
/// @nodoc
class __$RegisterCompleteRequestCopyWithImpl<$Res>
    implements _$RegisterCompleteRequestCopyWith<$Res> {
  __$RegisterCompleteRequestCopyWithImpl(this._self, this._then);

  final _RegisterCompleteRequest _self;
  final $Res Function(_RegisterCompleteRequest) _then;

/// Create a copy of RegisterCompleteRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? challengeId = null,Object? code = null,Object? password = null,Object? device = null,Object? profile = null,}) {
  return _then(_RegisterCompleteRequest(
challengeId: null == challengeId ? _self.challengeId : challengeId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceRequest,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as PrimaryPatientProfile,
  ));
}

/// Create a copy of RegisterCompleteRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceRequestCopyWith<$Res> get device {
  
  return $DeviceRequestCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}/// Create a copy of RegisterCompleteRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PrimaryPatientProfileCopyWith<$Res> get profile {
  
  return $PrimaryPatientProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// @nodoc
mixin _$LoginRequest {

 String get emailOrPhone; String get password; DeviceRequest get device;
/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginRequestCopyWith<LoginRequest> get copyWith => _$LoginRequestCopyWithImpl<LoginRequest>(this as LoginRequest, _$identity);

  /// Serializes this LoginRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginRequest&&(identical(other.emailOrPhone, emailOrPhone) || other.emailOrPhone == emailOrPhone)&&(identical(other.password, password) || other.password == password)&&(identical(other.device, device) || other.device == device));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emailOrPhone,password,device);

@override
String toString() {
  return 'LoginRequest(emailOrPhone: $emailOrPhone, password: $password, device: $device)';
}


}

/// @nodoc
abstract mixin class $LoginRequestCopyWith<$Res>  {
  factory $LoginRequestCopyWith(LoginRequest value, $Res Function(LoginRequest) _then) = _$LoginRequestCopyWithImpl;
@useResult
$Res call({
 String emailOrPhone, String password, DeviceRequest device
});


$DeviceRequestCopyWith<$Res> get device;

}
/// @nodoc
class _$LoginRequestCopyWithImpl<$Res>
    implements $LoginRequestCopyWith<$Res> {
  _$LoginRequestCopyWithImpl(this._self, this._then);

  final LoginRequest _self;
  final $Res Function(LoginRequest) _then;

/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? emailOrPhone = null,Object? password = null,Object? device = null,}) {
  return _then(_self.copyWith(
emailOrPhone: null == emailOrPhone ? _self.emailOrPhone : emailOrPhone // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceRequest,
  ));
}
/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceRequestCopyWith<$Res> get device {
  
  return $DeviceRequestCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}


/// Adds pattern-matching-related methods to [LoginRequest].
extension LoginRequestPatterns on LoginRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginRequest value)  $default,){
final _that = this;
switch (_that) {
case _LoginRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginRequest value)?  $default,){
final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String emailOrPhone,  String password,  DeviceRequest device)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
return $default(_that.emailOrPhone,_that.password,_that.device);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String emailOrPhone,  String password,  DeviceRequest device)  $default,) {final _that = this;
switch (_that) {
case _LoginRequest():
return $default(_that.emailOrPhone,_that.password,_that.device);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String emailOrPhone,  String password,  DeviceRequest device)?  $default,) {final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
return $default(_that.emailOrPhone,_that.password,_that.device);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoginRequest implements LoginRequest {
  const _LoginRequest({required this.emailOrPhone, required this.password, required this.device});
  factory _LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);

@override final  String emailOrPhone;
@override final  String password;
@override final  DeviceRequest device;

/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginRequestCopyWith<_LoginRequest> get copyWith => __$LoginRequestCopyWithImpl<_LoginRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoginRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginRequest&&(identical(other.emailOrPhone, emailOrPhone) || other.emailOrPhone == emailOrPhone)&&(identical(other.password, password) || other.password == password)&&(identical(other.device, device) || other.device == device));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emailOrPhone,password,device);

@override
String toString() {
  return 'LoginRequest(emailOrPhone: $emailOrPhone, password: $password, device: $device)';
}


}

/// @nodoc
abstract mixin class _$LoginRequestCopyWith<$Res> implements $LoginRequestCopyWith<$Res> {
  factory _$LoginRequestCopyWith(_LoginRequest value, $Res Function(_LoginRequest) _then) = __$LoginRequestCopyWithImpl;
@override @useResult
$Res call({
 String emailOrPhone, String password, DeviceRequest device
});


@override $DeviceRequestCopyWith<$Res> get device;

}
/// @nodoc
class __$LoginRequestCopyWithImpl<$Res>
    implements _$LoginRequestCopyWith<$Res> {
  __$LoginRequestCopyWithImpl(this._self, this._then);

  final _LoginRequest _self;
  final $Res Function(_LoginRequest) _then;

/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? emailOrPhone = null,Object? password = null,Object? device = null,}) {
  return _then(_LoginRequest(
emailOrPhone: null == emailOrPhone ? _self.emailOrPhone : emailOrPhone // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceRequest,
  ));
}

/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceRequestCopyWith<$Res> get device {
  
  return $DeviceRequestCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}


/// @nodoc
mixin _$ChallengeResponse {

 String get challengeId;
/// Create a copy of ChallengeResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChallengeResponseCopyWith<ChallengeResponse> get copyWith => _$ChallengeResponseCopyWithImpl<ChallengeResponse>(this as ChallengeResponse, _$identity);

  /// Serializes this ChallengeResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChallengeResponse&&(identical(other.challengeId, challengeId) || other.challengeId == challengeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,challengeId);

@override
String toString() {
  return 'ChallengeResponse(challengeId: $challengeId)';
}


}

/// @nodoc
abstract mixin class $ChallengeResponseCopyWith<$Res>  {
  factory $ChallengeResponseCopyWith(ChallengeResponse value, $Res Function(ChallengeResponse) _then) = _$ChallengeResponseCopyWithImpl;
@useResult
$Res call({
 String challengeId
});




}
/// @nodoc
class _$ChallengeResponseCopyWithImpl<$Res>
    implements $ChallengeResponseCopyWith<$Res> {
  _$ChallengeResponseCopyWithImpl(this._self, this._then);

  final ChallengeResponse _self;
  final $Res Function(ChallengeResponse) _then;

/// Create a copy of ChallengeResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? challengeId = null,}) {
  return _then(_self.copyWith(
challengeId: null == challengeId ? _self.challengeId : challengeId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChallengeResponse].
extension ChallengeResponsePatterns on ChallengeResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChallengeResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChallengeResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChallengeResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChallengeResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChallengeResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChallengeResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String challengeId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChallengeResponse() when $default != null:
return $default(_that.challengeId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String challengeId)  $default,) {final _that = this;
switch (_that) {
case _ChallengeResponse():
return $default(_that.challengeId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String challengeId)?  $default,) {final _that = this;
switch (_that) {
case _ChallengeResponse() when $default != null:
return $default(_that.challengeId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChallengeResponse implements ChallengeResponse {
  const _ChallengeResponse({required this.challengeId});
  factory _ChallengeResponse.fromJson(Map<String, dynamic> json) => _$ChallengeResponseFromJson(json);

@override final  String challengeId;

/// Create a copy of ChallengeResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChallengeResponseCopyWith<_ChallengeResponse> get copyWith => __$ChallengeResponseCopyWithImpl<_ChallengeResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChallengeResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChallengeResponse&&(identical(other.challengeId, challengeId) || other.challengeId == challengeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,challengeId);

@override
String toString() {
  return 'ChallengeResponse(challengeId: $challengeId)';
}


}

/// @nodoc
abstract mixin class _$ChallengeResponseCopyWith<$Res> implements $ChallengeResponseCopyWith<$Res> {
  factory _$ChallengeResponseCopyWith(_ChallengeResponse value, $Res Function(_ChallengeResponse) _then) = __$ChallengeResponseCopyWithImpl;
@override @useResult
$Res call({
 String challengeId
});




}
/// @nodoc
class __$ChallengeResponseCopyWithImpl<$Res>
    implements _$ChallengeResponseCopyWith<$Res> {
  __$ChallengeResponseCopyWithImpl(this._self, this._then);

  final _ChallengeResponse _self;
  final $Res Function(_ChallengeResponse) _then;

/// Create a copy of ChallengeResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? challengeId = null,}) {
  return _then(_ChallengeResponse(
challengeId: null == challengeId ? _self.challengeId : challengeId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TokenResponse {

 String get sessionId; String get accessToken; DateTime get accessTokenExpiresAt; String get refreshToken; DateTime get refreshTokenExpiresAt;
/// Create a copy of TokenResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenResponseCopyWith<TokenResponse> get copyWith => _$TokenResponseCopyWithImpl<TokenResponse>(this as TokenResponse, _$identity);

  /// Serializes this TokenResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenResponse&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.accessTokenExpiresAt, accessTokenExpiresAt) || other.accessTokenExpiresAt == accessTokenExpiresAt)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.refreshTokenExpiresAt, refreshTokenExpiresAt) || other.refreshTokenExpiresAt == refreshTokenExpiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,accessToken,accessTokenExpiresAt,refreshToken,refreshTokenExpiresAt);

@override
String toString() {
  return 'TokenResponse(sessionId: $sessionId, accessToken: $accessToken, accessTokenExpiresAt: $accessTokenExpiresAt, refreshToken: $refreshToken, refreshTokenExpiresAt: $refreshTokenExpiresAt)';
}


}

/// @nodoc
abstract mixin class $TokenResponseCopyWith<$Res>  {
  factory $TokenResponseCopyWith(TokenResponse value, $Res Function(TokenResponse) _then) = _$TokenResponseCopyWithImpl;
@useResult
$Res call({
 String sessionId, String accessToken, DateTime accessTokenExpiresAt, String refreshToken, DateTime refreshTokenExpiresAt
});




}
/// @nodoc
class _$TokenResponseCopyWithImpl<$Res>
    implements $TokenResponseCopyWith<$Res> {
  _$TokenResponseCopyWithImpl(this._self, this._then);

  final TokenResponse _self;
  final $Res Function(TokenResponse) _then;

/// Create a copy of TokenResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? accessToken = null,Object? accessTokenExpiresAt = null,Object? refreshToken = null,Object? refreshTokenExpiresAt = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,accessTokenExpiresAt: null == accessTokenExpiresAt ? _self.accessTokenExpiresAt : accessTokenExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,refreshTokenExpiresAt: null == refreshTokenExpiresAt ? _self.refreshTokenExpiresAt : refreshTokenExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TokenResponse].
extension TokenResponsePatterns on TokenResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TokenResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TokenResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TokenResponse value)  $default,){
final _that = this;
switch (_that) {
case _TokenResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TokenResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TokenResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  String accessToken,  DateTime accessTokenExpiresAt,  String refreshToken,  DateTime refreshTokenExpiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TokenResponse() when $default != null:
return $default(_that.sessionId,_that.accessToken,_that.accessTokenExpiresAt,_that.refreshToken,_that.refreshTokenExpiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  String accessToken,  DateTime accessTokenExpiresAt,  String refreshToken,  DateTime refreshTokenExpiresAt)  $default,) {final _that = this;
switch (_that) {
case _TokenResponse():
return $default(_that.sessionId,_that.accessToken,_that.accessTokenExpiresAt,_that.refreshToken,_that.refreshTokenExpiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  String accessToken,  DateTime accessTokenExpiresAt,  String refreshToken,  DateTime refreshTokenExpiresAt)?  $default,) {final _that = this;
switch (_that) {
case _TokenResponse() when $default != null:
return $default(_that.sessionId,_that.accessToken,_that.accessTokenExpiresAt,_that.refreshToken,_that.refreshTokenExpiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TokenResponse implements TokenResponse {
  const _TokenResponse({required this.sessionId, required this.accessToken, required this.accessTokenExpiresAt, required this.refreshToken, required this.refreshTokenExpiresAt});
  factory _TokenResponse.fromJson(Map<String, dynamic> json) => _$TokenResponseFromJson(json);

@override final  String sessionId;
@override final  String accessToken;
@override final  DateTime accessTokenExpiresAt;
@override final  String refreshToken;
@override final  DateTime refreshTokenExpiresAt;

/// Create a copy of TokenResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TokenResponseCopyWith<_TokenResponse> get copyWith => __$TokenResponseCopyWithImpl<_TokenResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TokenResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TokenResponse&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.accessTokenExpiresAt, accessTokenExpiresAt) || other.accessTokenExpiresAt == accessTokenExpiresAt)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.refreshTokenExpiresAt, refreshTokenExpiresAt) || other.refreshTokenExpiresAt == refreshTokenExpiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,accessToken,accessTokenExpiresAt,refreshToken,refreshTokenExpiresAt);

@override
String toString() {
  return 'TokenResponse(sessionId: $sessionId, accessToken: $accessToken, accessTokenExpiresAt: $accessTokenExpiresAt, refreshToken: $refreshToken, refreshTokenExpiresAt: $refreshTokenExpiresAt)';
}


}

/// @nodoc
abstract mixin class _$TokenResponseCopyWith<$Res> implements $TokenResponseCopyWith<$Res> {
  factory _$TokenResponseCopyWith(_TokenResponse value, $Res Function(_TokenResponse) _then) = __$TokenResponseCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, String accessToken, DateTime accessTokenExpiresAt, String refreshToken, DateTime refreshTokenExpiresAt
});




}
/// @nodoc
class __$TokenResponseCopyWithImpl<$Res>
    implements _$TokenResponseCopyWith<$Res> {
  __$TokenResponseCopyWithImpl(this._self, this._then);

  final _TokenResponse _self;
  final $Res Function(_TokenResponse) _then;

/// Create a copy of TokenResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? accessToken = null,Object? accessTokenExpiresAt = null,Object? refreshToken = null,Object? refreshTokenExpiresAt = null,}) {
  return _then(_TokenResponse(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,accessTokenExpiresAt: null == accessTokenExpiresAt ? _self.accessTokenExpiresAt : accessTokenExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,refreshTokenExpiresAt: null == refreshTokenExpiresAt ? _self.refreshTokenExpiresAt : refreshTokenExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$SessionView {

 String get id; String get deviceId; String? get deviceLabel; DateTime get issuedAt; DateTime get lastSeenAt; DateTime get expiresAt;
/// Create a copy of SessionView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionViewCopyWith<SessionView> get copyWith => _$SessionViewCopyWithImpl<SessionView>(this as SessionView, _$identity);

  /// Serializes this SessionView to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionView&&(identical(other.id, id) || other.id == id)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.deviceLabel, deviceLabel) || other.deviceLabel == deviceLabel)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deviceId,deviceLabel,issuedAt,lastSeenAt,expiresAt);

@override
String toString() {
  return 'SessionView(id: $id, deviceId: $deviceId, deviceLabel: $deviceLabel, issuedAt: $issuedAt, lastSeenAt: $lastSeenAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $SessionViewCopyWith<$Res>  {
  factory $SessionViewCopyWith(SessionView value, $Res Function(SessionView) _then) = _$SessionViewCopyWithImpl;
@useResult
$Res call({
 String id, String deviceId, String? deviceLabel, DateTime issuedAt, DateTime lastSeenAt, DateTime expiresAt
});




}
/// @nodoc
class _$SessionViewCopyWithImpl<$Res>
    implements $SessionViewCopyWith<$Res> {
  _$SessionViewCopyWithImpl(this._self, this._then);

  final SessionView _self;
  final $Res Function(SessionView) _then;

/// Create a copy of SessionView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? deviceId = null,Object? deviceLabel = freezed,Object? issuedAt = null,Object? lastSeenAt = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,deviceLabel: freezed == deviceLabel ? _self.deviceLabel : deviceLabel // ignore: cast_nullable_to_non_nullable
as String?,issuedAt: null == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionView].
extension SessionViewPatterns on SessionView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionView value)  $default,){
final _that = this;
switch (_that) {
case _SessionView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionView value)?  $default,){
final _that = this;
switch (_that) {
case _SessionView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String deviceId,  String? deviceLabel,  DateTime issuedAt,  DateTime lastSeenAt,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionView() when $default != null:
return $default(_that.id,_that.deviceId,_that.deviceLabel,_that.issuedAt,_that.lastSeenAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String deviceId,  String? deviceLabel,  DateTime issuedAt,  DateTime lastSeenAt,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _SessionView():
return $default(_that.id,_that.deviceId,_that.deviceLabel,_that.issuedAt,_that.lastSeenAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String deviceId,  String? deviceLabel,  DateTime issuedAt,  DateTime lastSeenAt,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _SessionView() when $default != null:
return $default(_that.id,_that.deviceId,_that.deviceLabel,_that.issuedAt,_that.lastSeenAt,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionView implements SessionView {
  const _SessionView({required this.id, required this.deviceId, this.deviceLabel, required this.issuedAt, required this.lastSeenAt, required this.expiresAt});
  factory _SessionView.fromJson(Map<String, dynamic> json) => _$SessionViewFromJson(json);

@override final  String id;
@override final  String deviceId;
@override final  String? deviceLabel;
@override final  DateTime issuedAt;
@override final  DateTime lastSeenAt;
@override final  DateTime expiresAt;

/// Create a copy of SessionView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionViewCopyWith<_SessionView> get copyWith => __$SessionViewCopyWithImpl<_SessionView>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionViewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionView&&(identical(other.id, id) || other.id == id)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.deviceLabel, deviceLabel) || other.deviceLabel == deviceLabel)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deviceId,deviceLabel,issuedAt,lastSeenAt,expiresAt);

@override
String toString() {
  return 'SessionView(id: $id, deviceId: $deviceId, deviceLabel: $deviceLabel, issuedAt: $issuedAt, lastSeenAt: $lastSeenAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$SessionViewCopyWith<$Res> implements $SessionViewCopyWith<$Res> {
  factory _$SessionViewCopyWith(_SessionView value, $Res Function(_SessionView) _then) = __$SessionViewCopyWithImpl;
@override @useResult
$Res call({
 String id, String deviceId, String? deviceLabel, DateTime issuedAt, DateTime lastSeenAt, DateTime expiresAt
});




}
/// @nodoc
class __$SessionViewCopyWithImpl<$Res>
    implements _$SessionViewCopyWith<$Res> {
  __$SessionViewCopyWithImpl(this._self, this._then);

  final _SessionView _self;
  final $Res Function(_SessionView) _then;

/// Create a copy of SessionView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? deviceId = null,Object? deviceLabel = freezed,Object? issuedAt = null,Object? lastSeenAt = null,Object? expiresAt = null,}) {
  return _then(_SessionView(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,deviceLabel: freezed == deviceLabel ? _self.deviceLabel : deviceLabel // ignore: cast_nullable_to_non_nullable
as String?,issuedAt: null == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$SessionListResponse {

 List<SessionView> get sessions;
/// Create a copy of SessionListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionListResponseCopyWith<SessionListResponse> get copyWith => _$SessionListResponseCopyWithImpl<SessionListResponse>(this as SessionListResponse, _$identity);

  /// Serializes this SessionListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionListResponse&&const DeepCollectionEquality().equals(other.sessions, sessions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(sessions));

@override
String toString() {
  return 'SessionListResponse(sessions: $sessions)';
}


}

/// @nodoc
abstract mixin class $SessionListResponseCopyWith<$Res>  {
  factory $SessionListResponseCopyWith(SessionListResponse value, $Res Function(SessionListResponse) _then) = _$SessionListResponseCopyWithImpl;
@useResult
$Res call({
 List<SessionView> sessions
});




}
/// @nodoc
class _$SessionListResponseCopyWithImpl<$Res>
    implements $SessionListResponseCopyWith<$Res> {
  _$SessionListResponseCopyWithImpl(this._self, this._then);

  final SessionListResponse _self;
  final $Res Function(SessionListResponse) _then;

/// Create a copy of SessionListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessions = null,}) {
  return _then(_self.copyWith(
sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<SessionView>,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionListResponse].
extension SessionListResponsePatterns on SessionListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionListResponse value)  $default,){
final _that = this;
switch (_that) {
case _SessionListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SessionListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SessionView> sessions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionListResponse() when $default != null:
return $default(_that.sessions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SessionView> sessions)  $default,) {final _that = this;
switch (_that) {
case _SessionListResponse():
return $default(_that.sessions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SessionView> sessions)?  $default,) {final _that = this;
switch (_that) {
case _SessionListResponse() when $default != null:
return $default(_that.sessions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionListResponse implements SessionListResponse {
  const _SessionListResponse({required final  List<SessionView> sessions}): _sessions = sessions;
  factory _SessionListResponse.fromJson(Map<String, dynamic> json) => _$SessionListResponseFromJson(json);

 final  List<SessionView> _sessions;
@override List<SessionView> get sessions {
  if (_sessions is EqualUnmodifiableListView) return _sessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sessions);
}


/// Create a copy of SessionListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionListResponseCopyWith<_SessionListResponse> get copyWith => __$SessionListResponseCopyWithImpl<_SessionListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionListResponse&&const DeepCollectionEquality().equals(other._sessions, _sessions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_sessions));

@override
String toString() {
  return 'SessionListResponse(sessions: $sessions)';
}


}

/// @nodoc
abstract mixin class _$SessionListResponseCopyWith<$Res> implements $SessionListResponseCopyWith<$Res> {
  factory _$SessionListResponseCopyWith(_SessionListResponse value, $Res Function(_SessionListResponse) _then) = __$SessionListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<SessionView> sessions
});




}
/// @nodoc
class __$SessionListResponseCopyWithImpl<$Res>
    implements _$SessionListResponseCopyWith<$Res> {
  __$SessionListResponseCopyWithImpl(this._self, this._then);

  final _SessionListResponse _self;
  final $Res Function(_SessionListResponse) _then;

/// Create a copy of SessionListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessions = null,}) {
  return _then(_SessionListResponse(
sessions: null == sessions ? _self._sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<SessionView>,
  ));
}


}

// dart format on
