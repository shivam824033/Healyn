import 'jwt.dart';

/// The account roles Healyn issues (the access token's `role` claim). The mobile
/// app reads this to choose the patient vs physiotherapist experience; the
/// server remains the authority for authorization.
enum AccountRole {
  account,
  physio;

  /// Maps the wire enum name (`ROLE_ACCOUNT` / `ROLE_PHYSIO`) to a role, or null
  /// for anything unknown.
  static AccountRole? fromWire(String? value) => switch (value) {
    'ROLE_ACCOUNT' => AccountRole.account,
    'ROLE_PHYSIO' => AccountRole.physio,
    _ => null,
  };
}

/// Reads the `role` claim from an access token. Null when absent or malformed.
AccountRole? accountRoleFromToken(String jwt) {
  final role = decodeJwtPayload(jwt)?['role'];
  return role is String ? AccountRole.fromWire(role) : null;
}
