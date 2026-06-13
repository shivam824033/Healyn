import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/shared/push/local_notifications.dart';

void main() {
  group('notificationContent', () {
    test('uses the appointment number as the body when present', () {
      expect(
        notificationContent({
          'kind': 'BOOKING_REQUESTED',
          'appointmentId': 'ap1',
          'appointmentNumber': 'PHY-20260613-1001',
        }),
        ('New appointment request', 'PHY-20260613-1001'),
      );
      expect(
        notificationContent({
          'kind': 'BOOKING_CANCELLED',
          'appointmentNumber': 'PHY-20260613-1001',
        }),
        ('Appointment cancelled', 'PHY-20260613-1001'),
      );
    });

    test('prefixes the number for a new discussion message', () {
      expect(
        notificationContent({
          'kind': 'DISCUSSION_NEW_MESSAGE',
          'appointmentId': 'ap1',
          'messageId': 'm1',
          'appointmentNumber': 'PHY-20260613-1001',
        }),
        ('New message', 'In PHY-20260613-1001'),
      );
    });

    test('falls back to generic text when the number is absent or blank', () {
      expect(
        notificationContent({'kind': 'BOOKING_CONFIRMED'}),
        ('Appointment confirmed', 'Your appointment has been confirmed.'),
      );
      expect(
        notificationContent({'kind': 'DISCUSSION_NEW_MESSAGE', 'appointmentNumber': ''}),
        ('New message', 'You have a new message.'),
      );
    });

    test('never leaks a name or body — only kind + number drive the text', () {
      // Even if some rogue key were present, the mapper ignores everything but
      // kind and appointmentNumber.
      final (title, body) = notificationContent({
        'kind': 'DISCUSSION_NEW_MESSAGE',
        'appointmentNumber': 'PHY-1',
        'body': 'secret clinical text',
        'patientName': 'John Doe',
      });
      expect(title, 'New message');
      expect(body, 'In PHY-1');
    });

    test('unknown kind falls back to the app name', () {
      expect(
        notificationContent({'kind': 'WHATEVER'}),
        ('Healyn', 'You have a new notification.'),
      );
      expect(
        notificationContent(const {}),
        ('Healyn', 'You have a new notification.'),
      );
    });
  });
}
