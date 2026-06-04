/// Session state that drives top-level routing.
///
/// [unknown] is the boot state while the token store is read; the router shows
/// a splash until it resolves to [authenticated] or [unauthenticated].
enum AuthStatus { unknown, authenticated, unauthenticated }
