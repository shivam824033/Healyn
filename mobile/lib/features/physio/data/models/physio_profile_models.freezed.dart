// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'physio_profile_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PhysioProfile {

 String? get displayName; String? get qualification; int? get experienceYears; String? get specialization; String? get bio; String? get clinicName; String? get clinicAddress; String? get clinicContactPhone; String? get clinicDescription; String? get instagramUrl; String? get facebookUrl; String? get linkedinUrl; String? get websiteUrl; String? get avatarUrl;
/// Create a copy of PhysioProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhysioProfileCopyWith<PhysioProfile> get copyWith => _$PhysioProfileCopyWithImpl<PhysioProfile>(this as PhysioProfile, _$identity);

  /// Serializes this PhysioProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhysioProfile&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.qualification, qualification) || other.qualification == qualification)&&(identical(other.experienceYears, experienceYears) || other.experienceYears == experienceYears)&&(identical(other.specialization, specialization) || other.specialization == specialization)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.clinicName, clinicName) || other.clinicName == clinicName)&&(identical(other.clinicAddress, clinicAddress) || other.clinicAddress == clinicAddress)&&(identical(other.clinicContactPhone, clinicContactPhone) || other.clinicContactPhone == clinicContactPhone)&&(identical(other.clinicDescription, clinicDescription) || other.clinicDescription == clinicDescription)&&(identical(other.instagramUrl, instagramUrl) || other.instagramUrl == instagramUrl)&&(identical(other.facebookUrl, facebookUrl) || other.facebookUrl == facebookUrl)&&(identical(other.linkedinUrl, linkedinUrl) || other.linkedinUrl == linkedinUrl)&&(identical(other.websiteUrl, websiteUrl) || other.websiteUrl == websiteUrl)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,displayName,qualification,experienceYears,specialization,bio,clinicName,clinicAddress,clinicContactPhone,clinicDescription,instagramUrl,facebookUrl,linkedinUrl,websiteUrl,avatarUrl);

@override
String toString() {
  return 'PhysioProfile(displayName: $displayName, qualification: $qualification, experienceYears: $experienceYears, specialization: $specialization, bio: $bio, clinicName: $clinicName, clinicAddress: $clinicAddress, clinicContactPhone: $clinicContactPhone, clinicDescription: $clinicDescription, instagramUrl: $instagramUrl, facebookUrl: $facebookUrl, linkedinUrl: $linkedinUrl, websiteUrl: $websiteUrl, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $PhysioProfileCopyWith<$Res>  {
  factory $PhysioProfileCopyWith(PhysioProfile value, $Res Function(PhysioProfile) _then) = _$PhysioProfileCopyWithImpl;
@useResult
$Res call({
 String? displayName, String? qualification, int? experienceYears, String? specialization, String? bio, String? clinicName, String? clinicAddress, String? clinicContactPhone, String? clinicDescription, String? instagramUrl, String? facebookUrl, String? linkedinUrl, String? websiteUrl, String? avatarUrl
});




}
/// @nodoc
class _$PhysioProfileCopyWithImpl<$Res>
    implements $PhysioProfileCopyWith<$Res> {
  _$PhysioProfileCopyWithImpl(this._self, this._then);

  final PhysioProfile _self;
  final $Res Function(PhysioProfile) _then;

/// Create a copy of PhysioProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayName = freezed,Object? qualification = freezed,Object? experienceYears = freezed,Object? specialization = freezed,Object? bio = freezed,Object? clinicName = freezed,Object? clinicAddress = freezed,Object? clinicContactPhone = freezed,Object? clinicDescription = freezed,Object? instagramUrl = freezed,Object? facebookUrl = freezed,Object? linkedinUrl = freezed,Object? websiteUrl = freezed,Object? avatarUrl = freezed,}) {
  return _then(_self.copyWith(
displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,qualification: freezed == qualification ? _self.qualification : qualification // ignore: cast_nullable_to_non_nullable
as String?,experienceYears: freezed == experienceYears ? _self.experienceYears : experienceYears // ignore: cast_nullable_to_non_nullable
as int?,specialization: freezed == specialization ? _self.specialization : specialization // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,clinicName: freezed == clinicName ? _self.clinicName : clinicName // ignore: cast_nullable_to_non_nullable
as String?,clinicAddress: freezed == clinicAddress ? _self.clinicAddress : clinicAddress // ignore: cast_nullable_to_non_nullable
as String?,clinicContactPhone: freezed == clinicContactPhone ? _self.clinicContactPhone : clinicContactPhone // ignore: cast_nullable_to_non_nullable
as String?,clinicDescription: freezed == clinicDescription ? _self.clinicDescription : clinicDescription // ignore: cast_nullable_to_non_nullable
as String?,instagramUrl: freezed == instagramUrl ? _self.instagramUrl : instagramUrl // ignore: cast_nullable_to_non_nullable
as String?,facebookUrl: freezed == facebookUrl ? _self.facebookUrl : facebookUrl // ignore: cast_nullable_to_non_nullable
as String?,linkedinUrl: freezed == linkedinUrl ? _self.linkedinUrl : linkedinUrl // ignore: cast_nullable_to_non_nullable
as String?,websiteUrl: freezed == websiteUrl ? _self.websiteUrl : websiteUrl // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PhysioProfile].
extension PhysioProfilePatterns on PhysioProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhysioProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhysioProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhysioProfile value)  $default,){
final _that = this;
switch (_that) {
case _PhysioProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhysioProfile value)?  $default,){
final _that = this;
switch (_that) {
case _PhysioProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? displayName,  String? qualification,  int? experienceYears,  String? specialization,  String? bio,  String? clinicName,  String? clinicAddress,  String? clinicContactPhone,  String? clinicDescription,  String? instagramUrl,  String? facebookUrl,  String? linkedinUrl,  String? websiteUrl,  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhysioProfile() when $default != null:
return $default(_that.displayName,_that.qualification,_that.experienceYears,_that.specialization,_that.bio,_that.clinicName,_that.clinicAddress,_that.clinicContactPhone,_that.clinicDescription,_that.instagramUrl,_that.facebookUrl,_that.linkedinUrl,_that.websiteUrl,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? displayName,  String? qualification,  int? experienceYears,  String? specialization,  String? bio,  String? clinicName,  String? clinicAddress,  String? clinicContactPhone,  String? clinicDescription,  String? instagramUrl,  String? facebookUrl,  String? linkedinUrl,  String? websiteUrl,  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _PhysioProfile():
return $default(_that.displayName,_that.qualification,_that.experienceYears,_that.specialization,_that.bio,_that.clinicName,_that.clinicAddress,_that.clinicContactPhone,_that.clinicDescription,_that.instagramUrl,_that.facebookUrl,_that.linkedinUrl,_that.websiteUrl,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? displayName,  String? qualification,  int? experienceYears,  String? specialization,  String? bio,  String? clinicName,  String? clinicAddress,  String? clinicContactPhone,  String? clinicDescription,  String? instagramUrl,  String? facebookUrl,  String? linkedinUrl,  String? websiteUrl,  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _PhysioProfile() when $default != null:
return $default(_that.displayName,_that.qualification,_that.experienceYears,_that.specialization,_that.bio,_that.clinicName,_that.clinicAddress,_that.clinicContactPhone,_that.clinicDescription,_that.instagramUrl,_that.facebookUrl,_that.linkedinUrl,_that.websiteUrl,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PhysioProfile extends PhysioProfile {
  const _PhysioProfile({this.displayName, this.qualification, this.experienceYears, this.specialization, this.bio, this.clinicName, this.clinicAddress, this.clinicContactPhone, this.clinicDescription, this.instagramUrl, this.facebookUrl, this.linkedinUrl, this.websiteUrl, this.avatarUrl}): super._();
  factory _PhysioProfile.fromJson(Map<String, dynamic> json) => _$PhysioProfileFromJson(json);

@override final  String? displayName;
@override final  String? qualification;
@override final  int? experienceYears;
@override final  String? specialization;
@override final  String? bio;
@override final  String? clinicName;
@override final  String? clinicAddress;
@override final  String? clinicContactPhone;
@override final  String? clinicDescription;
@override final  String? instagramUrl;
@override final  String? facebookUrl;
@override final  String? linkedinUrl;
@override final  String? websiteUrl;
@override final  String? avatarUrl;

/// Create a copy of PhysioProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhysioProfileCopyWith<_PhysioProfile> get copyWith => __$PhysioProfileCopyWithImpl<_PhysioProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhysioProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhysioProfile&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.qualification, qualification) || other.qualification == qualification)&&(identical(other.experienceYears, experienceYears) || other.experienceYears == experienceYears)&&(identical(other.specialization, specialization) || other.specialization == specialization)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.clinicName, clinicName) || other.clinicName == clinicName)&&(identical(other.clinicAddress, clinicAddress) || other.clinicAddress == clinicAddress)&&(identical(other.clinicContactPhone, clinicContactPhone) || other.clinicContactPhone == clinicContactPhone)&&(identical(other.clinicDescription, clinicDescription) || other.clinicDescription == clinicDescription)&&(identical(other.instagramUrl, instagramUrl) || other.instagramUrl == instagramUrl)&&(identical(other.facebookUrl, facebookUrl) || other.facebookUrl == facebookUrl)&&(identical(other.linkedinUrl, linkedinUrl) || other.linkedinUrl == linkedinUrl)&&(identical(other.websiteUrl, websiteUrl) || other.websiteUrl == websiteUrl)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,displayName,qualification,experienceYears,specialization,bio,clinicName,clinicAddress,clinicContactPhone,clinicDescription,instagramUrl,facebookUrl,linkedinUrl,websiteUrl,avatarUrl);

@override
String toString() {
  return 'PhysioProfile(displayName: $displayName, qualification: $qualification, experienceYears: $experienceYears, specialization: $specialization, bio: $bio, clinicName: $clinicName, clinicAddress: $clinicAddress, clinicContactPhone: $clinicContactPhone, clinicDescription: $clinicDescription, instagramUrl: $instagramUrl, facebookUrl: $facebookUrl, linkedinUrl: $linkedinUrl, websiteUrl: $websiteUrl, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$PhysioProfileCopyWith<$Res> implements $PhysioProfileCopyWith<$Res> {
  factory _$PhysioProfileCopyWith(_PhysioProfile value, $Res Function(_PhysioProfile) _then) = __$PhysioProfileCopyWithImpl;
@override @useResult
$Res call({
 String? displayName, String? qualification, int? experienceYears, String? specialization, String? bio, String? clinicName, String? clinicAddress, String? clinicContactPhone, String? clinicDescription, String? instagramUrl, String? facebookUrl, String? linkedinUrl, String? websiteUrl, String? avatarUrl
});




}
/// @nodoc
class __$PhysioProfileCopyWithImpl<$Res>
    implements _$PhysioProfileCopyWith<$Res> {
  __$PhysioProfileCopyWithImpl(this._self, this._then);

  final _PhysioProfile _self;
  final $Res Function(_PhysioProfile) _then;

/// Create a copy of PhysioProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayName = freezed,Object? qualification = freezed,Object? experienceYears = freezed,Object? specialization = freezed,Object? bio = freezed,Object? clinicName = freezed,Object? clinicAddress = freezed,Object? clinicContactPhone = freezed,Object? clinicDescription = freezed,Object? instagramUrl = freezed,Object? facebookUrl = freezed,Object? linkedinUrl = freezed,Object? websiteUrl = freezed,Object? avatarUrl = freezed,}) {
  return _then(_PhysioProfile(
displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,qualification: freezed == qualification ? _self.qualification : qualification // ignore: cast_nullable_to_non_nullable
as String?,experienceYears: freezed == experienceYears ? _self.experienceYears : experienceYears // ignore: cast_nullable_to_non_nullable
as int?,specialization: freezed == specialization ? _self.specialization : specialization // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,clinicName: freezed == clinicName ? _self.clinicName : clinicName // ignore: cast_nullable_to_non_nullable
as String?,clinicAddress: freezed == clinicAddress ? _self.clinicAddress : clinicAddress // ignore: cast_nullable_to_non_nullable
as String?,clinicContactPhone: freezed == clinicContactPhone ? _self.clinicContactPhone : clinicContactPhone // ignore: cast_nullable_to_non_nullable
as String?,clinicDescription: freezed == clinicDescription ? _self.clinicDescription : clinicDescription // ignore: cast_nullable_to_non_nullable
as String?,instagramUrl: freezed == instagramUrl ? _self.instagramUrl : instagramUrl // ignore: cast_nullable_to_non_nullable
as String?,facebookUrl: freezed == facebookUrl ? _self.facebookUrl : facebookUrl // ignore: cast_nullable_to_non_nullable
as String?,linkedinUrl: freezed == linkedinUrl ? _self.linkedinUrl : linkedinUrl // ignore: cast_nullable_to_non_nullable
as String?,websiteUrl: freezed == websiteUrl ? _self.websiteUrl : websiteUrl // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UpdatePhysioProfileRequest {

 String get displayName; String get qualification; int? get experienceYears; String get specialization; String get bio; String get clinicName; String get clinicAddress; String get clinicContactPhone; String get clinicDescription; String get instagramUrl; String get facebookUrl; String get linkedinUrl; String get websiteUrl;
/// Create a copy of UpdatePhysioProfileRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdatePhysioProfileRequestCopyWith<UpdatePhysioProfileRequest> get copyWith => _$UpdatePhysioProfileRequestCopyWithImpl<UpdatePhysioProfileRequest>(this as UpdatePhysioProfileRequest, _$identity);

  /// Serializes this UpdatePhysioProfileRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdatePhysioProfileRequest&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.qualification, qualification) || other.qualification == qualification)&&(identical(other.experienceYears, experienceYears) || other.experienceYears == experienceYears)&&(identical(other.specialization, specialization) || other.specialization == specialization)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.clinicName, clinicName) || other.clinicName == clinicName)&&(identical(other.clinicAddress, clinicAddress) || other.clinicAddress == clinicAddress)&&(identical(other.clinicContactPhone, clinicContactPhone) || other.clinicContactPhone == clinicContactPhone)&&(identical(other.clinicDescription, clinicDescription) || other.clinicDescription == clinicDescription)&&(identical(other.instagramUrl, instagramUrl) || other.instagramUrl == instagramUrl)&&(identical(other.facebookUrl, facebookUrl) || other.facebookUrl == facebookUrl)&&(identical(other.linkedinUrl, linkedinUrl) || other.linkedinUrl == linkedinUrl)&&(identical(other.websiteUrl, websiteUrl) || other.websiteUrl == websiteUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,displayName,qualification,experienceYears,specialization,bio,clinicName,clinicAddress,clinicContactPhone,clinicDescription,instagramUrl,facebookUrl,linkedinUrl,websiteUrl);

@override
String toString() {
  return 'UpdatePhysioProfileRequest(displayName: $displayName, qualification: $qualification, experienceYears: $experienceYears, specialization: $specialization, bio: $bio, clinicName: $clinicName, clinicAddress: $clinicAddress, clinicContactPhone: $clinicContactPhone, clinicDescription: $clinicDescription, instagramUrl: $instagramUrl, facebookUrl: $facebookUrl, linkedinUrl: $linkedinUrl, websiteUrl: $websiteUrl)';
}


}

/// @nodoc
abstract mixin class $UpdatePhysioProfileRequestCopyWith<$Res>  {
  factory $UpdatePhysioProfileRequestCopyWith(UpdatePhysioProfileRequest value, $Res Function(UpdatePhysioProfileRequest) _then) = _$UpdatePhysioProfileRequestCopyWithImpl;
@useResult
$Res call({
 String displayName, String qualification, int? experienceYears, String specialization, String bio, String clinicName, String clinicAddress, String clinicContactPhone, String clinicDescription, String instagramUrl, String facebookUrl, String linkedinUrl, String websiteUrl
});




}
/// @nodoc
class _$UpdatePhysioProfileRequestCopyWithImpl<$Res>
    implements $UpdatePhysioProfileRequestCopyWith<$Res> {
  _$UpdatePhysioProfileRequestCopyWithImpl(this._self, this._then);

  final UpdatePhysioProfileRequest _self;
  final $Res Function(UpdatePhysioProfileRequest) _then;

/// Create a copy of UpdatePhysioProfileRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayName = null,Object? qualification = null,Object? experienceYears = freezed,Object? specialization = null,Object? bio = null,Object? clinicName = null,Object? clinicAddress = null,Object? clinicContactPhone = null,Object? clinicDescription = null,Object? instagramUrl = null,Object? facebookUrl = null,Object? linkedinUrl = null,Object? websiteUrl = null,}) {
  return _then(_self.copyWith(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,qualification: null == qualification ? _self.qualification : qualification // ignore: cast_nullable_to_non_nullable
as String,experienceYears: freezed == experienceYears ? _self.experienceYears : experienceYears // ignore: cast_nullable_to_non_nullable
as int?,specialization: null == specialization ? _self.specialization : specialization // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,clinicName: null == clinicName ? _self.clinicName : clinicName // ignore: cast_nullable_to_non_nullable
as String,clinicAddress: null == clinicAddress ? _self.clinicAddress : clinicAddress // ignore: cast_nullable_to_non_nullable
as String,clinicContactPhone: null == clinicContactPhone ? _self.clinicContactPhone : clinicContactPhone // ignore: cast_nullable_to_non_nullable
as String,clinicDescription: null == clinicDescription ? _self.clinicDescription : clinicDescription // ignore: cast_nullable_to_non_nullable
as String,instagramUrl: null == instagramUrl ? _self.instagramUrl : instagramUrl // ignore: cast_nullable_to_non_nullable
as String,facebookUrl: null == facebookUrl ? _self.facebookUrl : facebookUrl // ignore: cast_nullable_to_non_nullable
as String,linkedinUrl: null == linkedinUrl ? _self.linkedinUrl : linkedinUrl // ignore: cast_nullable_to_non_nullable
as String,websiteUrl: null == websiteUrl ? _self.websiteUrl : websiteUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdatePhysioProfileRequest].
extension UpdatePhysioProfileRequestPatterns on UpdatePhysioProfileRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdatePhysioProfileRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdatePhysioProfileRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdatePhysioProfileRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdatePhysioProfileRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdatePhysioProfileRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdatePhysioProfileRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String displayName,  String qualification,  int? experienceYears,  String specialization,  String bio,  String clinicName,  String clinicAddress,  String clinicContactPhone,  String clinicDescription,  String instagramUrl,  String facebookUrl,  String linkedinUrl,  String websiteUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdatePhysioProfileRequest() when $default != null:
return $default(_that.displayName,_that.qualification,_that.experienceYears,_that.specialization,_that.bio,_that.clinicName,_that.clinicAddress,_that.clinicContactPhone,_that.clinicDescription,_that.instagramUrl,_that.facebookUrl,_that.linkedinUrl,_that.websiteUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String displayName,  String qualification,  int? experienceYears,  String specialization,  String bio,  String clinicName,  String clinicAddress,  String clinicContactPhone,  String clinicDescription,  String instagramUrl,  String facebookUrl,  String linkedinUrl,  String websiteUrl)  $default,) {final _that = this;
switch (_that) {
case _UpdatePhysioProfileRequest():
return $default(_that.displayName,_that.qualification,_that.experienceYears,_that.specialization,_that.bio,_that.clinicName,_that.clinicAddress,_that.clinicContactPhone,_that.clinicDescription,_that.instagramUrl,_that.facebookUrl,_that.linkedinUrl,_that.websiteUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String displayName,  String qualification,  int? experienceYears,  String specialization,  String bio,  String clinicName,  String clinicAddress,  String clinicContactPhone,  String clinicDescription,  String instagramUrl,  String facebookUrl,  String linkedinUrl,  String websiteUrl)?  $default,) {final _that = this;
switch (_that) {
case _UpdatePhysioProfileRequest() when $default != null:
return $default(_that.displayName,_that.qualification,_that.experienceYears,_that.specialization,_that.bio,_that.clinicName,_that.clinicAddress,_that.clinicContactPhone,_that.clinicDescription,_that.instagramUrl,_that.facebookUrl,_that.linkedinUrl,_that.websiteUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdatePhysioProfileRequest implements UpdatePhysioProfileRequest {
  const _UpdatePhysioProfileRequest({required this.displayName, required this.qualification, this.experienceYears, required this.specialization, required this.bio, required this.clinicName, required this.clinicAddress, required this.clinicContactPhone, required this.clinicDescription, required this.instagramUrl, required this.facebookUrl, required this.linkedinUrl, required this.websiteUrl});
  factory _UpdatePhysioProfileRequest.fromJson(Map<String, dynamic> json) => _$UpdatePhysioProfileRequestFromJson(json);

@override final  String displayName;
@override final  String qualification;
@override final  int? experienceYears;
@override final  String specialization;
@override final  String bio;
@override final  String clinicName;
@override final  String clinicAddress;
@override final  String clinicContactPhone;
@override final  String clinicDescription;
@override final  String instagramUrl;
@override final  String facebookUrl;
@override final  String linkedinUrl;
@override final  String websiteUrl;

/// Create a copy of UpdatePhysioProfileRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdatePhysioProfileRequestCopyWith<_UpdatePhysioProfileRequest> get copyWith => __$UpdatePhysioProfileRequestCopyWithImpl<_UpdatePhysioProfileRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdatePhysioProfileRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdatePhysioProfileRequest&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.qualification, qualification) || other.qualification == qualification)&&(identical(other.experienceYears, experienceYears) || other.experienceYears == experienceYears)&&(identical(other.specialization, specialization) || other.specialization == specialization)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.clinicName, clinicName) || other.clinicName == clinicName)&&(identical(other.clinicAddress, clinicAddress) || other.clinicAddress == clinicAddress)&&(identical(other.clinicContactPhone, clinicContactPhone) || other.clinicContactPhone == clinicContactPhone)&&(identical(other.clinicDescription, clinicDescription) || other.clinicDescription == clinicDescription)&&(identical(other.instagramUrl, instagramUrl) || other.instagramUrl == instagramUrl)&&(identical(other.facebookUrl, facebookUrl) || other.facebookUrl == facebookUrl)&&(identical(other.linkedinUrl, linkedinUrl) || other.linkedinUrl == linkedinUrl)&&(identical(other.websiteUrl, websiteUrl) || other.websiteUrl == websiteUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,displayName,qualification,experienceYears,specialization,bio,clinicName,clinicAddress,clinicContactPhone,clinicDescription,instagramUrl,facebookUrl,linkedinUrl,websiteUrl);

@override
String toString() {
  return 'UpdatePhysioProfileRequest(displayName: $displayName, qualification: $qualification, experienceYears: $experienceYears, specialization: $specialization, bio: $bio, clinicName: $clinicName, clinicAddress: $clinicAddress, clinicContactPhone: $clinicContactPhone, clinicDescription: $clinicDescription, instagramUrl: $instagramUrl, facebookUrl: $facebookUrl, linkedinUrl: $linkedinUrl, websiteUrl: $websiteUrl)';
}


}

/// @nodoc
abstract mixin class _$UpdatePhysioProfileRequestCopyWith<$Res> implements $UpdatePhysioProfileRequestCopyWith<$Res> {
  factory _$UpdatePhysioProfileRequestCopyWith(_UpdatePhysioProfileRequest value, $Res Function(_UpdatePhysioProfileRequest) _then) = __$UpdatePhysioProfileRequestCopyWithImpl;
@override @useResult
$Res call({
 String displayName, String qualification, int? experienceYears, String specialization, String bio, String clinicName, String clinicAddress, String clinicContactPhone, String clinicDescription, String instagramUrl, String facebookUrl, String linkedinUrl, String websiteUrl
});




}
/// @nodoc
class __$UpdatePhysioProfileRequestCopyWithImpl<$Res>
    implements _$UpdatePhysioProfileRequestCopyWith<$Res> {
  __$UpdatePhysioProfileRequestCopyWithImpl(this._self, this._then);

  final _UpdatePhysioProfileRequest _self;
  final $Res Function(_UpdatePhysioProfileRequest) _then;

/// Create a copy of UpdatePhysioProfileRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayName = null,Object? qualification = null,Object? experienceYears = freezed,Object? specialization = null,Object? bio = null,Object? clinicName = null,Object? clinicAddress = null,Object? clinicContactPhone = null,Object? clinicDescription = null,Object? instagramUrl = null,Object? facebookUrl = null,Object? linkedinUrl = null,Object? websiteUrl = null,}) {
  return _then(_UpdatePhysioProfileRequest(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,qualification: null == qualification ? _self.qualification : qualification // ignore: cast_nullable_to_non_nullable
as String,experienceYears: freezed == experienceYears ? _self.experienceYears : experienceYears // ignore: cast_nullable_to_non_nullable
as int?,specialization: null == specialization ? _self.specialization : specialization // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,clinicName: null == clinicName ? _self.clinicName : clinicName // ignore: cast_nullable_to_non_nullable
as String,clinicAddress: null == clinicAddress ? _self.clinicAddress : clinicAddress // ignore: cast_nullable_to_non_nullable
as String,clinicContactPhone: null == clinicContactPhone ? _self.clinicContactPhone : clinicContactPhone // ignore: cast_nullable_to_non_nullable
as String,clinicDescription: null == clinicDescription ? _self.clinicDescription : clinicDescription // ignore: cast_nullable_to_non_nullable
as String,instagramUrl: null == instagramUrl ? _self.instagramUrl : instagramUrl // ignore: cast_nullable_to_non_nullable
as String,facebookUrl: null == facebookUrl ? _self.facebookUrl : facebookUrl // ignore: cast_nullable_to_non_nullable
as String,linkedinUrl: null == linkedinUrl ? _self.linkedinUrl : linkedinUrl // ignore: cast_nullable_to_non_nullable
as String,websiteUrl: null == websiteUrl ? _self.websiteUrl : websiteUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AvatarPresign {

 String get objectKey; String get url; String get contentType; int get expiresInSeconds;
/// Create a copy of AvatarPresign
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvatarPresignCopyWith<AvatarPresign> get copyWith => _$AvatarPresignCopyWithImpl<AvatarPresign>(this as AvatarPresign, _$identity);

  /// Serializes this AvatarPresign to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvatarPresign&&(identical(other.objectKey, objectKey) || other.objectKey == objectKey)&&(identical(other.url, url) || other.url == url)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.expiresInSeconds, expiresInSeconds) || other.expiresInSeconds == expiresInSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,objectKey,url,contentType,expiresInSeconds);

@override
String toString() {
  return 'AvatarPresign(objectKey: $objectKey, url: $url, contentType: $contentType, expiresInSeconds: $expiresInSeconds)';
}


}

/// @nodoc
abstract mixin class $AvatarPresignCopyWith<$Res>  {
  factory $AvatarPresignCopyWith(AvatarPresign value, $Res Function(AvatarPresign) _then) = _$AvatarPresignCopyWithImpl;
@useResult
$Res call({
 String objectKey, String url, String contentType, int expiresInSeconds
});




}
/// @nodoc
class _$AvatarPresignCopyWithImpl<$Res>
    implements $AvatarPresignCopyWith<$Res> {
  _$AvatarPresignCopyWithImpl(this._self, this._then);

  final AvatarPresign _self;
  final $Res Function(AvatarPresign) _then;

/// Create a copy of AvatarPresign
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? objectKey = null,Object? url = null,Object? contentType = null,Object? expiresInSeconds = null,}) {
  return _then(_self.copyWith(
objectKey: null == objectKey ? _self.objectKey : objectKey // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,expiresInSeconds: null == expiresInSeconds ? _self.expiresInSeconds : expiresInSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AvatarPresign].
extension AvatarPresignPatterns on AvatarPresign {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvatarPresign value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvatarPresign() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvatarPresign value)  $default,){
final _that = this;
switch (_that) {
case _AvatarPresign():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvatarPresign value)?  $default,){
final _that = this;
switch (_that) {
case _AvatarPresign() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String objectKey,  String url,  String contentType,  int expiresInSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvatarPresign() when $default != null:
return $default(_that.objectKey,_that.url,_that.contentType,_that.expiresInSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String objectKey,  String url,  String contentType,  int expiresInSeconds)  $default,) {final _that = this;
switch (_that) {
case _AvatarPresign():
return $default(_that.objectKey,_that.url,_that.contentType,_that.expiresInSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String objectKey,  String url,  String contentType,  int expiresInSeconds)?  $default,) {final _that = this;
switch (_that) {
case _AvatarPresign() when $default != null:
return $default(_that.objectKey,_that.url,_that.contentType,_that.expiresInSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AvatarPresign implements AvatarPresign {
  const _AvatarPresign({required this.objectKey, required this.url, required this.contentType, required this.expiresInSeconds});
  factory _AvatarPresign.fromJson(Map<String, dynamic> json) => _$AvatarPresignFromJson(json);

@override final  String objectKey;
@override final  String url;
@override final  String contentType;
@override final  int expiresInSeconds;

/// Create a copy of AvatarPresign
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvatarPresignCopyWith<_AvatarPresign> get copyWith => __$AvatarPresignCopyWithImpl<_AvatarPresign>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AvatarPresignToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvatarPresign&&(identical(other.objectKey, objectKey) || other.objectKey == objectKey)&&(identical(other.url, url) || other.url == url)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.expiresInSeconds, expiresInSeconds) || other.expiresInSeconds == expiresInSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,objectKey,url,contentType,expiresInSeconds);

@override
String toString() {
  return 'AvatarPresign(objectKey: $objectKey, url: $url, contentType: $contentType, expiresInSeconds: $expiresInSeconds)';
}


}

/// @nodoc
abstract mixin class _$AvatarPresignCopyWith<$Res> implements $AvatarPresignCopyWith<$Res> {
  factory _$AvatarPresignCopyWith(_AvatarPresign value, $Res Function(_AvatarPresign) _then) = __$AvatarPresignCopyWithImpl;
@override @useResult
$Res call({
 String objectKey, String url, String contentType, int expiresInSeconds
});




}
/// @nodoc
class __$AvatarPresignCopyWithImpl<$Res>
    implements _$AvatarPresignCopyWith<$Res> {
  __$AvatarPresignCopyWithImpl(this._self, this._then);

  final _AvatarPresign _self;
  final $Res Function(_AvatarPresign) _then;

/// Create a copy of AvatarPresign
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? objectKey = null,Object? url = null,Object? contentType = null,Object? expiresInSeconds = null,}) {
  return _then(_AvatarPresign(
objectKey: null == objectKey ? _self.objectKey : objectKey // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,expiresInSeconds: null == expiresInSeconds ? _self.expiresInSeconds : expiresInSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
