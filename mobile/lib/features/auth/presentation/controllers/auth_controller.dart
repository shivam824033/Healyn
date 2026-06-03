import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  }

  void markAuthenticated() => state = AuthStatus.authenticated;

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = AuthStatus.unauthenticated;
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthStatus>(
  AuthController.new,
);
