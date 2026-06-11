import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../appointments/data/models/appointment_models.dart';
import '../../../appointments/presentation/appointment_format.dart';
import '../../../appointments/presentation/widgets/appointment_status_chip.dart';
import '../../../patients/data/models/patient_models.dart';
import '../../../patients/presentation/patients_providers.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/elevation.dart';
import '../../../shared/design/radii.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/error_banner.dart';
import '../physio_upcoming_providers.dart';
import '../widgets/patient_avatar_button.dart';

/// The physiotherapist's Upcoming list (F1.12), pushed from Today: the next live
/// scheduled appointments from now, ascending and grouped by day. Tapping a row
/// opens the appointment detail. Read-only — scheduling happens in the detail.
class PhysioUpcomingScreen extends ConsumerWidget {
  const PhysioUpcomingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcoming = ref.watch(physioUpcomingProvider);
    final patients = ref.watch(patientsProvider).valueOrNull ?? const [];
    final byId = {for (final p in patients) p.id: p};

    return Scaffold(
      appBar: const HealynAppBar(title: 'Upcoming'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(physioUpcomingProvider);
            await ref.read(physioUpcomingProvider.future);
          },
          child: upcoming.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => ListView(
              padding: const EdgeInsets.all(HealynSpacing.screenEdge),
              children: const [
                ErrorBanner(
                  message: 'Could not load upcoming appointments. '
                      'Pull down to retry.',
                ),
              ],
            ),
            data: (items) {
              if (items.isEmpty) return const _NothingUpcoming();
              // Group by the scheduled local day, preserving ascending order.
              final groups = <String, List<Appointment>>{};
              for (final a in items) {
                groups.putIfAbsent(formatDateLong(a.day), () => []).add(a);
              }
              return ListView(
                padding: const EdgeInsets.all(HealynSpacing.screenEdge),
                children: [
                  for (final entry in groups.entries) ...[
                    Text(
                      entry.key.toUpperCase(),
                      style: HealynTypography.overline,
                    ),
                    const SizedBox(height: HealynSpacing.s3),
                    for (final a in entry.value) ...[
                      _UpcomingTile(
                        appointment: a,
                        patient: byId[a.patientId],
                      ),
                      const SizedBox(height: HealynSpacing.s3),
                    ],
                    const SizedBox(height: HealynSpacing.s4),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _UpcomingTile extends StatelessWidget {
  const _UpcomingTile({required this.appointment, this.patient});

  final Appointment appointment;
  final Patient? patient;

  @override
  Widget build(BuildContext context) {
    final patientName = patient?.fullName;
    return Container(
      decoration: BoxDecoration(
        color: HealynColors.surfaceBase,
        borderRadius: HealynRadii.brLg,
        border: Border.all(color: HealynColors.borderSubtle),
        boxShadow: HealynElevation.e1,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: HealynRadii.brLg,
          onTap: () => context.push(
            '/physio/appointments/${appointment.id}',
            extra: appointment,
          ),
          child: Padding(
            padding: const EdgeInsets.all(HealynSpacing.s4),
            child: Row(
              children: [
                PatientAvatarButton(
                  patientId: appointment.patientId,
                  name: patientName,
                  patient: patient,
                ),
                const SizedBox(width: HealynSpacing.s4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _time(appointment),
                        style: HealynTypography.bodyStrong,
                      ),
                      const SizedBox(height: HealynSpacing.s1),
                      Text(
                        patientName ?? 'Patient',
                        style: HealynTypography.body,
                      ),
                      if (appointment.appointmentNumber != null) ...[
                        const SizedBox(height: HealynSpacing.s1),
                        Text(
                          appointment.appointmentNumber!,
                          style: HealynTypography.caption.copyWith(
                            color: HealynColors.textMuted,
                          ),
                        ),
                      ],
                      const SizedBox(height: HealynSpacing.s2),
                      Wrap(
                        spacing: HealynSpacing.s2,
                        runSpacing: HealynSpacing.s2,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          AppointmentStatusChip(status: appointment.status),
                          if (appointment.isFollowUp) const _FollowUpChip(),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: HealynColors.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Upcoming rows are always scheduled, but stay null-safe.
  static String _time(Appointment a) {
    final startsAt = a.scheduledAt;
    final endsAt = a.scheduledEndAt;
    if (startsAt == null) return 'Time to be confirmed';
    if (endsAt == null) return formatTimeOfDay(startsAt);
    return '${formatTimeOfDay(startsAt)} – ${formatTimeOfDay(endsAt)}';
  }
}

/// Marks a follow-up review so it reads distinctly from a first booking (F1.12).
class _FollowUpChip extends StatelessWidget {
  const _FollowUpChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HealynSpacing.s2,
        vertical: 2,
      ),
      decoration: const BoxDecoration(
        color: HealynColors.brandPrimarySubtle,
        borderRadius: HealynRadii.brSm,
      ),
      child: Text(
        'Follow-up',
        style: HealynTypography.caption.copyWith(
          color: HealynColors.brandPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _NothingUpcoming extends StatelessWidget {
  const _NothingUpcoming();

  @override
  Widget build(BuildContext context) {
    // Inside a scrollable so pull-to-refresh still works when empty.
    return ListView(
      padding: const EdgeInsets.all(HealynSpacing.s8),
      children: [
        const SizedBox(height: HealynSpacing.s8),
        const Icon(
          Icons.event_available_outlined,
          size: 48,
          color: HealynColors.textMuted,
        ),
        const SizedBox(height: HealynSpacing.s4),
        const Text(
          'Nothing upcoming',
          style: HealynTypography.h3,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: HealynSpacing.s2),
        Text(
          'Confirmed appointments will appear here as they are scheduled.',
          style: HealynTypography.body.copyWith(
            color: HealynColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
