// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promotion_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Promotion {

 String get id; String get title; String? get shortDescription; String? get longDescription; String? get serviceCategory; String? get ctaText;@JsonKey(unknownEnumValue: PromotionAction.none) PromotionAction get ctaAction; String? get coverUrl; int get displayOrder;
/// Create a copy of Promotion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromotionCopyWith<Promotion> get copyWith => _$PromotionCopyWithImpl<Promotion>(this as Promotion, _$identity);

  /// Serializes this Promotion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Promotion&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription)&&(identical(other.longDescription, longDescription) || other.longDescription == longDescription)&&(identical(other.serviceCategory, serviceCategory) || other.serviceCategory == serviceCategory)&&(identical(other.ctaText, ctaText) || other.ctaText == ctaText)&&(identical(other.ctaAction, ctaAction) || other.ctaAction == ctaAction)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,shortDescription,longDescription,serviceCategory,ctaText,ctaAction,coverUrl,displayOrder);

@override
String toString() {
  return 'Promotion(id: $id, title: $title, shortDescription: $shortDescription, longDescription: $longDescription, serviceCategory: $serviceCategory, ctaText: $ctaText, ctaAction: $ctaAction, coverUrl: $coverUrl, displayOrder: $displayOrder)';
}


}

/// @nodoc
abstract mixin class $PromotionCopyWith<$Res>  {
  factory $PromotionCopyWith(Promotion value, $Res Function(Promotion) _then) = _$PromotionCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? shortDescription, String? longDescription, String? serviceCategory, String? ctaText,@JsonKey(unknownEnumValue: PromotionAction.none) PromotionAction ctaAction, String? coverUrl, int displayOrder
});




}
/// @nodoc
class _$PromotionCopyWithImpl<$Res>
    implements $PromotionCopyWith<$Res> {
  _$PromotionCopyWithImpl(this._self, this._then);

  final Promotion _self;
  final $Res Function(Promotion) _then;

/// Create a copy of Promotion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? shortDescription = freezed,Object? longDescription = freezed,Object? serviceCategory = freezed,Object? ctaText = freezed,Object? ctaAction = null,Object? coverUrl = freezed,Object? displayOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,shortDescription: freezed == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String?,longDescription: freezed == longDescription ? _self.longDescription : longDescription // ignore: cast_nullable_to_non_nullable
as String?,serviceCategory: freezed == serviceCategory ? _self.serviceCategory : serviceCategory // ignore: cast_nullable_to_non_nullable
as String?,ctaText: freezed == ctaText ? _self.ctaText : ctaText // ignore: cast_nullable_to_non_nullable
as String?,ctaAction: null == ctaAction ? _self.ctaAction : ctaAction // ignore: cast_nullable_to_non_nullable
as PromotionAction,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Promotion].
extension PromotionPatterns on Promotion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Promotion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Promotion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Promotion value)  $default,){
final _that = this;
switch (_that) {
case _Promotion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Promotion value)?  $default,){
final _that = this;
switch (_that) {
case _Promotion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? shortDescription,  String? longDescription,  String? serviceCategory,  String? ctaText, @JsonKey(unknownEnumValue: PromotionAction.none)  PromotionAction ctaAction,  String? coverUrl,  int displayOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Promotion() when $default != null:
return $default(_that.id,_that.title,_that.shortDescription,_that.longDescription,_that.serviceCategory,_that.ctaText,_that.ctaAction,_that.coverUrl,_that.displayOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? shortDescription,  String? longDescription,  String? serviceCategory,  String? ctaText, @JsonKey(unknownEnumValue: PromotionAction.none)  PromotionAction ctaAction,  String? coverUrl,  int displayOrder)  $default,) {final _that = this;
switch (_that) {
case _Promotion():
return $default(_that.id,_that.title,_that.shortDescription,_that.longDescription,_that.serviceCategory,_that.ctaText,_that.ctaAction,_that.coverUrl,_that.displayOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? shortDescription,  String? longDescription,  String? serviceCategory,  String? ctaText, @JsonKey(unknownEnumValue: PromotionAction.none)  PromotionAction ctaAction,  String? coverUrl,  int displayOrder)?  $default,) {final _that = this;
switch (_that) {
case _Promotion() when $default != null:
return $default(_that.id,_that.title,_that.shortDescription,_that.longDescription,_that.serviceCategory,_that.ctaText,_that.ctaAction,_that.coverUrl,_that.displayOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Promotion extends Promotion {
  const _Promotion({required this.id, required this.title, this.shortDescription, this.longDescription, this.serviceCategory, this.ctaText, @JsonKey(unknownEnumValue: PromotionAction.none) this.ctaAction = PromotionAction.none, this.coverUrl, this.displayOrder = 0}): super._();
  factory _Promotion.fromJson(Map<String, dynamic> json) => _$PromotionFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? shortDescription;
@override final  String? longDescription;
@override final  String? serviceCategory;
@override final  String? ctaText;
@override@JsonKey(unknownEnumValue: PromotionAction.none) final  PromotionAction ctaAction;
@override final  String? coverUrl;
@override@JsonKey() final  int displayOrder;

/// Create a copy of Promotion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromotionCopyWith<_Promotion> get copyWith => __$PromotionCopyWithImpl<_Promotion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PromotionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Promotion&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription)&&(identical(other.longDescription, longDescription) || other.longDescription == longDescription)&&(identical(other.serviceCategory, serviceCategory) || other.serviceCategory == serviceCategory)&&(identical(other.ctaText, ctaText) || other.ctaText == ctaText)&&(identical(other.ctaAction, ctaAction) || other.ctaAction == ctaAction)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,shortDescription,longDescription,serviceCategory,ctaText,ctaAction,coverUrl,displayOrder);

@override
String toString() {
  return 'Promotion(id: $id, title: $title, shortDescription: $shortDescription, longDescription: $longDescription, serviceCategory: $serviceCategory, ctaText: $ctaText, ctaAction: $ctaAction, coverUrl: $coverUrl, displayOrder: $displayOrder)';
}


}

/// @nodoc
abstract mixin class _$PromotionCopyWith<$Res> implements $PromotionCopyWith<$Res> {
  factory _$PromotionCopyWith(_Promotion value, $Res Function(_Promotion) _then) = __$PromotionCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? shortDescription, String? longDescription, String? serviceCategory, String? ctaText,@JsonKey(unknownEnumValue: PromotionAction.none) PromotionAction ctaAction, String? coverUrl, int displayOrder
});




}
/// @nodoc
class __$PromotionCopyWithImpl<$Res>
    implements _$PromotionCopyWith<$Res> {
  __$PromotionCopyWithImpl(this._self, this._then);

  final _Promotion _self;
  final $Res Function(_Promotion) _then;

/// Create a copy of Promotion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? shortDescription = freezed,Object? longDescription = freezed,Object? serviceCategory = freezed,Object? ctaText = freezed,Object? ctaAction = null,Object? coverUrl = freezed,Object? displayOrder = null,}) {
  return _then(_Promotion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,shortDescription: freezed == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String?,longDescription: freezed == longDescription ? _self.longDescription : longDescription // ignore: cast_nullable_to_non_nullable
as String?,serviceCategory: freezed == serviceCategory ? _self.serviceCategory : serviceCategory // ignore: cast_nullable_to_non_nullable
as String?,ctaText: freezed == ctaText ? _self.ctaText : ctaText // ignore: cast_nullable_to_non_nullable
as String?,ctaAction: null == ctaAction ? _self.ctaAction : ctaAction // ignore: cast_nullable_to_non_nullable
as PromotionAction,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ManagedPromotion {

 String get id; String get title; String? get shortDescription; String? get longDescription; String? get serviceCategory; String? get ctaText;@JsonKey(unknownEnumValue: PromotionAction.none) PromotionAction get ctaAction; String? get coverUrl; int get displayOrder; bool get active; DateTime? get startsAt; DateTime? get endsAt; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of ManagedPromotion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManagedPromotionCopyWith<ManagedPromotion> get copyWith => _$ManagedPromotionCopyWithImpl<ManagedPromotion>(this as ManagedPromotion, _$identity);

  /// Serializes this ManagedPromotion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManagedPromotion&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription)&&(identical(other.longDescription, longDescription) || other.longDescription == longDescription)&&(identical(other.serviceCategory, serviceCategory) || other.serviceCategory == serviceCategory)&&(identical(other.ctaText, ctaText) || other.ctaText == ctaText)&&(identical(other.ctaAction, ctaAction) || other.ctaAction == ctaAction)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.active, active) || other.active == active)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,shortDescription,longDescription,serviceCategory,ctaText,ctaAction,coverUrl,displayOrder,active,startsAt,endsAt,createdAt,updatedAt);

@override
String toString() {
  return 'ManagedPromotion(id: $id, title: $title, shortDescription: $shortDescription, longDescription: $longDescription, serviceCategory: $serviceCategory, ctaText: $ctaText, ctaAction: $ctaAction, coverUrl: $coverUrl, displayOrder: $displayOrder, active: $active, startsAt: $startsAt, endsAt: $endsAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ManagedPromotionCopyWith<$Res>  {
  factory $ManagedPromotionCopyWith(ManagedPromotion value, $Res Function(ManagedPromotion) _then) = _$ManagedPromotionCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? shortDescription, String? longDescription, String? serviceCategory, String? ctaText,@JsonKey(unknownEnumValue: PromotionAction.none) PromotionAction ctaAction, String? coverUrl, int displayOrder, bool active, DateTime? startsAt, DateTime? endsAt, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$ManagedPromotionCopyWithImpl<$Res>
    implements $ManagedPromotionCopyWith<$Res> {
  _$ManagedPromotionCopyWithImpl(this._self, this._then);

  final ManagedPromotion _self;
  final $Res Function(ManagedPromotion) _then;

/// Create a copy of ManagedPromotion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? shortDescription = freezed,Object? longDescription = freezed,Object? serviceCategory = freezed,Object? ctaText = freezed,Object? ctaAction = null,Object? coverUrl = freezed,Object? displayOrder = null,Object? active = null,Object? startsAt = freezed,Object? endsAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,shortDescription: freezed == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String?,longDescription: freezed == longDescription ? _self.longDescription : longDescription // ignore: cast_nullable_to_non_nullable
as String?,serviceCategory: freezed == serviceCategory ? _self.serviceCategory : serviceCategory // ignore: cast_nullable_to_non_nullable
as String?,ctaText: freezed == ctaText ? _self.ctaText : ctaText // ignore: cast_nullable_to_non_nullable
as String?,ctaAction: null == ctaAction ? _self.ctaAction : ctaAction // ignore: cast_nullable_to_non_nullable
as PromotionAction,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ManagedPromotion].
extension ManagedPromotionPatterns on ManagedPromotion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ManagedPromotion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ManagedPromotion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ManagedPromotion value)  $default,){
final _that = this;
switch (_that) {
case _ManagedPromotion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ManagedPromotion value)?  $default,){
final _that = this;
switch (_that) {
case _ManagedPromotion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? shortDescription,  String? longDescription,  String? serviceCategory,  String? ctaText, @JsonKey(unknownEnumValue: PromotionAction.none)  PromotionAction ctaAction,  String? coverUrl,  int displayOrder,  bool active,  DateTime? startsAt,  DateTime? endsAt,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManagedPromotion() when $default != null:
return $default(_that.id,_that.title,_that.shortDescription,_that.longDescription,_that.serviceCategory,_that.ctaText,_that.ctaAction,_that.coverUrl,_that.displayOrder,_that.active,_that.startsAt,_that.endsAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? shortDescription,  String? longDescription,  String? serviceCategory,  String? ctaText, @JsonKey(unknownEnumValue: PromotionAction.none)  PromotionAction ctaAction,  String? coverUrl,  int displayOrder,  bool active,  DateTime? startsAt,  DateTime? endsAt,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ManagedPromotion():
return $default(_that.id,_that.title,_that.shortDescription,_that.longDescription,_that.serviceCategory,_that.ctaText,_that.ctaAction,_that.coverUrl,_that.displayOrder,_that.active,_that.startsAt,_that.endsAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? shortDescription,  String? longDescription,  String? serviceCategory,  String? ctaText, @JsonKey(unknownEnumValue: PromotionAction.none)  PromotionAction ctaAction,  String? coverUrl,  int displayOrder,  bool active,  DateTime? startsAt,  DateTime? endsAt,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ManagedPromotion() when $default != null:
return $default(_that.id,_that.title,_that.shortDescription,_that.longDescription,_that.serviceCategory,_that.ctaText,_that.ctaAction,_that.coverUrl,_that.displayOrder,_that.active,_that.startsAt,_that.endsAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ManagedPromotion extends ManagedPromotion {
  const _ManagedPromotion({required this.id, required this.title, this.shortDescription, this.longDescription, this.serviceCategory, this.ctaText, @JsonKey(unknownEnumValue: PromotionAction.none) this.ctaAction = PromotionAction.none, this.coverUrl, this.displayOrder = 0, this.active = true, this.startsAt, this.endsAt, this.createdAt, this.updatedAt}): super._();
  factory _ManagedPromotion.fromJson(Map<String, dynamic> json) => _$ManagedPromotionFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? shortDescription;
@override final  String? longDescription;
@override final  String? serviceCategory;
@override final  String? ctaText;
@override@JsonKey(unknownEnumValue: PromotionAction.none) final  PromotionAction ctaAction;
@override final  String? coverUrl;
@override@JsonKey() final  int displayOrder;
@override@JsonKey() final  bool active;
@override final  DateTime? startsAt;
@override final  DateTime? endsAt;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of ManagedPromotion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManagedPromotionCopyWith<_ManagedPromotion> get copyWith => __$ManagedPromotionCopyWithImpl<_ManagedPromotion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ManagedPromotionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManagedPromotion&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription)&&(identical(other.longDescription, longDescription) || other.longDescription == longDescription)&&(identical(other.serviceCategory, serviceCategory) || other.serviceCategory == serviceCategory)&&(identical(other.ctaText, ctaText) || other.ctaText == ctaText)&&(identical(other.ctaAction, ctaAction) || other.ctaAction == ctaAction)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.active, active) || other.active == active)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,shortDescription,longDescription,serviceCategory,ctaText,ctaAction,coverUrl,displayOrder,active,startsAt,endsAt,createdAt,updatedAt);

@override
String toString() {
  return 'ManagedPromotion(id: $id, title: $title, shortDescription: $shortDescription, longDescription: $longDescription, serviceCategory: $serviceCategory, ctaText: $ctaText, ctaAction: $ctaAction, coverUrl: $coverUrl, displayOrder: $displayOrder, active: $active, startsAt: $startsAt, endsAt: $endsAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ManagedPromotionCopyWith<$Res> implements $ManagedPromotionCopyWith<$Res> {
  factory _$ManagedPromotionCopyWith(_ManagedPromotion value, $Res Function(_ManagedPromotion) _then) = __$ManagedPromotionCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? shortDescription, String? longDescription, String? serviceCategory, String? ctaText,@JsonKey(unknownEnumValue: PromotionAction.none) PromotionAction ctaAction, String? coverUrl, int displayOrder, bool active, DateTime? startsAt, DateTime? endsAt, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$ManagedPromotionCopyWithImpl<$Res>
    implements _$ManagedPromotionCopyWith<$Res> {
  __$ManagedPromotionCopyWithImpl(this._self, this._then);

  final _ManagedPromotion _self;
  final $Res Function(_ManagedPromotion) _then;

/// Create a copy of ManagedPromotion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? shortDescription = freezed,Object? longDescription = freezed,Object? serviceCategory = freezed,Object? ctaText = freezed,Object? ctaAction = null,Object? coverUrl = freezed,Object? displayOrder = null,Object? active = null,Object? startsAt = freezed,Object? endsAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ManagedPromotion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,shortDescription: freezed == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String?,longDescription: freezed == longDescription ? _self.longDescription : longDescription // ignore: cast_nullable_to_non_nullable
as String?,serviceCategory: freezed == serviceCategory ? _self.serviceCategory : serviceCategory // ignore: cast_nullable_to_non_nullable
as String?,ctaText: freezed == ctaText ? _self.ctaText : ctaText // ignore: cast_nullable_to_non_nullable
as String?,ctaAction: null == ctaAction ? _self.ctaAction : ctaAction // ignore: cast_nullable_to_non_nullable
as PromotionAction,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$CreatePromotionRequest {

 String get title; String? get shortDescription; String? get longDescription; String? get serviceCategory; String? get ctaText; PromotionAction get ctaAction; DateTime? get startsAt; DateTime? get endsAt; bool? get active;
/// Create a copy of CreatePromotionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatePromotionRequestCopyWith<CreatePromotionRequest> get copyWith => _$CreatePromotionRequestCopyWithImpl<CreatePromotionRequest>(this as CreatePromotionRequest, _$identity);

  /// Serializes this CreatePromotionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatePromotionRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription)&&(identical(other.longDescription, longDescription) || other.longDescription == longDescription)&&(identical(other.serviceCategory, serviceCategory) || other.serviceCategory == serviceCategory)&&(identical(other.ctaText, ctaText) || other.ctaText == ctaText)&&(identical(other.ctaAction, ctaAction) || other.ctaAction == ctaAction)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,shortDescription,longDescription,serviceCategory,ctaText,ctaAction,startsAt,endsAt,active);

@override
String toString() {
  return 'CreatePromotionRequest(title: $title, shortDescription: $shortDescription, longDescription: $longDescription, serviceCategory: $serviceCategory, ctaText: $ctaText, ctaAction: $ctaAction, startsAt: $startsAt, endsAt: $endsAt, active: $active)';
}


}

/// @nodoc
abstract mixin class $CreatePromotionRequestCopyWith<$Res>  {
  factory $CreatePromotionRequestCopyWith(CreatePromotionRequest value, $Res Function(CreatePromotionRequest) _then) = _$CreatePromotionRequestCopyWithImpl;
@useResult
$Res call({
 String title, String? shortDescription, String? longDescription, String? serviceCategory, String? ctaText, PromotionAction ctaAction, DateTime? startsAt, DateTime? endsAt, bool? active
});




}
/// @nodoc
class _$CreatePromotionRequestCopyWithImpl<$Res>
    implements $CreatePromotionRequestCopyWith<$Res> {
  _$CreatePromotionRequestCopyWithImpl(this._self, this._then);

  final CreatePromotionRequest _self;
  final $Res Function(CreatePromotionRequest) _then;

/// Create a copy of CreatePromotionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? shortDescription = freezed,Object? longDescription = freezed,Object? serviceCategory = freezed,Object? ctaText = freezed,Object? ctaAction = null,Object? startsAt = freezed,Object? endsAt = freezed,Object? active = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,shortDescription: freezed == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String?,longDescription: freezed == longDescription ? _self.longDescription : longDescription // ignore: cast_nullable_to_non_nullable
as String?,serviceCategory: freezed == serviceCategory ? _self.serviceCategory : serviceCategory // ignore: cast_nullable_to_non_nullable
as String?,ctaText: freezed == ctaText ? _self.ctaText : ctaText // ignore: cast_nullable_to_non_nullable
as String?,ctaAction: null == ctaAction ? _self.ctaAction : ctaAction // ignore: cast_nullable_to_non_nullable
as PromotionAction,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,active: freezed == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreatePromotionRequest].
extension CreatePromotionRequestPatterns on CreatePromotionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatePromotionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatePromotionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatePromotionRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreatePromotionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatePromotionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreatePromotionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String? shortDescription,  String? longDescription,  String? serviceCategory,  String? ctaText,  PromotionAction ctaAction,  DateTime? startsAt,  DateTime? endsAt,  bool? active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatePromotionRequest() when $default != null:
return $default(_that.title,_that.shortDescription,_that.longDescription,_that.serviceCategory,_that.ctaText,_that.ctaAction,_that.startsAt,_that.endsAt,_that.active);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String? shortDescription,  String? longDescription,  String? serviceCategory,  String? ctaText,  PromotionAction ctaAction,  DateTime? startsAt,  DateTime? endsAt,  bool? active)  $default,) {final _that = this;
switch (_that) {
case _CreatePromotionRequest():
return $default(_that.title,_that.shortDescription,_that.longDescription,_that.serviceCategory,_that.ctaText,_that.ctaAction,_that.startsAt,_that.endsAt,_that.active);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String? shortDescription,  String? longDescription,  String? serviceCategory,  String? ctaText,  PromotionAction ctaAction,  DateTime? startsAt,  DateTime? endsAt,  bool? active)?  $default,) {final _that = this;
switch (_that) {
case _CreatePromotionRequest() when $default != null:
return $default(_that.title,_that.shortDescription,_that.longDescription,_that.serviceCategory,_that.ctaText,_that.ctaAction,_that.startsAt,_that.endsAt,_that.active);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreatePromotionRequest implements CreatePromotionRequest {
  const _CreatePromotionRequest({required this.title, this.shortDescription, this.longDescription, this.serviceCategory, this.ctaText, required this.ctaAction, this.startsAt, this.endsAt, this.active});
  factory _CreatePromotionRequest.fromJson(Map<String, dynamic> json) => _$CreatePromotionRequestFromJson(json);

@override final  String title;
@override final  String? shortDescription;
@override final  String? longDescription;
@override final  String? serviceCategory;
@override final  String? ctaText;
@override final  PromotionAction ctaAction;
@override final  DateTime? startsAt;
@override final  DateTime? endsAt;
@override final  bool? active;

/// Create a copy of CreatePromotionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatePromotionRequestCopyWith<_CreatePromotionRequest> get copyWith => __$CreatePromotionRequestCopyWithImpl<_CreatePromotionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreatePromotionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatePromotionRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription)&&(identical(other.longDescription, longDescription) || other.longDescription == longDescription)&&(identical(other.serviceCategory, serviceCategory) || other.serviceCategory == serviceCategory)&&(identical(other.ctaText, ctaText) || other.ctaText == ctaText)&&(identical(other.ctaAction, ctaAction) || other.ctaAction == ctaAction)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,shortDescription,longDescription,serviceCategory,ctaText,ctaAction,startsAt,endsAt,active);

@override
String toString() {
  return 'CreatePromotionRequest(title: $title, shortDescription: $shortDescription, longDescription: $longDescription, serviceCategory: $serviceCategory, ctaText: $ctaText, ctaAction: $ctaAction, startsAt: $startsAt, endsAt: $endsAt, active: $active)';
}


}

/// @nodoc
abstract mixin class _$CreatePromotionRequestCopyWith<$Res> implements $CreatePromotionRequestCopyWith<$Res> {
  factory _$CreatePromotionRequestCopyWith(_CreatePromotionRequest value, $Res Function(_CreatePromotionRequest) _then) = __$CreatePromotionRequestCopyWithImpl;
@override @useResult
$Res call({
 String title, String? shortDescription, String? longDescription, String? serviceCategory, String? ctaText, PromotionAction ctaAction, DateTime? startsAt, DateTime? endsAt, bool? active
});




}
/// @nodoc
class __$CreatePromotionRequestCopyWithImpl<$Res>
    implements _$CreatePromotionRequestCopyWith<$Res> {
  __$CreatePromotionRequestCopyWithImpl(this._self, this._then);

  final _CreatePromotionRequest _self;
  final $Res Function(_CreatePromotionRequest) _then;

/// Create a copy of CreatePromotionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? shortDescription = freezed,Object? longDescription = freezed,Object? serviceCategory = freezed,Object? ctaText = freezed,Object? ctaAction = null,Object? startsAt = freezed,Object? endsAt = freezed,Object? active = freezed,}) {
  return _then(_CreatePromotionRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,shortDescription: freezed == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String?,longDescription: freezed == longDescription ? _self.longDescription : longDescription // ignore: cast_nullable_to_non_nullable
as String?,serviceCategory: freezed == serviceCategory ? _self.serviceCategory : serviceCategory // ignore: cast_nullable_to_non_nullable
as String?,ctaText: freezed == ctaText ? _self.ctaText : ctaText // ignore: cast_nullable_to_non_nullable
as String?,ctaAction: null == ctaAction ? _self.ctaAction : ctaAction // ignore: cast_nullable_to_non_nullable
as PromotionAction,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,active: freezed == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$UpdatePromotionRequest {

 String get title; String get shortDescription; String get longDescription; String get serviceCategory; String get ctaText; PromotionAction get ctaAction; DateTime? get startsAt; DateTime? get endsAt;
/// Create a copy of UpdatePromotionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdatePromotionRequestCopyWith<UpdatePromotionRequest> get copyWith => _$UpdatePromotionRequestCopyWithImpl<UpdatePromotionRequest>(this as UpdatePromotionRequest, _$identity);

  /// Serializes this UpdatePromotionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdatePromotionRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription)&&(identical(other.longDescription, longDescription) || other.longDescription == longDescription)&&(identical(other.serviceCategory, serviceCategory) || other.serviceCategory == serviceCategory)&&(identical(other.ctaText, ctaText) || other.ctaText == ctaText)&&(identical(other.ctaAction, ctaAction) || other.ctaAction == ctaAction)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,shortDescription,longDescription,serviceCategory,ctaText,ctaAction,startsAt,endsAt);

@override
String toString() {
  return 'UpdatePromotionRequest(title: $title, shortDescription: $shortDescription, longDescription: $longDescription, serviceCategory: $serviceCategory, ctaText: $ctaText, ctaAction: $ctaAction, startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class $UpdatePromotionRequestCopyWith<$Res>  {
  factory $UpdatePromotionRequestCopyWith(UpdatePromotionRequest value, $Res Function(UpdatePromotionRequest) _then) = _$UpdatePromotionRequestCopyWithImpl;
@useResult
$Res call({
 String title, String shortDescription, String longDescription, String serviceCategory, String ctaText, PromotionAction ctaAction, DateTime? startsAt, DateTime? endsAt
});




}
/// @nodoc
class _$UpdatePromotionRequestCopyWithImpl<$Res>
    implements $UpdatePromotionRequestCopyWith<$Res> {
  _$UpdatePromotionRequestCopyWithImpl(this._self, this._then);

  final UpdatePromotionRequest _self;
  final $Res Function(UpdatePromotionRequest) _then;

/// Create a copy of UpdatePromotionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? shortDescription = null,Object? longDescription = null,Object? serviceCategory = null,Object? ctaText = null,Object? ctaAction = null,Object? startsAt = freezed,Object? endsAt = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,shortDescription: null == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String,longDescription: null == longDescription ? _self.longDescription : longDescription // ignore: cast_nullable_to_non_nullable
as String,serviceCategory: null == serviceCategory ? _self.serviceCategory : serviceCategory // ignore: cast_nullable_to_non_nullable
as String,ctaText: null == ctaText ? _self.ctaText : ctaText // ignore: cast_nullable_to_non_nullable
as String,ctaAction: null == ctaAction ? _self.ctaAction : ctaAction // ignore: cast_nullable_to_non_nullable
as PromotionAction,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdatePromotionRequest].
extension UpdatePromotionRequestPatterns on UpdatePromotionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdatePromotionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdatePromotionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdatePromotionRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdatePromotionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdatePromotionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdatePromotionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String shortDescription,  String longDescription,  String serviceCategory,  String ctaText,  PromotionAction ctaAction,  DateTime? startsAt,  DateTime? endsAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdatePromotionRequest() when $default != null:
return $default(_that.title,_that.shortDescription,_that.longDescription,_that.serviceCategory,_that.ctaText,_that.ctaAction,_that.startsAt,_that.endsAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String shortDescription,  String longDescription,  String serviceCategory,  String ctaText,  PromotionAction ctaAction,  DateTime? startsAt,  DateTime? endsAt)  $default,) {final _that = this;
switch (_that) {
case _UpdatePromotionRequest():
return $default(_that.title,_that.shortDescription,_that.longDescription,_that.serviceCategory,_that.ctaText,_that.ctaAction,_that.startsAt,_that.endsAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String shortDescription,  String longDescription,  String serviceCategory,  String ctaText,  PromotionAction ctaAction,  DateTime? startsAt,  DateTime? endsAt)?  $default,) {final _that = this;
switch (_that) {
case _UpdatePromotionRequest() when $default != null:
return $default(_that.title,_that.shortDescription,_that.longDescription,_that.serviceCategory,_that.ctaText,_that.ctaAction,_that.startsAt,_that.endsAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdatePromotionRequest implements UpdatePromotionRequest {
  const _UpdatePromotionRequest({required this.title, required this.shortDescription, required this.longDescription, required this.serviceCategory, required this.ctaText, required this.ctaAction, this.startsAt, this.endsAt});
  factory _UpdatePromotionRequest.fromJson(Map<String, dynamic> json) => _$UpdatePromotionRequestFromJson(json);

@override final  String title;
@override final  String shortDescription;
@override final  String longDescription;
@override final  String serviceCategory;
@override final  String ctaText;
@override final  PromotionAction ctaAction;
@override final  DateTime? startsAt;
@override final  DateTime? endsAt;

/// Create a copy of UpdatePromotionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdatePromotionRequestCopyWith<_UpdatePromotionRequest> get copyWith => __$UpdatePromotionRequestCopyWithImpl<_UpdatePromotionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdatePromotionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdatePromotionRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription)&&(identical(other.longDescription, longDescription) || other.longDescription == longDescription)&&(identical(other.serviceCategory, serviceCategory) || other.serviceCategory == serviceCategory)&&(identical(other.ctaText, ctaText) || other.ctaText == ctaText)&&(identical(other.ctaAction, ctaAction) || other.ctaAction == ctaAction)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,shortDescription,longDescription,serviceCategory,ctaText,ctaAction,startsAt,endsAt);

@override
String toString() {
  return 'UpdatePromotionRequest(title: $title, shortDescription: $shortDescription, longDescription: $longDescription, serviceCategory: $serviceCategory, ctaText: $ctaText, ctaAction: $ctaAction, startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class _$UpdatePromotionRequestCopyWith<$Res> implements $UpdatePromotionRequestCopyWith<$Res> {
  factory _$UpdatePromotionRequestCopyWith(_UpdatePromotionRequest value, $Res Function(_UpdatePromotionRequest) _then) = __$UpdatePromotionRequestCopyWithImpl;
@override @useResult
$Res call({
 String title, String shortDescription, String longDescription, String serviceCategory, String ctaText, PromotionAction ctaAction, DateTime? startsAt, DateTime? endsAt
});




}
/// @nodoc
class __$UpdatePromotionRequestCopyWithImpl<$Res>
    implements _$UpdatePromotionRequestCopyWith<$Res> {
  __$UpdatePromotionRequestCopyWithImpl(this._self, this._then);

  final _UpdatePromotionRequest _self;
  final $Res Function(_UpdatePromotionRequest) _then;

/// Create a copy of UpdatePromotionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? shortDescription = null,Object? longDescription = null,Object? serviceCategory = null,Object? ctaText = null,Object? ctaAction = null,Object? startsAt = freezed,Object? endsAt = freezed,}) {
  return _then(_UpdatePromotionRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,shortDescription: null == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String,longDescription: null == longDescription ? _self.longDescription : longDescription // ignore: cast_nullable_to_non_nullable
as String,serviceCategory: null == serviceCategory ? _self.serviceCategory : serviceCategory // ignore: cast_nullable_to_non_nullable
as String,ctaText: null == ctaText ? _self.ctaText : ctaText // ignore: cast_nullable_to_non_nullable
as String,ctaAction: null == ctaAction ? _self.ctaAction : ctaAction // ignore: cast_nullable_to_non_nullable
as PromotionAction,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$CoverPresign {

 String get objectKey; String get url; String get contentType; int get expiresInSeconds;
/// Create a copy of CoverPresign
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoverPresignCopyWith<CoverPresign> get copyWith => _$CoverPresignCopyWithImpl<CoverPresign>(this as CoverPresign, _$identity);

  /// Serializes this CoverPresign to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoverPresign&&(identical(other.objectKey, objectKey) || other.objectKey == objectKey)&&(identical(other.url, url) || other.url == url)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.expiresInSeconds, expiresInSeconds) || other.expiresInSeconds == expiresInSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,objectKey,url,contentType,expiresInSeconds);

@override
String toString() {
  return 'CoverPresign(objectKey: $objectKey, url: $url, contentType: $contentType, expiresInSeconds: $expiresInSeconds)';
}


}

/// @nodoc
abstract mixin class $CoverPresignCopyWith<$Res>  {
  factory $CoverPresignCopyWith(CoverPresign value, $Res Function(CoverPresign) _then) = _$CoverPresignCopyWithImpl;
@useResult
$Res call({
 String objectKey, String url, String contentType, int expiresInSeconds
});




}
/// @nodoc
class _$CoverPresignCopyWithImpl<$Res>
    implements $CoverPresignCopyWith<$Res> {
  _$CoverPresignCopyWithImpl(this._self, this._then);

  final CoverPresign _self;
  final $Res Function(CoverPresign) _then;

/// Create a copy of CoverPresign
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


/// Adds pattern-matching-related methods to [CoverPresign].
extension CoverPresignPatterns on CoverPresign {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoverPresign value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoverPresign() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoverPresign value)  $default,){
final _that = this;
switch (_that) {
case _CoverPresign():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoverPresign value)?  $default,){
final _that = this;
switch (_that) {
case _CoverPresign() when $default != null:
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
case _CoverPresign() when $default != null:
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
case _CoverPresign():
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
case _CoverPresign() when $default != null:
return $default(_that.objectKey,_that.url,_that.contentType,_that.expiresInSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CoverPresign implements CoverPresign {
  const _CoverPresign({required this.objectKey, required this.url, required this.contentType, required this.expiresInSeconds});
  factory _CoverPresign.fromJson(Map<String, dynamic> json) => _$CoverPresignFromJson(json);

@override final  String objectKey;
@override final  String url;
@override final  String contentType;
@override final  int expiresInSeconds;

/// Create a copy of CoverPresign
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoverPresignCopyWith<_CoverPresign> get copyWith => __$CoverPresignCopyWithImpl<_CoverPresign>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoverPresignToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoverPresign&&(identical(other.objectKey, objectKey) || other.objectKey == objectKey)&&(identical(other.url, url) || other.url == url)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.expiresInSeconds, expiresInSeconds) || other.expiresInSeconds == expiresInSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,objectKey,url,contentType,expiresInSeconds);

@override
String toString() {
  return 'CoverPresign(objectKey: $objectKey, url: $url, contentType: $contentType, expiresInSeconds: $expiresInSeconds)';
}


}

/// @nodoc
abstract mixin class _$CoverPresignCopyWith<$Res> implements $CoverPresignCopyWith<$Res> {
  factory _$CoverPresignCopyWith(_CoverPresign value, $Res Function(_CoverPresign) _then) = __$CoverPresignCopyWithImpl;
@override @useResult
$Res call({
 String objectKey, String url, String contentType, int expiresInSeconds
});




}
/// @nodoc
class __$CoverPresignCopyWithImpl<$Res>
    implements _$CoverPresignCopyWith<$Res> {
  __$CoverPresignCopyWithImpl(this._self, this._then);

  final _CoverPresign _self;
  final $Res Function(_CoverPresign) _then;

/// Create a copy of CoverPresign
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? objectKey = null,Object? url = null,Object? contentType = null,Object? expiresInSeconds = null,}) {
  return _then(_CoverPresign(
objectKey: null == objectKey ? _self.objectKey : objectKey // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,expiresInSeconds: null == expiresInSeconds ? _self.expiresInSeconds : expiresInSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
