import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../storage/token_store.dart';
import 'auth_interceptor.dart';

BaseOptions _baseOptions(String baseUrl) => BaseOptions(
  baseUrl: baseUrl,
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 15),
  sendTimeout: const Duration(seconds: 15),
  contentType: Headers.jsonContentType,
  responseType: ResponseType.json,
);

/// The app's HTTP client: a Dio bound to the API base URL with the
/// [AuthInterceptor] wired in. JSON is snake_case on the wire; models map field
/// names explicitly, so no client-side key transform is needed here.
final dioProvider = Provider<Dio>((ref) {
  final baseUrl = ref.watch(appConfigProvider).apiBaseUrl;
  final tokenStore = ref.watch(tokenStoreProvider);

  // Bare client for refresh + retry — deliberately has no AuthInterceptor.
  final refreshClient = Dio(_baseOptions(baseUrl));

  return Dio(_baseOptions(baseUrl))
    ..interceptors.add(AuthInterceptor(tokenStore, refreshClient));
});
