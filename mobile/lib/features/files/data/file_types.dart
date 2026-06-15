/// The Phase 1 accepted attachment types and their per-type size caps, mirroring
/// the backend `FileMime` whitelist (FILE_STORAGE_GUIDELINES §1). A type that is
/// not in this set is rejected client-side before a presign is even requested.
class UploadType {
  const UploadType({required this.mimeType, required this.maxBytes});

  final String mimeType;
  final int maxBytes;
}

const _pdf = UploadType(mimeType: 'application/pdf', maxBytes: 20 * 1024 * 1024);
const _jpeg = UploadType(mimeType: 'image/jpeg', maxBytes: 10 * 1024 * 1024);
const _png = UploadType(mimeType: 'image/png', maxBytes: 10 * 1024 * 1024);
const _webp = UploadType(mimeType: 'image/webp', maxBytes: 10 * 1024 * 1024);

/// Resolves a filename's extension to an accepted [UploadType], or `null` when
/// the type is not allowed in Phase 1 (no `.docx`, `.heic`, `.zip`, …). The
/// extension only picks the candidate; the server still magic-byte verifies the
/// bytes at complete.
UploadType? uploadTypeForFilename(String filename) {
  final dot = filename.lastIndexOf('.');
  if (dot < 0 || dot == filename.length - 1) return null;
  return switch (filename.substring(dot + 1).toLowerCase()) {
    'pdf' => _pdf,
    'jpg' || 'jpeg' => _jpeg,
    'png' => _png,
    'webp' => _webp,
    _ => null,
  };
}

/// The most images merged into a single PDF in one upload. Bounds the combined
/// document under the 20 MB PDF cap and keeps the in-memory conversion responsive.
const maxImagesPerUpload = 20;

/// True when [bytes] start with the PDF signature `%PDF-`. The picker only reads
/// the filename extension; this is the byte-level check that catches a mislabelled
/// or empty file client-side before a presign — the server magic-byte verifies
/// again at complete (never trust the extension alone).
bool hasPdfMagic(List<int> bytes) {
  const magic = [0x25, 0x50, 0x44, 0x46, 0x2D]; // "%PDF-"
  if (bytes.length < magic.length) return false;
  for (var i = 0; i < magic.length; i++) {
    if (bytes[i] != magic[i]) return false;
  }
  return true;
}
