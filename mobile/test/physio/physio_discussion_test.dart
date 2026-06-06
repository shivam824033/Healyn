import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';
import 'package:healyn/features/discussion/data/discussion_api.dart';
import 'package:healyn/features/discussion/data/discussion_repository.dart';
import 'package:healyn/features/discussion/data/models/discussion_models.dart';
import 'package:healyn/features/discussion/presentation/screens/discussion_screen.dart';
import 'package:healyn/features/discussion/presentation/widgets/message_bubble.dart';
import 'package:healyn/features/shared/auth/current_account.dart';

/// Serves a fixed page and records physio-side posts without the network.
class _FakePhysioDiscussionRepo extends DiscussionRepository {
  _FakePhysioDiscussionRepo(this.page) : super(DiscussionApi(Dio()));

  final MessagePage page;
  bool postCalled = false;
  String? lastBody;
  bool lastInstruction = false;

  @override
  Future<MessagePage> list(
    String appointmentId, {
    String? cursor,
    int? limit,
  }) async => page;

  @override
  Future<void> markRead(String appointmentId, String messageId) async {}

  @override
  Future<DiscussionMessage> postPhysioMessage(
    String appointmentId, {
    String? body,
    List<String> fileIds = const [],
    bool instruction = false,
  }) async {
    postCalled = true;
    lastBody = body;
    lastInstruction = instruction;
    final hasText = body != null && body.isNotEmpty;
    return DiscussionMessage(
      id: 'new',
      appointmentId: appointmentId,
      senderAccountId: 'phys',
      senderRole: DiscussionSenderRole.physio,
      messageType: !hasText
          ? DiscussionMessageType.attachmentOnly
          : (instruction
                ? DiscussionMessageType.instruction
                : DiscussionMessageType.reply),
      body: body,
      createdAt: DateTime.now().toUtc(),
    );
  }
}

DiscussionMessage _msg({
  required String id,
  required DiscussionSenderRole role,
  required String body,
  DiscussionMessageType type = DiscussionMessageType.reply,
}) => DiscussionMessage(
  id: id,
  appointmentId: 'ap1',
  senderAccountId: role == DiscussionSenderRole.physio ? 'phys' : 'ac1',
  senderRole: role,
  messageType: type,
  body: body,
  createdAt: DateTime.utc(2026, 6, 10, 9),
);

Appointment _appt(AppointmentStatus status) => Appointment(
  id: 'ap1',
  patientId: 'pt1',
  bookedByAccountId: 'ac1',
  physiotherapistId: 'ph1',
  requestedDate: DateTime(2026, 6, 10),
  scheduledAt: DateTime.utc(2026, 6, 10, 9),
  scheduledEndAt: DateTime.utc(2026, 6, 10, 9, 45),
  durationMinutes: 45,
  status: status,
);

Future<void> _pump(
  WidgetTester tester,
  AppointmentStatus status, {
  required _FakePhysioDiscussionRepo repo,
}) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        discussionRepositoryProvider.overrideWithValue(repo),
        currentAccountIdProvider.overrideWith((ref) => 'phys'),
      ],
      child: MaterialApp(
        home: DiscussionScreen(
          appointment: _appt(status),
          viewer: DiscussionViewer.physio,
        ),
      ),
    ),
  );
}

MessageBubble _bubble(WidgetTester tester, String id) => tester
    .widget<MessageBubble>(
      find.byWidgetPredicate((w) => w is MessageBubble && w.message.id == id),
    );

void main() {
  testWidgets('physio messages are outgoing and patient messages incoming', (
    tester,
  ) async {
    final repo = _FakePhysioDiscussionRepo(
      MessagePage(
        items: [
          _msg(
            id: 'mPatient',
            role: DiscussionSenderRole.patientSide,
            body: 'Is icing still recommended?',
            type: DiscussionMessageType.question,
          ),
          _msg(
            id: 'mPhysio',
            role: DiscussionSenderRole.physio,
            body: 'Yes, fifteen minutes.',
          ),
        ],
      ),
    );
    await _pump(tester, AppointmentStatus.confirmed, repo: repo);
    await tester.pumpAndSettle();

    // The viewer is the physio, so its messages sit on the right.
    expect(_bubble(tester, 'mPhysio').isOutgoing, isTrue);
    expect(_bubble(tester, 'mPatient').isOutgoing, isFalse);
  });

  testWidgets('the thread stays writable on a cancelled appointment', (
    tester,
  ) async {
    final repo = _FakePhysioDiscussionRepo(
      MessagePage(
        items: [
          _msg(
            id: 'm1',
            role: DiscussionSenderRole.patientSide,
            body: 'Sorry I had to cancel.',
            type: DiscussionMessageType.question,
          ),
        ],
      ),
    );
    await _pump(tester, AppointmentStatus.cancelled, repo: repo);
    await tester.pumpAndSettle();

    // The physio keeps write access regardless of status (no read-only notice).
    expect(find.byTooltip('Send'), findsOneWidget);
    expect(
      find.text('This appointment is closed — the discussion is read-only.'),
      findsNothing,
    );
  });

  testWidgets('sending text posts a REPLY', (tester) async {
    final repo = _FakePhysioDiscussionRepo(const MessagePage(items: []));
    await _pump(tester, AppointmentStatus.confirmed, repo: repo);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Keep up the stretches.');
    await tester.tap(find.byTooltip('Send'));
    await tester.pumpAndSettle();

    expect(repo.postCalled, isTrue);
    expect(repo.lastBody, 'Keep up the stretches.');
    expect(repo.lastInstruction, isFalse);
  });

  testWidgets('toggling Instruction posts an INSTRUCTION', (tester) async {
    final repo = _FakePhysioDiscussionRepo(const MessagePage(items: []));
    await _pump(tester, AppointmentStatus.confirmed, repo: repo);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Do these twice daily.');
    await tester.tap(find.widgetWithText(FilterChip, 'Instruction'));
    await tester.pump();
    await tester.tap(find.byTooltip('Send'));
    await tester.pumpAndSettle();

    expect(repo.postCalled, isTrue);
    expect(repo.lastInstruction, isTrue);
  });

  testWidgets('empty thread shows the physio prompt', (tester) async {
    final repo = _FakePhysioDiscussionRepo(const MessagePage(items: []));
    await _pump(tester, AppointmentStatus.confirmed, repo: repo);
    await tester.pumpAndSettle();

    expect(find.text('No messages yet'), findsOneWidget);
    expect(
      find.text('Reply to the patient or add an instruction for this appointment.'),
      findsOneWidget,
    );
  });
}
