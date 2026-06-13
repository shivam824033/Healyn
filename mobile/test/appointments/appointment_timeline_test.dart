import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/appointments_api.dart';
import 'package:healyn/features/appointments/data/appointments_repository.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';
import 'package:healyn/features/appointments/presentation/widgets/appointment_timeline_section.dart';
import 'package:healyn/features/shared/auth/account_role.dart';
import 'package:healyn/features/shared/auth/current_account.dart';
import 'package:healyn/features/shared/network/api_exception.dart';

/// Serves a fixed timeline (or throws) without hitting the network.
class _FakeRepo extends AppointmentsRepository {
  _FakeRepo({this.events = const [], this.fail = false})
    : super(AppointmentsApi(Dio()));

  final List<TimelineEvent> events;
  final bool fail;

  @override
  Future<List<TimelineEvent>> timeline(String id) async {
    if (fail) {
      throw const ApiException(code: 'boom', message: 'nope', statusCode: 500);
    }
    return events;
  }
}

Future<void> _pump(WidgetTester tester, _FakeRepo repo) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        appointmentsRepositoryProvider.overrideWithValue(repo),
        currentAccountIdProvider.overrideWith((ref) async => 'acc-self'),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: AppointmentTimelineSection(appointmentId: 'ap-root'),
          ),
        ),
      ),
    ),
  );
}

TimelineEvent _event({
  String appointmentId = 'ap-root',
  String appointmentNumber = 'PHY-20260610-0001',
  required AppointmentEventType eventType,
  String? actorAccountId,
  AccountRole? actorRole,
  String? relatedAppointmentId,
  AppointmentChildKind? childKind,
  AppointmentCancelReason? cancelReason,
  required DateTime occurredAt,
}) => TimelineEvent(
  appointmentId: appointmentId,
  appointmentNumber: appointmentNumber,
  eventType: eventType,
  actorAccountId: actorAccountId,
  actorRole: actorRole,
  relatedAppointmentId: relatedAppointmentId,
  childKind: childKind,
  cancelReason: cancelReason,
  occurredAt: occurredAt,
);

void main() {
  group('TimelineEvent.fromJson', () {
    test('parses the snake_case wire shape with all enums', () {
      final event = TimelineEvent.fromJson(const {
        'appointment_id': 'ap-2',
        'appointment_number': 'PHY-20260610-0001-R1',
        'event_type': 'CREATED',
        'actor_account_id': 'acc-1',
        'actor_role': 'ROLE_PHYSIO',
        'related_appointment_id': 'ap-1',
        'child_kind': 'RESCHEDULE',
        'occurred_at': '2026-06-10T09:30:00Z',
      });

      expect(event.appointmentId, 'ap-2');
      expect(event.appointmentNumber, 'PHY-20260610-0001-R1');
      expect(event.eventType, AppointmentEventType.created);
      expect(event.actorAccountId, 'acc-1');
      expect(event.actorRole, AccountRole.physio);
      expect(event.relatedAppointmentId, 'ap-1');
      expect(event.childKind, AppointmentChildKind.reschedule);
      expect(event.cancelReason, isNull);
      expect(event.occurredAt, DateTime.utc(2026, 6, 10, 9, 30));
    });

    test('parses a minimal backfilled event (no actor, no lineage link)', () {
      final event = TimelineEvent.fromJson(const {
        'appointment_id': 'ap-1',
        'appointment_number': 'PHY-20260610-0001',
        'event_type': 'CANCELLED',
        'cancel_reason': 'PATIENT_CANCELLED',
        'occurred_at': '2026-06-10T10:00:00Z',
      });

      expect(event.eventType, AppointmentEventType.cancelled);
      expect(event.cancelReason, AppointmentCancelReason.patientCancelled);
      expect(event.actorAccountId, isNull);
      expect(event.actorRole, isNull);
    });
  });

  group('AppointmentTimelineSection', () {
    testWidgets('tells the lineage story with actors and numbers', (
      tester,
    ) async {
      await _pump(
        tester,
        _FakeRepo(
          events: [
            _event(
              eventType: AppointmentEventType.created,
              actorAccountId: 'acc-self',
              actorRole: AccountRole.account,
              occurredAt: DateTime.utc(2026, 6, 10, 9),
            ),
            _event(
              eventType: AppointmentEventType.scheduled,
              actorAccountId: 'acc-physio',
              actorRole: AccountRole.physio,
              occurredAt: DateTime.utc(2026, 6, 10, 10),
            ),
            _event(
              eventType: AppointmentEventType.rescheduled,
              actorAccountId: 'acc-physio',
              actorRole: AccountRole.physio,
              relatedAppointmentId: 'ap-child',
              occurredAt: DateTime.utc(2026, 6, 11, 8),
            ),
            _event(
              appointmentId: 'ap-child',
              appointmentNumber: 'PHY-20260610-0001-R1',
              eventType: AppointmentEventType.created,
              actorAccountId: 'acc-physio',
              actorRole: AccountRole.physio,
              relatedAppointmentId: 'ap-root',
              childKind: AppointmentChildKind.reschedule,
              occurredAt: DateTime.utc(2026, 6, 11, 8),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('HISTORY'), findsOneWidget);
      expect(find.text('Appointment created'), findsOneWidget);
      expect(find.text('Time confirmed'), findsOneWidget);
      expect(find.text('Rescheduled'), findsOneWidget);
      expect(find.text('New appointment created'), findsOneWidget);
      // The signed-in account reads "you"; the other party reads by role.
      expect(find.textContaining('by you'), findsOneWidget);
      expect(find.textContaining('by physiotherapist'), findsNWidgets(3));
      // Multi-appointment lineage: each entry is tagged with its number, and
      // the reschedule names the appointment it moved to.
      expect(find.text('PHY-20260610-0001'), findsNWidgets(3));
      expect(find.text('PHY-20260610-0001-R1'), findsOneWidget);
      expect(find.text('Moved to PHY-20260610-0001-R1'), findsOneWidget);
      expect(find.text('From PHY-20260610-0001'), findsOneWidget);
    });

    testWidgets(
      'hides number tags when the lineage is a single appointment',
      (tester) async {
        await _pump(
          tester,
          _FakeRepo(
            events: [
              _event(
                eventType: AppointmentEventType.created,
                actorAccountId: 'acc-self',
                actorRole: AccountRole.account,
                occurredAt: DateTime.utc(2026, 6, 10, 9),
              ),
              _event(
                eventType: AppointmentEventType.cancelled,
                actorAccountId: 'acc-self',
                actorRole: AccountRole.account,
                cancelReason: AppointmentCancelReason.patientCancelled,
                occurredAt: DateTime.utc(2026, 6, 10, 11),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('PHY-20260610-0001'), findsNothing);
        expect(find.text('Cancelled'), findsOneWidget);
        // The cancel reason renders as its enum label — never the free-text note.
        expect(find.text('Cancelled by patient'), findsOneWidget);
      },
    );

    testWidgets('offers a retry when the timeline fails to load', (
      tester,
    ) async {
      await _pump(tester, _FakeRepo(fail: true));
      await tester.pumpAndSettle();

      expect(find.text('Retry'), findsOneWidget);
      expect(find.textContaining("Couldn't load"), findsOneWidget);
    });
  });
}
