// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compliance_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LegalDocument {

 String get kind; String get version; String get locale; String get title; String get bodyMarkdown; DateTime? get effectiveAt;
/// Create a copy of LegalDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LegalDocumentCopyWith<LegalDocument> get copyWith => _$LegalDocumentCopyWithImpl<LegalDocument>(this as LegalDocument, _$identity);

  /// Serializes this LegalDocument to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LegalDocument&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.version, version) || other.version == version)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.title, title) || other.title == title)&&(identical(other.bodyMarkdown, bodyMarkdown) || other.bodyMarkdown == bodyMarkdown)&&(identical(other.effectiveAt, effectiveAt) || other.effectiveAt == effectiveAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,version,locale,title,bodyMarkdown,effectiveAt);

@override
String toString() {
  return 'LegalDocument(kind: $kind, version: $version, locale: $locale, title: $title, bodyMarkdown: $bodyMarkdown, effectiveAt: $effectiveAt)';
}


}

/// @nodoc
abstract mixin class $LegalDocumentCopyWith<$Res>  {
  factory $LegalDocumentCopyWith(LegalDocument value, $Res Function(LegalDocument) _then) = _$LegalDocumentCopyWithImpl;
@useResult
$Res call({
 String kind, String version, String locale, String title, String bodyMarkdown, DateTime? effectiveAt
});




}
/// @nodoc
class _$LegalDocumentCopyWithImpl<$Res>
    implements $LegalDocumentCopyWith<$Res> {
  _$LegalDocumentCopyWithImpl(this._self, this._then);

  final LegalDocument _self;
  final $Res Function(LegalDocument) _then;

/// Create a copy of LegalDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? version = null,Object? locale = null,Object? title = null,Object? bodyMarkdown = null,Object? effectiveAt = freezed,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,bodyMarkdown: null == bodyMarkdown ? _self.bodyMarkdown : bodyMarkdown // ignore: cast_nullable_to_non_nullable
as String,effectiveAt: freezed == effectiveAt ? _self.effectiveAt : effectiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [LegalDocument].
extension LegalDocumentPatterns on LegalDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LegalDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LegalDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LegalDocument value)  $default,){
final _that = this;
switch (_that) {
case _LegalDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LegalDocument value)?  $default,){
final _that = this;
switch (_that) {
case _LegalDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String kind,  String version,  String locale,  String title,  String bodyMarkdown,  DateTime? effectiveAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LegalDocument() when $default != null:
return $default(_that.kind,_that.version,_that.locale,_that.title,_that.bodyMarkdown,_that.effectiveAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String kind,  String version,  String locale,  String title,  String bodyMarkdown,  DateTime? effectiveAt)  $default,) {final _that = this;
switch (_that) {
case _LegalDocument():
return $default(_that.kind,_that.version,_that.locale,_that.title,_that.bodyMarkdown,_that.effectiveAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String kind,  String version,  String locale,  String title,  String bodyMarkdown,  DateTime? effectiveAt)?  $default,) {final _that = this;
switch (_that) {
case _LegalDocument() when $default != null:
return $default(_that.kind,_that.version,_that.locale,_that.title,_that.bodyMarkdown,_that.effectiveAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LegalDocument implements LegalDocument {
  const _LegalDocument({required this.kind, required this.version, required this.locale, required this.title, required this.bodyMarkdown, this.effectiveAt});
  factory _LegalDocument.fromJson(Map<String, dynamic> json) => _$LegalDocumentFromJson(json);

@override final  String kind;
@override final  String version;
@override final  String locale;
@override final  String title;
@override final  String bodyMarkdown;
@override final  DateTime? effectiveAt;

/// Create a copy of LegalDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LegalDocumentCopyWith<_LegalDocument> get copyWith => __$LegalDocumentCopyWithImpl<_LegalDocument>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LegalDocumentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LegalDocument&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.version, version) || other.version == version)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.title, title) || other.title == title)&&(identical(other.bodyMarkdown, bodyMarkdown) || other.bodyMarkdown == bodyMarkdown)&&(identical(other.effectiveAt, effectiveAt) || other.effectiveAt == effectiveAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,version,locale,title,bodyMarkdown,effectiveAt);

@override
String toString() {
  return 'LegalDocument(kind: $kind, version: $version, locale: $locale, title: $title, bodyMarkdown: $bodyMarkdown, effectiveAt: $effectiveAt)';
}


}

/// @nodoc
abstract mixin class _$LegalDocumentCopyWith<$Res> implements $LegalDocumentCopyWith<$Res> {
  factory _$LegalDocumentCopyWith(_LegalDocument value, $Res Function(_LegalDocument) _then) = __$LegalDocumentCopyWithImpl;
@override @useResult
$Res call({
 String kind, String version, String locale, String title, String bodyMarkdown, DateTime? effectiveAt
});




}
/// @nodoc
class __$LegalDocumentCopyWithImpl<$Res>
    implements _$LegalDocumentCopyWith<$Res> {
  __$LegalDocumentCopyWithImpl(this._self, this._then);

  final _LegalDocument _self;
  final $Res Function(_LegalDocument) _then;

/// Create a copy of LegalDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? version = null,Object? locale = null,Object? title = null,Object? bodyMarkdown = null,Object? effectiveAt = freezed,}) {
  return _then(_LegalDocument(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,bodyMarkdown: null == bodyMarkdown ? _self.bodyMarkdown : bodyMarkdown // ignore: cast_nullable_to_non_nullable
as String,effectiveAt: freezed == effectiveAt ? _self.effectiveAt : effectiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ConsentView {

 String get id; ConsentType get consentType; String? get patientId; bool get granted; String? get documentVersion; DateTime? get grantedAt; DateTime? get withdrawnAt;
/// Create a copy of ConsentView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsentViewCopyWith<ConsentView> get copyWith => _$ConsentViewCopyWithImpl<ConsentView>(this as ConsentView, _$identity);

  /// Serializes this ConsentView to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsentView&&(identical(other.id, id) || other.id == id)&&(identical(other.consentType, consentType) || other.consentType == consentType)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.granted, granted) || other.granted == granted)&&(identical(other.documentVersion, documentVersion) || other.documentVersion == documentVersion)&&(identical(other.grantedAt, grantedAt) || other.grantedAt == grantedAt)&&(identical(other.withdrawnAt, withdrawnAt) || other.withdrawnAt == withdrawnAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,consentType,patientId,granted,documentVersion,grantedAt,withdrawnAt);

@override
String toString() {
  return 'ConsentView(id: $id, consentType: $consentType, patientId: $patientId, granted: $granted, documentVersion: $documentVersion, grantedAt: $grantedAt, withdrawnAt: $withdrawnAt)';
}


}

/// @nodoc
abstract mixin class $ConsentViewCopyWith<$Res>  {
  factory $ConsentViewCopyWith(ConsentView value, $Res Function(ConsentView) _then) = _$ConsentViewCopyWithImpl;
@useResult
$Res call({
 String id, ConsentType consentType, String? patientId, bool granted, String? documentVersion, DateTime? grantedAt, DateTime? withdrawnAt
});




}
/// @nodoc
class _$ConsentViewCopyWithImpl<$Res>
    implements $ConsentViewCopyWith<$Res> {
  _$ConsentViewCopyWithImpl(this._self, this._then);

  final ConsentView _self;
  final $Res Function(ConsentView) _then;

/// Create a copy of ConsentView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? consentType = null,Object? patientId = freezed,Object? granted = null,Object? documentVersion = freezed,Object? grantedAt = freezed,Object? withdrawnAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,consentType: null == consentType ? _self.consentType : consentType // ignore: cast_nullable_to_non_nullable
as ConsentType,patientId: freezed == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String?,granted: null == granted ? _self.granted : granted // ignore: cast_nullable_to_non_nullable
as bool,documentVersion: freezed == documentVersion ? _self.documentVersion : documentVersion // ignore: cast_nullable_to_non_nullable
as String?,grantedAt: freezed == grantedAt ? _self.grantedAt : grantedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,withdrawnAt: freezed == withdrawnAt ? _self.withdrawnAt : withdrawnAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsentView].
extension ConsentViewPatterns on ConsentView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsentView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsentView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsentView value)  $default,){
final _that = this;
switch (_that) {
case _ConsentView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsentView value)?  $default,){
final _that = this;
switch (_that) {
case _ConsentView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ConsentType consentType,  String? patientId,  bool granted,  String? documentVersion,  DateTime? grantedAt,  DateTime? withdrawnAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsentView() when $default != null:
return $default(_that.id,_that.consentType,_that.patientId,_that.granted,_that.documentVersion,_that.grantedAt,_that.withdrawnAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ConsentType consentType,  String? patientId,  bool granted,  String? documentVersion,  DateTime? grantedAt,  DateTime? withdrawnAt)  $default,) {final _that = this;
switch (_that) {
case _ConsentView():
return $default(_that.id,_that.consentType,_that.patientId,_that.granted,_that.documentVersion,_that.grantedAt,_that.withdrawnAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ConsentType consentType,  String? patientId,  bool granted,  String? documentVersion,  DateTime? grantedAt,  DateTime? withdrawnAt)?  $default,) {final _that = this;
switch (_that) {
case _ConsentView() when $default != null:
return $default(_that.id,_that.consentType,_that.patientId,_that.granted,_that.documentVersion,_that.grantedAt,_that.withdrawnAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsentView implements ConsentView {
  const _ConsentView({required this.id, required this.consentType, this.patientId, this.granted = false, this.documentVersion, this.grantedAt, this.withdrawnAt});
  factory _ConsentView.fromJson(Map<String, dynamic> json) => _$ConsentViewFromJson(json);

@override final  String id;
@override final  ConsentType consentType;
@override final  String? patientId;
@override@JsonKey() final  bool granted;
@override final  String? documentVersion;
@override final  DateTime? grantedAt;
@override final  DateTime? withdrawnAt;

/// Create a copy of ConsentView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsentViewCopyWith<_ConsentView> get copyWith => __$ConsentViewCopyWithImpl<_ConsentView>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsentViewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsentView&&(identical(other.id, id) || other.id == id)&&(identical(other.consentType, consentType) || other.consentType == consentType)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.granted, granted) || other.granted == granted)&&(identical(other.documentVersion, documentVersion) || other.documentVersion == documentVersion)&&(identical(other.grantedAt, grantedAt) || other.grantedAt == grantedAt)&&(identical(other.withdrawnAt, withdrawnAt) || other.withdrawnAt == withdrawnAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,consentType,patientId,granted,documentVersion,grantedAt,withdrawnAt);

@override
String toString() {
  return 'ConsentView(id: $id, consentType: $consentType, patientId: $patientId, granted: $granted, documentVersion: $documentVersion, grantedAt: $grantedAt, withdrawnAt: $withdrawnAt)';
}


}

/// @nodoc
abstract mixin class _$ConsentViewCopyWith<$Res> implements $ConsentViewCopyWith<$Res> {
  factory _$ConsentViewCopyWith(_ConsentView value, $Res Function(_ConsentView) _then) = __$ConsentViewCopyWithImpl;
@override @useResult
$Res call({
 String id, ConsentType consentType, String? patientId, bool granted, String? documentVersion, DateTime? grantedAt, DateTime? withdrawnAt
});




}
/// @nodoc
class __$ConsentViewCopyWithImpl<$Res>
    implements _$ConsentViewCopyWith<$Res> {
  __$ConsentViewCopyWithImpl(this._self, this._then);

  final _ConsentView _self;
  final $Res Function(_ConsentView) _then;

/// Create a copy of ConsentView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? consentType = null,Object? patientId = freezed,Object? granted = null,Object? documentVersion = freezed,Object? grantedAt = freezed,Object? withdrawnAt = freezed,}) {
  return _then(_ConsentView(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,consentType: null == consentType ? _self.consentType : consentType // ignore: cast_nullable_to_non_nullable
as ConsentType,patientId: freezed == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String?,granted: null == granted ? _self.granted : granted // ignore: cast_nullable_to_non_nullable
as bool,documentVersion: freezed == documentVersion ? _self.documentVersion : documentVersion // ignore: cast_nullable_to_non_nullable
as String?,grantedAt: freezed == grantedAt ? _self.grantedAt : grantedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,withdrawnAt: freezed == withdrawnAt ? _self.withdrawnAt : withdrawnAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ConsentListResponse {

 List<ConsentView> get consents;
/// Create a copy of ConsentListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsentListResponseCopyWith<ConsentListResponse> get copyWith => _$ConsentListResponseCopyWithImpl<ConsentListResponse>(this as ConsentListResponse, _$identity);

  /// Serializes this ConsentListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsentListResponse&&const DeepCollectionEquality().equals(other.consents, consents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(consents));

@override
String toString() {
  return 'ConsentListResponse(consents: $consents)';
}


}

/// @nodoc
abstract mixin class $ConsentListResponseCopyWith<$Res>  {
  factory $ConsentListResponseCopyWith(ConsentListResponse value, $Res Function(ConsentListResponse) _then) = _$ConsentListResponseCopyWithImpl;
@useResult
$Res call({
 List<ConsentView> consents
});




}
/// @nodoc
class _$ConsentListResponseCopyWithImpl<$Res>
    implements $ConsentListResponseCopyWith<$Res> {
  _$ConsentListResponseCopyWithImpl(this._self, this._then);

  final ConsentListResponse _self;
  final $Res Function(ConsentListResponse) _then;

/// Create a copy of ConsentListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? consents = null,}) {
  return _then(_self.copyWith(
consents: null == consents ? _self.consents : consents // ignore: cast_nullable_to_non_nullable
as List<ConsentView>,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsentListResponse].
extension ConsentListResponsePatterns on ConsentListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsentListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsentListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsentListResponse value)  $default,){
final _that = this;
switch (_that) {
case _ConsentListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsentListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ConsentListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ConsentView> consents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsentListResponse() when $default != null:
return $default(_that.consents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ConsentView> consents)  $default,) {final _that = this;
switch (_that) {
case _ConsentListResponse():
return $default(_that.consents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ConsentView> consents)?  $default,) {final _that = this;
switch (_that) {
case _ConsentListResponse() when $default != null:
return $default(_that.consents);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsentListResponse implements ConsentListResponse {
  const _ConsentListResponse({final  List<ConsentView> consents = const <ConsentView>[]}): _consents = consents;
  factory _ConsentListResponse.fromJson(Map<String, dynamic> json) => _$ConsentListResponseFromJson(json);

 final  List<ConsentView> _consents;
@override@JsonKey() List<ConsentView> get consents {
  if (_consents is EqualUnmodifiableListView) return _consents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_consents);
}


/// Create a copy of ConsentListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsentListResponseCopyWith<_ConsentListResponse> get copyWith => __$ConsentListResponseCopyWithImpl<_ConsentListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsentListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsentListResponse&&const DeepCollectionEquality().equals(other._consents, _consents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_consents));

@override
String toString() {
  return 'ConsentListResponse(consents: $consents)';
}


}

/// @nodoc
abstract mixin class _$ConsentListResponseCopyWith<$Res> implements $ConsentListResponseCopyWith<$Res> {
  factory _$ConsentListResponseCopyWith(_ConsentListResponse value, $Res Function(_ConsentListResponse) _then) = __$ConsentListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<ConsentView> consents
});




}
/// @nodoc
class __$ConsentListResponseCopyWithImpl<$Res>
    implements _$ConsentListResponseCopyWith<$Res> {
  __$ConsentListResponseCopyWithImpl(this._self, this._then);

  final _ConsentListResponse _self;
  final $Res Function(_ConsentListResponse) _then;

/// Create a copy of ConsentListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? consents = null,}) {
  return _then(_ConsentListResponse(
consents: null == consents ? _self._consents : consents // ignore: cast_nullable_to_non_nullable
as List<ConsentView>,
  ));
}


}


/// @nodoc
mixin _$DeletionRequestView {

 String get status; DateTime? get requestedAt; DateTime? get purgeAfter;
/// Create a copy of DeletionRequestView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeletionRequestViewCopyWith<DeletionRequestView> get copyWith => _$DeletionRequestViewCopyWithImpl<DeletionRequestView>(this as DeletionRequestView, _$identity);

  /// Serializes this DeletionRequestView to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeletionRequestView&&(identical(other.status, status) || other.status == status)&&(identical(other.requestedAt, requestedAt) || other.requestedAt == requestedAt)&&(identical(other.purgeAfter, purgeAfter) || other.purgeAfter == purgeAfter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,requestedAt,purgeAfter);

@override
String toString() {
  return 'DeletionRequestView(status: $status, requestedAt: $requestedAt, purgeAfter: $purgeAfter)';
}


}

/// @nodoc
abstract mixin class $DeletionRequestViewCopyWith<$Res>  {
  factory $DeletionRequestViewCopyWith(DeletionRequestView value, $Res Function(DeletionRequestView) _then) = _$DeletionRequestViewCopyWithImpl;
@useResult
$Res call({
 String status, DateTime? requestedAt, DateTime? purgeAfter
});




}
/// @nodoc
class _$DeletionRequestViewCopyWithImpl<$Res>
    implements $DeletionRequestViewCopyWith<$Res> {
  _$DeletionRequestViewCopyWithImpl(this._self, this._then);

  final DeletionRequestView _self;
  final $Res Function(DeletionRequestView) _then;

/// Create a copy of DeletionRequestView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? requestedAt = freezed,Object? purgeAfter = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,requestedAt: freezed == requestedAt ? _self.requestedAt : requestedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,purgeAfter: freezed == purgeAfter ? _self.purgeAfter : purgeAfter // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeletionRequestView].
extension DeletionRequestViewPatterns on DeletionRequestView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeletionRequestView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeletionRequestView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeletionRequestView value)  $default,){
final _that = this;
switch (_that) {
case _DeletionRequestView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeletionRequestView value)?  $default,){
final _that = this;
switch (_that) {
case _DeletionRequestView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  DateTime? requestedAt,  DateTime? purgeAfter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeletionRequestView() when $default != null:
return $default(_that.status,_that.requestedAt,_that.purgeAfter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  DateTime? requestedAt,  DateTime? purgeAfter)  $default,) {final _that = this;
switch (_that) {
case _DeletionRequestView():
return $default(_that.status,_that.requestedAt,_that.purgeAfter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  DateTime? requestedAt,  DateTime? purgeAfter)?  $default,) {final _that = this;
switch (_that) {
case _DeletionRequestView() when $default != null:
return $default(_that.status,_that.requestedAt,_that.purgeAfter);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeletionRequestView implements DeletionRequestView {
  const _DeletionRequestView({required this.status, this.requestedAt, this.purgeAfter});
  factory _DeletionRequestView.fromJson(Map<String, dynamic> json) => _$DeletionRequestViewFromJson(json);

@override final  String status;
@override final  DateTime? requestedAt;
@override final  DateTime? purgeAfter;

/// Create a copy of DeletionRequestView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeletionRequestViewCopyWith<_DeletionRequestView> get copyWith => __$DeletionRequestViewCopyWithImpl<_DeletionRequestView>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeletionRequestViewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeletionRequestView&&(identical(other.status, status) || other.status == status)&&(identical(other.requestedAt, requestedAt) || other.requestedAt == requestedAt)&&(identical(other.purgeAfter, purgeAfter) || other.purgeAfter == purgeAfter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,requestedAt,purgeAfter);

@override
String toString() {
  return 'DeletionRequestView(status: $status, requestedAt: $requestedAt, purgeAfter: $purgeAfter)';
}


}

/// @nodoc
abstract mixin class _$DeletionRequestViewCopyWith<$Res> implements $DeletionRequestViewCopyWith<$Res> {
  factory _$DeletionRequestViewCopyWith(_DeletionRequestView value, $Res Function(_DeletionRequestView) _then) = __$DeletionRequestViewCopyWithImpl;
@override @useResult
$Res call({
 String status, DateTime? requestedAt, DateTime? purgeAfter
});




}
/// @nodoc
class __$DeletionRequestViewCopyWithImpl<$Res>
    implements _$DeletionRequestViewCopyWith<$Res> {
  __$DeletionRequestViewCopyWithImpl(this._self, this._then);

  final _DeletionRequestView _self;
  final $Res Function(_DeletionRequestView) _then;

/// Create a copy of DeletionRequestView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? requestedAt = freezed,Object? purgeAfter = freezed,}) {
  return _then(_DeletionRequestView(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,requestedAt: freezed == requestedAt ? _self.requestedAt : requestedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,purgeAfter: freezed == purgeAfter ? _self.purgeAfter : purgeAfter // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
