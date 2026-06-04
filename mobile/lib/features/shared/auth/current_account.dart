import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/token_store.dart';
import 'jwt.dart';

/// The signed-in account's id, read from the access token's `sub` claim.
///
/// Used to decide which messages this account may edit or delete — the backend
/// only lets the original sender mutate a message, so the UI mirrors that to
/// avoid offering an action that would 403. Returns null when there is no
/// session or the token can't be parsed. The token itself is never logged
/// (CLAUDE.md §3).
final currentAccountIdProvider = FutureProvider<String?>((ref) async {
  final token = await ref.watch(tokenStoreProvider).readAccessToken();
  if (token == null) return null;
  final sub = decodeJwtPayload(token)?['sub'];
  return sub is String ? sub : null;
});
