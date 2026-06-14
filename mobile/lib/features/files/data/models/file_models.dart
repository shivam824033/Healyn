import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_models.freezed.dart';
part 'file_models.g.dart';

/// Clinical category of an uploaded file. Wire values are the backend
/// `file_kind` enum names.
enum FileKind {
  @JsonValue('REPORT')
  report,
  @JsonValue('MRI')
  mri,
  @JsonValue('XRAY')
  xray,
  @JsonValue('PRESCRIPTION')
  prescription,
  @JsonValue('EXERCISE_PLAN')
  exercisePlan,
  @JsonValue('OTHER')
  other,
}

/// Lifecycle of a stored file. The patient app only ever attaches a file that
/// reached [available]; the others are server-side states ([pendingUpload]
/// between presign and complete, [quarantined] on a failed content check).
enum FileStatus {
  @JsonValue('PENDING_UPLOAD')
  pendingUpload,
  @JsonValue('AVAILABLE')
  available,
  @JsonValue('QUARANTINED')
  quarantined,
  @JsonValue('DELETED')
  deleted,
}

/// Whether a file is a chat attachment or a document-library upload. Wire values
/// are the backend `file_context` enum; sent as `context` on presign.
abstract final class FileUploadContext {
  static const library = 'LIBRARY';
  static const discussion = 'DISCUSSION';
}

/// Optional client hint for how the file was sourced (backend `upload_source`).
abstract final class FileUploadSource {
  static const camera = 'CAMERA';
  static const gallery = 'GALLERY';
  static const file = 'FILE';
  static const convertedPdf = 'CONVERTED_PDF';
}

/// Body for `POST /files/presign`. [sizeBytes] is the exact byte length the
/// client will PUT — the backend signs it and rejects a mismatch at complete.
/// [appointmentId] is optional: null means a standalone library document.
/// Null [appointmentId]/[context]/[uploadSource] are omitted from the JSON.
@freezed
abstract class PresignRequest with _$PresignRequest {
  const factory PresignRequest({
    required String patientId,
    String? appointmentId,
    required FileKind kind,
    String? context,
    String? uploadSource,
    required String mimeType,
    required int sizeBytes,
    required String originalFilename,
  }) = _PresignRequest;

  factory PresignRequest.fromJson(Map<String, dynamic> json) =>
      _$PresignRequestFromJson(json);
}

/// Who uploaded a library document (the backend `account_role`). Drives the
/// two-section split: [patient] files vs [physiotherapist] files.
enum DocumentUploaderRole {
  @JsonValue('ROLE_ACCOUNT')
  patient,
  @JsonValue('ROLE_PHYSIO')
  physiotherapist,
}

/// The uploader filter for `GET /files`. [query] is the wire value.
enum DocumentUploader {
  patient('PATIENT'),
  physio('PHYSIO');

  const DocumentUploader(this.query);

  final String query;
}

/// One library document for the per-patient listing (the backend `FileDocumentView`).
/// [appointmentNumber] is the human-friendly id of the linked appointment, when any.
/// [originalFilename] is display-only PHI — never log it.
@freezed
abstract class FileDocument with _$FileDocument {
  const factory FileDocument({
    required String id,
    required String patientId,
    required FileKind kind,
    required String mimeType,
    required String originalFilename,
    required int sizeBytes,
    required DocumentUploaderRole uploadedByRole,
    String? appointmentId,
    String? appointmentNumber,
    DateTime? createdAt,
  }) = _FileDocument;

  factory FileDocument.fromJson(Map<String, dynamic> json) =>
      _$FileDocumentFromJson(json);
}

/// A cursor page of library documents (the backend `DocumentPage`). [nextCursor]
/// is null on the last page.
@freezed
abstract class DocumentPage with _$DocumentPage {
  const factory DocumentPage({
    @Default(<FileDocument>[]) List<FileDocument> items,
    String? nextCursor,
  }) = _DocumentPage;

  factory DocumentPage.fromJson(Map<String, dynamic> json) =>
      _$DocumentPageFromJson(json);
}

/// The presigned PUT instruction from `/files/presign`. The client must PUT the
/// bytes to [url] sending exactly [headers] (the storage signs the Content-Type).
@freezed
abstract class UploadTarget with _$UploadTarget {
  const factory UploadTarget({
    required String method,
    required String url,
    @Default(<String, String>{}) Map<String, String> headers,
    required int expiresInSeconds,
  }) = _UploadTarget;

  factory UploadTarget.fromJson(Map<String, dynamic> json) =>
      _$UploadTargetFromJson(json);
}

/// The presigned GET from `GET /files/{id}/download` (the backend `DownloadView`):
/// a short-lived [url] the client opens directly (TTL ≤5 min). Never persist it.
@freezed
abstract class DownloadTarget with _$DownloadTarget {
  const factory DownloadTarget({
    required String url,
    required int expiresInSeconds,
  }) = _DownloadTarget;

  factory DownloadTarget.fromJson(Map<String, dynamic> json) =>
      _$DownloadTargetFromJson(json);
}

/// Response of `POST /files/presign`: the new file's id (referenced by a message
/// via `file_ids` once it is AVAILABLE) plus where to PUT its bytes.
@freezed
abstract class PresignResponse with _$PresignResponse {
  const factory PresignResponse({
    required String fileId,
    required UploadTarget upload,
  }) = _PresignResponse;

  factory PresignResponse.fromJson(Map<String, dynamic> json) =>
      _$PresignResponseFromJson(json);
}

/// Metadata for a stored file (the backend `FileView`). Returned by `complete`;
/// a freshly completed file is [FileStatus.available]. [originalFilename] is
/// display-only and PHI — never log it.
@freezed
abstract class FileObjectView with _$FileObjectView {
  const factory FileObjectView({
    required String id,
    required String patientId,
    required String ownerAccountId,
    required FileKind kind,
    required String mimeType,
    required String originalFilename,
    required int sizeBytes,
    required FileStatus status,
    DateTime? createdAt,
    DateTime? availableAt,
  }) = _FileObjectView;

  factory FileObjectView.fromJson(Map<String, dynamic> json) =>
      _$FileObjectViewFromJson(json);
}
