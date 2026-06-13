import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// A file the user picked, held in memory. [filename] is display-only and feeds
/// extension/type detection; [bytes] are PUT straight to storage.
class PickedFile {
  const PickedFile({required this.bytes, required this.filename});

  final List<int> bytes;
  final String filename;
}

/// Where an attachment comes from. [camera]/[gallery] go through image_picker
/// (photos); [file] goes through file_picker (PDFs, also images from storage).
enum PickSource { camera, gallery, file }

/// Seam over the platform pickers so the composer stays unit-testable — no
/// plugins or platform channels run in tests, which inject a fake instead.
abstract interface class FilePickerService {
  /// Returns the picked file, or `null` if the user cancelled.
  Future<PickedFile?> pick(PickSource source);

  /// Picks one or more images from the gallery (multi-select). Returns an empty
  /// list if the user cancelled. Used by the document library's "Choose photos"
  /// flow, where two or more images are merged into a single PDF.
  Future<List<PickedFile>> pickImages();
}

/// Real implementation backed by image_picker + file_picker.
class PluginFilePickerService implements FilePickerService {
  PluginFilePickerService([ImagePicker? imagePicker])
    : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  @override
  Future<PickedFile?> pick(PickSource source) async {
    switch (source) {
      case PickSource.camera:
        return _fromImage(ImageSource.camera);
      case PickSource.gallery:
        return _fromImage(ImageSource.gallery);
      case PickSource.file:
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
          withData: true,
        );
        final files = result?.files ?? const [];
        if (files.isEmpty) return null;
        final bytes = files.first.bytes;
        if (bytes == null) return null;
        return PickedFile(bytes: bytes, filename: files.first.name);
    }
  }

  @override
  Future<List<PickedFile>> pickImages() async {
    // Downscale at the source so several photos merge into a PDF that stays under
    // the 20 MB cap, while keeping scanned text legible.
    final picked = await _imagePicker.pickMultiImage(
      maxWidth: 2400,
      imageQuality: 85,
    );
    final files = <PickedFile>[];
    for (final image in picked) {
      files.add(PickedFile(bytes: await image.readAsBytes(), filename: image.name));
    }
    return files;
  }

  Future<PickedFile?> _fromImage(ImageSource source) async {
    final picked = await _imagePicker.pickImage(source: source);
    if (picked == null) return null;
    return PickedFile(bytes: await picked.readAsBytes(), filename: picked.name);
  }
}

final filePickerServiceProvider = Provider<FilePickerService>(
  (ref) => PluginFilePickerService(),
);
