import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/appointments/data/appointments_api.dart';

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
}
