import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';
import 'package:healyn/features/discussion/data/discussion_api.dart';
import 'package:healyn/features/discussion/data/discussion_repository.dart';
import 'package:healyn/features/discussion/data/models/discussion_models.dart';
import 'package:healyn/features/discussion/presentation/screens/discussion_screen.dart';
import 'package:healyn/features/shared/auth/current_account.dart';

/// Serves a fixed page and records writes without hitting the network.
class _FakeDiscussionRepo extends DiscussionRepository {
  _FakeDiscussionRepo(this.page) : super(DiscussionApi(Dio()));

  final MessagePage page;
  bool postCalled = false;

  @override
  Future<MessagePage> list(String appointmentId, {String? cursor, int? limit}) async =>
      page;

  @override
  Future<void> markRead(String appointmentId, String messageId) async {}

  @override
  Future<DiscussionMessage> post(String appointmentId, String body) async {
    postCalled = true;
    return DiscussionMessage(
      id: 'new',
      appointmentId: appointmentId,
      senderAccountId: 'ac1',
      senderRole: DiscussionSenderRole.patientSide,
      messageType: DiscussionMessageType.question,
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
  senderAccountId: role == DiscussionSenderRole.patientSide ? 'ac1' : 'phys',
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
  scheduledAt: DateTime.utc(2026, 6, 10, 9),
  scheduledEndAt: DateTime.utc(2026, 6, 10, 9, 45),
  durationMinutes: 45,
  status: status,
);

Future<void> _pump(
  WidgetTester tester,
  AppointmentStatus status, {
  required _FakeDiscussionRepo repo,
}) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        discussionRepositoryProvider.overrideWithValue(repo),
        currentAccountIdProvider.overrideWith((ref) => 'ac1'),
      ],
      child: MaterialApp(home: DiscussionScreen(appointment: _appt(status))),
    ),
  );
}

void main() {
  testWidgets('renders incoming and outgoing messages with a composer', (
    tester,
  ) async {
    final repo = _FakeDiscussionRepo(
      MessagePage(
        items: [
          _msg(
            id: 'm2',
            role: DiscussionSenderRole.patientSide,
            body: 'Is icing still recommended?',
            type: DiscussionMessageType.question,
          ),
          _msg(
            id: 'm1',
            role: DiscussionSenderRole.physio,
            body: 'Yes, fifteen minutes.',
          ),
        ],
      ),
    );
    await _pump(tester, AppointmentStatus.confirmed, repo: repo);
    await tester.pumpAndSettle();

    expect(find.text('Is icing still recommended?'), findsOneWidget);
    expect(find.text('Yes, fifteen minutes.'), findsOneWidget);
    // The composer is available on an open appointment.
    expect(find.byTooltip('Send'), findsOneWidget);
  });

  testWidgets('shows an empty state when there are no messages', (tester) async {
    final repo = _FakeDiscussionRepo(const MessagePage(items: []));
    await _pump(tester, AppointmentStatus.confirmed, repo: repo);
    await tester.pumpAndSettle();

    expect(find.text('No messages yet'), findsOneWidget);
    expect(find.byTooltip('Send'), findsOneWidget);
  });

  testWidgets('a cancelled appointment is read-only — no composer', (
    tester,
  ) async {
    final repo = _FakeDiscussionRepo(
      MessagePage(
        items: [
          _msg(
            id: 'm1',
            role: DiscussionSenderRole.physio,
            body: 'Get well soon.',
          ),
        ],
      ),
    );
    await _pump(tester, AppointmentStatus.cancelled, repo: repo);
    await tester.pumpAndSettle();

    expect(find.text('Get well soon.'), findsOneWidget);
    expect(find.byTooltip('Send'), findsNothing);
    expect(
      find.text('This appointment is closed — the discussion is read-only.'),
      findsOneWidget,
    );
  });
}
