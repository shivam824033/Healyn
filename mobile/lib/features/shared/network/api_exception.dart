import 'package:dio/dio.dart';

/// A field-level validation detail from the backend error envelope
/// (`error.details[]` → `{ field, issue }`).
class ApiFieldError {
  const ApiFieldError({required this.field, required this.issue});

  factory ApiFieldError.fromJson(Map<String, dynamic> json) => ApiFieldError(
    field: (json['field'] ?? '').toString(),
    issue: (json['issue'] ?? '').toString(),
  );

  final String field;
  final String issue;
}

/// Normalized error surfaced to the UI. Wraps the backend envelope
/// (`{ error: { code, message, details, trace_id } }`) and transport failures
/// (timeouts, no connection) behind one type so controllers handle one thing.
class ApiException implements Exception {
  const ApiException({
    required this.code,
    required this.message,
    this.statusCode,
    this.details = const [],
  });

  /// Maps a [DioException] to an [ApiException], preferring the server envelope.
  factory ApiException.fromDio(DioException e) {
    final response = e.response;
    final data = response?.data;
    if (data is Map<String, dynamic> &&
        data['error'] is Map<String, dynamic>) {
      final error = data['error'] as Map<String, dynamic>;
      final rawDetails = error['details'];
      return ApiException(
        code: (error['code'] ?? 'error').toString(),
        message: (error['message'] ?? 'Something went wrong.').toString(),
        statusCode: response?.statusCode,
        details: rawDetails is List
            ? rawDetails
                  .whereType<Map<String, dynamic>>()
                  .map(ApiFieldError.fromJson)
                  .toList()
            : const [],
      );
    }

    final (code, message) = switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => (
        'timeout',
        'The server took too long to respond. Try again.',
      ),
      DioExceptionType.connectionError => (
        'no_connection',
        "Couldn't reach the server. Check your connection and try again.",
      ),
      _ => (
        'error',
        'Something went wrong. Please try again.',
      ),
    };
    return ApiException(
      code: code,
      message: message,
      statusCode: response?.statusCode,
    );
  }

  final String code;
  final String message;
  final int? statusCode;
  final List<ApiFieldError> details;

  @override
  String toString() => 'ApiException($statusCode, $code): $message';
}
