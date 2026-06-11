import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/appointments_api.dart';
import 'package:healyn/features/appointments/data/models/appointment_models.dart';

void main() {
  late Dio dio;
  late RequestOptions? captured;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://api.test'));
    captured = null;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          captured = options;
          handler.resolve(
            Response<Map<String, dynamic>>(
              requestOptions: options,
              statusCode: 200,
              data: {'items': <dynamic>[], 'next_cursor': null},
            ),
          );
        },
      ),
    );
  });

  test('list sends from/to as UTC instants plus status and limit', () async {
    await AppointmentsApi(dio).list(
      from: DateTime.utc(2026, 6, 4),
      to: DateTime.utc(2026, 6, 5),
      statusCsv: 'CONFIRMED,REQUESTED',
      limit: 50,
    );

    final q = captured!.queryParameters;
    expect(captured!.path, '/appointments');
    expect(q['from'], '2026-06-04T00:00:00.000Z');
    expect(q['to'], '2026-06-05T00:00:00.000Z');
    expect(q['status'], 'CONFIRMED,REQUESTED');
    expect(q['limit'], 50);
  });

  test('list converts a local from/to to UTC on the wire', () async {
    // A non-UTC instant is normalised to Z before it is sent.
    final local = DateTime.utc(2026, 6, 4, 3, 30).toLocal();
    await AppointmentsApi(dio).list(from: local);

    expect(captured!.queryParameters['from'], '2026-06-04T03:30:00.000Z');
  });

  test('list omits from/to when they are not provided', () async {
    await AppointmentsApi(dio).list(limit: 20);

    final q = captured!.queryParameters;
    expect(q.containsKey('from'), isFalse);
    expect(q.containsKey('to'), isFalse);
  });

  test('list sends is_follow_up when set and omits it when absent', () async {
    await AppointmentsApi(dio).list(isFollowUp: true, limit: 20);
    expect(captured!.queryParameters['is_follow_up'], true);

    await AppointmentsApi(dio).list(limit: 20);
    expect(captured!.queryParameters.containsKey('is_follow_up'), isFalse);
  });

  test('search hits /appointments/search with q and limit', () async {
    await AppointmentsApi(dio).search('PHY-2026', limit: 10);

    final q = captured!.queryParameters;
    expect(captured!.path, '/appointments/search');
    expect(q['q'], 'PHY-2026');
    expect(q['limit'], 10);
  });

  test('search parses the suggestion items', () async {
    final itemsDio = Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) => handler.resolve(
            Response<Map<String, dynamic>>(
              requestOptions: options,
              statusCode: 200,
              data: {
                'items': [_suggestionJson],
              },
            ),
          ),
        ),
      );

    final hits = await AppointmentsApi(itemsDio).search('asha');
    expect(hits, hasLength(1));
    expect(hits.single.appointmentId, 'ap1');
    expect(hits.single.appointmentNumber, 'PHY-20260611-0001');
    expect(hits.single.patientName, 'Asha Rao');
    expect(hits.single.patientNumber, 'PAT-100001');
    expect(hits.single.status, AppointmentStatus.confirmed);
  });

  test('upcoming hits /appointments/upcoming with the limit', () async {
    await AppointmentsApi(dio).upcoming(limit: 30);

    expect(captured!.path, '/appointments/upcoming');
    expect(captured!.queryParameters['limit'], 30);
  });

  test('calendar sends from/to as UTC instants', () async {
    await AppointmentsApi(dio).calendar(
      from: DateTime.utc(2026, 6, 1),
      to: DateTime.utc(2026, 7, 6),
    );

    final q = captured!.queryParameters;
    expect(captured!.path, '/appointments/calendar');
    expect(q['from'], '2026-06-01T00:00:00.000Z');
    expect(q['to'], '2026-07-06T00:00:00.000Z');
  });

  test('upcoming/calendar read the cursorless items list', () async {
    // A dio that answers with a one-item AppointmentList (no next_cursor).
    final itemsDio = Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) => handler.resolve(
            Response<Map<String, dynamic>>(
              requestOptions: options,
              statusCode: 200,
              data: {
                'items': [_appointmentJson],
              },
            ),
          ),
        ),
      );

    final upcoming = await AppointmentsApi(itemsDio).upcoming();
    expect(upcoming, hasLength(1));
    expect(upcoming.single.id, 'ap1');

    final calendar = await AppointmentsApi(itemsDio).calendar(
      from: DateTime.utc(2026, 6, 1),
      to: DateTime.utc(2026, 7, 6),
    );
    expect(calendar, hasLength(1));
    expect(calendar.single.scheduledAt!.toUtc(), DateTime.utc(2026, 6, 10, 9));
  });
}

const _appointmentJson = <String, dynamic>{
  'id': 'ap1',
  'patient_id': 'pt1',
  'booked_by_account_id': 'ac1',
  'physiotherapist_id': 'ph1',
  'requested_date': '2026-06-10',
  'scheduled_at': '2026-06-10T09:00:00Z',
  'scheduled_end_at': '2026-06-10T09:45:00Z',
  'duration_minutes': 45,
  'status': 'CONFIRMED',
  'is_follow_up': false,
};

const _suggestionJson = <String, dynamic>{
  'appointment_id': 'ap1',
  'appointment_number': 'PHY-20260611-0001',
  'patient_id': 'pt1',
  'patient_name': 'Asha Rao',
  'patient_number': 'PAT-100001',
  'status': 'CONFIRMED',
  'scheduled_at': '2026-06-11T09:00:00Z',
  'requested_date': '2026-06-11',
};
