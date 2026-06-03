import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/token_store.dart';

/// The signed-in account's id, read from the access token's `sub` claim.
///
/// Used to decide which messages this account may edit or delete — the backend
/// only lets the original sender mutate a message, so the UI mirrors that to
/// avoid offering an action that would 403. Returns null when there is no
/// session or the token can't be parsed. The token itself is never logged
/// (CLAUDE.md §3).
final currentAccountIdProvider = FutureProvider<String?>((ref) async {
  final token = await ref.watch(tokenStoreProvider).readAccessToken();
  return token == null ? null : _subjectOf(token);
});

/// Extracts the `sub` claim from a JWT *without* verifying its signature —
/// verification is the server's job; the client only reads the subject.
String? _subjectOf(String jwt) {
  final parts = jwt.split('.');
  if (parts.length != 3) return null;
  try {
    final payload = json.decode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
    );
    final sub = (payload as Map<String, dynamic>)['sub'];
    return sub is String ? sub : null;
  } catch (_) {
    return null;
  }
}
