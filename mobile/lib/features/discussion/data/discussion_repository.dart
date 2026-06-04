import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/network/api_exception.dart';
import 'discussion_api.dart';
import 'models/discussion_models.dart';

/// Data access for a discussion thread. Maps transport errors to
/// [ApiException]; the UI talks only to this class, never to Dio directly.
class DiscussionRepository {
  DiscussionRepository(this._api);

  final DiscussionApi _api;

  Future<MessagePage> list(
    String appointmentId, {
    String? cursor,
    int? limit,
  }) {
    return _guard(() => _api.list(appointmentId, cursor: cursor, limit: limit));
  }

  /// Posts a patient-side message. With [body] text it is a
  /// [DiscussionMessageType.question]; with only [fileIds] and no text it is a
  /// [DiscussionMessageType.attachmentOnly] (the backend rejects a QUESTION with
  /// no body and an ATTACHMENT_ONLY that carries a body). The caller ensures at
  /// least one of text or attachments is present.
  Future<DiscussionMessage> postMessage(
    String appointmentId, {
    String? body,
    List<String> fileIds = const [],
  }) {
    final text = body?.trim() ?? '';
    final hasText = text.isNotEmpty;
    return _guard(
      () => _api.post(
        appointmentId,
        PostMessageRequest(
          messageType: hasText
              ? DiscussionMessageType.question
              : DiscussionMessageType.attachmentOnly,
          body: hasText ? text : null,
          fileIds: fileIds,
        ),
      ),
    );
  }

  Future<DiscussionMessage> edit(
    String appointmentId,
    String messageId,
    String body,
  ) {
    return _guard(
      () => _api.edit(appointmentId, messageId, EditMessageRequest(body: body)),
    );
  }

  Future<void> delete(String appointmentId, String messageId) {
    return _guard(() => _api.delete(appointmentId, messageId));
  }

  Future<void> markRead(String appointmentId, String messageId) {
    return _guard(() => _api.markRead(appointmentId, messageId));
  }

  Future<int> unreadCount(String appointmentId) {
    return _guard(() => _api.unreadCount(appointmentId));
  }

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

final discussionRepositoryProvider = Provider<DiscussionRepository>(
  (ref) => DiscussionRepository(ref.watch(discussionApiProvider)),
);
