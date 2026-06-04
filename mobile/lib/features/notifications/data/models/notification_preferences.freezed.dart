// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationPreferences {

 bool get appointmentUpdates; bool get appointmentReminders; bool get messages; bool get treatmentNotes;
/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPreferencesCopyWith<NotificationPreferences> get copyWith => _$NotificationPreferencesCopyWithImpl<NotificationPreferences>(this as NotificationPreferences, _$identity);

  /// Serializes this NotificationPreferences to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPreferences&&(identical(other.appointmentUpdates, appointmentUpdates) || other.appointmentUpdates == appointmentUpdates)&&(identical(other.appointmentReminders, appointmentReminders) || other.appointmentReminders == appointmentReminders)&&(identical(other.messages, messages) || other.messages == messages)&&(identical(other.treatmentNotes, treatmentNotes) || other.treatmentNotes == treatmentNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appointmentUpdates,appointmentReminders,messages,treatmentNotes);

@override
String toString() {
  return 'NotificationPreferences(appointmentUpdates: $appointmentUpdates, appointmentReminders: $appointmentReminders, messages: $messages, treatmentNotes: $treatmentNotes)';
}


}

/// @nodoc
abstract mixin class $NotificationPreferencesCopyWith<$Res>  {
  factory $NotificationPreferencesCopyWith(NotificationPreferences value, $Res Function(NotificationPreferences) _then) = _$NotificationPreferencesCopyWithImpl;
@useResult
$Res call({
 bool appointmentUpdates, bool appointmentReminders, bool messages, bool treatmentNotes
});




}
/// @nodoc
class _$NotificationPreferencesCopyWithImpl<$Res>
    implements $NotificationPreferencesCopyWith<$Res> {
  _$NotificationPreferencesCopyWithImpl(this._self, this._then);

  final NotificationPreferences _self;
  final $Res Function(NotificationPreferences) _then;

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appointmentUpdates = null,Object? appointmentReminders = null,Object? messages = null,Object? treatmentNotes = null,}) {
  return _then(_self.copyWith(
appointmentUpdates: null == appointmentUpdates ? _self.appointmentUpdates : appointmentUpdates // ignore: cast_nullable_to_non_nullable
as bool,appointmentReminders: null == appointmentReminders ? _self.appointmentReminders : appointmentReminders // ignore: cast_nullable_to_non_nullable
as bool,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as bool,treatmentNotes: null == treatmentNotes ? _self.treatmentNotes : treatmentNotes // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationPreferences].
extension NotificationPreferencesPatterns on NotificationPreferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationPreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationPreferences value)  $default,){
final _that = this;
switch (_that) {
case _NotificationPreferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationPreferences value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool appointmentUpdates,  bool appointmentReminders,  bool messages,  bool treatmentNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
return $default(_that.appointmentUpdates,_that.appointmentReminders,_that.messages,_that.treatmentNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool appointmentUpdates,  bool appointmentReminders,  bool messages,  bool treatmentNotes)  $default,) {final _that = this;
switch (_that) {
case _NotificationPreferences():
return $default(_that.appointmentUpdates,_that.appointmentReminders,_that.messages,_that.treatmentNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool appointmentUpdates,  bool appointmentReminders,  bool messages,  bool treatmentNotes)?  $default,) {final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
return $default(_that.appointmentUpdates,_that.appointmentReminders,_that.messages,_that.treatmentNotes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationPreferences extends NotificationPreferences {
  const _NotificationPreferences({this.appointmentUpdates = true, this.appointmentReminders = true, this.messages = true, this.treatmentNotes = true}): super._();
  factory _NotificationPreferences.fromJson(Map<String, dynamic> json) => _$NotificationPreferencesFromJson(json);

@override@JsonKey() final  bool appointmentUpdates;
@override@JsonKey() final  bool appointmentReminders;
@override@JsonKey() final  bool messages;
@override@JsonKey() final  bool treatmentNotes;

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationPreferencesCopyWith<_NotificationPreferences> get copyWith => __$NotificationPreferencesCopyWithImpl<_NotificationPreferences>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationPreferencesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPreferences&&(identical(other.appointmentUpdates, appointmentUpdates) || other.appointmentUpdates == appointmentUpdates)&&(identical(other.appointmentReminders, appointmentReminders) || other.appointmentReminders == appointmentReminders)&&(identical(other.messages, messages) || other.messages == messages)&&(identical(other.treatmentNotes, treatmentNotes) || other.treatmentNotes == treatmentNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appointmentUpdates,appointmentReminders,messages,treatmentNotes);

@override
String toString() {
  return 'NotificationPreferences(appointmentUpdates: $appointmentUpdates, appointmentReminders: $appointmentReminders, messages: $messages, treatmentNotes: $treatmentNotes)';
}


}

/// @nodoc
abstract mixin class _$NotificationPreferencesCopyWith<$Res> implements $NotificationPreferencesCopyWith<$Res> {
  factory _$NotificationPreferencesCopyWith(_NotificationPreferences value, $Res Function(_NotificationPreferences) _then) = __$NotificationPreferencesCopyWithImpl;
@override @useResult
$Res call({
 bool appointmentUpdates, bool appointmentReminders, bool messages, bool treatmentNotes
});




}
/// @nodoc
class __$NotificationPreferencesCopyWithImpl<$Res>
    implements _$NotificationPreferencesCopyWith<$Res> {
  __$NotificationPreferencesCopyWithImpl(this._self, this._then);

  final _NotificationPreferences _self;
  final $Res Function(_NotificationPreferences) _then;

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appointmentUpdates = null,Object? appointmentReminders = null,Object? messages = null,Object? treatmentNotes = null,}) {
  return _then(_NotificationPreferences(
appointmentUpdates: null == appointmentUpdates ? _self.appointmentUpdates : appointmentUpdates // ignore: cast_nullable_to_non_nullable
as bool,appointmentReminders: null == appointmentReminders ? _self.appointmentReminders : appointmentReminders // ignore: cast_nullable_to_non_nullable
as bool,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as bool,treatmentNotes: null == treatmentNotes ? _self.treatmentNotes : treatmentNotes // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
