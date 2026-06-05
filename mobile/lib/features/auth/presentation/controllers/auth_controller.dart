import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/auth/account_role.dart';
import '../../../shared/push/push_service.dart';
import '../../../shared/storage/token_store.dart';
import '../../data/auth_repository.dart';
import '../../domain/auth_status.dart';

/// Holds the app-wide [AuthState]. On build it reads the token store to decide
/// whether a session already exists; the auth screens call [markAuthenticated]
/// after a successful login/registration (tokens are persisted by the repo).
///
/// The account [AccountRole] is resolved from the access token *before* the
/// status flips to authenticated, so the router lands the right app (patient vs
/// physiotherapist) without a flash of the wrong shell.
class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    unawaited(_bootstrap());
    return const AuthState.unknown();
  }

  Future<void> _bootstrap() async {
    final store = ref.read(tokenStoreProvider);
    if (!await store.hasSession()) {
      state = const AuthState.unauthenticated();
      return;
    }
    state = AuthState(status: AuthStatus.authenticated, role: await _role(store));
    // A returning session re-registers its push token (it may have rotated, or
    // permission may have been granted since last run). Fire-and-forget.
    unawaited(ref.read(pushServiceProvider).register());
  }

  Future<void> markAuthenticated() async {
    state = AuthState(
      status: AuthStatus.authenticated,
      role: await _role(ref.read(tokenStoreProvider)),
    );
    unawaited(ref.read(pushServiceProvider).register());
  }

  Future<void> logout() async {
    await ref.read(pushServiceProvider).unregister();
    await ref.read(authRepositoryProvider).logout();
    state = const AuthState.unauthenticated();
  }

  Future<AccountRole?> _role(TokenStore store) async {
    final token = await store.readAccessToken();
    return token == null ? null : accountRoleFromToken(token);
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
