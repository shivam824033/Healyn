import '../data/models/file_models.dart';

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// "13 Jun 2026" in the device's local timezone (timestamps are UTC on the wire).
String formatDocumentDate(DateTime when) {
  final local = when.toLocal();
  return '${local.day} ${_months[local.month - 1]} ${local.year}';
}

/// Short file-type label for a document card ("PDF" / "JPG" / "PNG").
String documentFileTypeLabel(String mimeType) => switch (mimeType) {
  'application/pdf' => 'PDF',
  'image/jpeg' => 'JPG',
  'image/png' => 'PNG',
  _ => 'File',
};

bool isPdfMime(String mimeType) => mimeType == 'application/pdf';

/// Human label for who uploaded a document (drives the "Uploaded by" line).
String uploaderRoleLabel(DocumentUploaderRole role) => switch (role) {
  DocumentUploaderRole.physiotherapist => 'Physiotherapist',
  DocumentUploaderRole.patient => 'Patient',
};

/// Display label for a clinical document category.
String fileKindLabel(FileKind kind) => switch (kind) {
  FileKind.report => 'Report',
  FileKind.mri => 'MRI',
  FileKind.xray => 'X-ray',
  FileKind.prescription => 'Prescription',
  FileKind.exercisePlan => 'Exercise plan',
  FileKind.other => 'Other',
};
