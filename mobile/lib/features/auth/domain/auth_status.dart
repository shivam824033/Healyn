import '../../shared/auth/account_role.dart';

/// Session phase that drives top-level routing.
///
/// [unknown] is the boot state while the token store is read; the router shows
/// a splash until it resolves to [authenticated] or [unauthenticated].
enum AuthStatus { unknown, authenticated, unauthenticated }

/// Top-level session state: the [AuthStatus] plus, once authenticated, the
/// signed-in account's [AccountRole] (null while unknown/unauthenticated, or if
/// the token has no resolvable role). The router lands a physiotherapist in the
/// physio app and every other account in the patient app.
class AuthState {
  const AuthState({required this.status, this.role});

  const AuthState.unknown() : status = AuthStatus.unknown, role = null;
  const AuthState.unauthenticated()
    : status = AuthStatus.unauthenticated,
      role = null;

  final AuthStatus status;
  final AccountRole? role;

  @override
  bool operator ==(Object other) =>
      other is AuthState && other.status == status && other.role == role;

  @override
  int get hashCode => Object.hash(status, role);
}
