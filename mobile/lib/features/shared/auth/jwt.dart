import 'dart:convert';

/// Decodes a JWT's payload (claims) *without* verifying the signature —
/// verification is the server's job; the client only reads the claims it needs
/// (the token itself is never logged, CLAUDE.md §3). Returns null when the
/// token is malformed.
Map<String, dynamic>? decodeJwtPayload(String jwt) {
  final parts = jwt.split('.');
  if (parts.length != 3) return null;
  try {
    final payload = json.decode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
    );
    return payload is Map<String, dynamic> ? payload : null;
  } catch (_) {
    return null;
  }
}
