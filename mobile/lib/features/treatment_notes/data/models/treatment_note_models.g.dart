// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treatment_note_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TreatmentNote _$TreatmentNoteFromJson(Map<String, dynamic> json) =>
    _TreatmentNote(
      id: json['id'] as String,
      appointmentId: json['appointment_id'] as String,
      patientId: json['patient_id'] as String,
      authorAccountId: json['author_account_id'] as String,
      diagnosis: json['diagnosis'] as String?,
      notes: json['notes'] as String?,
      recoveryInstructions: json['recovery_instructions'] as String?,
      nextReviewAt: json['next_review_at'] == null
          ? null
          : DateTime.parse(json['next_review_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$TreatmentNoteToJson(_TreatmentNote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'appointment_id': instance.appointmentId,
      'patient_id': instance.patientId,
      'author_account_id': instance.authorAccountId,
      'diagnosis': ?instance.diagnosis,
      'notes': ?instance.notes,
      'recovery_instructions': ?instance.recoveryInstructions,
      'next_review_at': ?instance.nextReviewAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
