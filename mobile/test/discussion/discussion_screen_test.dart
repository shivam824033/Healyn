import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';
import 'package:healyn/features/discussion/data/discussion_api.dart';
import 'package:healyn/features/discussion/data/discussion_repository.dart';
import 'package:healyn/features/discussion/data/models/discussion_models.dart';
import 'package:healyn/features/discussion/presentation/screens/discussion_screen.dart';
import 'package:healyn/features/files/data/file_picker_service.dart';
import 'package:healyn/features/files/data/files_api.dart';
import 'package:healyn/features/files/data/files_repository.dart';
import 'package:healyn/features/files/data/models/file_models.dart';
import 'package:healyn/features/files/data/url_opener.dart';
import 'package:healyn/features/shared/auth/current_account.dart';

/// Serves a fixed page and records writes without hitting the network.
class _FakeDiscussionRepo extends DiscussionRepository {
  _FakeDiscussionRepo(this.page) : super(DiscussionApi(Dio()));

  final MessagePage page;
  bool postCalled = false;
  String? lastBody;
  List<String> lastFileIds = const [];

  @override
  Future<MessagePage> list(String appointmentId, {String? cursor, int? limit}) async =>
      page;

  @override
  Future<void> markRead(String appointmentId, String messageId) async {}

  @override
  Future<DiscussionMessage> postMessage(
    String appointmentId, {
    String? body,
    List<String> fileIds = const [],
  }) async {
    postCalled = true;
    lastBody = body;
    lastFileIds = fileIds;
    return DiscussionMessage(
      id: 'new',
      appointmentId: appointmentId,
      senderAccountId: 'ac1',
      senderRole: DiscussionSenderRole.patientSide,
      messageType: (body == null || body.isEmpty)
          ? DiscussionMessageType.attachmentOnly
          : DiscussionMessageType.question,
      body: body,
      createdAt: DateTime.now().toUtc(),
    );
  }
}

/// Returns a fixed picked file (or null to simulate cancel).
class _FakePicker implements FilePickerService {
  _FakePicker(this.result);

  final PickedFile? result;

  @override
  Future<PickedFile?> pick(PickSource source) async => result;
}

/// Returns a fixed AVAILABLE file / download target without the network.
class _FakeFilesRepo extends FilesRepository {
  _FakeFilesRepo() : super(FilesApi(Dio(), Dio()));

  String? downloadedFileId;

  @override
  Future<FileObjectView> upload({
    required String patientId,
    required String appointmentId,
    required FileKind kind,
    required String mimeType,
    required String originalFilename,
    required List<int> bytes,
  }) async => FileObjectView(
    id: 'file-1',
    patientId: patientId,
    ownerAccountId: 'ac1',
    kind: kind,
    mimeType: mimeType,
    originalFilename: originalFilename,
    sizeBytes: bytes.length,
    status: FileStatus.available,
  );

  @override
  Future<DownloadTarget> download(String fileId) async {
    downloadedFileId = fileId;
    return const DownloadTarget(
      url: 'https://store.example/get?sig=xyz',
      expiresInSeconds: 300,
    );
  }
}

/// Records the URL the screen asked to open instead of hitting a platform channel.
class _FakeUrlOpener implements UrlOpener {
  String? openedUrl;

  @override
  Future<bool> open(String url) async {
    openedUrl = url;
    return true;
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
  FilePickerService? picker,
  FilesRepository? filesRepo,
  UrlOpener? urlOpener,
}) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        discussionRepositoryProvider.overrideWithValue(repo),
        currentAccountIdProvider.overrideWith((ref) => 'ac1'),
        if (picker != null)
          filePickerServiceProvider.overrideWithValue(picker),
        if (filesRepo != null)
          filesRepositoryProvider.overrideWithValue(filesRepo),
        if (urlOpener != null)
          urlOpenerProvider.overrideWithValue(urlOpener),
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

  testWidgets('attaching a file stages a chip and sends it with the message', (
    tester,
  ) async {
    final repo = _FakeDiscussionRepo(const MessagePage(items: []));
    await _pump(
      tester,
      AppointmentStatus.confirmed,
      repo: repo,
      picker: _FakePicker(
        const PickedFile(bytes: [1, 2, 3], filename: 'spine.pdf'),
      ),
      filesRepo: _FakeFilesRepo(),
    );
    await tester.pumpAndSettle();

    // Attach → pick a file from storage → the upload stages a named chip.
    await tester.tap(find.byTooltip('Attach'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose file'));
    await tester.pumpAndSettle();
    expect(find.text('spine.pdf'), findsOneWidget);

    // Send with no text → an ATTACHMENT_ONLY message carrying the file id.
    await tester.tap(find.byTooltip('Send'));
    await tester.pumpAndSettle();

    expect(repo.postCalled, isTrue);
    expect(repo.lastBody, isNull);
    expect(repo.lastFileIds, ['file-1']);
    // The staged chip clears once sent.
    expect(find.text('spine.pdf'), findsNothing);
  });

  testWidgets('tapping an attachment opens its presigned url', (tester) async {
    final repo = _FakeDiscussionRepo(
      MessagePage(
        items: [
          DiscussionMessage(
            id: 'm1',
            appointmentId: 'ap1',
            senderAccountId: 'phys',
            senderRole: DiscussionSenderRole.physio,
            messageType: DiscussionMessageType.reply,
            body: 'Here is your plan.',
            attachments: const [
              MessageAttachment(
                fileId: 'file-9',
                kind: 'EXERCISE_PLAN',
                mimeType: 'application/pdf',
                originalFilename: 'plan.pdf',
                sizeBytes: 1024,
              ),
            ],
            createdAt: DateTime.utc(2026, 6, 10, 9),
          ),
        ],
      ),
    );
    final filesRepo = _FakeFilesRepo();
    final opener = _FakeUrlOpener();
    await _pump(
      tester,
      AppointmentStatus.confirmed,
      repo: repo,
      filesRepo: filesRepo,
      urlOpener: opener,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('plan.pdf'));
    await tester.pumpAndSettle();

    // The chip resolves its file id to a presigned URL and opens that URL.
    expect(filesRepo.downloadedFileId, 'file-9');
    expect(opener.openedUrl, 'https://store.example/get?sig=xyz');
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
