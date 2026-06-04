import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../appointments/data/models/appointment_models.dart';
import '../../appointments/presentation/appointment_format.dart';
import '../../appointments/presentation/appointments_providers.dart';
import '../../appointments/presentation/widgets/appointment_status_chip.dart';
import '../../patients/presentation/active_patient_provider.dart';
import '../../patients/presentation/patients_providers.dart';
import '../../patients/presentation/widgets/patient_switcher.dart';
import '../../shared/design/colors.dart';
import '../../shared/design/spacing.dart';
import '../../shared/design/typography.dart';
import '../../shared/widgets/section_card.dart';

/// Home tab — the signed-in landing. Greets the primary patient by first name
/// and surfaces the next upcoming appointment (or an invitation to book one).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstName = ref.watch(patientsProvider).maybeWhen(
      data: (patients) {
        final me = primaryPatientOf(patients);
        final name = me?.fullName.trim() ?? '';
        return name.isEmpty ? null : name.split(RegExp(r'\s+')).first;
      },
      orElse: () => null,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Healyn')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(HealynSpacing.screenEdge),
          children: [
            Text(
              firstName == null ? 'Welcome back' : 'Hi, $firstName',
              style: HealynTypography.h1,
            ),
            const SizedBox(height: HealynSpacing.s2),
            const Text(
              'Manage your appointments, family, and care in one place.',
              style: HealynTypography.body,
            ),
            const SizedBox(height: HealynSpacing.s5),
            const PatientSwitcher(),
            const SizedBox(height: HealynSpacing.s5),
            const _UpcomingSummary(),
          ],
        ),
      ),
    );
  }
}

/// The "Upcoming appointments" card: shows the soonest open appointment, or an
/// invitation to book when there's nothing scheduled.
class _UpcomingSummary extends ConsumerWidget {
  const _UpcomingSummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointments = ref.watch(appointmentsProvider);
    final active = ref.watch(activePatientProvider);
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.event_outlined,
                size: 20,
                color: HealynColors.brandPrimary,
              ),
              SizedBox(width: HealynSpacing.s2),
              Text(
                'Upcoming appointments',
                style: HealynTypography.bodyStrong,
              ),
            ],
          ),
          const SizedBox(height: HealynSpacing.s3),
          appointments.when(
            loading: () => Text(
              'Checking your schedule…',
              style: HealynTypography.body.copyWith(
                color: HealynColors.textSecondary,
              ),
            ),
            error: (_, _) => Text(
              'Could not load your appointments.',
              style: HealynTypography.body.copyWith(
                color: HealynColors.textSecondary,
              ),
            ),
            // Scoped to the active Patient context (PATIENT_RELATIONSHIP_MODEL
            // §7): switching the patient up top refetches this card.
            data: (all) {
              final scoped = active == null
                  ? all
                  : all.where((a) => a.patientId == active.id).toList();
              final upcoming = upcomingOf(scoped);
              if (upcoming.isEmpty) return const _NothingScheduled();
              return _NextAppointment(next: upcoming.first);
            },
          ),
        ],
      ),
    );
  }
}

class _NextAppointment extends StatelessWidget {
  const _NextAppointment({required this.next});

  final Appointment next;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/appointments/${next.id}', extra: next),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${formatDateShort(next.scheduledAt)} · '
                  '${formatTimeOfDay(next.scheduledAt)}',
                  style: HealynTypography.bodyStrong,
                ),
                const SizedBox(height: HealynSpacing.s2),
                AppointmentStatusChip(status: next.status),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: HealynColors.textMuted),
        ],
      ),
    );
  }
}

class _NothingScheduled extends StatelessWidget {
  const _NothingScheduled();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nothing scheduled yet.',
          style: HealynTypography.body.copyWith(
            color: HealynColors.textSecondary,
          ),
        ),
        const SizedBox(height: HealynSpacing.s2),
        TextButton.icon(
          onPressed: () => context.push('/appointments/book'),
          icon: const Icon(Icons.add),
          label: const Text('Book appointment'),
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
        ),
      ],
    );
  }
}
