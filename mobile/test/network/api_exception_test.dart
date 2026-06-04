import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/shared/network/api_exception.dart';

void main() {
  group('ApiException.fromDio', () {
    test('parses the backend error envelope', () {
      final options = RequestOptions(path: '/auth/login');
      final error = DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response<Map<String, dynamic>>(
          requestOptions: options,
          statusCode: 401,
          data: const {
            'error': {
              'code': 'unauthorized',
              'message': 'Invalid credentials',
              'details': [
                {'field': 'password', 'issue': 'mismatch'},
              ],
              'trace_id': 'abc123',
            },
          },
        ),
      );

      final api = ApiException.fromDio(error);

      expect(api.code, 'unauthorized');
      expect(api.message, 'Invalid credentials');
      expect(api.statusCode, 401);
      expect(api.details, hasLength(1));
      expect(api.details.first.field, 'password');
      expect(api.details.first.issue, 'mismatch');
    });

    test('maps a connection error to a friendly, code-tagged message', () {
      final api = ApiException.fromDio(
        DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(api.code, 'no_connection');
      expect(api.message, isNotEmpty);
    });
  });
}
