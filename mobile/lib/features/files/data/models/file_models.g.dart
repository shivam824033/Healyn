// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PresignRequest _$PresignRequestFromJson(Map<String, dynamic> json) =>
    _PresignRequest(
      patientId: json['patient_id'] as String,
      appointmentId: json['appointment_id'] as String,
      kind: $enumDecode(_$FileKindEnumMap, json['kind']),
      mimeType: json['mime_type'] as String,
      sizeBytes: (json['size_bytes'] as num).toInt(),
      originalFilename: json['original_filename'] as String,
    );

Map<String, dynamic> _$PresignRequestToJson(_PresignRequest instance) =>
    <String, dynamic>{
      'patient_id': instance.patientId,
      'appointment_id': instance.appointmentId,
      'kind': _$FileKindEnumMap[instance.kind]!,
      'mime_type': instance.mimeType,
      'size_bytes': instance.sizeBytes,
      'original_filename': instance.originalFilename,
    };

const _$FileKindEnumMap = {
  FileKind.report: 'REPORT',
  FileKind.mri: 'MRI',
  FileKind.xray: 'XRAY',
  FileKind.prescription: 'PRESCRIPTION',
  FileKind.exercisePlan: 'EXERCISE_PLAN',
  FileKind.other: 'OTHER',
};

_UploadTarget _$UploadTargetFromJson(Map<String, dynamic> json) =>
    _UploadTarget(
      method: json['method'] as String,
      url: json['url'] as String,
      headers:
          (json['headers'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      expiresInSeconds: (json['expires_in_seconds'] as num).toInt(),
    );

Map<String, dynamic> _$UploadTargetToJson(_UploadTarget instance) =>
    <String, dynamic>{
      'method': instance.method,
      'url': instance.url,
      'headers': instance.headers,
      'expires_in_seconds': instance.expiresInSeconds,
    };

_DownloadTarget _$DownloadTargetFromJson(Map<String, dynamic> json) =>
    _DownloadTarget(
      url: json['url'] as String,
      expiresInSeconds: (json['expires_in_seconds'] as num).toInt(),
    );

Map<String, dynamic> _$DownloadTargetToJson(_DownloadTarget instance) =>
    <String, dynamic>{
      'url': instance.url,
      'expires_in_seconds': instance.expiresInSeconds,
    };

_PresignResponse _$PresignResponseFromJson(Map<String, dynamic> json) =>
    _PresignResponse(
      fileId: json['file_id'] as String,
      upload: UploadTarget.fromJson(json['upload'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PresignResponseToJson(_PresignResponse instance) =>
    <String, dynamic>{
      'file_id': instance.fileId,
      'upload': instance.upload.toJson(),
    };

_FileObjectView _$FileObjectViewFromJson(Map<String, dynamic> json) =>
    _FileObjectView(
      id: json['id'] as String,
      patientId: json['patient_id'] as String,
      ownerAccountId: json['owner_account_id'] as String,
      kind: $enumDecode(_$FileKindEnumMap, json['kind']),
      mimeType: json['mime_type'] as String,
      originalFilename: json['original_filename'] as String,
      sizeBytes: (json['size_bytes'] as num).toInt(),
      status: $enumDecode(_$FileStatusEnumMap, json['status']),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      availableAt: json['available_at'] == null
          ? null
          : DateTime.parse(json['available_at'] as String),
    );

Map<String, dynamic> _$FileObjectViewToJson(_FileObjectView instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patient_id': instance.patientId,
      'owner_account_id': instance.ownerAccountId,
      'kind': _$FileKindEnumMap[instance.kind]!,
      'mime_type': instance.mimeType,
      'original_filename': instance.originalFilename,
      'size_bytes': instance.sizeBytes,
      'status': _$FileStatusEnumMap[instance.status]!,
      'created_at': ?instance.createdAt?.toIso8601String(),
      'available_at': ?instance.availableAt?.toIso8601String(),
    };

const _$FileStatusEnumMap = {
  FileStatus.pendingUpload: 'PENDING_UPLOAD',
  FileStatus.available: 'AVAILABLE',
  FileStatus.quarantined: 'QUARANTINED',
  FileStatus.deleted: 'DELETED',
};
