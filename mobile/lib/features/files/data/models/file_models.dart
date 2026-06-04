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

/// Body for `POST /files/presign`. [sizeBytes] is the exact byte length the
/// client will PUT — the backend signs it and rejects a mismatch at complete.
@freezed
abstract class PresignRequest with _$PresignRequest {
  const factory PresignRequest({
    required String patientId,
    required String appointmentId,
    required FileKind kind,
    required String mimeType,
    required int sizeBytes,
    required String originalFilename,
  }) = _PresignRequest;

  factory PresignRequest.fromJson(Map<String, dynamic> json) =>
      _$PresignRequestFromJson(json);
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
