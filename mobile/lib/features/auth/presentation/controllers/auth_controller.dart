import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/push/push_service.dart';
import '../../../shared/storage/token_store.dart';
import '../../data/auth_repository.dart';
import '../../domain/auth_status.dart';

/// Holds the app-wide [AuthStatus]. On build it reads the token store to decide
/// whether a session already exists; the auth screens call [markAuthenticated]
/// after a successful login/registration (tokens are persisted by the repo).
class AuthController extends Notifier<AuthStatus> {
  @override
  AuthStatus build() {
    unawaited(_bootstrap());
    return AuthStatus.unknown;
  }

  Future<void> _bootstrap() async {
    final hasSession = await ref.read(tokenStoreProvider).hasSession();
    state = hasSession ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    // A returning session re-registers its push token (it may have rotated, or
    // permission may have been granted since last run). Fire-and-forget.
    if (hasSession) unawaited(ref.read(pushServiceProvider).register());
  }

  void markAuthenticated() {
    state = AuthStatus.authenticated;
    unawaited(ref.read(pushServiceProvider).register());
  }

  Future<void> logout() async {
    await ref.read(pushServiceProvider).unregister();
    await ref.read(authRepositoryProvider).logout();
    state = AuthStatus.unauthenticated;
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthStatus>(
  AuthController.new,
);
