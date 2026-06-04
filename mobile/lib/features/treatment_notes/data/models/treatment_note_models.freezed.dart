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


/// @nodoc
mixin _$TreatmentNotePage {

 List<TreatmentNote> get items; String? get nextCursor;
/// Create a copy of TreatmentNotePage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TreatmentNotePageCopyWith<TreatmentNotePage> get copyWith => _$TreatmentNotePageCopyWithImpl<TreatmentNotePage>(this as TreatmentNotePage, _$identity);

  /// Serializes this TreatmentNotePage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TreatmentNotePage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextCursor);

@override
String toString() {
  return 'TreatmentNotePage(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $TreatmentNotePageCopyWith<$Res>  {
  factory $TreatmentNotePageCopyWith(TreatmentNotePage value, $Res Function(TreatmentNotePage) _then) = _$TreatmentNotePageCopyWithImpl;
@useResult
$Res call({
 List<TreatmentNote> items, String? nextCursor
});




}
/// @nodoc
class _$TreatmentNotePageCopyWithImpl<$Res>
    implements $TreatmentNotePageCopyWith<$Res> {
  _$TreatmentNotePageCopyWithImpl(this._self, this._then);

  final TreatmentNotePage _self;
  final $Res Function(TreatmentNotePage) _then;

/// Create a copy of TreatmentNotePage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TreatmentNote>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TreatmentNotePage].
extension TreatmentNotePagePatterns on TreatmentNotePage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TreatmentNotePage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TreatmentNotePage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TreatmentNotePage value)  $default,){
final _that = this;
switch (_that) {
case _TreatmentNotePage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TreatmentNotePage value)?  $default,){
final _that = this;
switch (_that) {
case _TreatmentNotePage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TreatmentNote> items,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TreatmentNotePage() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TreatmentNote> items,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _TreatmentNotePage():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TreatmentNote> items,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _TreatmentNotePage() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TreatmentNotePage implements TreatmentNotePage {
  const _TreatmentNotePage({required final  List<TreatmentNote> items, this.nextCursor}): _items = items;
  factory _TreatmentNotePage.fromJson(Map<String, dynamic> json) => _$TreatmentNotePageFromJson(json);

 final  List<TreatmentNote> _items;
@override List<TreatmentNote> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String? nextCursor;

/// Create a copy of TreatmentNotePage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TreatmentNotePageCopyWith<_TreatmentNotePage> get copyWith => __$TreatmentNotePageCopyWithImpl<_TreatmentNotePage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TreatmentNotePageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TreatmentNotePage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);

@override
String toString() {
  return 'TreatmentNotePage(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$TreatmentNotePageCopyWith<$Res> implements $TreatmentNotePageCopyWith<$Res> {
  factory _$TreatmentNotePageCopyWith(_TreatmentNotePage value, $Res Function(_TreatmentNotePage) _then) = __$TreatmentNotePageCopyWithImpl;
@override @useResult
$Res call({
 List<TreatmentNote> items, String? nextCursor
});




}
/// @nodoc
class __$TreatmentNotePageCopyWithImpl<$Res>
    implements _$TreatmentNotePageCopyWith<$Res> {
  __$TreatmentNotePageCopyWithImpl(this._self, this._then);

  final _TreatmentNotePage _self;
  final $Res Function(_TreatmentNotePage) _then;

/// Create a copy of TreatmentNotePage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_TreatmentNotePage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TreatmentNote>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UpsertTreatmentNoteRequest {

 String? get diagnosis; String? get notes; String? get recoveryInstructions; DateTime? get nextReviewAt;
/// Create a copy of UpsertTreatmentNoteRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpsertTreatmentNoteRequestCopyWith<UpsertTreatmentNoteRequest> get copyWith => _$UpsertTreatmentNoteRequestCopyWithImpl<UpsertTreatmentNoteRequest>(this as UpsertTreatmentNoteRequest, _$identity);

  /// Serializes this UpsertTreatmentNoteRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpsertTreatmentNoteRequest&&(identical(other.diagnosis, diagnosis) || other.diagnosis == diagnosis)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.recoveryInstructions, recoveryInstructions) || other.recoveryInstructions == recoveryInstructions)&&(identical(other.nextReviewAt, nextReviewAt) || other.nextReviewAt == nextReviewAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,diagnosis,notes,recoveryInstructions,nextReviewAt);

@override
String toString() {
  return 'UpsertTreatmentNoteRequest(diagnosis: $diagnosis, notes: $notes, recoveryInstructions: $recoveryInstructions, nextReviewAt: $nextReviewAt)';
}


}

/// @nodoc
abstract mixin class $UpsertTreatmentNoteRequestCopyWith<$Res>  {
  factory $UpsertTreatmentNoteRequestCopyWith(UpsertTreatmentNoteRequest value, $Res Function(UpsertTreatmentNoteRequest) _then) = _$UpsertTreatmentNoteRequestCopyWithImpl;
@useResult
$Res call({
 String? diagnosis, String? notes, String? recoveryInstructions, DateTime? nextReviewAt
});




}
/// @nodoc
class _$UpsertTreatmentNoteRequestCopyWithImpl<$Res>
    implements $UpsertTreatmentNoteRequestCopyWith<$Res> {
  _$UpsertTreatmentNoteRequestCopyWithImpl(this._self, this._then);

  final UpsertTreatmentNoteRequest _self;
  final $Res Function(UpsertTreatmentNoteRequest) _then;

/// Create a copy of UpsertTreatmentNoteRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? diagnosis = freezed,Object? notes = freezed,Object? recoveryInstructions = freezed,Object? nextReviewAt = freezed,}) {
  return _then(_self.copyWith(
diagnosis: freezed == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,recoveryInstructions: freezed == recoveryInstructions ? _self.recoveryInstructions : recoveryInstructions // ignore: cast_nullable_to_non_nullable
as String?,nextReviewAt: freezed == nextReviewAt ? _self.nextReviewAt : nextReviewAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpsertTreatmentNoteRequest].
extension UpsertTreatmentNoteRequestPatterns on UpsertTreatmentNoteRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpsertTreatmentNoteRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpsertTreatmentNoteRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpsertTreatmentNoteRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpsertTreatmentNoteRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpsertTreatmentNoteRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpsertTreatmentNoteRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? diagnosis,  String? notes,  String? recoveryInstructions,  DateTime? nextReviewAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpsertTreatmentNoteRequest() when $default != null:
return $default(_that.diagnosis,_that.notes,_that.recoveryInstructions,_that.nextReviewAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? diagnosis,  String? notes,  String? recoveryInstructions,  DateTime? nextReviewAt)  $default,) {final _that = this;
switch (_that) {
case _UpsertTreatmentNoteRequest():
return $default(_that.diagnosis,_that.notes,_that.recoveryInstructions,_that.nextReviewAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? diagnosis,  String? notes,  String? recoveryInstructions,  DateTime? nextReviewAt)?  $default,) {final _that = this;
switch (_that) {
case _UpsertTreatmentNoteRequest() when $default != null:
return $default(_that.diagnosis,_that.notes,_that.recoveryInstructions,_that.nextReviewAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpsertTreatmentNoteRequest implements UpsertTreatmentNoteRequest {
  const _UpsertTreatmentNoteRequest({this.diagnosis, this.notes, this.recoveryInstructions, this.nextReviewAt});
  factory _UpsertTreatmentNoteRequest.fromJson(Map<String, dynamic> json) => _$UpsertTreatmentNoteRequestFromJson(json);

@override final  String? diagnosis;
@override final  String? notes;
@override final  String? recoveryInstructions;
@override final  DateTime? nextReviewAt;

/// Create a copy of UpsertTreatmentNoteRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpsertTreatmentNoteRequestCopyWith<_UpsertTreatmentNoteRequest> get copyWith => __$UpsertTreatmentNoteRequestCopyWithImpl<_UpsertTreatmentNoteRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpsertTreatmentNoteRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpsertTreatmentNoteRequest&&(identical(other.diagnosis, diagnosis) || other.diagnosis == diagnosis)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.recoveryInstructions, recoveryInstructions) || other.recoveryInstructions == recoveryInstructions)&&(identical(other.nextReviewAt, nextReviewAt) || other.nextReviewAt == nextReviewAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,diagnosis,notes,recoveryInstructions,nextReviewAt);

@override
String toString() {
  return 'UpsertTreatmentNoteRequest(diagnosis: $diagnosis, notes: $notes, recoveryInstructions: $recoveryInstructions, nextReviewAt: $nextReviewAt)';
}


}

/// @nodoc
abstract mixin class _$UpsertTreatmentNoteRequestCopyWith<$Res> implements $UpsertTreatmentNoteRequestCopyWith<$Res> {
  factory _$UpsertTreatmentNoteRequestCopyWith(_UpsertTreatmentNoteRequest value, $Res Function(_UpsertTreatmentNoteRequest) _then) = __$UpsertTreatmentNoteRequestCopyWithImpl;
@override @useResult
$Res call({
 String? diagnosis, String? notes, String? recoveryInstructions, DateTime? nextReviewAt
});




}
/// @nodoc
class __$UpsertTreatmentNoteRequestCopyWithImpl<$Res>
    implements _$UpsertTreatmentNoteRequestCopyWith<$Res> {
  __$UpsertTreatmentNoteRequestCopyWithImpl(this._self, this._then);

  final _UpsertTreatmentNoteRequest _self;
  final $Res Function(_UpsertTreatmentNoteRequest) _then;

/// Create a copy of UpsertTreatmentNoteRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? diagnosis = freezed,Object? notes = freezed,Object? recoveryInstructions = freezed,Object? nextReviewAt = freezed,}) {
  return _then(_UpsertTreatmentNoteRequest(
diagnosis: freezed == diagnosis ? _self.diagnosis : diagnosis // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,recoveryInstructions: freezed == recoveryInstructions ? _self.recoveryInstructions : recoveryInstructions // ignore: cast_nullable_to_non_nullable
as String?,nextReviewAt: freezed == nextReviewAt ? _self.nextReviewAt : nextReviewAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
