import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../appointments/data/models/appointment_models.dart';
import '../../../files/data/file_picker_service.dart';
import '../../../files/data/file_types.dart';
import '../../../files/data/files_repository.dart';
import '../../../files/data/models/file_models.dart';
import '../../../files/data/url_opener.dart';
import '../../../patients/presentation/patients_providers.dart';
import '../../../shared/auth/current_account.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/widgets/healyn_state_switcher.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/copyable_id.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/healyn_skeletons.dart';
import '../../data/discussion_repository.dart';
import '../../data/models/discussion_models.dart';
import '../discussion_format.dart';
import '../widgets/message_bubble.dart';

/// Which side is viewing the thread. The screen is one widget for both apps
/// because the thread itself is identical — only the perspective differs:
/// - [patient]: patient-side messages are outgoing; the composer posts a
///   QUESTION and is hidden (read-only) on CANCELLED/NO_SHOW appointments.
/// - [physio]: PHYSIO messages are outgoing; the composer posts a REPLY (or an
///   INSTRUCTION when toggled) and stays writable on every status, mirroring
///   the backend `DiscussionAccessPolicy` (the physio keeps write access).
enum DiscussionViewer { patient, physio }

/// The appointment-scoped discussion thread (F1.14, both sides). Loads the
/// newest page of messages, lets the viewer post text or attach files, and
/// edit/delete their own text message within the 5-minute window. Attaching
/// uploads via the `files` feature (F1.15) and stages the file to send with the
/// next message. Tapping an attachment resolves it to a short-lived presigned
/// URL and opens it externally. See [DiscussionViewer] for the per-side
/// behaviour.
class DiscussionScreen extends ConsumerStatefulWidget {
  const DiscussionScreen({
    required this.appointment,
    this.viewer = DiscussionViewer.patient,
    super.key,
  });

  final Appointment appointment;
  final DiscussionViewer viewer;

  @override
  ConsumerState<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends ConsumerState<DiscussionScreen> {
  final _scroll = ScrollController();
  final _composer = TextEditingController();

  /// Oldest-first (the backend lists newest-first; we reverse for display).
  final List<DiscussionMessage> _messages = [];

  /// Files already uploaded (AVAILABLE) and staged to send with the next message.
  final List<FileObjectView> _attachments = [];
  String? _nextCursor;
  String? _myAccountId;

  bool _loading = true;
  bool _loadingOlder = false;
  bool _posting = false;
  bool _attaching = false;

  /// Physio composer only: send the next message as an INSTRUCTION.
  bool _instructionMode = false;
  String? _loadError;

  Appointment get _appt => widget.appointment;
  String get _appointmentId => _appt.id;
  bool get _isPhysio => widget.viewer == DiscussionViewer.physio;

  /// The sender role of *this* viewer — its own messages are outgoing.
  DiscussionSenderRole get _mySide => _isPhysio
      ? DiscussionSenderRole.physio
      : DiscussionSenderRole.patientSide;

  /// The physio keeps write access on every status; the patient side is blocked
  /// only on terminal statuses (CANCELLED/NO_SHOW) — every other status (incl.
  /// COMPLETED) stays writable, matching the server policy.
  bool get _writable =>
      _isPhysio ||
      (_appt.status != AppointmentStatus.cancelled &&
          _appt.status != AppointmentStatus.noShow);

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _scroll.dispose();
    _composer.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    _myAccountId = await ref.read(currentAccountIdProvider.future);
    await _loadInitial();
  }

  Future<void> _loadInitial() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final page = await ref
          .read(discussionRepositoryProvider)
          .list(_appointmentId, limit: 30);
      if (!mounted) return;
      setState(() {
        _messages
          ..clear()
          ..addAll(page.items.reversed);
        _nextCursor = page.nextCursor;
        _loading = false;
      });
      _markNewestRead();
      _jumpToBottomSoon();
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _loadError = e.message;
          _loading = false;
        });
      }
    }
  }

  Future<void> _loadOlder() async {
    if (_loadingOlder || _nextCursor == null) return;
    setState(() => _loadingOlder = true);
    try {
      final page = await ref
          .read(discussionRepositoryProvider)
          .list(_appointmentId, cursor: _nextCursor, limit: 30);
      if (!mounted) return;
      setState(() {
        _messages.insertAll(0, page.items.reversed);
        _nextCursor = page.nextCursor;
        _loadingOlder = false;
      });
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _loadingOlder = false);
        _toast(e.message);
      }
    }
  }

  /// Advances the read marker to the newest message so unread counts clear.
  /// Fire-and-forget: a failed mark must not block reading the thread.
  void _markNewestRead() {
    if (_messages.isEmpty) return;
    final newest = _messages.last.id;
    unawaited(
      ref
          .read(discussionRepositoryProvider)
          .markRead(_appointmentId, newest)
          .catchError((_) {}),
    );
  }

  Future<void> _send() async {
    final text = _composer.text.trim();
    final fileIds = _attachments.map((f) => f.id).toList();
    if ((text.isEmpty && fileIds.isEmpty) || _posting) return;
    setState(() => _posting = true);
    try {
      final repo = ref.read(discussionRepositoryProvider);
      final body = text.isEmpty ? null : text;
      final saved = _isPhysio
          ? await repo.postPhysioMessage(
              _appointmentId,
              body: body,
              fileIds: fileIds,
              instruction: _instructionMode,
            )
          : await repo.postMessage(
              _appointmentId,
              body: body,
              fileIds: fileIds,
            );
      if (!mounted) return;
      setState(() {
        _messages.add(saved);
        _composer.clear();
        _attachments.clear();
        _instructionMode = false;
        _posting = false;
      });
      _markNewestRead();
      _jumpToBottomSoon();
    } on ApiException catch (e) {
      // Keep the typed text and staged attachments so the patient can retry.
      if (mounted) {
        setState(() => _posting = false);
        _toast(e.message);
      }
    }
  }

  /// Offers the three attachment sources; the chosen one picks, validates, and
  /// uploads the file, staging it on success.
  void _chooseAttachmentSource() {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take photo'),
              onTap: () {
                Navigator.pop(ctx);
                _pickAndUpload(PickSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose photo'),
              onTap: () {
                Navigator.pop(ctx);
                _pickAndUpload(PickSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file_outlined),
              title: const Text('Choose file'),
              onTap: () {
                Navigator.pop(ctx);
                _pickAndUpload(PickSource.file);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndUpload(PickSource source) async {
    if (_attaching) return;
    PickedFile? picked;
    try {
      picked = await ref.read(filePickerServiceProvider).pick(source);
    } catch (_) {
      _toast("Couldn't open the picker.");
      return;
    }
    if (picked == null || !mounted) return;

    final type = uploadTypeForFilename(picked.filename);
    if (type == null) {
      _toast('Only PDF, JPG, and PNG files can be attached.');
      return;
    }
    if (picked.bytes.length > type.maxBytes) {
      _toast('That file is too large.');
      return;
    }

    setState(() => _attaching = true);
    try {
      final file = await ref
          .read(filesRepositoryProvider)
          .upload(
            patientId: _appt.patientId,
            appointmentId: _appointmentId,
            kind: FileKind.other,
            context: FileUploadContext.discussion,
            mimeType: type.mimeType,
            originalFilename: picked.filename,
            bytes: picked.bytes,
          );
      if (!mounted) return;
      setState(() {
        _attachments.add(file);
        _attaching = false;
      });
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _attaching = false);
        _toast(e.message);
      }
    }
  }

  void _removeAttachment(FileObjectView file) {
    setState(() => _attachments.removeWhere((f) => f.id == file.id));
  }

  /// Resolves a tapped attachment to a presigned URL and opens it externally
  /// (browser/native viewer); no bytes touch local storage and the URL expires.
  Future<void> _openAttachment(MessageAttachment attachment) async {
    final repo = ref.read(filesRepositoryProvider);
    final opener = ref.read(urlOpenerProvider);
    try {
      final target = await repo.download(attachment.fileId);
      final opened = await opener.open(target.url);
      if (!opened && mounted) _toast("Couldn't open this attachment.");
    } on ApiException catch (e) {
      if (mounted) _toast(e.message);
    }
  }

  Future<void> _editMessage(DiscussionMessage m) async {
    final controller = TextEditingController(text: m.body ?? '');
    final newBody = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit message'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: null,
          maxLength: 2000,
          decoration: const InputDecoration(hintText: 'Your message'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (newBody == null || newBody.isEmpty || newBody == m.body || !mounted) {
      return;
    }
    try {
      final updated = await ref
          .read(discussionRepositoryProvider)
          .edit(_appointmentId, m.id, newBody);
      if (!mounted) return;
      setState(() {
        final i = _messages.indexWhere((x) => x.id == m.id);
        if (i != -1) _messages[i] = updated;
      });
    } on ApiException catch (e) {
      if (mounted) _toast(e.message);
    }
  }

  Future<void> _deleteMessage(DiscussionMessage m) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete message?'),
        content: const Text('This removes your message from the discussion.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep it'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: HealynColors.statusDanger,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await ref
          .read(discussionRepositoryProvider)
          .delete(_appointmentId, m.id);
      if (!mounted) return;
      setState(() => _messages.removeWhere((x) => x.id == m.id));
    } on ApiException catch (e) {
      if (mounted) _toast(e.message);
    }
  }

  void _showActions(DiscussionMessage m) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(ctx);
                _editMessage(m);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: HealynColors.statusDanger,
              ),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(ctx);
                _deleteMessage(m);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Within the 5-minute window, this account's own text messages can be
  /// edited or deleted — mirrors the backend so we don't offer a doomed action.
  bool _canModify(DiscussionMessage m) {
    if (!_writable) return false;
    if (m.senderRole != _mySide) return false;
    if (m.messageType == DiscussionMessageType.attachmentOnly) return false;
    if (_myAccountId == null || m.senderAccountId != _myAccountId) return false;
    return DateTime.now().difference(m.createdAt).inSeconds < 300;
  }

  void _jumpToBottomSoon() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Opens this thread's appointment detail, scoped to the viewer's app.
  void _openDetail() {
    final route = _isPhysio
        ? '/physio/appointments/$_appointmentId'
        : '/appointments/$_appointmentId';
    context.push(route, extra: _appt);
  }

  /// The patient's name for the physio viewer's header (the physio has the
  /// roster loaded). Null for the patient viewer, or until the roster resolves.
  String? _headerPatientName() {
    if (!_isPhysio) return null;
    final patients = ref.watch(patientsProvider).valueOrNull;
    if (patients == null) return null;
    for (final p in patients) {
      if (p.id == _appt.patientId) return p.fullName;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: HealynAppBar(
        titleWidget: _DiscussionHeader(
          appointmentNumber: _appt.appointmentNumber,
          patientName: _headerPatientName(),
          onOpenDetail: _openDetail,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: HealynStateSwitcher(
                child: _body(),
              ),
            ),
            _writable ? _buildComposer() : const _ReadOnlyNotice(),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    if (_loading) {
      return const HealynChatSkeleton();
    }
    if (_loadError != null) {
      return _LoadError(message: _loadError!, onRetry: _loadInitial);
    }
    if (_messages.isEmpty) {
      return _EmptyThread(
        subtitle: _isPhysio
            ? 'Reply to the patient or add an instruction for this appointment.'
            : 'Ask your physiotherapist a question about this appointment.',
      );
    }
    return ListView(
      controller: _scroll,
      padding: const EdgeInsets.all(HealynSpacing.screenEdge),
      children: _streamChildren(),
    );
  }

  List<Widget> _streamChildren() {
    final children = <Widget>[];
    if (_nextCursor != null) {
      children.add(
        Center(
          child: _loadingOlder
              ? const Padding(
                  padding: EdgeInsets.all(HealynSpacing.s3),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : TextButton(
                  onPressed: _loadOlder,
                  child: const Text('Load earlier messages'),
                ),
        ),
      );
    }
    for (var i = 0; i < _messages.length; i++) {
      final m = _messages[i];
      final prev = i == 0 ? null : _messages[i - 1];
      if (prev == null || !sameLocalDay(prev.createdAt, m.createdAt)) {
        children.add(_DaySeparator(label: daySeparatorLabel(m.createdAt)));
      }
      final isOutgoing = m.senderRole == _mySide;
      Widget bubble = MessageBubble(
        message: m,
        isOutgoing: isOutgoing,
        onOpenAttachment: _openAttachment,
      );
      if (_canModify(m)) {
        bubble = GestureDetector(
          onLongPress: () => _showActions(m),
          child: bubble,
        );
      }
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: HealynSpacing.s3),
          child: bubble,
        ),
      );
    }
    return children;
  }

  Widget _buildComposer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        HealynSpacing.s4,
        HealynSpacing.s2,
        HealynSpacing.s2,
        HealynSpacing.s2,
      ),
      decoration: const BoxDecoration(
        color: HealynColors.surfaceBase,
        border: Border(top: BorderSide(color: HealynColors.borderSubtle)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isPhysio) _buildInstructionToggle(),
          if (_attachments.isNotEmpty || _attaching) _buildAttachmentBar(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: (_attaching || _posting)
                    ? null
                    : _chooseAttachmentSource,
                icon: const Icon(Icons.attach_file),
                color: HealynColors.brandPrimary,
                tooltip: 'Attach',
              ),
              Expanded(
                child: TextField(
                  controller: _composer,
                  minLines: 1,
                  maxLines: 5,
                  maxLength: 2000,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: _isPhysio && _instructionMode
                        ? 'Write an instruction'
                        : 'Write a message',
                    counterText: '',
                    border: const OutlineInputBorder(
                      borderRadius: HealynRadii.brMd,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: HealynSpacing.s3,
                      vertical: HealynSpacing.s2,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: _posting ? null : _send,
                icon: _posting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send_rounded),
                color: HealynColors.brandPrimary,
                tooltip: 'Send',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Physio-only: tag the next message as a prescriptive INSTRUCTION.
  Widget _buildInstructionToggle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(
          left: HealynSpacing.s2,
          bottom: HealynSpacing.s2,
        ),
        child: FilterChip(
          label: const Text('Instruction'),
          avatar: Icon(
            _instructionMode
                ? Icons.assignment_turned_in_outlined
                : Icons.assignment_outlined,
            size: 18,
          ),
          selected: _instructionMode,
          onSelected: _posting
              ? null
              : (v) => setState(() => _instructionMode = v),
          tooltip: 'Send as a prescriptive instruction',
        ),
      ),
    );
  }

  Widget _buildAttachmentBar() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(
          left: HealynSpacing.s2,
          bottom: HealynSpacing.s2,
        ),
        child: Wrap(
          spacing: HealynSpacing.s2,
          runSpacing: HealynSpacing.s2,
          children: [
            for (final f in _attachments)
              InputChip(
                label: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 180),
                  child: Text(
                    f.originalFilename,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                onDeleted: _posting ? null : () => _removeAttachment(f),
              ),
            if (_attaching)
              const Chip(
                avatar: SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                label: Text('Uploading…'),
              ),
          ],
        ),
      ),
    );
  }
}

/// The discussion app-bar title: "Discussion" (tappable → appointment detail)
/// over the human-friendly appointment number (copyable) and, for the physio
/// viewer, the patient's name. Renders on the gradient app bar, so its text is
/// inverse-coloured. Carries no PHI for the patient viewer (just the number).
class _DiscussionHeader extends StatelessWidget {
  const _DiscussionHeader({
    this.appointmentNumber,
    this.patientName,
    required this.onOpenDetail,
  });

  final String? appointmentNumber;
  final String? patientName;
  final VoidCallback onOpenDetail;

  @override
  Widget build(BuildContext context) {
    const inverse = HealynColors.textInverse;
    final hasName = patientName != null && patientName!.isNotEmpty;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onOpenDetail,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Discussion',
                style: HealynTypography.h3.copyWith(color: inverse),
              ),
              const SizedBox(width: 2),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: inverse.withValues(alpha: 0.85),
              ),
            ],
          ),
        ),
        if (appointmentNumber != null || hasName)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (appointmentNumber != null)
                CopyableId(
                  value: appointmentNumber!,
                  color: inverse,
                  style: HealynTypography.caption,
                ),
              if (appointmentNumber != null && hasName)
                Text(
                  '  ·  ',
                  style: HealynTypography.caption.copyWith(color: inverse),
                ),
              if (hasName)
                Flexible(
                  child: Text(
                    patientName!,
                    style: HealynTypography.caption.copyWith(color: inverse),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _DaySeparator extends StatelessWidget {
  const _DaySeparator({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: HealynSpacing.s2),
      child: Center(
        child: Text(label.toUpperCase(), style: HealynTypography.overline),
      ),
    );
  }
}

class _EmptyThread extends StatelessWidget {
  const _EmptyThread({required this.subtitle});

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(HealynSpacing.s7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.forum_outlined,
              size: 40,
              color: HealynColors.textMuted,
            ),
            const SizedBox(height: HealynSpacing.s3),
            const Text(
              'No messages yet',
              style: HealynTypography.h3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: HealynSpacing.s1),
            Text(
              subtitle,
              style: HealynTypography.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(HealynSpacing.s6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ErrorBanner(message: message),
            const SizedBox(height: HealynSpacing.s4),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyNotice extends StatelessWidget {
  const _ReadOnlyNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(HealynSpacing.s4),
      decoration: const BoxDecoration(
        color: HealynColors.surfaceAlt,
        border: Border(top: BorderSide(color: HealynColors.borderSubtle)),
      ),
      child: const Text(
        'This appointment is closed — the discussion is read-only.',
        style: HealynTypography.caption,
        textAlign: TextAlign.center,
      ),
    );
  }
}
