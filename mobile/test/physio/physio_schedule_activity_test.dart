import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';
import 'package:healyn/features/discussion/data/discussion_api.dart';
import 'package:healyn/features/discussion/data/discussion_repository.dart';
import 'package:healyn/features/discussion/data/models/discussion_models.dart';
import 'package:healyn/features/patients/data/models/patient_models.dart';
import 'package:healyn/features/patients/presentation/patients_providers.dart';
import 'package:healyn/features/physio/presentation/physio_requests_providers.dart';
import 'package:healyn/features/physio/presentation/physio_schedule_providers.dart';
import 'package:healyn/features/physio/presentation/screens/physio_today_screen.dart';
import 'package:healyn/features/shared/network/api_exception.dart';

Appointment _appt({
  required String id,
  AppointmentStatus status = AppointmentStatus.confirmed,
  String patientId = 'pt1',
  DateTime? scheduledAt,
}) {
  final at = scheduledAt ?? DateTime(2026, 6, 4, 9, 0);
  return Appointment(
    id: id,
    patientId: patientId,
    bookedByAccountId: 'ac1',
    physiotherapistId: 'ph1',
    requestedDate: DateTime(at.year, at.month, at.day),
    scheduledAt: at,
    scheduledEndAt: at.add(const Duration(minutes: 45)),
    durationMinutes: 45,
    status: status,
  );
}

MessageAttachment _att(int i) => MessageAttachment(
  fileId: 'f$i',
  kind: 'IMAGE',
  mimeType: 'image/png',
  originalFilename: 'scan$i.png',
  sizeBytes: 1024,
);

DiscussionMessage _msg({
  required DiscussionSenderRole role,
  int attachments = 0,
}) => DiscussionMessage(
  id: 'm${role.name}$attachments',
  appointmentId: 'a1',
  senderAccountId: role == DiscussionSenderRole.physio ? 'ph' : 'pt',
  senderRole: role,
  messageType: DiscussionMessageType.question,
  attachments: [for (var i = 0; i < attachments; i++) _att(i)],
  createdAt: DateTime(2026, 6, 4, 8, 0),
);

/// Records the threads it was asked to page so tests can assert the file scan
/// runs only when (and where) it should.
class _FakeDiscussionRepo extends DiscussionRepository {
  _FakeDiscussionRepo({
    this.counts = const {},
    this.pages = const {},
    this.throwUnreadFor = const {},
    this.throwListFor = const {},
  }) : super(DiscussionApi(Dio()));

  final Map<String, int> counts;
  final Map<String, List<DiscussionMessage>> pages;
  final Set<String> throwUnreadFor;
  final Set<String> throwListFor;

  final List<String> listed = [];

  @override
  Future<int> unreadCount(String appointmentId) async {
    if (throwUnreadFor.contains(appointmentId)) {
      throw const ApiException(code: 'error', message: 'boom');
    }
    return counts[appointmentId] ?? 0;
  }

  @override
  Future<MessagePage> list(
    String appointmentId, {
    String? cursor,
    int? limit,
  }) async {
    listed.add(appointmentId);
    if (throwListFor.contains(appointmentId)) {
      throw const ApiException(code: 'error', message: 'boom');
    }
    return MessagePage(items: pages[appointmentId] ?? const [], nextCursor: null);
  }
}

ProviderContainer _container({
  required List<Appointment> appointments,
  required _FakeDiscussionRepo repo,
}) {
  final container = ProviderContainer(
    overrides: [
      physioScheduleProvider.overrideWith((ref) async => appointments),
      discussionRepositoryProvider.overrideWithValue(repo),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

final _asha = Patient(
  id: 'pt1',
  fullName: 'Asha Rao',
  dateOfBirth: DateTime(1990, 5, 21),
  relationship: PatientRelationship.self,
  primary: true,
);

Future<void> _pumpScreen(
  WidgetTester tester, {
  required List<Appointment> appointments,
  required _FakeDiscussionRepo repo,
}) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        physioScheduleProvider.overrideWith((ref) async => appointments),
        physioRequestsProvider.overrideWith((ref) async => const []),
        discussionRepositoryProvider.overrideWithValue(repo),
        patientsProvider.overrideWith((ref) => [_asha]),
      ],
      child: const MaterialApp(home: PhysioTodayScreen()),
    ),
  );
}

void main() {
  group('physioScheduleActivityProvider', () {
    test('aggregates unread + pending files, skipping dead and zero rows', () async {
      final repo = _FakeDiscussionRepo(
        counts: {'a1': 2, 'a3': 5, 'a4': 1},
        pages: {
          'a1': [
            _msg(role: DiscussionSenderRole.patientSide, attachments: 1),
            _msg(role: DiscussionSenderRole.patientSide),
          ],
          'a4': [_msg(role: DiscussionSenderRole.patientSide)],
        },
      );
      final container = _container(
        appointments: [
          _appt(id: 'a1', status: AppointmentStatus.confirmed),
          _appt(id: 'a2', status: AppointmentStatus.requested), // unread 0
          _appt(id: 'a3', status: AppointmentStatus.cancelled), // dead → skip
          _appt(id: 'a4', status: AppointmentStatus.completed),
        ],
        repo: repo,
      );

      final map = await container.read(physioScheduleActivityProvider.future);

      expect(map.keys, unorderedEquals(['a1', 'a4']));
      expect(map['a1']!.unreadCount, 2);
      expect(map['a1']!.pendingFileCount, 1);
      expect(map['a4']!.unreadCount, 1);
      expect(map['a4']!.pendingFileCount, 0);
      // Dead state never queried; zero-unread thread not paged for files.
      expect(repo.listed, isNot(contains('a3')));
      expect(repo.listed, isNot(contains('a2')));
      expect(repo.listed, containsAll(['a1', 'a4']));
    });

    test('counts files only on the newest unread patient-side messages', () async {
      final repo = _FakeDiscussionRepo(
        counts: {'a1': 1},
        pages: {
          'a1': [
            // Newest-first: a physio message (never counted) then two patient
            // messages; with unread = 1 only the newest patient one counts.
            _msg(role: DiscussionSenderRole.physio, attachments: 9),
            _msg(role: DiscussionSenderRole.patientSide, attachments: 2),
            _msg(role: DiscussionSenderRole.patientSide, attachments: 3),
          ],
        },
      );
      final container = _container(
        appointments: [_appt(id: 'a1')],
        repo: repo,
      );

      final map = await container.read(physioScheduleActivityProvider.future);

      expect(map['a1']!.unreadCount, 1);
      expect(map['a1']!.pendingFileCount, 2);
    });

    test('degrades: unread error drops the row, list error keeps the badge', () async {
      final repo = _FakeDiscussionRepo(
        counts: {'a1': 4, 'a2': 3},
        throwUnreadFor: {'a1'},
        throwListFor: {'a2'},
      );
      final container = _container(
        appointments: [_appt(id: 'a1'), _appt(id: 'a2')],
        repo: repo,
      );

      final map = await container.read(physioScheduleActivityProvider.future);

      expect(map.keys, ['a2']);
      expect(map['a2']!.unreadCount, 3);
      expect(map['a2']!.pendingFileCount, 0);
    });
  });

  group('PhysioTodayScreen badges', () {
    testWidgets('shows unread and pending-file badges for an active thread', (
      tester,
    ) async {
      final repo = _FakeDiscussionRepo(
        counts: {'a1': 2},
        pages: {
          'a1': [
            _msg(role: DiscussionSenderRole.patientSide, attachments: 1),
            _msg(role: DiscussionSenderRole.patientSide),
          ],
        },
      );
      await _pumpScreen(tester, appointments: [_appt(id: 'a1')], repo: repo);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mark_email_unread_outlined), findsOneWidget);
      expect(find.text('2'), findsOneWidget); // unread count
      expect(find.byIcon(Icons.attach_file), findsOneWidget);
      expect(find.text('1'), findsOneWidget); // pending files
    });

    testWidgets('shows no badges when the thread has no activity', (
      tester,
    ) async {
      final repo = _FakeDiscussionRepo(counts: {'a1': 0});
      await _pumpScreen(tester, appointments: [_appt(id: 'a1')], repo: repo);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mark_email_unread_outlined), findsNothing);
      expect(find.byIcon(Icons.attach_file), findsNothing);
    });
  });
}
