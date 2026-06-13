import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healyn/features/appointments/data/appointments_api.dart';
import 'package:healyn/features/appointments/data/appointments_repository.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';
import 'package:healyn/features/discussion/data/discussion_api.dart';
import 'package:healyn/features/discussion/data/discussion_repository.dart';
import 'package:healyn/features/discussion/data/models/discussion_models.dart';
import 'package:healyn/features/physio/presentation/physio_unread_providers.dart';

/// Serves a fixed page of the physio's live appointments.
class _FakeApptRepo extends AppointmentsRepository {
  _FakeApptRepo(this.items) : super(AppointmentsApi(Dio()));

  final List<Appointment> items;

  @override
  Future<AppointmentPage> list({
    String? patientId,
    String? statusCsv,
    bool? isFollowUp,
    DateTime? from,
    DateTime? to,
    String? cursor,
    int? limit,
  }) async => AppointmentPage(items: items, nextCursor: null);
}

/// Returns per-appointment unread counts and a single newest message for the
/// preview, without the network.
class _FakeDiscRepo extends DiscussionRepository {
  _FakeDiscRepo(this.counts, this.newest) : super(DiscussionApi(Dio()));

  final Map<String, int> counts;
  final Map<String, DiscussionMessage> newest;

  @override
  Future<int> unreadCount(String appointmentId) async =>
      counts[appointmentId] ?? 0;

  @override
  Future<MessagePage> list(
    String appointmentId, {
    String? cursor,
    int? limit,
  }) async {
    final m = newest[appointmentId];
    return MessagePage(items: m == null ? const [] : [m], nextCursor: null);
  }
}

Appointment _appt(String id, AppointmentStatus status) => Appointment(
  id: id,
  appointmentNumber: 'PHY-2026-$id',
  patientId: 'pt-$id',
  bookedByAccountId: 'ac1',
  physiotherapistId: 'ph1',
  requestedDate: DateTime(2026, 6, 10),
  durationMinutes: 45,
  status: status,
);

DiscussionMessage _msg(String apptId, String body, DateTime at) =>
    DiscussionMessage(
      id: 'm-$apptId',
      appointmentId: apptId,
      senderAccountId: 'ac-$apptId',
      senderRole: DiscussionSenderRole.patientSide,
      messageType: DiscussionMessageType.question,
      body: body,
      createdAt: at,
    );

void main() {
  test('sums unread across live threads, drops zero, sorts newest first', () async {
    final appts = [
      _appt('a1', AppointmentStatus.confirmed),
      _appt('a2', AppointmentStatus.completed),
      _appt('a3', AppointmentStatus.confirmed),
    ];
    final container = ProviderContainer(
      overrides: [
        appointmentsRepositoryProvider.overrideWithValue(_FakeApptRepo(appts)),
        discussionRepositoryProvider.overrideWithValue(
          _FakeDiscRepo(
            {'a1': 3, 'a2': 1, 'a3': 0},
            {
              'a1': _msg('a1', 'Can we change timing?', DateTime.utc(2026, 6, 10, 9)),
              'a2': _msg('a2', 'Thanks!', DateTime.utc(2026, 6, 11, 9)),
            },
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    final summary = await container.read(physioUnreadSummaryProvider.future);

    expect(summary.total, 4);
    expect(summary.threads, hasLength(2));
    // a2's message is newer, so it sorts first.
    expect(summary.threads.first.appointment.id, 'a2');
    expect(summary.threads.first.lastMessagePreview, 'Thanks!');
    expect(summary.threads[1].appointment.id, 'a1');
    expect(summary.threads[1].count, 3);
  });

  test('is empty when there are no live appointments', () async {
    final container = ProviderContainer(
      overrides: [
        appointmentsRepositoryProvider.overrideWithValue(_FakeApptRepo(const [])),
        discussionRepositoryProvider.overrideWithValue(
          _FakeDiscRepo(const {}, const {}),
        ),
      ],
    );
    addTearDown(container.dispose);

    final summary = await container.read(physioUnreadSummaryProvider.future);
    expect(summary.total, 0);
    expect(summary.threads, isEmpty);
  });
}
