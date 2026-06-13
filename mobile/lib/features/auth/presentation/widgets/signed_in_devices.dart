import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/section_card.dart';
import '../../data/auth_repository.dart';
import '../../data/models/auth_models.dart';

/// Active sessions for the signed-in account. autoDispose so it refetches each
/// time a Profile mounts, and so a per-device revoke can invalidate it.
final signedInDevicesProvider = FutureProvider.autoDispose<List<SessionView>>(
  (ref) => ref.watch(authRepositoryProvider).listSessions(),
);

/// This device's own session id, so the list can mark it "This device" and keep
/// it from signing itself out — that path is the full "Sign out" (logout).
final currentSessionIdProvider = FutureProvider.autoDispose<String?>(
  (ref) => ref.watch(authRepositoryProvider).currentSessionId(),
);

/// "Signed-in devices" Profile section (D5): the account's active sessions, each
/// with a "Sign out this device" action — except the current device, which is
/// marked and guarded. Shared by the patient and physiotherapist profiles so the
/// two stay identical.
class SignedInDevicesSection extends ConsumerWidget {
  const SignedInDevicesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(signedInDevicesProvider);
    final currentId = ref.watch(currentSessionIdProvider);

    // Hold the section until the current session is known too, so a device is
    // never offered "Sign out" before we can tell whether it is this one.
    final Widget body;
    if (sessions.isLoading || currentId.isLoading) {
      body = const Padding(
        padding: EdgeInsets.symmetric(vertical: HealynSpacing.s3),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (sessions.hasError) {
      body = const Text(
        'Could not load your devices.',
        style: HealynTypography.caption,
      );
    } else {
      final items = sessions.value ?? const <SessionView>[];
      final current = currentId.value;
      body = Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const Divider(height: HealynSpacing.s5),
            _DeviceRow(session: items[i], isCurrent: items[i].id == current),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('SIGNED-IN DEVICES', style: HealynTypography.overline),
        const SizedBox(height: HealynSpacing.s3),
        SectionCard(child: body),
      ],
    );
  }
}

class _DeviceRow extends ConsumerWidget {
  const _DeviceRow({required this.session, required this.isCurrent});

  final SessionView session;
  final bool isCurrent;

  String get _label => session.deviceLabel?.isNotEmpty == true
      ? session.deviceLabel!
      : session.deviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        const Icon(
          Icons.devices_outlined,
          size: 20,
          color: HealynColors.textSecondary,
        ),
        const SizedBox(width: HealynSpacing.s3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      _label,
                      style: HealynTypography.bodyStrong,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isCurrent) ...[
                    const SizedBox(width: HealynSpacing.s2),
                    const _CurrentChip(),
                  ],
                ],
              ),
              Text(
                'Last active ${_shortDateTime(session.lastSeenAt)}',
                style: HealynTypography.caption,
              ),
            ],
          ),
        ),
        if (!isCurrent)
          TextButton(
            onPressed: () => _signOut(context, ref),
            style: TextButton.styleFrom(
              foregroundColor: HealynColors.statusDanger,
            ),
            child: const Text('Sign out'),
          ),
      ],
    );
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    // Capture the messenger before the dialog await so no BuildContext crosses
    // the async gap.
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign out this device?'),
        content: Text('"$_label" will need to sign in again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: HealynColors.statusDanger,
            ),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(authRepositoryProvider).revokeSession(session.id);
      ref.invalidate(signedInDevicesProvider);
      messenger.showSnackBar(
        const SnackBar(content: Text('Signed out that device')),
      );
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}

class _CurrentChip extends StatelessWidget {
  const _CurrentChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HealynSpacing.s2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: HealynColors.brandPrimarySubtle,
        borderRadius: BorderRadius.circular(HealynRadii.full),
      ),
      child: Text(
        'This device',
        style: HealynTypography.caption.copyWith(
          color: HealynColors.brandPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

String _shortDateTime(DateTime d) {
  final l = d.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${l.year}-${two(l.month)}-${two(l.day)} ${two(l.hour)}:${two(l.minute)}';
}
