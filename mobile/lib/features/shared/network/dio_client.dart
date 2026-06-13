import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/controllers/auth_controller.dart';
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
    ..interceptors.add(
      AuthInterceptor(
        tokenStore,
        refreshClient,
        // Read lazily (at 401 time, not provider build) so there's no dependency
        // cycle between the Dio and auth providers.
        onSessionExpired: () =>
            ref.read(authControllerProvider.notifier).onSessionExpired(),
      ),
    );
});

/// A bare Dio for uploading bytes straight to object storage via a presigned
/// PUT. Deliberately has **no** [AuthInterceptor] (the presigned URL carries its
/// own signature; an `Authorization` header would break it), no `baseUrl` (the
/// URL is absolute), and no default content type (the caller sets the exact
/// Content-Type the presign signed). Generous timeouts cover larger files.
final uploadDioProvider = Provider<Dio>(
  (ref) => Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(minutes: 2),
      receiveTimeout: const Duration(seconds: 30),
    ),
  ),
);
