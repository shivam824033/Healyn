import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../appointments/data/models/appointment_models.dart';
import '../../../appointments/presentation/appointment_format.dart';
import '../../../patients/presentation/patients_providers.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/copyable_id.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/healyn_list_row.dart';
import '../physio_unread_providers.dart';

/// Every appointment thread carrying unread patient messages for the
/// physiotherapist, most-recent activity first (the account-wide roll-up the
/// Today "Unread" stat opens). Tapping a card opens that thread.
class PhysioUnreadDiscussionsScreen extends ConsumerWidget {
  const PhysioUnreadDiscussionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(physioUnreadSummaryProvider);
    final patients = ref.watch(patientsProvider).valueOrNull ?? const [];
    final names = {for (final p in patients) p.id: p.fullName};

    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: const HealynAppBar(title: 'Unread messages'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(physioUnreadSummaryProvider);
            await ref.read(physioUnreadSummaryProvider.future);
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
                  return _UnreadCard(
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

class _UnreadCard extends StatelessWidget {
  const _UnreadCard({required this.thread, this.patientName});

  final PhysioUnreadThread thread;
  final String? patientName;

  @override
  Widget build(BuildContext context) {
    final appointment = thread.appointment;
    final when = thread.lastMessageAt ?? appointment.day;
    final preview = thread.lastMessagePreview;
    return HealynListRow(
      title: patientName ?? formatAppointmentWhenShort(appointment),
      subtitle: (preview != null && preview.isNotEmpty) ? preview : null,
      footer: Wrap(
        spacing: HealynSpacing.s2,
        runSpacing: HealynSpacing.s1,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (appointment.appointmentNumber != null)
            CopyableId(value: appointment.appointmentNumber!),
          Text(
            formatDateLong(when),
            style: HealynTypography.caption.copyWith(
              color: HealynColors.textMuted,
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _UnreadBadge(count: thread.count),
          const SizedBox(width: HealynSpacing.s2),
          const Icon(Icons.chevron_right, color: HealynColors.textMuted),
        ],
      ),
      onTap: () => context.push(
        '/physio/appointments/${appointment.id}/discussion',
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
    final label = count > 99 ? '99+' : '$count';
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
        label,
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
          'New patient messages will show up here.',
          style: HealynTypography.body.copyWith(
            color: HealynColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
