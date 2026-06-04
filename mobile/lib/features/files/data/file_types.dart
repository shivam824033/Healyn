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
    _ => null,
  };
}
