import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/auth_repository.dart';
import '../../auth/data/models/auth_models.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import '../../shared/design/spacing.dart';
import '../../shared/design/typography.dart';
import '../../shared/widgets/error_banner.dart';

/// Active sessions for the signed-in account. autoDispose so it re-fetches each
/// time Home is shown; refreshable via pull-to-refresh.
final sessionsProvider = FutureProvider.autoDispose<List<SessionView>>(
  (ref) => ref.watch(authRepositoryProvider).listSessions(),
);

/// First-slice authenticated landing. The full patient app gets the
/// Home/Appointments/Family/Profile bottom nav (UI_UX_GUIDELINES §8.1) in a
/// later slice; for now this confirms the session round-trips end to end.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(sessionsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Healyn'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(sessionsProvider);
            await ref.read(sessionsProvider.future);
          },
          child: ListView(
            padding: const EdgeInsets.all(HealynSpacing.screenEdge),
            children: [
              const Text("You're signed in", style: HealynTypography.h1),
              const SizedBox(height: HealynSpacing.s2),
              const Text(
                'Your session is active and talking to the Healyn backend.',
                style: HealynTypography.body,
              ),
              const SizedBox(height: HealynSpacing.s7),
              const Text('Active sessions', style: HealynTypography.h2),
              const SizedBox(height: HealynSpacing.s3),
              sessions.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: HealynSpacing.s6),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => const ErrorBanner(
                  message: 'Could not load sessions. Pull down to retry.',
                ),
                data: (items) => Column(
                  children: [
                    for (final s in items) _SessionTile(session: s),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.session});

  final SessionView session;

  @override
  Widget build(BuildContext context) {
    final label = session.deviceLabel?.isNotEmpty == true
        ? session.deviceLabel!
        : session.deviceId;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.devices_outlined),
      title: Text(label, style: HealynTypography.bodyStrong),
      subtitle: Text(
        'Last active ${_short(session.lastSeenAt)}',
        style: HealynTypography.caption,
      ),
    );
  }

  String _short(DateTime d) {
    final local = d.toLocal();
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')} '
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }
}
