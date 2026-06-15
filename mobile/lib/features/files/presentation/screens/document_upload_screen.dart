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
  static const _maxImageBytes = 10 * 1024 * 1024;

  FileKind _kind = FileKind.report;
  bool _uploading = false;
  String? _error;

  /// Mutable copy of the picked images so the user can drop ones they don't want.
  late final List<PickedFile> _images = [...?widget.images];
  late final TextEditingController _nameController;

  bool get _isPdf => widget.pdf != null;
  bool get _willConvert => !_isPdf && _images.length > 1;

  @override
  void initState() {
    super.initState();
    // Bound the set so the merged PDF stays under the cap and conversion stays
    // responsive; an over-large selection is trimmed rather than silently lost.
    if (_images.length > maxImagesPerUpload) {
      _images.removeRange(maxImagesPerUpload, _images.length);
      _error =
          'Only the first $maxImagesPerUpload images were kept (limit per document).';
    }
    _nameController = TextEditingController(text: _defaultNameStem());
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// The fixed extension for the upload, derived from the source. The user edits
  /// only the stem; the extension is enforced so server-side validation holds.
  String _extension() {
    if (_isPdf || _willConvert) return '.pdf';
    return _imageExtension(_images.first.filename);
  }

  String _imageExtension(String filename) {
    final lower = filename.toLowerCase();
    if (lower.endsWith('.png')) return '.png';
    return '.jpg';
  }

  String _defaultNameStem() {
    if (_isPdf) return _stripExtension(widget.pdf!.filename);
    if (widget.images!.length == 1) {
      return _stripExtension(widget.images!.first.filename);
    }
    return _stripExtension(_generatedPdfName());
  }

  String _stripExtension(String filename) {
    final dot = filename.lastIndexOf('.');
    return dot > 0 ? filename.substring(0, dot) : filename;
  }

  /// The trimmed user-entered name plus the enforced extension, falling back to
  /// the generated default when the field is left empty.
  String _resolvedFilename() {
    final stem = _nameController.text.trim();
    final base = stem.isEmpty ? _defaultNameStem() : stem;
    return '$base${_extension()}';
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
    if (_images.isEmpty && mounted) Navigator.pop(context, false);
  }

  Future<void> _addMore() async {
    if (_images.length >= maxImagesPerUpload) {
      setState(() => _error =
          'You can add up to $maxImagesPerUpload images per document.');
      return;
    }
    final source = await showModalBottomSheet<PickSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(ctx, PickSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(ctx, PickSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final service = ref.read(filePickerServiceProvider);
    try {
      final added = source == PickSource.camera
          ? [?await service.pick(PickSource.camera)]
          : await service.pickImages();
      if (added.isEmpty || !mounted) return;
      // Keep only what fits under the cap; tell the user if some were dropped.
      final room = maxImagesPerUpload - _images.length;
      final kept = added.length > room ? added.sublist(0, room) : added;
      setState(() {
        _images.addAll(kept);
        _error = kept.length < added.length
            ? 'Added $room of ${added.length}; the limit is $maxImagesPerUpload images.'
            : null;
      });
    } catch (_) {
      if (mounted) setState(() => _error = "Couldn't open the picker.");
    }
  }

  Future<void> _upload() async {
    setState(() {
      _uploading = true;
      _error = null;
    });
    try {
      final repo = ref.read(filesRepositoryProvider);
      if (_isPdf) {
        await _uploadPdf(repo);
      } else if (_images.length == 1) {
        await _uploadSingleImage(repo, _images.first);
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
    // Verify the bytes actually are a PDF, not just a .pdf name on an empty or
    // damaged file — the extension alone is not trusted (server re-checks too).
    if (file.bytes.isEmpty || !hasPdfMagic(file.bytes)) {
      _fail("That PDF appears to be empty or damaged and can't be uploaded.");
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
      originalFilename: _resolvedFilename(),
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
    if (image.bytes.length > _maxImageBytes) {
      _fail('That image is too large (max 10 MB).');
      return;
    }
    await repo.upload(
      patientId: widget.patientId,
      kind: _kind,
      mimeType: mime,
      originalFilename: _resolvedFilename(),
      bytes: image.bytes,
      uploadSource: widget.source,
    );
  }

  Future<void> _uploadImagesAsPdf(FilesRepository repo) async {
    for (final image in _images) {
      if (image.bytes.length > _maxImageBytes) {
        _fail('One image is too large (max 10 MB each). Remove it and try again.');
        return;
      }
    }
    // Runs on a background isolate so a large multi-image merge doesn't freeze
    // the UI; the Upload button already shows its progress spinner meanwhile.
    final bytes = await imagesToPdfInBackground(_images);
    if (bytes.length > _maxPdfBytes) {
      _fail('The combined PDF is too large. Try selecting fewer images.');
      return;
    }
    await repo.upload(
      patientId: widget.patientId,
      kind: _kind,
      mimeType: 'application/pdf',
      originalFilename: _resolvedFilename(),
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
            const Text('File name', style: HealynTypography.caption),
            const SizedBox(height: HealynSpacing.s2),
            _nameField(),
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

  Widget _nameField() {
    return TextField(
      controller: _nameController,
      enabled: !_uploading,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: 'e.g. Blood test results',
        suffixText: _extension(),
        border: const OutlineInputBorder(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selected images (${_images.length})',
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
            for (var i = 0; i < _images.length; i++)
              _Thumb(
                index: i + 1,
                bytes: _images[i].bytes,
                onRemove: _uploading ? null : () => _removeImage(i),
              ),
            _AddTile(onTap: _uploading ? null : _addMore),
          ],
        ),
      ],
    );
  }
}

class _AddTile extends StatelessWidget {
  const _AddTile({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: HealynRadii.brMd,
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          borderRadius: HealynRadii.brMd,
          border: Border.all(color: HealynColors.borderSubtle),
          color: HealynColors.surfaceBase,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_a_photo_outlined, color: HealynColors.textMuted),
            const SizedBox(height: HealynSpacing.s1),
            Text(
              'Add',
              style: HealynTypography.caption.copyWith(
                color: HealynColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.index, required this.bytes, this.onRemove});

  final int index;
  final List<int> bytes;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
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
        ),
        if (onRemove != null)
          Positioned(
            right: -8,
            top: -8,
            child: Material(
              color: Colors.black.withValues(alpha: 0.65),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onRemove,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: HealynColors.textInverse,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
