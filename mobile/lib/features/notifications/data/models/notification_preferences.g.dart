// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationPreferences _$NotificationPreferencesFromJson(
  Map<String, dynamic> json,
) => _NotificationPreferences(
  appointmentUpdates: json['appointment_updates'] as bool? ?? true,
  appointmentReminders: json['appointment_reminders'] as bool? ?? true,
  messages: json['messages'] as bool? ?? true,
  treatmentNotes: json['treatment_notes'] as bool? ?? true,
);

Map<String, dynamic> _$NotificationPreferencesToJson(
  _NotificationPreferences instance,
) => <String, dynamic>{
  'appointment_updates': instance.appointmentUpdates,
  'appointment_reminders': instance.appointmentReminders,
  'messages': instance.messages,
  'treatment_notes': instance.treatmentNotes,
};
