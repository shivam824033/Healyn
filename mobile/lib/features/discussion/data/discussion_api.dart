import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/network/dio_client.dart';
import 'models/discussion_models.dart';

/// Thin transport for an appointment's discussion thread — the nested
/// `/appointments/{appointmentId}/messages` endpoints. Returns typed models;
/// DioErrors propagate and are mapped to [ApiException] in the repository.
class DiscussionApi {
  DiscussionApi(this._dio);

  final Dio _dio;

  String _base(String appointmentId) => '/appointments/$appointmentId/messages';

  /// A page of messages, newest-first. [cursor] pages toward older messages.
  Future<MessagePage> list(
    String appointmentId, {
    String? cursor,
    int? limit,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      _base(appointmentId),
      queryParameters: <String, dynamic>{
        if (cursor != null && cursor.isNotEmpty) 'cursor': cursor,
        'limit': ?limit,
      },
    );
    return MessagePage.fromJson(res.data!);
  }

  Future<DiscussionMessage> post(
    String appointmentId,
    PostMessageRequest body,
  ) async {
    final res = await _dio.post<Map<String, dynamic>>(
      _base(appointmentId),
      data: body.toJson(),
    );
    return DiscussionMessage.fromJson(res.data!);
  }

  Future<DiscussionMessage> edit(
    String appointmentId,
    String messageId,
    EditMessageRequest body,
  ) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '${_base(appointmentId)}/$messageId',
      data: body.toJson(),
    );
    return DiscussionMessage.fromJson(res.data!);
  }

  Future<void> delete(String appointmentId, String messageId) async {
    await _dio.delete<void>('${_base(appointmentId)}/$messageId');
  }

  /// Advances this account's read marker to [messageId] (clears unread up to it).
  Future<void> markRead(String appointmentId, String messageId) async {
    await _dio.post<void>(
      '${_base(appointmentId)}/read',
      data: <String, dynamic>{'message_id': messageId},
    );
  }
}

final discussionApiProvider = Provider<DiscussionApi>(
  (ref) => DiscussionApi(ref.watch(dioProvider)),
);
