import 'package:freezed_annotation/freezed_annotation.dart';

part 'discussion_models.freezed.dart';
part 'discussion_models.g.dart';

/// Who sent a message. In the patient app, [physio] messages are incoming
/// (rendered on the left) and [patientSide] are outgoing (right).
enum DiscussionSenderRole {
  @JsonValue('PATIENT_SIDE')
  patientSide,
  @JsonValue('PHYSIO')
  physio,
}

/// Classifies a message. The patient app only ever *sends* [question]; the
/// physiotherapist sends [reply] / [instruction]. [instruction] is prescriptive
/// guidance and is rendered with emphasis. [attachmentOnly] carries no body.
enum DiscussionMessageType {
  @JsonValue('QUESTION')
  question,
  @JsonValue('REPLY')
  reply,
  @JsonValue('INSTRUCTION')
  instruction,
  @JsonValue('ATTACHMENT_ONLY')
  attachmentOnly,
}

/// A file attached to a message. Display-only in the Phase 1 patient thread
/// (name + type + size); the upload/download bytes flow is the `files` feature
/// (F1.15). [fileId] is the handle that flow will resolve to a presigned URL.
@freezed
abstract class MessageAttachment with _$MessageAttachment {
  const factory MessageAttachment({
    required String fileId,
    required String kind,
    required String mimeType,
    required String originalFilename,
    required int sizeBytes,
  }) = _MessageAttachment;

  factory MessageAttachment.fromJson(Map<String, dynamic> json) =>
      _$MessageAttachmentFromJson(json);
}

/// One message in an appointment's discussion. Mirrors the backend
/// `MessageView`. [body] is null for [DiscussionMessageType.attachmentOnly].
/// Timestamps are UTC instants; convert to local before display. Never log
/// [body] — it is PHI (CLAUDE.md §3).
@freezed
abstract class DiscussionMessage with _$DiscussionMessage {
  const factory DiscussionMessage({
    required String id,
    required String appointmentId,
    required String senderAccountId,
    required DiscussionSenderRole senderRole,
    required DiscussionMessageType messageType,
    String? body,
    @Default(<MessageAttachment>[]) List<MessageAttachment> attachments,
    required DateTime createdAt,
    DateTime? editedAt,
  }) = _DiscussionMessage;

  factory DiscussionMessage.fromJson(Map<String, dynamic> json) =>
      _$DiscussionMessageFromJson(json);
}

/// One cursor page of messages, newest-first (the backend order). [nextCursor]
/// is null on the last (oldest) page.
@freezed
abstract class MessagePage with _$MessagePage {
  const factory MessagePage({
    required List<DiscussionMessage> items,
    String? nextCursor,
  }) = _MessagePage;

  factory MessagePage.fromJson(Map<String, dynamic> json) =>
      _$MessagePageFromJson(json);
}

/// Body for `POST /appointments/{id}/messages`. The patient app sends a text
/// [DiscussionMessageType.question] with a [body]; [fileIds] stays empty until
/// the attachment-upload flow lands (F1.15).
@freezed
abstract class PostMessageRequest with _$PostMessageRequest {
  const factory PostMessageRequest({
    required DiscussionMessageType messageType,
    String? body,
    @Default(<String>[]) List<String> fileIds,
  }) = _PostMessageRequest;

  factory PostMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$PostMessageRequestFromJson(json);
}

/// Body for `PATCH /appointments/{id}/messages/{messageId}` — replaces the body
/// within the 5-minute edit window (enforced server-side).
@freezed
abstract class EditMessageRequest with _$EditMessageRequest {
  const factory EditMessageRequest({required String body}) =
      _EditMessageRequest;

  factory EditMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$EditMessageRequestFromJson(json);
}
