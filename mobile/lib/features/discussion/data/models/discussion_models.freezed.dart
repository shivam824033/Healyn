// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discussion_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageAttachment {

 String get fileId; String get kind; String get mimeType; String get originalFilename; int get sizeBytes;
/// Create a copy of MessageAttachment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageAttachmentCopyWith<MessageAttachment> get copyWith => _$MessageAttachmentCopyWithImpl<MessageAttachment>(this as MessageAttachment, _$identity);

  /// Serializes this MessageAttachment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageAttachment&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.originalFilename, originalFilename) || other.originalFilename == originalFilename)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,kind,mimeType,originalFilename,sizeBytes);

@override
String toString() {
  return 'MessageAttachment(fileId: $fileId, kind: $kind, mimeType: $mimeType, originalFilename: $originalFilename, sizeBytes: $sizeBytes)';
}


}

/// @nodoc
abstract mixin class $MessageAttachmentCopyWith<$Res>  {
  factory $MessageAttachmentCopyWith(MessageAttachment value, $Res Function(MessageAttachment) _then) = _$MessageAttachmentCopyWithImpl;
@useResult
$Res call({
 String fileId, String kind, String mimeType, String originalFilename, int sizeBytes
});




}
/// @nodoc
class _$MessageAttachmentCopyWithImpl<$Res>
    implements $MessageAttachmentCopyWith<$Res> {
  _$MessageAttachmentCopyWithImpl(this._self, this._then);

  final MessageAttachment _self;
  final $Res Function(MessageAttachment) _then;

/// Create a copy of MessageAttachment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileId = null,Object? kind = null,Object? mimeType = null,Object? originalFilename = null,Object? sizeBytes = null,}) {
  return _then(_self.copyWith(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,originalFilename: null == originalFilename ? _self.originalFilename : originalFilename // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageAttachment].
extension MessageAttachmentPatterns on MessageAttachment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageAttachment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageAttachment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageAttachment value)  $default,){
final _that = this;
switch (_that) {
case _MessageAttachment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageAttachment value)?  $default,){
final _that = this;
switch (_that) {
case _MessageAttachment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileId,  String kind,  String mimeType,  String originalFilename,  int sizeBytes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageAttachment() when $default != null:
return $default(_that.fileId,_that.kind,_that.mimeType,_that.originalFilename,_that.sizeBytes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileId,  String kind,  String mimeType,  String originalFilename,  int sizeBytes)  $default,) {final _that = this;
switch (_that) {
case _MessageAttachment():
return $default(_that.fileId,_that.kind,_that.mimeType,_that.originalFilename,_that.sizeBytes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileId,  String kind,  String mimeType,  String originalFilename,  int sizeBytes)?  $default,) {final _that = this;
switch (_that) {
case _MessageAttachment() when $default != null:
return $default(_that.fileId,_that.kind,_that.mimeType,_that.originalFilename,_that.sizeBytes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageAttachment implements MessageAttachment {
  const _MessageAttachment({required this.fileId, required this.kind, required this.mimeType, required this.originalFilename, required this.sizeBytes});
  factory _MessageAttachment.fromJson(Map<String, dynamic> json) => _$MessageAttachmentFromJson(json);

@override final  String fileId;
@override final  String kind;
@override final  String mimeType;
@override final  String originalFilename;
@override final  int sizeBytes;

/// Create a copy of MessageAttachment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageAttachmentCopyWith<_MessageAttachment> get copyWith => __$MessageAttachmentCopyWithImpl<_MessageAttachment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageAttachmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageAttachment&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.originalFilename, originalFilename) || other.originalFilename == originalFilename)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileId,kind,mimeType,originalFilename,sizeBytes);

@override
String toString() {
  return 'MessageAttachment(fileId: $fileId, kind: $kind, mimeType: $mimeType, originalFilename: $originalFilename, sizeBytes: $sizeBytes)';
}


}

/// @nodoc
abstract mixin class _$MessageAttachmentCopyWith<$Res> implements $MessageAttachmentCopyWith<$Res> {
  factory _$MessageAttachmentCopyWith(_MessageAttachment value, $Res Function(_MessageAttachment) _then) = __$MessageAttachmentCopyWithImpl;
@override @useResult
$Res call({
 String fileId, String kind, String mimeType, String originalFilename, int sizeBytes
});




}
/// @nodoc
class __$MessageAttachmentCopyWithImpl<$Res>
    implements _$MessageAttachmentCopyWith<$Res> {
  __$MessageAttachmentCopyWithImpl(this._self, this._then);

  final _MessageAttachment _self;
  final $Res Function(_MessageAttachment) _then;

/// Create a copy of MessageAttachment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileId = null,Object? kind = null,Object? mimeType = null,Object? originalFilename = null,Object? sizeBytes = null,}) {
  return _then(_MessageAttachment(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,originalFilename: null == originalFilename ? _self.originalFilename : originalFilename // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DiscussionMessage {

 String get id; String get appointmentId; String get senderAccountId; DiscussionSenderRole get senderRole; DiscussionMessageType get messageType; String? get body; List<MessageAttachment> get attachments; DateTime get createdAt; DateTime? get editedAt;
/// Create a copy of DiscussionMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscussionMessageCopyWith<DiscussionMessage> get copyWith => _$DiscussionMessageCopyWithImpl<DiscussionMessage>(this as DiscussionMessage, _$identity);

  /// Serializes this DiscussionMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscussionMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.senderAccountId, senderAccountId) || other.senderAccountId == senderAccountId)&&(identical(other.senderRole, senderRole) || other.senderRole == senderRole)&&(identical(other.messageType, messageType) || other.messageType == messageType)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.attachments, attachments)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.editedAt, editedAt) || other.editedAt == editedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,appointmentId,senderAccountId,senderRole,messageType,body,const DeepCollectionEquality().hash(attachments),createdAt,editedAt);

@override
String toString() {
  return 'DiscussionMessage(id: $id, appointmentId: $appointmentId, senderAccountId: $senderAccountId, senderRole: $senderRole, messageType: $messageType, body: $body, attachments: $attachments, createdAt: $createdAt, editedAt: $editedAt)';
}


}

/// @nodoc
abstract mixin class $DiscussionMessageCopyWith<$Res>  {
  factory $DiscussionMessageCopyWith(DiscussionMessage value, $Res Function(DiscussionMessage) _then) = _$DiscussionMessageCopyWithImpl;
@useResult
$Res call({
 String id, String appointmentId, String senderAccountId, DiscussionSenderRole senderRole, DiscussionMessageType messageType, String? body, List<MessageAttachment> attachments, DateTime createdAt, DateTime? editedAt
});




}
/// @nodoc
class _$DiscussionMessageCopyWithImpl<$Res>
    implements $DiscussionMessageCopyWith<$Res> {
  _$DiscussionMessageCopyWithImpl(this._self, this._then);

  final DiscussionMessage _self;
  final $Res Function(DiscussionMessage) _then;

/// Create a copy of DiscussionMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? appointmentId = null,Object? senderAccountId = null,Object? senderRole = null,Object? messageType = null,Object? body = freezed,Object? attachments = null,Object? createdAt = null,Object? editedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,senderAccountId: null == senderAccountId ? _self.senderAccountId : senderAccountId // ignore: cast_nullable_to_non_nullable
as String,senderRole: null == senderRole ? _self.senderRole : senderRole // ignore: cast_nullable_to_non_nullable
as DiscussionSenderRole,messageType: null == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as DiscussionMessageType,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,attachments: null == attachments ? _self.attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<MessageAttachment>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,editedAt: freezed == editedAt ? _self.editedAt : editedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscussionMessage].
extension DiscussionMessagePatterns on DiscussionMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscussionMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscussionMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscussionMessage value)  $default,){
final _that = this;
switch (_that) {
case _DiscussionMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscussionMessage value)?  $default,){
final _that = this;
switch (_that) {
case _DiscussionMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String appointmentId,  String senderAccountId,  DiscussionSenderRole senderRole,  DiscussionMessageType messageType,  String? body,  List<MessageAttachment> attachments,  DateTime createdAt,  DateTime? editedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscussionMessage() when $default != null:
return $default(_that.id,_that.appointmentId,_that.senderAccountId,_that.senderRole,_that.messageType,_that.body,_that.attachments,_that.createdAt,_that.editedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String appointmentId,  String senderAccountId,  DiscussionSenderRole senderRole,  DiscussionMessageType messageType,  String? body,  List<MessageAttachment> attachments,  DateTime createdAt,  DateTime? editedAt)  $default,) {final _that = this;
switch (_that) {
case _DiscussionMessage():
return $default(_that.id,_that.appointmentId,_that.senderAccountId,_that.senderRole,_that.messageType,_that.body,_that.attachments,_that.createdAt,_that.editedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String appointmentId,  String senderAccountId,  DiscussionSenderRole senderRole,  DiscussionMessageType messageType,  String? body,  List<MessageAttachment> attachments,  DateTime createdAt,  DateTime? editedAt)?  $default,) {final _that = this;
switch (_that) {
case _DiscussionMessage() when $default != null:
return $default(_that.id,_that.appointmentId,_that.senderAccountId,_that.senderRole,_that.messageType,_that.body,_that.attachments,_that.createdAt,_that.editedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiscussionMessage implements DiscussionMessage {
  const _DiscussionMessage({required this.id, required this.appointmentId, required this.senderAccountId, required this.senderRole, required this.messageType, this.body, final  List<MessageAttachment> attachments = const <MessageAttachment>[], required this.createdAt, this.editedAt}): _attachments = attachments;
  factory _DiscussionMessage.fromJson(Map<String, dynamic> json) => _$DiscussionMessageFromJson(json);

@override final  String id;
@override final  String appointmentId;
@override final  String senderAccountId;
@override final  DiscussionSenderRole senderRole;
@override final  DiscussionMessageType messageType;
@override final  String? body;
 final  List<MessageAttachment> _attachments;
@override@JsonKey() List<MessageAttachment> get attachments {
  if (_attachments is EqualUnmodifiableListView) return _attachments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachments);
}

@override final  DateTime createdAt;
@override final  DateTime? editedAt;

/// Create a copy of DiscussionMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscussionMessageCopyWith<_DiscussionMessage> get copyWith => __$DiscussionMessageCopyWithImpl<_DiscussionMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiscussionMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscussionMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.senderAccountId, senderAccountId) || other.senderAccountId == senderAccountId)&&(identical(other.senderRole, senderRole) || other.senderRole == senderRole)&&(identical(other.messageType, messageType) || other.messageType == messageType)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other._attachments, _attachments)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.editedAt, editedAt) || other.editedAt == editedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,appointmentId,senderAccountId,senderRole,messageType,body,const DeepCollectionEquality().hash(_attachments),createdAt,editedAt);

@override
String toString() {
  return 'DiscussionMessage(id: $id, appointmentId: $appointmentId, senderAccountId: $senderAccountId, senderRole: $senderRole, messageType: $messageType, body: $body, attachments: $attachments, createdAt: $createdAt, editedAt: $editedAt)';
}


}

/// @nodoc
abstract mixin class _$DiscussionMessageCopyWith<$Res> implements $DiscussionMessageCopyWith<$Res> {
  factory _$DiscussionMessageCopyWith(_DiscussionMessage value, $Res Function(_DiscussionMessage) _then) = __$DiscussionMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String appointmentId, String senderAccountId, DiscussionSenderRole senderRole, DiscussionMessageType messageType, String? body, List<MessageAttachment> attachments, DateTime createdAt, DateTime? editedAt
});




}
/// @nodoc
class __$DiscussionMessageCopyWithImpl<$Res>
    implements _$DiscussionMessageCopyWith<$Res> {
  __$DiscussionMessageCopyWithImpl(this._self, this._then);

  final _DiscussionMessage _self;
  final $Res Function(_DiscussionMessage) _then;

/// Create a copy of DiscussionMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? appointmentId = null,Object? senderAccountId = null,Object? senderRole = null,Object? messageType = null,Object? body = freezed,Object? attachments = null,Object? createdAt = null,Object? editedAt = freezed,}) {
  return _then(_DiscussionMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,appointmentId: null == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String,senderAccountId: null == senderAccountId ? _self.senderAccountId : senderAccountId // ignore: cast_nullable_to_non_nullable
as String,senderRole: null == senderRole ? _self.senderRole : senderRole // ignore: cast_nullable_to_non_nullable
as DiscussionSenderRole,messageType: null == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as DiscussionMessageType,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,attachments: null == attachments ? _self._attachments : attachments // ignore: cast_nullable_to_non_nullable
as List<MessageAttachment>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,editedAt: freezed == editedAt ? _self.editedAt : editedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$MessagePage {

 List<DiscussionMessage> get items; String? get nextCursor;
/// Create a copy of MessagePage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessagePageCopyWith<MessagePage> get copyWith => _$MessagePageCopyWithImpl<MessagePage>(this as MessagePage, _$identity);

  /// Serializes this MessagePage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagePage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),nextCursor);

@override
String toString() {
  return 'MessagePage(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $MessagePageCopyWith<$Res>  {
  factory $MessagePageCopyWith(MessagePage value, $Res Function(MessagePage) _then) = _$MessagePageCopyWithImpl;
@useResult
$Res call({
 List<DiscussionMessage> items, String? nextCursor
});




}
/// @nodoc
class _$MessagePageCopyWithImpl<$Res>
    implements $MessagePageCopyWith<$Res> {
  _$MessagePageCopyWithImpl(this._self, this._then);

  final MessagePage _self;
  final $Res Function(MessagePage) _then;

/// Create a copy of MessagePage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<DiscussionMessage>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MessagePage].
extension MessagePagePatterns on MessagePage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessagePage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessagePage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessagePage value)  $default,){
final _that = this;
switch (_that) {
case _MessagePage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessagePage value)?  $default,){
final _that = this;
switch (_that) {
case _MessagePage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DiscussionMessage> items,  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessagePage() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DiscussionMessage> items,  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _MessagePage():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DiscussionMessage> items,  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _MessagePage() when $default != null:
return $default(_that.items,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessagePage implements MessagePage {
  const _MessagePage({required final  List<DiscussionMessage> items, this.nextCursor}): _items = items;
  factory _MessagePage.fromJson(Map<String, dynamic> json) => _$MessagePageFromJson(json);

 final  List<DiscussionMessage> _items;
@override List<DiscussionMessage> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String? nextCursor;

/// Create a copy of MessagePage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessagePageCopyWith<_MessagePage> get copyWith => __$MessagePageCopyWithImpl<_MessagePage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessagePageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessagePage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),nextCursor);

@override
String toString() {
  return 'MessagePage(items: $items, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$MessagePageCopyWith<$Res> implements $MessagePageCopyWith<$Res> {
  factory _$MessagePageCopyWith(_MessagePage value, $Res Function(_MessagePage) _then) = __$MessagePageCopyWithImpl;
@override @useResult
$Res call({
 List<DiscussionMessage> items, String? nextCursor
});




}
/// @nodoc
class __$MessagePageCopyWithImpl<$Res>
    implements _$MessagePageCopyWith<$Res> {
  __$MessagePageCopyWithImpl(this._self, this._then);

  final _MessagePage _self;
  final $Res Function(_MessagePage) _then;

/// Create a copy of MessagePage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? nextCursor = freezed,}) {
  return _then(_MessagePage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<DiscussionMessage>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PostMessageRequest {

 DiscussionMessageType get messageType; String? get body; List<String> get fileIds;
/// Create a copy of PostMessageRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostMessageRequestCopyWith<PostMessageRequest> get copyWith => _$PostMessageRequestCopyWithImpl<PostMessageRequest>(this as PostMessageRequest, _$identity);

  /// Serializes this PostMessageRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostMessageRequest&&(identical(other.messageType, messageType) || other.messageType == messageType)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.fileIds, fileIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageType,body,const DeepCollectionEquality().hash(fileIds));

@override
String toString() {
  return 'PostMessageRequest(messageType: $messageType, body: $body, fileIds: $fileIds)';
}


}

/// @nodoc
abstract mixin class $PostMessageRequestCopyWith<$Res>  {
  factory $PostMessageRequestCopyWith(PostMessageRequest value, $Res Function(PostMessageRequest) _then) = _$PostMessageRequestCopyWithImpl;
@useResult
$Res call({
 DiscussionMessageType messageType, String? body, List<String> fileIds
});




}
/// @nodoc
class _$PostMessageRequestCopyWithImpl<$Res>
    implements $PostMessageRequestCopyWith<$Res> {
  _$PostMessageRequestCopyWithImpl(this._self, this._then);

  final PostMessageRequest _self;
  final $Res Function(PostMessageRequest) _then;

/// Create a copy of PostMessageRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageType = null,Object? body = freezed,Object? fileIds = null,}) {
  return _then(_self.copyWith(
messageType: null == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as DiscussionMessageType,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,fileIds: null == fileIds ? _self.fileIds : fileIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PostMessageRequest].
extension PostMessageRequestPatterns on PostMessageRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostMessageRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostMessageRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostMessageRequest value)  $default,){
final _that = this;
switch (_that) {
case _PostMessageRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostMessageRequest value)?  $default,){
final _that = this;
switch (_that) {
case _PostMessageRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DiscussionMessageType messageType,  String? body,  List<String> fileIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostMessageRequest() when $default != null:
return $default(_that.messageType,_that.body,_that.fileIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DiscussionMessageType messageType,  String? body,  List<String> fileIds)  $default,) {final _that = this;
switch (_that) {
case _PostMessageRequest():
return $default(_that.messageType,_that.body,_that.fileIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DiscussionMessageType messageType,  String? body,  List<String> fileIds)?  $default,) {final _that = this;
switch (_that) {
case _PostMessageRequest() when $default != null:
return $default(_that.messageType,_that.body,_that.fileIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostMessageRequest implements PostMessageRequest {
  const _PostMessageRequest({required this.messageType, this.body, final  List<String> fileIds = const <String>[]}): _fileIds = fileIds;
  factory _PostMessageRequest.fromJson(Map<String, dynamic> json) => _$PostMessageRequestFromJson(json);

@override final  DiscussionMessageType messageType;
@override final  String? body;
 final  List<String> _fileIds;
@override@JsonKey() List<String> get fileIds {
  if (_fileIds is EqualUnmodifiableListView) return _fileIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fileIds);
}


/// Create a copy of PostMessageRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostMessageRequestCopyWith<_PostMessageRequest> get copyWith => __$PostMessageRequestCopyWithImpl<_PostMessageRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostMessageRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostMessageRequest&&(identical(other.messageType, messageType) || other.messageType == messageType)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other._fileIds, _fileIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageType,body,const DeepCollectionEquality().hash(_fileIds));

@override
String toString() {
  return 'PostMessageRequest(messageType: $messageType, body: $body, fileIds: $fileIds)';
}


}

/// @nodoc
abstract mixin class _$PostMessageRequestCopyWith<$Res> implements $PostMessageRequestCopyWith<$Res> {
  factory _$PostMessageRequestCopyWith(_PostMessageRequest value, $Res Function(_PostMessageRequest) _then) = __$PostMessageRequestCopyWithImpl;
@override @useResult
$Res call({
 DiscussionMessageType messageType, String? body, List<String> fileIds
});




}
/// @nodoc
class __$PostMessageRequestCopyWithImpl<$Res>
    implements _$PostMessageRequestCopyWith<$Res> {
  __$PostMessageRequestCopyWithImpl(this._self, this._then);

  final _PostMessageRequest _self;
  final $Res Function(_PostMessageRequest) _then;

/// Create a copy of PostMessageRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageType = null,Object? body = freezed,Object? fileIds = null,}) {
  return _then(_PostMessageRequest(
messageType: null == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as DiscussionMessageType,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,fileIds: null == fileIds ? _self._fileIds : fileIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$EditMessageRequest {

 String get body;
/// Create a copy of EditMessageRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditMessageRequestCopyWith<EditMessageRequest> get copyWith => _$EditMessageRequestCopyWithImpl<EditMessageRequest>(this as EditMessageRequest, _$identity);

  /// Serializes this EditMessageRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditMessageRequest&&(identical(other.body, body) || other.body == body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,body);

@override
String toString() {
  return 'EditMessageRequest(body: $body)';
}


}

/// @nodoc
abstract mixin class $EditMessageRequestCopyWith<$Res>  {
  factory $EditMessageRequestCopyWith(EditMessageRequest value, $Res Function(EditMessageRequest) _then) = _$EditMessageRequestCopyWithImpl;
@useResult
$Res call({
 String body
});




}
/// @nodoc
class _$EditMessageRequestCopyWithImpl<$Res>
    implements $EditMessageRequestCopyWith<$Res> {
  _$EditMessageRequestCopyWithImpl(this._self, this._then);

  final EditMessageRequest _self;
  final $Res Function(EditMessageRequest) _then;

/// Create a copy of EditMessageRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? body = null,}) {
  return _then(_self.copyWith(
body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EditMessageRequest].
extension EditMessageRequestPatterns on EditMessageRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditMessageRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditMessageRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditMessageRequest value)  $default,){
final _that = this;
switch (_that) {
case _EditMessageRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditMessageRequest value)?  $default,){
final _that = this;
switch (_that) {
case _EditMessageRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String body)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditMessageRequest() when $default != null:
return $default(_that.body);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String body)  $default,) {final _that = this;
switch (_that) {
case _EditMessageRequest():
return $default(_that.body);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String body)?  $default,) {final _that = this;
switch (_that) {
case _EditMessageRequest() when $default != null:
return $default(_that.body);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EditMessageRequest implements EditMessageRequest {
  const _EditMessageRequest({required this.body});
  factory _EditMessageRequest.fromJson(Map<String, dynamic> json) => _$EditMessageRequestFromJson(json);

@override final  String body;

/// Create a copy of EditMessageRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditMessageRequestCopyWith<_EditMessageRequest> get copyWith => __$EditMessageRequestCopyWithImpl<_EditMessageRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EditMessageRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditMessageRequest&&(identical(other.body, body) || other.body == body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,body);

@override
String toString() {
  return 'EditMessageRequest(body: $body)';
}


}

/// @nodoc
abstract mixin class _$EditMessageRequestCopyWith<$Res> implements $EditMessageRequestCopyWith<$Res> {
  factory _$EditMessageRequestCopyWith(_EditMessageRequest value, $Res Function(_EditMessageRequest) _then) = __$EditMessageRequestCopyWithImpl;
@override @useResult
$Res call({
 String body
});




}
/// @nodoc
class __$EditMessageRequestCopyWithImpl<$Res>
    implements _$EditMessageRequestCopyWith<$Res> {
  __$EditMessageRequestCopyWithImpl(this._self, this._then);

  final _EditMessageRequest _self;
  final $Res Function(_EditMessageRequest) _then;

/// Create a copy of EditMessageRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? body = null,}) {
  return _then(_EditMessageRequest(
body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
