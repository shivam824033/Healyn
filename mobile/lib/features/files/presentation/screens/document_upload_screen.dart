import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/section_card.dart';
import '../../data/file_picker_service.dart';
import '../../data/file_types.dart';
import '../../data/files_repository.dart';
import '../../data/image_to_pdf.dart';
import '../../data/models/file_models.dart';
import '../documents_format.dart';

/// Confirms and performs a document upload. Two modes:
/// - [DocumentUploadScreen.images]: one or more gallery/camera images. A single
///   image is uploaded as-is; two or more are merged into one PDF.
/// - [DocumentUploadScreen.pdf]: a PDF chosen from device storage, uploaded as-is.
///
/// Lets the user pick a clinical [FileKind] (default Report), previews the
/// selection, then uploads with a progress indicator. Pops `true` on success so
/// the caller refetches.
class DocumentUploadScreen extends ConsumerStatefulWidget {
  const DocumentUploadScreen.images({
    required this.patientId,
    required this.images,
    required this.source,
    super.key,
  }) : pdf = null;

  const DocumentUploadScreen.pdf({
    required this.patientId,
    required PickedFile file,
    required this.source,
    super.key,
  }) : pdf = file,
       images = null;

  final String patientId;
  final List<PickedFile>? images;
  final PickedFile? pdf;
  final String source;

  @override
  ConsumerState<DocumentUploadScreen> createState() =>
      _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends ConsumerState<DocumentUploadScreen> {
  static const _maxPdfBytes = 20 * 1024 * 1024;

  FileKind _kind = FileKind.report;
  bool _uploading = false;
  String? _error;

  bool get _isPdf => widget.pdf != null;
  bool get _willConvert => widget.images != null && widget.images!.length > 1;

  Future<void> _upload() async {
    setState(() {
      _uploading = true;
      _error = null;
    });
    try {
      final repo = ref.read(filesRepositoryProvider);
      if (_isPdf) {
        await _uploadPdf(repo);
      } else if (widget.images!.length == 1) {
        await _uploadSingleImage(repo, widget.images!.first);
      } else {
        await _uploadImagesAsPdf(repo);
      }
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _uploading = false;
          _error = e.message;
        });
      }
    }
  }

  Future<void> _uploadPdf(FilesRepository repo) async {
    final file = widget.pdf!;
    final type = uploadTypeForFilename(file.filename);
    if (type == null || type.mimeType != 'application/pdf') {
      _fail('That file is not a supported PDF.');
      return;
    }
    if (file.bytes.length > type.maxBytes) {
      _fail('That PDF is too large (max 20 MB).');
      return;
    }
    await repo.upload(
      patientId: widget.patientId,
      kind: _kind,
      mimeType: type.mimeType,
      originalFilename: file.filename,
      bytes: file.bytes,
      uploadSource: widget.source,
    );
  }

  Future<void> _uploadSingleImage(FilesRepository repo, PickedFile image) async {
    final type = uploadTypeForFilename(image.filename);
    // Picked images are JPEG/PNG; an unrecognised name (some galleries) is a JPEG.
    final mime = (type != null && type.mimeType != 'application/pdf')
        ? type.mimeType
        : 'image/jpeg';
    if (image.bytes.length > 10 * 1024 * 1024) {
      _fail('That image is too large (max 10 MB).');
      return;
    }
    await repo.upload(
      patientId: widget.patientId,
      kind: _kind,
      mimeType: mime,
      originalFilename: image.filename,
      bytes: image.bytes,
      uploadSource: widget.source,
    );
  }

  Future<void> _uploadImagesAsPdf(FilesRepository repo) async {
    final bytes = await imagesToPdf(widget.images!);
    if (bytes.length > _maxPdfBytes) {
      _fail('The combined PDF is too large. Try selecting fewer images.');
      return;
    }
    await repo.upload(
      patientId: widget.patientId,
      kind: _kind,
      mimeType: 'application/pdf',
      originalFilename: _generatedPdfName(),
      bytes: bytes,
      uploadSource: FileUploadSource.convertedPdf,
    );
  }

  void _fail(String message) {
    if (mounted) {
      setState(() {
        _uploading = false;
        _error = message;
      });
    }
  }

  String _generatedPdfName() {
    final now = DateTime.now();
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return 'document-${now.year}-$m-$d.pdf';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: const HealynAppBar(title: 'Upload document'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(HealynSpacing.screenEdge),
          children: [
            _preview(),
            const SizedBox(height: HealynSpacing.s6),
            const Text('Category', style: HealynTypography.caption),
            const SizedBox(height: HealynSpacing.s2),
            _kindDropdown(),
            if (_error != null) ...[
              const SizedBox(height: HealynSpacing.s5),
              ErrorBanner(message: _error!),
            ],
            const SizedBox(height: HealynSpacing.s7),
            FilledButton.icon(
              onPressed: _uploading ? null : _upload,
              icon: _uploading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: HealynColors.textInverse,
                      ),
                    )
                  : const Icon(Icons.cloud_upload_outlined),
              label: Text(_uploading ? 'Uploading…' : 'Upload'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kindDropdown() {
    return SectionCard(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<FileKind>(
          value: _kind,
          isExpanded: true,
          onChanged: _uploading
              ? null
              : (v) => setState(() => _kind = v ?? FileKind.report),
          items: [
            for (final k in FileKind.values)
              DropdownMenuItem(value: k, child: Text(fileKindLabel(k))),
          ],
        ),
      ),
    );
  }

  Widget _preview() {
    if (_isPdf) {
      return SectionCard(
        child: Row(
          children: [
            const Icon(
              Icons.picture_as_pdf_outlined,
              size: 32,
              color: HealynColors.brandPrimary,
            ),
            const SizedBox(width: HealynSpacing.s3),
            Expanded(
              child: Text(
                widget.pdf!.filename,
                style: HealynTypography.body,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }
    final images = widget.images!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selected images (${images.length})',
          style: HealynTypography.bodyStrong,
        ),
        const SizedBox(height: HealynSpacing.s1),
        Text(
          _willConvert
              ? 'These will be combined into a single PDF.'
              : 'Uploaded as a single image.',
          style: HealynTypography.caption.copyWith(
            color: HealynColors.textMuted,
          ),
        ),
        const SizedBox(height: HealynSpacing.s3),
        Wrap(
          spacing: HealynSpacing.s3,
          runSpacing: HealynSpacing.s3,
          children: [
            for (var i = 0; i < images.length; i++)
              _Thumb(index: i + 1, bytes: images[i].bytes),
          ],
        ),
      ],
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.index, required this.bytes});

  final int index;
  final List<int> bytes;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: HealynRadii.brMd,
      child: Stack(
        children: [
          Image.memory(
            Uint8List.fromList(bytes),
            width: 96,
            height: 96,
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 4,
            top: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(HealynRadii.full),
              ),
              child: Text(
                '$index',
                style: HealynTypography.caption.copyWith(
                  color: HealynColors.textInverse,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
