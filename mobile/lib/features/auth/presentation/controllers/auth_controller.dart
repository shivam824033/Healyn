import 'dart:async';

import 'package:flutter/foundation.dart';
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
    try {
      final store = ref.read(tokenStoreProvider);
      if (!await store.hasSession()) {
        state = const AuthState.unauthenticated();
        return;
      }
      state =
          AuthState(status: AuthStatus.authenticated, role: await _role(store));
      // A returning session re-registers its push token (it may have rotated, or
      // permission may have been granted since last run). Fire-and-forget.
      unawaited(ref.read(pushServiceProvider).register());
    } catch (e, st) {
      // The token store read failed (e.g. a keystore error). This runs via
      // `unawaited`, so a thrown error would otherwise be swallowed and leave
      // the status stuck at `unknown` — stranding the app on the splash. Fall
      // back to signed-out so the router moves to /login.
      debugPrint('Auth bootstrap failed; treating as signed out: $e\n$st');
      state = const AuthState.unauthenticated();
    }
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

  /// The session ended out from under us — this device was signed out elsewhere,
  /// or the refresh token is dead (the auth interceptor detects this). Tokens are
  /// already cleared; flipping to unauthenticated makes the router go to /login.
  void onSessionExpired() {
    if (state.status == AuthStatus.unauthenticated) return;
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
