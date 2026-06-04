import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/notifications/data/models/notification_preferences.dart';

void main() {
  test('parses the snake_case snapshot into category booleans', () {
    final prefs = NotificationPreferences.fromJson({
      'appointment_updates': true,
      'appointment_reminders': false,
      'messages': true,
      'treatment_notes': false,
    });

    expect(prefs.appointmentUpdates, isTrue);
    expect(prefs.appointmentReminders, isFalse);
    expect(prefs.messages, isTrue);
    expect(prefs.treatmentNotes, isFalse);
  });

  test('allEnabled defaults every category on', () {
    const prefs = NotificationPreferences.allEnabled;
    for (final c in NotificationCategory.values) {
      expect(prefs.enabled(c), isTrue, reason: c.name);
    }
  });

  test('enabled maps each category to its field', () {
    const prefs = NotificationPreferences(
      appointmentUpdates: false,
      appointmentReminders: true,
      messages: false,
      treatmentNotes: true,
    );

    expect(prefs.enabled(NotificationCategory.appointmentUpdates), isFalse);
    expect(prefs.enabled(NotificationCategory.appointmentReminders), isTrue);
    expect(prefs.enabled(NotificationCategory.messages), isFalse);
    expect(prefs.enabled(NotificationCategory.treatmentNotes), isTrue);
  });

  test('withCategory flips only the named category', () {
    const prefs = NotificationPreferences.allEnabled;

    final flipped = prefs.withCategory(NotificationCategory.messages, false);

    expect(flipped.messages, isFalse);
    expect(flipped.appointmentUpdates, isTrue);
    expect(flipped.appointmentReminders, isTrue);
    expect(flipped.treatmentNotes, isTrue);
  });

  test('each category exposes its wire key', () {
    expect(NotificationCategory.appointmentUpdates.wireKey, 'appointment_updates');
    expect(NotificationCategory.appointmentReminders.wireKey, 'appointment_reminders');
    expect(NotificationCategory.messages.wireKey, 'messages');
    expect(NotificationCategory.treatmentNotes.wireKey, 'treatment_notes');
  });
}
