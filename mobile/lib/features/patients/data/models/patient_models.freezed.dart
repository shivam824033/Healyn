// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'patient_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Patient {

 String get id; String? get patientNumber; String get fullName;@LocalDateConverter() DateTime get dateOfBirth; PatientSex? get sex; String? get phoneE164; String? get email; String? get bloodGroup; String? get allergies; String? get notes; PatientRelationship? get relationship; bool get primary; bool get canManage; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of Patient
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatientCopyWith<Patient> get copyWith => _$PatientCopyWithImpl<Patient>(this as Patient, _$identity);

  /// Serializes this Patient to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Patient&&(identical(other.id, id) || other.id == id)&&(identical(other.patientNumber, patientNumber) || other.patientNumber == patientNumber)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.phoneE164, phoneE164) || other.phoneE164 == phoneE164)&&(identical(other.email, email) || other.email == email)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.allergies, allergies) || other.allergies == allergies)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.primary, primary) || other.primary == primary)&&(identical(other.canManage, canManage) || other.canManage == canManage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,patientNumber,fullName,dateOfBirth,sex,phoneE164,email,bloodGroup,allergies,notes,relationship,primary,canManage,createdAt,updatedAt);

@override
String toString() {
  return 'Patient(id: $id, patientNumber: $patientNumber, fullName: $fullName, dateOfBirth: $dateOfBirth, sex: $sex, phoneE164: $phoneE164, email: $email, bloodGroup: $bloodGroup, allergies: $allergies, notes: $notes, relationship: $relationship, primary: $primary, canManage: $canManage, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PatientCopyWith<$Res>  {
  factory $PatientCopyWith(Patient value, $Res Function(Patient) _then) = _$PatientCopyWithImpl;
@useResult
$Res call({
 String id, String? patientNumber, String fullName,@LocalDateConverter() DateTime dateOfBirth, PatientSex? sex, String? phoneE164, String? email, String? bloodGroup, String? allergies, String? notes, PatientRelationship? relationship, bool primary, bool canManage, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$PatientCopyWithImpl<$Res>
    implements $PatientCopyWith<$Res> {
  _$PatientCopyWithImpl(this._self, this._then);

  final Patient _self;
  final $Res Function(Patient) _then;

/// Create a copy of Patient
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? patientNumber = freezed,Object? fullName = null,Object? dateOfBirth = null,Object? sex = freezed,Object? phoneE164 = freezed,Object? email = freezed,Object? bloodGroup = freezed,Object? allergies = freezed,Object? notes = freezed,Object? relationship = freezed,Object? primary = null,Object? canManage = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,patientNumber: freezed == patientNumber ? _self.patientNumber : patientNumber // ignore: cast_nullable_to_non_nullable
as String?,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as PatientSex?,phoneE164: freezed == phoneE164 ? _self.phoneE164 : phoneE164 // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,bloodGroup: freezed == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as String?,allergies: freezed == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,relationship: freezed == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as PatientRelationship?,primary: null == primary ? _self.primary : primary // ignore: cast_nullable_to_non_nullable
as bool,canManage: null == canManage ? _self.canManage : canManage // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Patient].
extension PatientPatterns on Patient {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Patient value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Patient() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Patient value)  $default,){
final _that = this;
switch (_that) {
case _Patient():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Patient value)?  $default,){
final _that = this;
switch (_that) {
case _Patient() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? patientNumber,  String fullName, @LocalDateConverter()  DateTime dateOfBirth,  PatientSex? sex,  String? phoneE164,  String? email,  String? bloodGroup,  String? allergies,  String? notes,  PatientRelationship? relationship,  bool primary,  bool canManage,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Patient() when $default != null:
return $default(_that.id,_that.patientNumber,_that.fullName,_that.dateOfBirth,_that.sex,_that.phoneE164,_that.email,_that.bloodGroup,_that.allergies,_that.notes,_that.relationship,_that.primary,_that.canManage,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? patientNumber,  String fullName, @LocalDateConverter()  DateTime dateOfBirth,  PatientSex? sex,  String? phoneE164,  String? email,  String? bloodGroup,  String? allergies,  String? notes,  PatientRelationship? relationship,  bool primary,  bool canManage,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Patient():
return $default(_that.id,_that.patientNumber,_that.fullName,_that.dateOfBirth,_that.sex,_that.phoneE164,_that.email,_that.bloodGroup,_that.allergies,_that.notes,_that.relationship,_that.primary,_that.canManage,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? patientNumber,  String fullName, @LocalDateConverter()  DateTime dateOfBirth,  PatientSex? sex,  String? phoneE164,  String? email,  String? bloodGroup,  String? allergies,  String? notes,  PatientRelationship? relationship,  bool primary,  bool canManage,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Patient() when $default != null:
return $default(_that.id,_that.patientNumber,_that.fullName,_that.dateOfBirth,_that.sex,_that.phoneE164,_that.email,_that.bloodGroup,_that.allergies,_that.notes,_that.relationship,_that.primary,_that.canManage,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Patient implements Patient {
  const _Patient({required this.id, this.patientNumber, required this.fullName, @LocalDateConverter() required this.dateOfBirth, this.sex, this.phoneE164, this.email, this.bloodGroup, this.allergies, this.notes, this.relationship, this.primary = false, this.canManage = false, this.createdAt, this.updatedAt});
  factory _Patient.fromJson(Map<String, dynamic> json) => _$PatientFromJson(json);

@override final  String id;
@override final  String? patientNumber;
@override final  String fullName;
@override@LocalDateConverter() final  DateTime dateOfBirth;
@override final  PatientSex? sex;
@override final  String? phoneE164;
@override final  String? email;
@override final  String? bloodGroup;
@override final  String? allergies;
@override final  String? notes;
@override final  PatientRelationship? relationship;
@override@JsonKey() final  bool primary;
@override@JsonKey() final  bool canManage;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Patient
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PatientCopyWith<_Patient> get copyWith => __$PatientCopyWithImpl<_Patient>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PatientToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Patient&&(identical(other.id, id) || other.id == id)&&(identical(other.patientNumber, patientNumber) || other.patientNumber == patientNumber)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.phoneE164, phoneE164) || other.phoneE164 == phoneE164)&&(identical(other.email, email) || other.email == email)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.allergies, allergies) || other.allergies == allergies)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.primary, primary) || other.primary == primary)&&(identical(other.canManage, canManage) || other.canManage == canManage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,patientNumber,fullName,dateOfBirth,sex,phoneE164,email,bloodGroup,allergies,notes,relationship,primary,canManage,createdAt,updatedAt);

@override
String toString() {
  return 'Patient(id: $id, patientNumber: $patientNumber, fullName: $fullName, dateOfBirth: $dateOfBirth, sex: $sex, phoneE164: $phoneE164, email: $email, bloodGroup: $bloodGroup, allergies: $allergies, notes: $notes, relationship: $relationship, primary: $primary, canManage: $canManage, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PatientCopyWith<$Res> implements $PatientCopyWith<$Res> {
  factory _$PatientCopyWith(_Patient value, $Res Function(_Patient) _then) = __$PatientCopyWithImpl;
@override @useResult
$Res call({
 String id, String? patientNumber, String fullName,@LocalDateConverter() DateTime dateOfBirth, PatientSex? sex, String? phoneE164, String? email, String? bloodGroup, String? allergies, String? notes, PatientRelationship? relationship, bool primary, bool canManage, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$PatientCopyWithImpl<$Res>
    implements _$PatientCopyWith<$Res> {
  __$PatientCopyWithImpl(this._self, this._then);

  final _Patient _self;
  final $Res Function(_Patient) _then;

/// Create a copy of Patient
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? patientNumber = freezed,Object? fullName = null,Object? dateOfBirth = null,Object? sex = freezed,Object? phoneE164 = freezed,Object? email = freezed,Object? bloodGroup = freezed,Object? allergies = freezed,Object? notes = freezed,Object? relationship = freezed,Object? primary = null,Object? canManage = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Patient(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,patientNumber: freezed == patientNumber ? _self.patientNumber : patientNumber // ignore: cast_nullable_to_non_nullable
as String?,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as PatientSex?,phoneE164: freezed == phoneE164 ? _self.phoneE164 : phoneE164 // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,bloodGroup: freezed == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as String?,allergies: freezed == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,relationship: freezed == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as PatientRelationship?,primary: null == primary ? _self.primary : primary // ignore: cast_nullable_to_non_nullable
as bool,canManage: null == canManage ? _self.canManage : canManage // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$PatientListResponse {

 List<Patient> get patients;
/// Create a copy of PatientListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatientListResponseCopyWith<PatientListResponse> get copyWith => _$PatientListResponseCopyWithImpl<PatientListResponse>(this as PatientListResponse, _$identity);

  /// Serializes this PatientListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PatientListResponse&&const DeepCollectionEquality().equals(other.patients, patients));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(patients));

@override
String toString() {
  return 'PatientListResponse(patients: $patients)';
}


}

/// @nodoc
abstract mixin class $PatientListResponseCopyWith<$Res>  {
  factory $PatientListResponseCopyWith(PatientListResponse value, $Res Function(PatientListResponse) _then) = _$PatientListResponseCopyWithImpl;
@useResult
$Res call({
 List<Patient> patients
});




}
/// @nodoc
class _$PatientListResponseCopyWithImpl<$Res>
    implements $PatientListResponseCopyWith<$Res> {
  _$PatientListResponseCopyWithImpl(this._self, this._then);

  final PatientListResponse _self;
  final $Res Function(PatientListResponse) _then;

/// Create a copy of PatientListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? patients = null,}) {
  return _then(_self.copyWith(
patients: null == patients ? _self.patients : patients // ignore: cast_nullable_to_non_nullable
as List<Patient>,
  ));
}

}


/// Adds pattern-matching-related methods to [PatientListResponse].
extension PatientListResponsePatterns on PatientListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PatientListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PatientListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PatientListResponse value)  $default,){
final _that = this;
switch (_that) {
case _PatientListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PatientListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PatientListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Patient> patients)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PatientListResponse() when $default != null:
return $default(_that.patients);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Patient> patients)  $default,) {final _that = this;
switch (_that) {
case _PatientListResponse():
return $default(_that.patients);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Patient> patients)?  $default,) {final _that = this;
switch (_that) {
case _PatientListResponse() when $default != null:
return $default(_that.patients);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PatientListResponse implements PatientListResponse {
  const _PatientListResponse({required final  List<Patient> patients}): _patients = patients;
  factory _PatientListResponse.fromJson(Map<String, dynamic> json) => _$PatientListResponseFromJson(json);

 final  List<Patient> _patients;
@override List<Patient> get patients {
  if (_patients is EqualUnmodifiableListView) return _patients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_patients);
}


/// Create a copy of PatientListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PatientListResponseCopyWith<_PatientListResponse> get copyWith => __$PatientListResponseCopyWithImpl<_PatientListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PatientListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PatientListResponse&&const DeepCollectionEquality().equals(other._patients, _patients));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_patients));

@override
String toString() {
  return 'PatientListResponse(patients: $patients)';
}


}

/// @nodoc
abstract mixin class _$PatientListResponseCopyWith<$Res> implements $PatientListResponseCopyWith<$Res> {
  factory _$PatientListResponseCopyWith(_PatientListResponse value, $Res Function(_PatientListResponse) _then) = __$PatientListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<Patient> patients
});




}
/// @nodoc
class __$PatientListResponseCopyWithImpl<$Res>
    implements _$PatientListResponseCopyWith<$Res> {
  __$PatientListResponseCopyWithImpl(this._self, this._then);

  final _PatientListResponse _self;
  final $Res Function(_PatientListResponse) _then;

/// Create a copy of PatientListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? patients = null,}) {
  return _then(_PatientListResponse(
patients: null == patients ? _self._patients : patients // ignore: cast_nullable_to_non_nullable
as List<Patient>,
  ));
}


}


/// @nodoc
mixin _$CreateFamilyMemberRequest {

 String get fullName;@LocalDateConverter() DateTime get dateOfBirth; PatientRelationship get relationship; PatientSex? get sex; String? get phoneE164; String? get email; String? get bloodGroup; String? get allergies; String? get notes;
/// Create a copy of CreateFamilyMemberRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateFamilyMemberRequestCopyWith<CreateFamilyMemberRequest> get copyWith => _$CreateFamilyMemberRequestCopyWithImpl<CreateFamilyMemberRequest>(this as CreateFamilyMemberRequest, _$identity);

  /// Serializes this CreateFamilyMemberRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateFamilyMemberRequest&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.phoneE164, phoneE164) || other.phoneE164 == phoneE164)&&(identical(other.email, email) || other.email == email)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.allergies, allergies) || other.allergies == allergies)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fullName,dateOfBirth,relationship,sex,phoneE164,email,bloodGroup,allergies,notes);

@override
String toString() {
  return 'CreateFamilyMemberRequest(fullName: $fullName, dateOfBirth: $dateOfBirth, relationship: $relationship, sex: $sex, phoneE164: $phoneE164, email: $email, bloodGroup: $bloodGroup, allergies: $allergies, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $CreateFamilyMemberRequestCopyWith<$Res>  {
  factory $CreateFamilyMemberRequestCopyWith(CreateFamilyMemberRequest value, $Res Function(CreateFamilyMemberRequest) _then) = _$CreateFamilyMemberRequestCopyWithImpl;
@useResult
$Res call({
 String fullName,@LocalDateConverter() DateTime dateOfBirth, PatientRelationship relationship, PatientSex? sex, String? phoneE164, String? email, String? bloodGroup, String? allergies, String? notes
});




}
/// @nodoc
class _$CreateFamilyMemberRequestCopyWithImpl<$Res>
    implements $CreateFamilyMemberRequestCopyWith<$Res> {
  _$CreateFamilyMemberRequestCopyWithImpl(this._self, this._then);

  final CreateFamilyMemberRequest _self;
  final $Res Function(CreateFamilyMemberRequest) _then;

/// Create a copy of CreateFamilyMemberRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fullName = null,Object? dateOfBirth = null,Object? relationship = null,Object? sex = freezed,Object? phoneE164 = freezed,Object? email = freezed,Object? bloodGroup = freezed,Object? allergies = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime,relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as PatientRelationship,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as PatientSex?,phoneE164: freezed == phoneE164 ? _self.phoneE164 : phoneE164 // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,bloodGroup: freezed == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as String?,allergies: freezed == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateFamilyMemberRequest].
extension CreateFamilyMemberRequestPatterns on CreateFamilyMemberRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateFamilyMemberRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateFamilyMemberRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateFamilyMemberRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateFamilyMemberRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateFamilyMemberRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateFamilyMemberRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fullName, @LocalDateConverter()  DateTime dateOfBirth,  PatientRelationship relationship,  PatientSex? sex,  String? phoneE164,  String? email,  String? bloodGroup,  String? allergies,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateFamilyMemberRequest() when $default != null:
return $default(_that.fullName,_that.dateOfBirth,_that.relationship,_that.sex,_that.phoneE164,_that.email,_that.bloodGroup,_that.allergies,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fullName, @LocalDateConverter()  DateTime dateOfBirth,  PatientRelationship relationship,  PatientSex? sex,  String? phoneE164,  String? email,  String? bloodGroup,  String? allergies,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _CreateFamilyMemberRequest():
return $default(_that.fullName,_that.dateOfBirth,_that.relationship,_that.sex,_that.phoneE164,_that.email,_that.bloodGroup,_that.allergies,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fullName, @LocalDateConverter()  DateTime dateOfBirth,  PatientRelationship relationship,  PatientSex? sex,  String? phoneE164,  String? email,  String? bloodGroup,  String? allergies,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _CreateFamilyMemberRequest() when $default != null:
return $default(_that.fullName,_that.dateOfBirth,_that.relationship,_that.sex,_that.phoneE164,_that.email,_that.bloodGroup,_that.allergies,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateFamilyMemberRequest implements CreateFamilyMemberRequest {
  const _CreateFamilyMemberRequest({required this.fullName, @LocalDateConverter() required this.dateOfBirth, required this.relationship, this.sex, this.phoneE164, this.email, this.bloodGroup, this.allergies, this.notes});
  factory _CreateFamilyMemberRequest.fromJson(Map<String, dynamic> json) => _$CreateFamilyMemberRequestFromJson(json);

@override final  String fullName;
@override@LocalDateConverter() final  DateTime dateOfBirth;
@override final  PatientRelationship relationship;
@override final  PatientSex? sex;
@override final  String? phoneE164;
@override final  String? email;
@override final  String? bloodGroup;
@override final  String? allergies;
@override final  String? notes;

/// Create a copy of CreateFamilyMemberRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateFamilyMemberRequestCopyWith<_CreateFamilyMemberRequest> get copyWith => __$CreateFamilyMemberRequestCopyWithImpl<_CreateFamilyMemberRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateFamilyMemberRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateFamilyMemberRequest&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.phoneE164, phoneE164) || other.phoneE164 == phoneE164)&&(identical(other.email, email) || other.email == email)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.allergies, allergies) || other.allergies == allergies)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fullName,dateOfBirth,relationship,sex,phoneE164,email,bloodGroup,allergies,notes);

@override
String toString() {
  return 'CreateFamilyMemberRequest(fullName: $fullName, dateOfBirth: $dateOfBirth, relationship: $relationship, sex: $sex, phoneE164: $phoneE164, email: $email, bloodGroup: $bloodGroup, allergies: $allergies, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$CreateFamilyMemberRequestCopyWith<$Res> implements $CreateFamilyMemberRequestCopyWith<$Res> {
  factory _$CreateFamilyMemberRequestCopyWith(_CreateFamilyMemberRequest value, $Res Function(_CreateFamilyMemberRequest) _then) = __$CreateFamilyMemberRequestCopyWithImpl;
@override @useResult
$Res call({
 String fullName,@LocalDateConverter() DateTime dateOfBirth, PatientRelationship relationship, PatientSex? sex, String? phoneE164, String? email, String? bloodGroup, String? allergies, String? notes
});




}
/// @nodoc
class __$CreateFamilyMemberRequestCopyWithImpl<$Res>
    implements _$CreateFamilyMemberRequestCopyWith<$Res> {
  __$CreateFamilyMemberRequestCopyWithImpl(this._self, this._then);

  final _CreateFamilyMemberRequest _self;
  final $Res Function(_CreateFamilyMemberRequest) _then;

/// Create a copy of CreateFamilyMemberRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fullName = null,Object? dateOfBirth = null,Object? relationship = null,Object? sex = freezed,Object? phoneE164 = freezed,Object? email = freezed,Object? bloodGroup = freezed,Object? allergies = freezed,Object? notes = freezed,}) {
  return _then(_CreateFamilyMemberRequest(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime,relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as PatientRelationship,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as PatientSex?,phoneE164: freezed == phoneE164 ? _self.phoneE164 : phoneE164 // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,bloodGroup: freezed == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as String?,allergies: freezed == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UpdatePatientRequest {

 String get fullName;@LocalDateConverter() DateTime get dateOfBirth; PatientSex? get sex; String get phoneE164; String get email; String get bloodGroup; String get allergies; String get notes;
/// Create a copy of UpdatePatientRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdatePatientRequestCopyWith<UpdatePatientRequest> get copyWith => _$UpdatePatientRequestCopyWithImpl<UpdatePatientRequest>(this as UpdatePatientRequest, _$identity);

  /// Serializes this UpdatePatientRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdatePatientRequest&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.phoneE164, phoneE164) || other.phoneE164 == phoneE164)&&(identical(other.email, email) || other.email == email)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.allergies, allergies) || other.allergies == allergies)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fullName,dateOfBirth,sex,phoneE164,email,bloodGroup,allergies,notes);

@override
String toString() {
  return 'UpdatePatientRequest(fullName: $fullName, dateOfBirth: $dateOfBirth, sex: $sex, phoneE164: $phoneE164, email: $email, bloodGroup: $bloodGroup, allergies: $allergies, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $UpdatePatientRequestCopyWith<$Res>  {
  factory $UpdatePatientRequestCopyWith(UpdatePatientRequest value, $Res Function(UpdatePatientRequest) _then) = _$UpdatePatientRequestCopyWithImpl;
@useResult
$Res call({
 String fullName,@LocalDateConverter() DateTime dateOfBirth, PatientSex? sex, String phoneE164, String email, String bloodGroup, String allergies, String notes
});




}
/// @nodoc
class _$UpdatePatientRequestCopyWithImpl<$Res>
    implements $UpdatePatientRequestCopyWith<$Res> {
  _$UpdatePatientRequestCopyWithImpl(this._self, this._then);

  final UpdatePatientRequest _self;
  final $Res Function(UpdatePatientRequest) _then;

/// Create a copy of UpdatePatientRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fullName = null,Object? dateOfBirth = null,Object? sex = freezed,Object? phoneE164 = null,Object? email = null,Object? bloodGroup = null,Object? allergies = null,Object? notes = null,}) {
  return _then(_self.copyWith(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as PatientSex?,phoneE164: null == phoneE164 ? _self.phoneE164 : phoneE164 // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,bloodGroup: null == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as String,allergies: null == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdatePatientRequest].
extension UpdatePatientRequestPatterns on UpdatePatientRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdatePatientRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdatePatientRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdatePatientRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdatePatientRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdatePatientRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdatePatientRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fullName, @LocalDateConverter()  DateTime dateOfBirth,  PatientSex? sex,  String phoneE164,  String email,  String bloodGroup,  String allergies,  String notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdatePatientRequest() when $default != null:
return $default(_that.fullName,_that.dateOfBirth,_that.sex,_that.phoneE164,_that.email,_that.bloodGroup,_that.allergies,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fullName, @LocalDateConverter()  DateTime dateOfBirth,  PatientSex? sex,  String phoneE164,  String email,  String bloodGroup,  String allergies,  String notes)  $default,) {final _that = this;
switch (_that) {
case _UpdatePatientRequest():
return $default(_that.fullName,_that.dateOfBirth,_that.sex,_that.phoneE164,_that.email,_that.bloodGroup,_that.allergies,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fullName, @LocalDateConverter()  DateTime dateOfBirth,  PatientSex? sex,  String phoneE164,  String email,  String bloodGroup,  String allergies,  String notes)?  $default,) {final _that = this;
switch (_that) {
case _UpdatePatientRequest() when $default != null:
return $default(_that.fullName,_that.dateOfBirth,_that.sex,_that.phoneE164,_that.email,_that.bloodGroup,_that.allergies,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdatePatientRequest implements UpdatePatientRequest {
  const _UpdatePatientRequest({required this.fullName, @LocalDateConverter() required this.dateOfBirth, this.sex, required this.phoneE164, required this.email, required this.bloodGroup, required this.allergies, required this.notes});
  factory _UpdatePatientRequest.fromJson(Map<String, dynamic> json) => _$UpdatePatientRequestFromJson(json);

@override final  String fullName;
@override@LocalDateConverter() final  DateTime dateOfBirth;
@override final  PatientSex? sex;
@override final  String phoneE164;
@override final  String email;
@override final  String bloodGroup;
@override final  String allergies;
@override final  String notes;

/// Create a copy of UpdatePatientRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdatePatientRequestCopyWith<_UpdatePatientRequest> get copyWith => __$UpdatePatientRequestCopyWithImpl<_UpdatePatientRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdatePatientRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdatePatientRequest&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.phoneE164, phoneE164) || other.phoneE164 == phoneE164)&&(identical(other.email, email) || other.email == email)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.allergies, allergies) || other.allergies == allergies)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fullName,dateOfBirth,sex,phoneE164,email,bloodGroup,allergies,notes);

@override
String toString() {
  return 'UpdatePatientRequest(fullName: $fullName, dateOfBirth: $dateOfBirth, sex: $sex, phoneE164: $phoneE164, email: $email, bloodGroup: $bloodGroup, allergies: $allergies, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$UpdatePatientRequestCopyWith<$Res> implements $UpdatePatientRequestCopyWith<$Res> {
  factory _$UpdatePatientRequestCopyWith(_UpdatePatientRequest value, $Res Function(_UpdatePatientRequest) _then) = __$UpdatePatientRequestCopyWithImpl;
@override @useResult
$Res call({
 String fullName,@LocalDateConverter() DateTime dateOfBirth, PatientSex? sex, String phoneE164, String email, String bloodGroup, String allergies, String notes
});




}
/// @nodoc
class __$UpdatePatientRequestCopyWithImpl<$Res>
    implements _$UpdatePatientRequestCopyWith<$Res> {
  __$UpdatePatientRequestCopyWithImpl(this._self, this._then);

  final _UpdatePatientRequest _self;
  final $Res Function(_UpdatePatientRequest) _then;

/// Create a copy of UpdatePatientRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fullName = null,Object? dateOfBirth = null,Object? sex = freezed,Object? phoneE164 = null,Object? email = null,Object? bloodGroup = null,Object? allergies = null,Object? notes = null,}) {
  return _then(_UpdatePatientRequest(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as PatientSex?,phoneE164: null == phoneE164 ? _self.phoneE164 : phoneE164 // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,bloodGroup: null == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as String,allergies: null == allergies ? _self.allergies : allergies // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
