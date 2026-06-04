import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_preferences.freezed.dart';
part 'notification_preferences.g.dart';

/// A user-facing push category the account can opt out of. Mirrors the backend
/// `NotificationCategory`; [wireKey] is the snake_case field the API uses in both
/// the GET snapshot and the partial PATCH body (API_STANDARDS §9.8).
enum NotificationCategory {
  appointmentUpdates('appointment_updates'),
  appointmentReminders('appointment_reminders'),
  messages('messages'),
  treatmentNotes('treatment_notes');

  const NotificationCategory(this.wireKey);

  final String wireKey;
}

/// The account's push opt-outs. Mirrors the backend `PreferencesView`: every
/// category is present and `true` means "send me this". The default is opted-in
/// to everything, so [NotificationPreferences.allEnabled] is a safe placeholder
/// while the real snapshot loads.
@freezed
abstract class NotificationPreferences with _$NotificationPreferences {
  const NotificationPreferences._();

  const factory NotificationPreferences({
    @Default(true) bool appointmentUpdates,
    @Default(true) bool appointmentReminders,
    @Default(true) bool messages,
    @Default(true) bool treatmentNotes,
  }) = _NotificationPreferences;

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);

  static const allEnabled = NotificationPreferences();

  bool enabled(NotificationCategory category) => switch (category) {
        NotificationCategory.appointmentUpdates => appointmentUpdates,
        NotificationCategory.appointmentReminders => appointmentReminders,
        NotificationCategory.messages => messages,
        NotificationCategory.treatmentNotes => treatmentNotes,
      };

  NotificationPreferences withCategory(NotificationCategory category, bool value) =>
      switch (category) {
        NotificationCategory.appointmentUpdates =>
          copyWith(appointmentUpdates: value),
        NotificationCategory.appointmentReminders =>
          copyWith(appointmentReminders: value),
        NotificationCategory.messages => copyWith(messages: value),
        NotificationCategory.treatmentNotes => copyWith(treatmentNotes: value),
      };
}
