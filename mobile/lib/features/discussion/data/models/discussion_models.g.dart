// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discussion_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageAttachment _$MessageAttachmentFromJson(Map<String, dynamic> json) =>
    _MessageAttachment(
      fileId: json['file_id'] as String,
      kind: json['kind'] as String,
      mimeType: json['mime_type'] as String,
      originalFilename: json['original_filename'] as String,
      sizeBytes: (json['size_bytes'] as num).toInt(),
    );

Map<String, dynamic> _$MessageAttachmentToJson(_MessageAttachment instance) =>
    <String, dynamic>{
      'file_id': instance.fileId,
      'kind': instance.kind,
      'mime_type': instance.mimeType,
      'original_filename': instance.originalFilename,
      'size_bytes': instance.sizeBytes,
    };

_DiscussionMessage _$DiscussionMessageFromJson(
  Map<String, dynamic> json,
) => _DiscussionMessage(
  id: json['id'] as String,
  appointmentId: json['appointment_id'] as String,
  senderAccountId: json['sender_account_id'] as String,
  senderRole: $enumDecode(_$DiscussionSenderRoleEnumMap, json['sender_role']),
  messageType: $enumDecode(
    _$DiscussionMessageTypeEnumMap,
    json['message_type'],
  ),
  body: json['body'] as String?,
  attachments:
      (json['attachments'] as List<dynamic>?)
          ?.map((e) => MessageAttachment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <MessageAttachment>[],
  createdAt: DateTime.parse(json['created_at'] as String),
  editedAt: json['edited_at'] == null
      ? null
      : DateTime.parse(json['edited_at'] as String),
);

Map<String, dynamic> _$DiscussionMessageToJson(_DiscussionMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'appointment_id': instance.appointmentId,
      'sender_account_id': instance.senderAccountId,
      'sender_role': _$DiscussionSenderRoleEnumMap[instance.senderRole]!,
      'message_type': _$DiscussionMessageTypeEnumMap[instance.messageType]!,
      'body': ?instance.body,
      'attachments': instance.attachments.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt.toIso8601String(),
      'edited_at': ?instance.editedAt?.toIso8601String(),
    };

const _$DiscussionSenderRoleEnumMap = {
  DiscussionSenderRole.patientSide: 'PATIENT_SIDE',
  DiscussionSenderRole.physio: 'PHYSIO',
};

const _$DiscussionMessageTypeEnumMap = {
  DiscussionMessageType.question: 'QUESTION',
  DiscussionMessageType.reply: 'REPLY',
  DiscussionMessageType.instruction: 'INSTRUCTION',
  DiscussionMessageType.attachmentOnly: 'ATTACHMENT_ONLY',
};

_MessagePage _$MessagePageFromJson(Map<String, dynamic> json) => _MessagePage(
  items: (json['items'] as List<dynamic>)
      .map((e) => DiscussionMessage.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextCursor: json['next_cursor'] as String?,
);

Map<String, dynamic> _$MessagePageToJson(_MessagePage instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': ?instance.nextCursor,
    };

_PostMessageRequest _$PostMessageRequestFromJson(Map<String, dynamic> json) =>
    _PostMessageRequest(
      messageType: $enumDecode(
        _$DiscussionMessageTypeEnumMap,
        json['message_type'],
      ),
      body: json['body'] as String?,
      fileIds:
          (json['file_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$PostMessageRequestToJson(_PostMessageRequest instance) =>
    <String, dynamic>{
      'message_type': _$DiscussionMessageTypeEnumMap[instance.messageType]!,
      'body': ?instance.body,
      'file_ids': instance.fileIds,
    };

_EditMessageRequest _$EditMessageRequestFromJson(Map<String, dynamic> json) =>
    _EditMessageRequest(body: json['body'] as String);

Map<String, dynamic> _$EditMessageRequestToJson(_EditMessageRequest instance) =>
    <String, dynamic>{'body': instance.body};
