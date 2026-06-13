import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/healyn_section_header.dart';
import '../../data/file_picker_service.dart';
import '../../data/file_types.dart';
import '../../data/files_repository.dart';
import '../../data/models/file_models.dart';
import '../documents_format.dart';
import 'document_preview_screen.dart';
import 'document_upload_screen.dart';

/// Which side is viewing a patient's document library. Both see the same two
/// sections; the difference is delete rights — the patient side cannot delete a
/// physiotherapist-uploaded document (mirrors the server rule).
enum DocumentsViewer { patient, physio }

/// A patient's medical document library (F1.15 extension). Two never-mixed
/// sections — documents uploaded by the physiotherapist and by the patient —
/// each cursor-paginated independently. Upload via the FAB (PDF from storage, or
/// photos that merge into one PDF); tap a document to preview it in-app.
class PatientDocumentsScreen extends ConsumerStatefulWidget {
  const PatientDocumentsScreen({
    required this.patientId,
    this.patientName,
    this.viewer = DocumentsViewer.patient,
    super.key,
  });

  final String patientId;
  final String? patientName;
  final DocumentsViewer viewer;

  @override
  ConsumerState<PatientDocumentsScreen> createState() =>
      _PatientDocumentsScreenState();
}

/// Mutable paging state for one section.
class _Section {
  _Section(this.uploader);

  final DocumentUploader uploader;
  final List<FileDocument> items = [];
  String? cursor;
  bool loading = false;
  bool loadedOnce = false;
  String? error;
}

class _PatientDocumentsScreenState
    extends ConsumerState<PatientDocumentsScreen> {
  late final _Section _physio = _Section(DocumentUploader.physio);
  late final _Section _patient = _Section(DocumentUploader.patient);

  bool get _isPhysioViewer => widget.viewer == DocumentsViewer.physio;

  @override
  void initState() {
    super.initState();
    _loadSection(_physio, reset: true);
    _loadSection(_patient, reset: true);
  }

  Future<void> _loadSection(_Section s, {bool reset = false}) async {
    if (s.loading) return;
    setState(() {
      s.loading = true;
      s.error = null;
      if (reset) {
        s.items.clear();
        s.cursor = null;
        s.loadedOnce = false;
      }
    });
    try {
      final page = await ref
          .read(filesRepositoryProvider)
          .listDocuments(
            patientId: widget.patientId,
            uploader: s.uploader,
            cursor: reset ? null : s.cursor,
          );
      if (!mounted) return;
      setState(() {
        s.items.addAll(page.items);
        s.cursor = page.nextCursor;
        s.loading = false;
        s.loadedOnce = true;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        s.loading = false;
        s.loadedOnce = true;
        s.error = e.message;
      });
    }
  }

  Future<void> _refreshAll() async {
    await Future.wait([
      _loadSection(_physio, reset: true),
      _loadSection(_patient, reset: true),
    ]);
  }

  void _addDocument() {
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
                _pickFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose photos'),
              subtitle: const Text('Multiple photos merge into one PDF'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImages();
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_outlined),
              title: const Text('Choose PDF'),
              onTap: () {
                Navigator.pop(ctx);
                _pickFile();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    final picked = await _safePick(() => ref
        .read(filePickerServiceProvider)
        .pick(PickSource.camera));
    if (picked == null) return;
    await _openUpload(
      DocumentUploadScreen.images(
        patientId: widget.patientId,
        images: [picked],
        source: FileUploadSource.camera,
      ),
    );
  }

  Future<void> _pickImages() async {
    final picked = await _safePickList(
      () => ref.read(filePickerServiceProvider).pickImages(),
    );
    if (picked == null || picked.isEmpty) return;
    await _openUpload(
      DocumentUploadScreen.images(
        patientId: widget.patientId,
        images: picked,
        source: FileUploadSource.gallery,
      ),
    );
  }

  Future<void> _pickFile() async {
    final picked = await _safePick(
      () => ref.read(filePickerServiceProvider).pick(PickSource.file),
    );
    if (picked == null) return;
    final type = uploadTypeForFilename(picked.filename);
    if (type == null) {
      _toast('Only PDF, JPG, and PNG files are supported.');
      return;
    }
    await _openUpload(
      type.mimeType == 'application/pdf'
          ? DocumentUploadScreen.pdf(
              patientId: widget.patientId,
              file: picked,
              source: FileUploadSource.file,
            )
          : DocumentUploadScreen.images(
              patientId: widget.patientId,
              images: [picked],
              source: FileUploadSource.file,
            ),
    );
  }

  Future<void> _openUpload(Widget screen) async {
    final uploaded = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => screen),
    );
    if (uploaded == true) {
      _toast('Document uploaded.');
      await _refreshAll();
    }
  }

  Future<PickedFile?> _safePick(Future<PickedFile?> Function() body) async {
    try {
      return await body();
    } catch (_) {
      _toast("Couldn't open the picker.");
      return null;
    }
  }

  Future<List<PickedFile>?> _safePickList(
    Future<List<PickedFile>> Function() body,
  ) async {
    try {
      return await body();
    } catch (_) {
      _toast("Couldn't open the picker.");
      return null;
    }
  }

  void _openPreview(FileDocument doc) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => DocumentPreviewScreen(
          fileId: doc.id,
          filename: doc.originalFilename,
          mimeType: doc.mimeType,
        ),
      ),
    );
  }

  bool _canDelete(FileDocument doc) =>
      _isPhysioViewer || doc.uploadedByRole == DocumentUploaderRole.patient;

  Future<void> _deleteDocument(FileDocument doc) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete document?'),
        content: const Text('This removes the document from the patient record.'),
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
    if (confirmed != true) return;
    try {
      await ref.read(filesRepositoryProvider).delete(doc.id);
      await _refreshAll();
    } on ApiException catch (e) {
      if (mounted) _toast(e.message);
    }
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: const HealynAppBar(title: 'Documents'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addDocument,
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshAll,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              HealynSpacing.screenEdge,
              HealynSpacing.screenEdge,
              HealynSpacing.screenEdge,
              HealynSpacing.s10,
            ),
            children: [
              if (widget.patientName != null) ...[
                Text(widget.patientName!, style: HealynTypography.h3),
                const SizedBox(height: HealynSpacing.s5),
              ],
              _sectionView(
                title: 'Uploaded by physiotherapist',
                section: _physio,
                emptyText: 'No documents from your physiotherapist yet.',
              ),
              const SizedBox(height: HealynSpacing.s7),
              _sectionView(
                title: _isPhysioViewer
                    ? 'Uploaded by patient'
                    : 'Uploaded by you',
                section: _patient,
                emptyText: 'No documents uploaded yet.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionView({
    required String title,
    required _Section section,
    required String emptyText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HealynSectionHeader(
          title: title,
          countLabel: section.loadedOnce && section.items.isNotEmpty
              ? '${section.items.length}'
              : null,
        ),
        const SizedBox(height: HealynSpacing.s3),
        if (!section.loadedOnce && section.loading)
          const Padding(
            padding: EdgeInsets.all(HealynSpacing.s5),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (section.error != null)
          ErrorBanner(message: section.error!)
        else if (section.items.isEmpty)
          _EmptySection(text: emptyText)
        else ...[
          for (final doc in section.items) ...[
            _DocumentCard(
              doc: doc,
              onTap: () => _openPreview(doc),
              onDelete: _canDelete(doc) ? () => _deleteDocument(doc) : null,
            ),
            const SizedBox(height: HealynSpacing.s3),
          ],
          if (section.cursor != null)
            Align(
              child: section.loading
                  ? const Padding(
                      padding: EdgeInsets.all(HealynSpacing.s3),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : TextButton(
                      onPressed: () => _loadSection(section),
                      child: const Text('Load more'),
                    ),
            ),
        ],
      ],
    );
  }
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({required this.doc, required this.onTap, this.onDelete});

  final FileDocument doc;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isPdf = isPdfMime(doc.mimeType);
    final created = doc.createdAt;
    final meta = [
      if (created != null) formatDocumentDate(created),
      documentFileTypeLabel(doc.mimeType),
    ].join(' · ');

    return Container(
      decoration: BoxDecoration(
        color: HealynColors.surfaceBase,
        borderRadius: HealynRadii.brLg,
        border: Border.all(color: HealynColors.borderSubtle),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: HealynRadii.brLg,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(HealynSpacing.s4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isPdf
                      ? Icons.picture_as_pdf_outlined
                      : Icons.image_outlined,
                  size: 28,
                  color: HealynColors.brandPrimary,
                ),
                const SizedBox(width: HealynSpacing.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.originalFilename,
                        style: HealynTypography.bodyStrong,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: HealynSpacing.s1),
                      Text(
                        'Uploaded by ${uploaderRoleLabel(doc.uploadedByRole)}',
                        style: HealynTypography.caption.copyWith(
                          color: HealynColors.textMuted,
                        ),
                      ),
                      Text(meta, style: HealynTypography.caption),
                      if (doc.appointmentNumber != null) ...[
                        const SizedBox(height: HealynSpacing.s2),
                        _AppointmentChip(number: doc.appointmentNumber!),
                      ],
                    ],
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    tooltip: 'Delete',
                    icon: const Icon(Icons.delete_outline),
                    color: HealynColors.textMuted,
                    onPressed: onDelete,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppointmentChip extends StatelessWidget {
  const _AppointmentChip({required this.number});

  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HealynSpacing.s2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: HealynColors.brandPrimarySubtle,
        borderRadius: BorderRadius.circular(HealynRadii.full),
      ),
      child: Text(
        number,
        style: HealynTypography.caption.copyWith(
          color: HealynColors.brandPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(HealynSpacing.s5),
      decoration: BoxDecoration(
        color: HealynColors.surfaceBase,
        borderRadius: HealynRadii.brLg,
        border: Border.all(color: HealynColors.borderSubtle),
      ),
      child: Text(
        text,
        style: HealynTypography.caption.copyWith(
          color: HealynColors.textMuted,
        ),
      ),
    );
  }
}
