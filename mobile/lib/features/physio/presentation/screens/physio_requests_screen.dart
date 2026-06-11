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
import '../physio_requests_providers.dart';
import '../widgets/patient_avatar_button.dart';

/// The physiotherapist's incoming-requests queue (F1.11): pending REQUESTED
/// appointments grouped by day, earliest first. Tapping a row opens the existing
/// appointment detail, where the request is confirmed or rejected.
class PhysioRequestsScreen extends ConsumerWidget {
  const PhysioRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(physioRequestsProvider);
    final patients = ref.watch(patientsProvider).valueOrNull ?? const [];
    final byId = {for (final p in patients) p.id: p};

    return Scaffold(
      appBar: const HealynAppBar(title: 'Requests'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(physioRequestsProvider);
            await ref.read(physioRequestsProvider.future);
          },
          child: requests.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => ListView(
              padding: const EdgeInsets.all(HealynSpacing.screenEdge),
              children: const [
                ErrorBanner(
                  message: 'Could not load requests. Pull down to retry.',
                ),
              ],
            ),
            data: (items) {
              if (items.isEmpty) return const _NoRequests();
              // Group by requested calendar day, preserving the earliest-first
              // order (a request has no scheduled time yet).
              final groups = <String, List<Appointment>>{};
              for (final a in items) {
                groups
                    .putIfAbsent(formatDateLong(a.requestedDate), () => [])
                    .add(a);
              }
              return ListView(
                padding: const EdgeInsets.all(HealynSpacing.screenEdge),
                children: [
                  for (final entry in groups.entries) ...[
                    _DayHeader(label: entry.key),
                    const SizedBox(height: HealynSpacing.s3),
                    for (final a in entry.value) ...[
                      _RequestTile(
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

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) =>
      Text(label.toUpperCase(), style: HealynTypography.overline);
}

class _RequestTile extends StatelessWidget {
  const _RequestTile({required this.appointment, this.patient});

  final Appointment appointment;
  final Patient? patient;

  @override
  Widget build(BuildContext context) {
    final patientName = patient?.fullName;
    final preferred = formatClockTime(appointment.preferredTime);
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
                        patientName ?? 'Patient',
                        style: HealynTypography.bodyStrong,
                      ),
                      const SizedBox(height: HealynSpacing.s1),
                      Text(
                        preferred != null
                            ? 'Prefers $preferred'
                            : 'No time preference',
                        style: HealynTypography.caption,
                      ),
                      const SizedBox(height: HealynSpacing.s2),
                      AppointmentStatusChip(status: appointment.status),
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
}

class _NoRequests extends StatelessWidget {
  const _NoRequests();

  @override
  Widget build(BuildContext context) {
    // Inside a scrollable so pull-to-refresh still works with no requests.
    return ListView(
      padding: const EdgeInsets.all(HealynSpacing.s8),
      children: [
        const SizedBox(height: HealynSpacing.s8),
        const Icon(
          Icons.inbox_outlined,
          size: 48,
          color: HealynColors.textMuted,
        ),
        const SizedBox(height: HealynSpacing.s4),
        const Text(
          'No new requests',
          style: HealynTypography.h3,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: HealynSpacing.s2),
        Text(
          'Incoming appointment requests will appear here for you to confirm '
          'or reject.',
          style: HealynTypography.body.copyWith(
            color: HealynColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
