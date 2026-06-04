// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'treatment_note_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TreatmentNote {

 String get id; String get appointmentId; String get patientId; String get authorAccountId; String? get diagnosis; String? get notes; String? get recoveryInstructions; DateTime? get nextReviewAt; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of TreatmentNote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TreatmentNoteCopyWith<TreatmentNote> get copyWith => _$TreatmentNoteCopyWithImpl<TreatmentNote>(this as TreatmentNote, _$identity);

  /// Serializes this TreatmentNote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TreatmentNote&&(identical(other.id, id) || other.id == id)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.authorAccountId, authorAccountId) || other.authorAccountId == authorAccountId)&&(identical(other.diagnosis, diagnosis) || other.diagnosis == diagnosis)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.recoveryInstructions, recoveryInstructions) || other.recoveryInstructions == recoveryInstructions)&&(identical(other.nextReviewAt, nextReviewAt) || other.nextReviewAt == nextReviewAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,appointmentId,patientId,authorAccountId,diagnosis,notes,recoveryInstructions,nextReviewAt,createdAt,updatedAt);

@override
String toString() {
  return 'TreatmentNote(id: $id, appointmentId: $appointmentId, patientId: $patientId, authorAccountId: $authorAccountId, diagnosis: $diagnosis, notes: $notes, recoveryInstructions: $recoveryInstructions, nextReviewAt: $nextReviewAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TreatmentNoteCopyWith<$Res>  {
  factory $TreatmentNoteCopyWith(TreatmentNote value, $Res Function(TreatmentNote) _then) = _$TreatmentNoteCopyWithImpl;
@useResult
$Res call({
 String id, String appointmentId, String patientId, String authorAccountId, String? diagnosis, String? notes, String? recoveryInstructions, DateTime? nextReviewAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$TreatmentNoteCopyWithImpl<$Res>
    implements $TreatmentNoteCopyWith<$Res> {
  _$TreatmentNoteCopyWithImpl(this._self, this._then);

  final TreatmentNote _self;
  final $Res Function(TreatmentNote) _then;

/// Create a copy of TreatmentNote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? appointmentId = null,Object? patientId = null,Object? authorAccountId = null,Object? diagnosis = freezed,Object? notes = freezed,Object? recoveryInstructions = freezed,Object? nextReviewAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,authorAccountId: null == authorAccountId ? _self.authorAccountId : authorAccountId // ignore: cast_nullable_to_non_nullable
as String,diagnosis: freezed == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,recoveryInstructions: freezed == recoveryInstructions ? _self.recoveryInstructions : recoveryInstructions // ignore: cast_nullable_to_non_nullable
as String?,nextReviewAt: freezed == nextReviewAt ? _self.nextReviewAt : nextReviewAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TreatmentNote].
extension TreatmentNotePatterns on TreatmentNote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TreatmentNote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TreatmentNote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TreatmentNote value)  $default,){
final _that = this;
switch (_that) {
case _TreatmentNote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TreatmentNote value)?  $default,){
final _that = this;
switch (_that) {
case _TreatmentNote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String appointmentId,  String patientId,  String authorAccountId,  String? diagnosis,  String? notes,  String? recoveryInstructions,  DateTime? nextReviewAt,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TreatmentNote() when $default != null:
return $default(_that.id,_that.appointmentId,_that.patientId,_that.authorAccountId,_that.diagnosis,_that.notes,_that.recoveryInstructions,_that.nextReviewAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String appointmentId,  String patientId,  String authorAccountId,  String? diagnosis,  String? notes,  String? recoveryInstructions,  DateTime? nextReviewAt,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TreatmentNote():
return $default(_that.id,_that.appointmentId,_that.patientId,_that.authorAccountId,_that.diagnosis,_that.notes,_that.recoveryInstructions,_that.nextReviewAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String appointmentId,  String patientId,  String authorAccountId,  String? diagnosis,  String? notes,  String? recoveryInstructions,  DateTime? nextReviewAt,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TreatmentNote() when $default != null:
return $default(_that.id,_that.appointmentId,_that.patientId,_that.authorAccountId,_that.diagnosis,_that.notes,_that.recoveryInstructions,_that.nextReviewAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TreatmentNote implements TreatmentNote {
  const _TreatmentNote({required this.id, required this.appointmentId, required this.patientId, required this.authorAccountId, this.diagnosis, this.notes, this.recoveryInstructions, this.nextReviewAt, required this.createdAt, required this.updatedAt});
  factory _TreatmentNote.fromJson(Map<String, dynamic> json) => _$TreatmentNoteFromJson(json);

@override final  String id;
@override final  String appointmentId;
@override final  String patientId;
@override final  String authorAccountId;
@override final  String? diagnosis;
@override final  String? notes;
@override final  String? recoveryInstructions;
@override final  DateTime? nextReviewAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of TreatmentNote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TreatmentNoteCopyWith<_TreatmentNote> get copyWith => __$TreatmentNoteCopyWithImpl<_TreatmentNote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TreatmentNoteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TreatmentNote&&(identical(other.id, id) || other.id == id)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.authorAccountId, authorAccountId) || other.authorAccountId == authorAccountId)&&(identical(other.diagnosis, diagnosis) || other.diagnosis == diagnosis)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.recoveryInstructions, recoveryInstructions) || other.recoveryInstructions == recoveryInstructions)&&(identical(other.nextReviewAt, nextReviewAt) || other.nextReviewAt == nextReviewAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,appointmentId,patientId,authorAccountId,diagnosis,notes,recoveryInstructions,nextReviewAt,createdAt,updatedAt);

@override
String toString() {
  return 'TreatmentNote(id: $id, appointmentId: $appointmentId, patientId: $patientId, authorAccountId: $authorAccountId, diagnosis: $diagnosis, notes: $notes, recoveryInstructions: $recoveryInstructions, nextReviewAt: $nextReviewAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TreatmentNoteCopyWith<$Res> implements $TreatmentNoteCopyWith<$Res> {
  factory _$TreatmentNoteCopyWith(_TreatmentNote value, $Res Function(_TreatmentNote) _then) = __$TreatmentNoteCopyWithImpl;
@override @useResult
$Res call({
 String id, String appointmentId, String patientId, String authorAccountId, String? diagnosis, String? notes, String? recoveryInstructions, DateTime? nextReviewAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$TreatmentNoteCopyWithImpl<$Res>
    implements _$TreatmentNoteCopyWith<$Res> {
  __$TreatmentNoteCopyWithImpl(this._self, this._then);

  final _TreatmentNote _self;
  final $Res Function(_TreatmentNote) _then;

/// Create a copy of TreatmentNote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? appointmentId = null,Object? patientId = null,Object? authorAccountId = null,Object? diagnosis = freezed,Object? notes = freezed,Object? recoveryInstructions = freezed,Object? nextReviewAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_TreatmentNote(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,authorAccountId: null == authorAccountId ? _self.authorAccountId : authorAccountId // ignore: cast_nullable_to_non_nullable
as String,diagnosis: freezed == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,recoveryInstructions: freezed == recoveryInstructions ? _self.recoveryInstructions : recoveryInstructions // ignore: cast_nullable_to_non_nullable
as String?,nextReviewAt: freezed == nextReviewAt ? _self.nextReviewAt : nextReviewAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
