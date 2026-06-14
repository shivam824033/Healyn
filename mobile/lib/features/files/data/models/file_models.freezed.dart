// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PresignRequest {

 String get patientId; String? get appointmentId; FileKind get kind; String? get context; String? get uploadSource; String get mimeType; int get sizeBytes; String get originalFilename;
/// Create a copy of PresignRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PresignRequestCopyWith<PresignRequest> get copyWith => _$PresignRequestCopyWithImpl<PresignRequest>(this as PresignRequest, _$identity);

  /// Serializes this PresignRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PresignRequest&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.context, context) || other.context == context)&&(identical(other.uploadSource, uploadSource) || other.uploadSource == uploadSource)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.originalFilename, originalFilename) || other.originalFilename == originalFilename));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,patientId,appointmentId,kind,context,uploadSource,mimeType,sizeBytes,originalFilename);

@override
String toString() {
  return 'PresignRequest(patientId: $patientId, appointmentId: $appointmentId, kind: $kind, context: $context, uploadSource: $uploadSource, mimeType: $mimeType, sizeBytes: $sizeBytes, originalFilename: $originalFilename)';
}


}

/// @nodoc
abstract mixin class $PresignRequestCopyWith<$Res>  {
  factory $PresignRequestCopyWith(PresignRequest value, $Res Function(PresignRequest) _then) = _$PresignRequestCopyWithImpl;
@useResult
$Res call({
 String patientId, String? appointmentId, FileKind kind, String? context, String? uploadSource, String mimeType, int sizeBytes, String originalFilename
});




}
/// @nodoc
class _$PresignRequestCopyWithImpl<$Res>
    implements $PresignRequestCopyWith<$Res> {
  _$PresignRequestCopyWithImpl(this._self, this._then);

  final PresignRequest _self;
  final $Res Function(PresignRequest) _then;

/// Create a copy of PresignRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? patientId = null,Object? appointmentId = freezed,Object? kind = null,Object? context = freezed,Object? uploadSource = freezed,Object? mimeType = null,Object? sizeBytes = null,Object? originalFilename = null,}) {
  return _then(_self.copyWith(
patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,appointmentId: freezed == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as FileKind,context: freezed == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as String?,uploadSource: freezed == uploadSource ? _self.uploadSource : uploadSource // ignore: cast_nullable_to_non_nullable
as String?,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,originalFilename: null == originalFilename ? _self.originalFilename : originalFilename // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PresignRequest].
extension PresignRequestPatterns on PresignRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PresignRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PresignRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PresignRequest value)  $default,){
final _that = this;
switch (_that) {
case _PresignRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PresignRequest value)?  $default,){
final _that = this;
switch (_that) {
case _PresignRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String patientId,  String? appointmentId,  FileKind kind,  String? context,  String? uploadSource,  String mimeType,  int sizeBytes,  String originalFilename)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PresignRequest() when $default != null:
return $default(_that.patientId,_that.appointmentId,_that.kind,_that.context,_that.uploadSource,_that.mimeType,_that.sizeBytes,_that.originalFilename);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String patientId,  String? appointmentId,  FileKind kind,  String? context,  String? uploadSource,  String mimeType,  int sizeBytes,  String originalFilename)  $default,) {final _that = this;
switch (_that) {
case _PresignRequest():
return $default(_that.patientId,_that.appointmentId,_that.kind,_that.context,_that.uploadSource,_that.mimeType,_that.sizeBytes,_that.originalFilename);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String patientId,  String? appointmentId,  FileKind kind,  String? context,  String? uploadSource,  String mimeType,  int sizeBytes,  String originalFilename)?  $default,) {final _that = this;
switch (_that) {
case _PresignRequest() when $default != null:
return $default(_that.patientId,_that.appointmentId,_that.kind,_that.context,_that.uploadSource,_that.mimeType,_that.sizeBytes,_that.originalFilename);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PresignRequest implements PresignRequest {
  const _PresignRequest({required this.patientId, this.appointmentId, required this.kind, this.context, this.uploadSource, required this.mimeType, required this.sizeBytes, required this.originalFilename});
  factory _PresignRequest.fromJson(Map<String, dynamic> json) => _$PresignRequestFromJson(json);

@override final  String patientId;
@override final  String? appointmentId;
@override final  FileKind kind;
@override final  String? context;
@override final  String? uploadSource;
@override final  String mimeType;
@override final  int sizeBytes;
@override final  String originalFilename;

/// Create a copy of PresignRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PresignRequestCopyWith<_PresignRequest> get copyWith => __$PresignRequestCopyWithImpl<_PresignRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PresignRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PresignRequest&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.context, context) || other.context == context)&&(identical(other.uploadSource, uploadSource) || other.uploadSource == uploadSource)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.originalFilename, originalFilename) || other.originalFilename == originalFilename));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,patientId,appointmentId,kind,context,uploadSource,mimeType,sizeBytes,originalFilename);

@override
String toString() {
  return 'PresignRequest(patientId: $patientId, appointmentId: $appointmentId, kind: $kind, context: $context, uploadSource: $uploadSource, mimeType: $mimeType, sizeBytes: $sizeBytes, originalFilename: $originalFilename)';
}


}

/// @nodoc
abstract mixin class _$PresignRequestCopyWith<$Res> implements $PresignRequestCopyWith<$Res> {
  factory _$PresignRequestCopyWith(_PresignRequest value, $Res Function(_PresignRequest) _then) = __$PresignRequestCopyWithImpl;
@override @useResult
$Res call({
 String patientId, String? appointmentId, FileKind kind, String? context, String? uploadSource, String mimeType, int sizeBytes, String originalFilename
});




}
/// @nodoc
class __$PresignRequestCopyWithImpl<$Res>
    implements _$PresignRequestCopyWith<$Res> {
  __$PresignRequestCopyWithImpl(this._self, this._then);

  final _PresignRequest _self;
  final $Res Function(_PresignRequest) _then;

/// Create a copy of PresignRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? patientId = null,Object? appointmentId = freezed,Object? kind = null,Object? context = freezed,Object? uploadSource = freezed,Object? mimeType = null,Object? sizeBytes = null,Object? originalFilename = null,}) {
  return _then(_PresignRequest(
patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,appointmentId: freezed == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as FileKind,context: freezed == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as String?,uploadSource: freezed == uploadSource ? _self.uploadSource : uploadSource // ignore: cast_nullable_to_non_nullable
as String?,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,originalFilename: null == originalFilename ? _self.originalFilename : originalFilename // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$FileDocument {

 String get id; String get patientId; FileKind get kind; String get mimeType; String get originalFilename; int get sizeBytes; DocumentUploaderRole get uploadedByRole; String? get appointmentId; String? get appointmentNumber; DateTime? get createdAt;
/// Create a copy of FileDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileDocumentCopyWith<FileDocument> get copyWith => _$FileDocumentCopyWithImpl<FileDocument>(this as FileDocument, _$identity);

  /// Serializes this FileDocument to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileDocument&&(identical(other.id, id) || other.id == id)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.originalFilename, originalFilename) || other.originalFilename == originalFilename)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.uploadedByRole, uploadedByRole) || other.uploadedByRole == uploadedByRole)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.appointmentNumber, appointmentNumber) || other.appointmentNumber == appointmentNumber)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,patientId,kind,mimeType,originalFilename,sizeBytes,uploadedByRole,appointmentId,appointmentNumber,createdAt);

@override
String toString() {
  return 'FileDocument(id: $id, patientId: $patientId, kind: $kind, mimeType: $mimeType, originalFilename: $originalFilename, sizeBytes: $sizeBytes, uploadedByRole: $uploadedByRole, appointmentId: $appointmentId, appointmentNumber: $appointmentNumber, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $FileDocumentCopyWith<$Res>  {
  factory $FileDocumentCopyWith(FileDocument value, $Res Function(FileDocument) _then) = _$FileDocumentCopyWithImpl;
@useResult
$Res call({
 String id, String patientId, FileKind kind, String mimeType, String originalFilename, int sizeBytes, DocumentUploaderRole uploadedByRole, String? appointmentId, String? appointmentNumber, DateTime? createdAt
});




}
/// @nodoc
class _$FileDocumentCopyWithImpl<$Res>
    implements $FileDocumentCopyWith<$Res> {
  _$FileDocumentCopyWithImpl(this._self, this._then);

  final FileDocument _self;
  final $Res Function(FileDocument) _then;

/// Create a copy of FileDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? patientId = null,Object? kind = null,Object? mimeType = null,Object? originalFilename = null,Object? sizeBytes = null,Object? uploadedByRole = null,Object? appointmentId = freezed,Object? appointmentNumber = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as FileKind,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,originalFilename: null == originalFilename ? _self.originalFilename : originalFilename // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,uploadedByRole: null == uploadedByRole ? _self.uploadedByRole : uploadedByRole // ignore: cast_nullable_to_non_nullable
as DocumentUploaderRole,appointmentId: freezed == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String?,appointmentNumber: freezed == appointmentNumber ? _self.appointmentNumber : appointmentNumber // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FileDocument].
extension FileDocumentPatterns on FileDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FileDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FileDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FileDocument value)  $default,){
final _that = this;
switch (_that) {
case _FileDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FileDocument value)?  $default,){
final _that = this;
switch (_that) {
case _FileDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String patientId,  FileKind kind,  String mimeType,  String originalFilename,  int sizeBytes,  DocumentUploaderRole uploadedByRole,  String? appointmentId,  String? appointmentNumber,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FileDocument() when $default != null:
return $default(_that.id,_that.patientId,_that.kind,_that.mimeType,_that.originalFilename,_that.sizeBytes,_that.uploadedByRole,_that.appointmentId,_that.appointmentNumber,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String patientId,  FileKind kind,  String mimeType,  String originalFilename,  int sizeBytes,  DocumentUploaderRole uploadedByRole,  String? appointmentId,  String? appointmentNumber,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _FileDocument():
return $default(_that.id,_that.patientId,_that.kind,_that.mimeType,_that.originalFilename,_that.sizeBytes,_that.uploadedByRole,_that.appointmentId,_that.appointmentNumber,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String patientId,  FileKind kind,  String mimeType,  String originalFilename,  int sizeBytes,  DocumentUploaderRole uploadedByRole,  String? appointmentId,  String? appointmentNumber,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _FileDocument() when $default != null:
return $default(_that.id,_that.patientId,_that.kind,_that.mimeType,_that.originalFilename,_that.sizeBytes,_that.uploadedByRole,_that.appointmentId,_that.appointmentNumber,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FileDocument implements FileDocument {
  const _FileDocument({required this.id, required this.patientId, required this.kind, required this.mimeType, required this.originalFilename, required this.sizeBytes, required this.uploadedByRole, this.appointmentId, this.appointmentNumber, this.createdAt});
  factory _FileDocument.fromJson(Map<String, dynamic> json) => _$FileDocumentFromJson(json);

@override final  String id;
@override final  String patientId;
@override final  FileKind kind;
@override final  String mimeType;
@override final  String originalFilename;
@override final  int sizeBytes;
@override final  DocumentUploaderRole uploadedByRole;
@override final  String? appointmentId;
@override final  String? appointmentNumber;
@override final  DateTime? createdAt;

/// Create a copy of FileDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileDocumentCopyWith<_FileDocument> get copyWith => __$FileDocumentCopyWithImpl<_FileDocument>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FileDocumentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FileDocument&&(identical(other.id, id) || other.id == id)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.originalFilename, originalFilename) || other.originalFilename == originalFilename)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.uploadedByRole, uploadedByRole) || other.uploadedByRole == uploadedByRole)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.appointmentNumber, appointmentNumber) || other.appointmentNumber == appointmentNumber)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,patientId,kind,mimeType,originalFilename,sizeBytes,uploadedByRole,appointmentId,appointmentNumber,createdAt);

@override
String toString() {
  return 'FileDocument(id: $id, patientId: $patientId, kind: $kind, mimeType: $mimeType, originalFilename: $originalFilename, sizeBytes: $sizeBytes, uploadedByRole: $uploadedByRole, appointmentId: $appointmentId, appointmentNumber: $appointmentNumber, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FileDocumentCopyWith<$Res> implements $FileDocumentCopyWith<$Res> {
  factory _$FileDocumentCopyWith(_FileDocument value, $Res Function(_FileDocument) _then) = __$FileDocumentCopyWithImpl;
@override @useResult
$Res call({
 String id, String patientId, FileKind kind, String mimeType, String originalFilename, int sizeBytes, DocumentUploaderRole uploadedByRole, String? appointmentId, String? appointmentNumber, DateTime? createdAt
});




}
/// @nodoc
class __$FileDocumentCopyWithImpl<$Res>
    implements _$FileDocumentCopyWith<$Res> {
  __$FileDocumentCopyWithImpl(this._self, this._then);

  final _FileDocument _self;
  final $Res Function(_FileDocument) _then;

/// Create a copy of FileDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? patientId = null,Object? kind = null,Object? mimeType = null,Object? originalFilename = null,Object? sizeBytes = null,Object? uploadedByRole = null,Object? appointmentId = freezed,Object? appointmentNumber = freezed,Object? createdAt = freezed,}) {
  return _then(_FileDocument(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as FileKind,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,originalFilename: null == originalFilename ? _self.originalFilename : originalFilename // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,uploadedByRole: null == uploadedByRole ? _self.uploadedByRole : uploadedByRole // ignore: cast_nullable_to_non_nullable
as DocumentUploaderRole,appointmentId: freezed == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String?,appointmentNumber: freezed == appointmentNumber ? _self.appointmentNumber : appointmentNumber // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$DocumentPage {

 List<FileDocument> get items; String? get nextCursor;
/// Create a copy of DocumentPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentPageCopyWith<DocumentPage> get copyWith => _$DocumentPageCopyWithImpl<DocumentPage>(this as DocumentPage, _$identity);

  /// Serializes this DocumentPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextCursor);

@override
String toString() {
  return 'DocumentPage(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $DocumentPageCopyWith<$Res>  {
  factory $DocumentPageCopyWith(DocumentPage value, $Res Function(DocumentPage) _then) = _$DocumentPageCopyWithImpl;
@useResult
$Res call({
 List<FileDocument> items, String? nextCursor
});




}
/// @nodoc
class _$DocumentPageCopyWithImpl<$Res>
    implements $DocumentPageCopyWith<$Res> {
  _$DocumentPageCopyWithImpl(this._self, this._then);

  final DocumentPage _self;
  final $Res Function(DocumentPage) _then;

/// Create a copy of DocumentPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<FileDocument>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentPage].
extension DocumentPagePatterns on DocumentPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentPage value)  $default,){
final _that = this;
switch (_that) {
case _DocumentPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentPage value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<FileDocument> items,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentPage() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<FileDocument> items,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _DocumentPage():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<FileDocument> items,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _DocumentPage() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DocumentPage implements DocumentPage {
  const _DocumentPage({final  List<FileDocument> items = const <FileDocument>[], this.nextCursor}): _items = items;
  factory _DocumentPage.fromJson(Map<String, dynamic> json) => _$DocumentPageFromJson(json);

 final  List<FileDocument> _items;
@override@JsonKey() List<FileDocument> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String? nextCursor;

/// Create a copy of DocumentPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentPageCopyWith<_DocumentPage> get copyWith => __$DocumentPageCopyWithImpl<_DocumentPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocumentPageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);

@override
String toString() {
  return 'DocumentPage(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$DocumentPageCopyWith<$Res> implements $DocumentPageCopyWith<$Res> {
  factory _$DocumentPageCopyWith(_DocumentPage value, $Res Function(_DocumentPage) _then) = __$DocumentPageCopyWithImpl;
@override @useResult
$Res call({
 List<FileDocument> items, String? nextCursor
});




}
/// @nodoc
class __$DocumentPageCopyWithImpl<$Res>
    implements _$DocumentPageCopyWith<$Res> {
  __$DocumentPageCopyWithImpl(this._self, this._then);

  final _DocumentPage _self;
  final $Res Function(_DocumentPage) _then;

/// Create a copy of DocumentPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_DocumentPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<FileDocument>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UploadTarget {

 String get method; String get url; Map<String, String> get headers; int get expiresInSeconds;
/// Create a copy of UploadTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadTargetCopyWith<UploadTarget> get copyWith => _$UploadTargetCopyWithImpl<UploadTarget>(this as UploadTarget, _$identity);

  /// Serializes this UploadTarget to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadTarget&&(identical(other.method, method) || other.method == method)&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other.headers, headers)&&(identical(other.expiresInSeconds, expiresInSeconds) || other.expiresInSeconds == expiresInSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,method,url,const DeepCollectionEquality().hash(headers),expiresInSeconds);

@override
String toString() {
  return 'UploadTarget(method: $method, url: $url, headers: $headers, expiresInSeconds: $expiresInSeconds)';
}


}

/// @nodoc
abstract mixin class $UploadTargetCopyWith<$Res>  {
  factory $UploadTargetCopyWith(UploadTarget value, $Res Function(UploadTarget) _then) = _$UploadTargetCopyWithImpl;
@useResult
$Res call({
 String method, String url, Map<String, String> headers, int expiresInSeconds
});




}
/// @nodoc
class _$UploadTargetCopyWithImpl<$Res>
    implements $UploadTargetCopyWith<$Res> {
  _$UploadTargetCopyWithImpl(this._self, this._then);

  final UploadTarget _self;
  final $Res Function(UploadTarget) _then;

/// Create a copy of UploadTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? method = null,Object? url = null,Object? headers = null,Object? expiresInSeconds = null,}) {
  return _then(_self.copyWith(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,headers: null == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,expiresInSeconds: null == expiresInSeconds ? _self.expiresInSeconds : expiresInSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UploadTarget].
extension UploadTargetPatterns on UploadTarget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UploadTarget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UploadTarget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UploadTarget value)  $default,){
final _that = this;
switch (_that) {
case _UploadTarget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UploadTarget value)?  $default,){
final _that = this;
switch (_that) {
case _UploadTarget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String method,  String url,  Map<String, String> headers,  int expiresInSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UploadTarget() when $default != null:
return $default(_that.method,_that.url,_that.headers,_that.expiresInSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String method,  String url,  Map<String, String> headers,  int expiresInSeconds)  $default,) {final _that = this;
switch (_that) {
case _UploadTarget():
return $default(_that.method,_that.url,_that.headers,_that.expiresInSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String method,  String url,  Map<String, String> headers,  int expiresInSeconds)?  $default,) {final _that = this;
switch (_that) {
case _UploadTarget() when $default != null:
return $default(_that.method,_that.url,_that.headers,_that.expiresInSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UploadTarget implements UploadTarget {
  const _UploadTarget({required this.method, required this.url, final  Map<String, String> headers = const <String, String>{}, required this.expiresInSeconds}): _headers = headers;
  factory _UploadTarget.fromJson(Map<String, dynamic> json) => _$UploadTargetFromJson(json);

@override final  String method;
@override final  String url;
 final  Map<String, String> _headers;
@override@JsonKey() Map<String, String> get headers {
  if (_headers is EqualUnmodifiableMapView) return _headers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_headers);
}

@override final  int expiresInSeconds;

/// Create a copy of UploadTarget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UploadTargetCopyWith<_UploadTarget> get copyWith => __$UploadTargetCopyWithImpl<_UploadTarget>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UploadTargetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadTarget&&(identical(other.method, method) || other.method == method)&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other._headers, _headers)&&(identical(other.expiresInSeconds, expiresInSeconds) || other.expiresInSeconds == expiresInSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,method,url,const DeepCollectionEquality().hash(_headers),expiresInSeconds);

@override
String toString() {
  return 'UploadTarget(method: $method, url: $url, headers: $headers, expiresInSeconds: $expiresInSeconds)';
}


}

/// @nodoc
abstract mixin class _$UploadTargetCopyWith<$Res> implements $UploadTargetCopyWith<$Res> {
  factory _$UploadTargetCopyWith(_UploadTarget value, $Res Function(_UploadTarget) _then) = __$UploadTargetCopyWithImpl;
@override @useResult
$Res call({
 String method, String url, Map<String, String> headers, int expiresInSeconds
});




}
/// @nodoc
class __$UploadTargetCopyWithImpl<$Res>
    implements _$UploadTargetCopyWith<$Res> {
  __$UploadTargetCopyWithImpl(this._self, this._then);

  final _UploadTarget _self;
  final $Res Function(_UploadTarget) _then;

/// Create a copy of UploadTarget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? method = null,Object? url = null,Object? headers = null,Object? expiresInSeconds = null,}) {
  return _then(_UploadTarget(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,headers: null == headers ? _self._headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,expiresInSeconds: null == expiresInSeconds ? _self.expiresInSeconds : expiresInSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DownloadTarget {

 String get url; int get expiresInSeconds;
/// Create a copy of DownloadTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadTargetCopyWith<DownloadTarget> get copyWith => _$DownloadTargetCopyWithImpl<DownloadTarget>(this as DownloadTarget, _$identity);

  /// Serializes this DownloadTarget to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadTarget&&(identical(other.url, url) || other.url == url)&&(identical(other.expiresInSeconds, expiresInSeconds) || other.expiresInSeconds == expiresInSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,expiresInSeconds);

@override
String toString() {
  return 'DownloadTarget(url: $url, expiresInSeconds: $expiresInSeconds)';
}


}

/// @nodoc
abstract mixin class $DownloadTargetCopyWith<$Res>  {
  factory $DownloadTargetCopyWith(DownloadTarget value, $Res Function(DownloadTarget) _then) = _$DownloadTargetCopyWithImpl;
@useResult
$Res call({
 String url, int expiresInSeconds
});




}
/// @nodoc
class _$DownloadTargetCopyWithImpl<$Res>
    implements $DownloadTargetCopyWith<$Res> {
  _$DownloadTargetCopyWithImpl(this._self, this._then);

  final DownloadTarget _self;
  final $Res Function(DownloadTarget) _then;

/// Create a copy of DownloadTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? expiresInSeconds = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,expiresInSeconds: null == expiresInSeconds ? _self.expiresInSeconds : expiresInSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DownloadTarget].
extension DownloadTargetPatterns on DownloadTarget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DownloadTarget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DownloadTarget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DownloadTarget value)  $default,){
final _that = this;
switch (_that) {
case _DownloadTarget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DownloadTarget value)?  $default,){
final _that = this;
switch (_that) {
case _DownloadTarget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  int expiresInSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DownloadTarget() when $default != null:
return $default(_that.url,_that.expiresInSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  int expiresInSeconds)  $default,) {final _that = this;
switch (_that) {
case _DownloadTarget():
return $default(_that.url,_that.expiresInSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  int expiresInSeconds)?  $default,) {final _that = this;
switch (_that) {
case _DownloadTarget() when $default != null:
return $default(_that.url,_that.expiresInSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DownloadTarget implements DownloadTarget {
  const _DownloadTarget({required this.url, required this.expiresInSeconds});
  factory _DownloadTarget.fromJson(Map<String, dynamic> json) => _$DownloadTargetFromJson(json);

@override final  String url;
@override final  int expiresInSeconds;

/// Create a copy of DownloadTarget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadTargetCopyWith<_DownloadTarget> get copyWith => __$DownloadTargetCopyWithImpl<_DownloadTarget>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DownloadTargetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DownloadTarget&&(identical(other.url, url) || other.url == url)&&(identical(other.expiresInSeconds, expiresInSeconds) || other.expiresInSeconds == expiresInSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,expiresInSeconds);

@override
String toString() {
  return 'DownloadTarget(url: $url, expiresInSeconds: $expiresInSeconds)';
}


}

/// @nodoc
abstract mixin class _$DownloadTargetCopyWith<$Res> implements $DownloadTargetCopyWith<$Res> {
  factory _$DownloadTargetCopyWith(_DownloadTarget value, $Res Function(_DownloadTarget) _then) = __$DownloadTargetCopyWithImpl;
@override @useResult
$Res call({
 String url, int expiresInSeconds
});




}
/// @nodoc
class __$DownloadTargetCopyWithImpl<$Res>
    implements _$DownloadTargetCopyWith<$Res> {
  __$DownloadTargetCopyWithImpl(this._self, this._then);

  final _DownloadTarget _self;
  final $Res Function(_DownloadTarget) _then;

/// Create a copy of DownloadTarget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? expiresInSeconds = null,}) {
  return _then(_DownloadTarget(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,expiresInSeconds: null == expiresInSeconds ? _self.expiresInSeconds : expiresInSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PresignResponse {

 String get fileId; UploadTarget get upload;
/// Create a copy of PresignResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PresignResponseCopyWith<PresignResponse> get copyWith => _$PresignResponseCopyWithImpl<PresignResponse>(this as PresignResponse, _$identity);

  /// Serializes this PresignResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PresignResponse&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.upload, upload) || other.upload == upload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,upload);

@override
String toString() {
  return 'PresignResponse(fileId: $fileId, upload: $upload)';
}


}

/// @nodoc
abstract mixin class $PresignResponseCopyWith<$Res>  {
  factory $PresignResponseCopyWith(PresignResponse value, $Res Function(PresignResponse) _then) = _$PresignResponseCopyWithImpl;
@useResult
$Res call({
 String fileId, UploadTarget upload
});


$UploadTargetCopyWith<$Res> get upload;

}
/// @nodoc
class _$PresignResponseCopyWithImpl<$Res>
    implements $PresignResponseCopyWith<$Res> {
  _$PresignResponseCopyWithImpl(this._self, this._then);

  final PresignResponse _self;
  final $Res Function(PresignResponse) _then;

/// Create a copy of PresignResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileId = null,Object? upload = null,}) {
  return _then(_self.copyWith(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,upload: null == upload ? _self.upload : upload // ignore: cast_nullable_to_non_nullable
as UploadTarget,
  ));
}
/// Create a copy of PresignResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadTargetCopyWith<$Res> get upload {
  
  return $UploadTargetCopyWith<$Res>(_self.upload, (value) {
    return _then(_self.copyWith(upload: value));
  });
}
}


/// Adds pattern-matching-related methods to [PresignResponse].
extension PresignResponsePatterns on PresignResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PresignResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PresignResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PresignResponse value)  $default,){
final _that = this;
switch (_that) {
case _PresignResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PresignResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PresignResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileId,  UploadTarget upload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PresignResponse() when $default != null:
return $default(_that.fileId,_that.upload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileId,  UploadTarget upload)  $default,) {final _that = this;
switch (_that) {
case _PresignResponse():
return $default(_that.fileId,_that.upload);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileId,  UploadTarget upload)?  $default,) {final _that = this;
switch (_that) {
case _PresignResponse() when $default != null:
return $default(_that.fileId,_that.upload);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PresignResponse implements PresignResponse {
  const _PresignResponse({required this.fileId, required this.upload});
  factory _PresignResponse.fromJson(Map<String, dynamic> json) => _$PresignResponseFromJson(json);

@override final  String fileId;
@override final  UploadTarget upload;

/// Create a copy of PresignResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PresignResponseCopyWith<_PresignResponse> get copyWith => __$PresignResponseCopyWithImpl<_PresignResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PresignResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PresignResponse&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.upload, upload) || other.upload == upload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,upload);

@override
String toString() {
  return 'PresignResponse(fileId: $fileId, upload: $upload)';
}


}

/// @nodoc
abstract mixin class _$PresignResponseCopyWith<$Res> implements $PresignResponseCopyWith<$Res> {
  factory _$PresignResponseCopyWith(_PresignResponse value, $Res Function(_PresignResponse) _then) = __$PresignResponseCopyWithImpl;
@override @useResult
$Res call({
 String fileId, UploadTarget upload
});


@override $UploadTargetCopyWith<$Res> get upload;

}
/// @nodoc
class __$PresignResponseCopyWithImpl<$Res>
    implements _$PresignResponseCopyWith<$Res> {
  __$PresignResponseCopyWithImpl(this._self, this._then);

  final _PresignResponse _self;
  final $Res Function(_PresignResponse) _then;

/// Create a copy of PresignResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileId = null,Object? upload = null,}) {
  return _then(_PresignResponse(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,upload: null == upload ? _self.upload : upload // ignore: cast_nullable_to_non_nullable
as UploadTarget,
  ));
}

/// Create a copy of PresignResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadTargetCopyWith<$Res> get upload {
  
  return $UploadTargetCopyWith<$Res>(_self.upload, (value) {
    return _then(_self.copyWith(upload: value));
  });
}
}


/// @nodoc
mixin _$FileObjectView {

 String get id; String get patientId; String get ownerAccountId; FileKind get kind; String get mimeType; String get originalFilename; int get sizeBytes; FileStatus get status; DateTime? get createdAt; DateTime? get availableAt;
/// Create a copy of FileObjectView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileObjectViewCopyWith<FileObjectView> get copyWith => _$FileObjectViewCopyWithImpl<FileObjectView>(this as FileObjectView, _$identity);

  /// Serializes this FileObjectView to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileObjectView&&(identical(other.id, id) || other.id == id)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.ownerAccountId, ownerAccountId) || other.ownerAccountId == ownerAccountId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.originalFilename, originalFilename) || other.originalFilename == originalFilename)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.availableAt, availableAt) || other.availableAt == availableAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,patientId,ownerAccountId,kind,mimeType,originalFilename,sizeBytes,status,createdAt,availableAt);

@override
String toString() {
  return 'FileObjectView(id: $id, patientId: $patientId, ownerAccountId: $ownerAccountId, kind: $kind, mimeType: $mimeType, originalFilename: $originalFilename, sizeBytes: $sizeBytes, status: $status, createdAt: $createdAt, availableAt: $availableAt)';
}


}

/// @nodoc
abstract mixin class $FileObjectViewCopyWith<$Res>  {
  factory $FileObjectViewCopyWith(FileObjectView value, $Res Function(FileObjectView) _then) = _$FileObjectViewCopyWithImpl;
@useResult
$Res call({
 String id, String patientId, String ownerAccountId, FileKind kind, String mimeType, String originalFilename, int sizeBytes, FileStatus status, DateTime? createdAt, DateTime? availableAt
});




}
/// @nodoc
class _$FileObjectViewCopyWithImpl<$Res>
    implements $FileObjectViewCopyWith<$Res> {
  _$FileObjectViewCopyWithImpl(this._self, this._then);

  final FileObjectView _self;
  final $Res Function(FileObjectView) _then;

/// Create a copy of FileObjectView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? patientId = null,Object? ownerAccountId = null,Object? kind = null,Object? mimeType = null,Object? originalFilename = null,Object? sizeBytes = null,Object? status = null,Object? createdAt = freezed,Object? availableAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,ownerAccountId: null == ownerAccountId ? _self.ownerAccountId : ownerAccountId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as FileKind,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,originalFilename: null == originalFilename ? _self.originalFilename : originalFilename // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FileStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,availableAt: freezed == availableAt ? _self.availableAt : availableAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FileObjectView].
extension FileObjectViewPatterns on FileObjectView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FileObjectView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FileObjectView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FileObjectView value)  $default,){
final _that = this;
switch (_that) {
case _FileObjectView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FileObjectView value)?  $default,){
final _that = this;
switch (_that) {
case _FileObjectView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String patientId,  String ownerAccountId,  FileKind kind,  String mimeType,  String originalFilename,  int sizeBytes,  FileStatus status,  DateTime? createdAt,  DateTime? availableAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FileObjectView() when $default != null:
return $default(_that.id,_that.patientId,_that.ownerAccountId,_that.kind,_that.mimeType,_that.originalFilename,_that.sizeBytes,_that.status,_that.createdAt,_that.availableAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String patientId,  String ownerAccountId,  FileKind kind,  String mimeType,  String originalFilename,  int sizeBytes,  FileStatus status,  DateTime? createdAt,  DateTime? availableAt)  $default,) {final _that = this;
switch (_that) {
case _FileObjectView():
return $default(_that.id,_that.patientId,_that.ownerAccountId,_that.kind,_that.mimeType,_that.originalFilename,_that.sizeBytes,_that.status,_that.createdAt,_that.availableAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String patientId,  String ownerAccountId,  FileKind kind,  String mimeType,  String originalFilename,  int sizeBytes,  FileStatus status,  DateTime? createdAt,  DateTime? availableAt)?  $default,) {final _that = this;
switch (_that) {
case _FileObjectView() when $default != null:
return $default(_that.id,_that.patientId,_that.ownerAccountId,_that.kind,_that.mimeType,_that.originalFilename,_that.sizeBytes,_that.status,_that.createdAt,_that.availableAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FileObjectView implements FileObjectView {
  const _FileObjectView({required this.id, required this.patientId, required this.ownerAccountId, required this.kind, required this.mimeType, required this.originalFilename, required this.sizeBytes, required this.status, this.createdAt, this.availableAt});
  factory _FileObjectView.fromJson(Map<String, dynamic> json) => _$FileObjectViewFromJson(json);

@override final  String id;
@override final  String patientId;
@override final  String ownerAccountId;
@override final  FileKind kind;
@override final  String mimeType;
@override final  String originalFilename;
@override final  int sizeBytes;
@override final  FileStatus status;
@override final  DateTime? createdAt;
@override final  DateTime? availableAt;

/// Create a copy of FileObjectView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileObjectViewCopyWith<_FileObjectView> get copyWith => __$FileObjectViewCopyWithImpl<_FileObjectView>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FileObjectViewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FileObjectView&&(identical(other.id, id) || other.id == id)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.ownerAccountId, ownerAccountId) || other.ownerAccountId == ownerAccountId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.originalFilename, originalFilename) || other.originalFilename == originalFilename)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.availableAt, availableAt) || other.availableAt == availableAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,patientId,ownerAccountId,kind,mimeType,originalFilename,sizeBytes,status,createdAt,availableAt);

@override
String toString() {
  return 'FileObjectView(id: $id, patientId: $patientId, ownerAccountId: $ownerAccountId, kind: $kind, mimeType: $mimeType, originalFilename: $originalFilename, sizeBytes: $sizeBytes, status: $status, createdAt: $createdAt, availableAt: $availableAt)';
}


}

/// @nodoc
abstract mixin class _$FileObjectViewCopyWith<$Res> implements $FileObjectViewCopyWith<$Res> {
  factory _$FileObjectViewCopyWith(_FileObjectView value, $Res Function(_FileObjectView) _then) = __$FileObjectViewCopyWithImpl;
@override @useResult
$Res call({
 String id, String patientId, String ownerAccountId, FileKind kind, String mimeType, String originalFilename, int sizeBytes, FileStatus status, DateTime? createdAt, DateTime? availableAt
});




}
/// @nodoc
class __$FileObjectViewCopyWithImpl<$Res>
    implements _$FileObjectViewCopyWith<$Res> {
  __$FileObjectViewCopyWithImpl(this._self, this._then);

  final _FileObjectView _self;
  final $Res Function(_FileObjectView) _then;

/// Create a copy of FileObjectView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? patientId = null,Object? ownerAccountId = null,Object? kind = null,Object? mimeType = null,Object? originalFilename = null,Object? sizeBytes = null,Object? status = null,Object? createdAt = freezed,Object? availableAt = freezed,}) {
  return _then(_FileObjectView(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,ownerAccountId: null == ownerAccountId ? _self.ownerAccountId : ownerAccountId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as FileKind,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,originalFilename: null == originalFilename ? _self.originalFilename : originalFilename // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FileStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,availableAt: freezed == availableAt ? _self.availableAt : availableAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
