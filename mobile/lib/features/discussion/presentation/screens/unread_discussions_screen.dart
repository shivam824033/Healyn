import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../appointments/presentation/appointment_format.dart';
import '../../../patients/presentation/patients_providers.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/healyn_list_row.dart';
import '../unread_providers.dart';

/// An index of the account's appointments that carry unread discussion messages
/// (DISCUSSION_SYSTEM_DESIGN §9 — an index, *not* a merged feed). Tapping a row
/// opens that appointment's thread.
class UnreadDiscussionsScreen extends ConsumerWidget {
  const UnreadDiscussionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(unreadSummaryProvider);
    final patients = ref.watch(patientsProvider).valueOrNull ?? const [];
    final names = {for (final p in patients) p.id: p.fullName};

    return Scaffold(
      appBar: const HealynAppBar(title: 'Unread messages'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(unreadSummaryProvider);
            await ref.read(unreadSummaryProvider.future);
          },
          child: summary.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => ListView(
              padding: const EdgeInsets.all(HealynSpacing.screenEdge),
              children: const [
                ErrorBanner(
                  message: 'Could not load unread messages. Pull down to retry.',
                ),
              ],
            ),
            data: (s) {
              if (s.threads.isEmpty) return const _AllCaughtUp();
              return ListView.separated(
                padding: const EdgeInsets.all(HealynSpacing.screenEdge),
                itemCount: s.threads.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: HealynSpacing.s3),
                itemBuilder: (_, i) {
                  final thread = s.threads[i];
                  return _UnreadTile(
                    thread: thread,
                    patientName: names[thread.appointment.patientId],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _UnreadTile extends StatelessWidget {
  const _UnreadTile({required this.thread, this.patientName});

  final UnreadThread thread;
  final String? patientName;

  @override
  Widget build(BuildContext context) {
    final appointment = thread.appointment;
    final when = formatAppointmentWhenShort(appointment);
    return HealynListRow(
      title: patientName ?? when,
      subtitle: patientName != null ? when : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _UnreadBadge(count: thread.count),
          const SizedBox(width: HealynSpacing.s2),
          const Icon(Icons.chevron_right, color: HealynColors.textMuted),
        ],
      ),
      onTap: () => context.push(
        '/appointments/${appointment.id}/discussion',
        extra: appointment,
      ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 24),
      padding: const EdgeInsets.symmetric(
        horizontal: HealynSpacing.s2,
        vertical: HealynSpacing.s1,
      ),
      decoration: const BoxDecoration(
        color: HealynColors.brandPrimary,
        borderRadius: HealynRadii.brSm,
      ),
      child: Text(
        '$count',
        textAlign: TextAlign.center,
        style: HealynTypography.caption.copyWith(
          color: HealynColors.surfaceBase,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _AllCaughtUp extends StatelessWidget {
  const _AllCaughtUp();

  @override
  Widget build(BuildContext context) {
    // Inside a scrollable so pull-to-refresh still works with nothing unread.
    return ListView(
      padding: const EdgeInsets.all(HealynSpacing.s8),
      children: [
        const SizedBox(height: HealynSpacing.s8),
        const Icon(
          Icons.mark_email_read_outlined,
          size: 48,
          color: HealynColors.textMuted,
        ),
        const SizedBox(height: HealynSpacing.s4),
        const Text(
          "You're all caught up",
          style: HealynTypography.h3,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: HealynSpacing.s2),
        Text(
          'New messages from your physiotherapist will show up here.',
          style: HealynTypography.body.copyWith(
            color: HealynColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
