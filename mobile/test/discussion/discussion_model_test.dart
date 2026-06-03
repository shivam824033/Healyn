import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/discussion/data/models/discussion_models.dart';

void main() {
  Map<String, dynamic> messageJson({
    String senderRole = 'PATIENT_SIDE',
    String messageType = 'QUESTION',
    String? body = 'Is icing still recommended?',
    List<Map<String, dynamic>> attachments = const [],
    String? editedAt,
  }) => <String, dynamic>{
    'id': 'msg1',
    'appointment_id': 'ap1',
    'sender_account_id': 'ac1',
    'sender_role': senderRole,
    'message_type': messageType,
    'body': body,
    'attachments': attachments,
    'created_at': '2026-06-10T09:00:00Z',
    'edited_at': editedAt,
  };

  test('parses a patient message from snake_case JSON (instant is UTC)', () {
    final m = DiscussionMessage.fromJson(messageJson());

    expect(m.id, 'msg1');
    expect(m.appointmentId, 'ap1');
    expect(m.senderAccountId, 'ac1');
    expect(m.senderRole, DiscussionSenderRole.patientSide);
    expect(m.messageType, DiscussionMessageType.question);
    expect(m.body, 'Is icing still recommended?');
    expect(m.attachments, isEmpty);
    expect(m.editedAt, isNull);
    expect(m.createdAt.isUtc, isTrue);
    expect(m.createdAt.toUtc(), DateTime.utc(2026, 6, 10, 9));
  });

  test('parses a physio INSTRUCTION with an attachment and edited marker', () {
    final m = DiscussionMessage.fromJson(
      messageJson(
        senderRole: 'PHYSIO',
        messageType: 'INSTRUCTION',
        body: 'Do these stretches twice daily.',
        attachments: [
          {
            'file_id': 'f1',
            'kind': 'REPORT',
            'mime_type': 'application/pdf',
            'original_filename': 'plan.pdf',
            'size_bytes': 20480,
          },
        ],
        editedAt: '2026-06-10T09:02:00Z',
      ),
    );

    expect(m.senderRole, DiscussionSenderRole.physio);
    expect(m.messageType, DiscussionMessageType.instruction);
    expect(m.attachments, hasLength(1));
    expect(m.attachments.single.originalFilename, 'plan.pdf');
    expect(m.attachments.single.mimeType, 'application/pdf');
    expect(m.attachments.single.sizeBytes, 20480);
    expect(m.editedAt, isNotNull);
  });

  test('an ATTACHMENT_ONLY message has a null body', () {
    final m = DiscussionMessage.fromJson(
      messageJson(messageType: 'ATTACHMENT_ONLY', body: null),
    );
    expect(m.messageType, DiscussionMessageType.attachmentOnly);
    expect(m.body, isNull);
  });

  test('MessagePage carries items and an optional next cursor', () {
    final page = MessagePage.fromJson(<String, dynamic>{
      'items': [messageJson()],
      'next_cursor': 'CURSOR',
    });
    expect(page.items, hasLength(1));
    expect(page.nextCursor, 'CURSOR');

    final last = MessagePage.fromJson(<String, dynamic>{
      'items': <dynamic>[],
      'next_cursor': null,
    });
    expect(last.items, isEmpty);
    expect(last.nextCursor, isNull);
  });

  test('PostMessageRequest serializes a patient question to snake_case', () {
    final json = const PostMessageRequest(
      messageType: DiscussionMessageType.question,
      body: 'Quick question',
    ).toJson();

    expect(json['message_type'], 'QUESTION');
    expect(json['body'], 'Quick question');
    // Empty (not null) — the backend reads file_ids even with no attachments.
    expect(json['file_ids'], isEmpty);
  });

  test('EditMessageRequest serializes the replacement body', () {
    final json = const EditMessageRequest(body: 'fixed typo').toJson();
    expect(json['body'], 'fixed typo');
  });
}
