import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/data/auth_repository.dart';
import '../../../auth/data/models/auth_models.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/section_card.dart';
import '../../data/models/patient_models.dart';
import '../patient_format.dart';
import '../patients_providers.dart';

/// Active sessions for the signed-in account, shown under "Signed-in devices".
/// autoDispose so it refetches each time Profile is shown.
final _sessionsProvider = FutureProvider.autoDispose<List<SessionView>>(
  (ref) => ref.watch(authRepositoryProvider).listSessions(),
);

/// Profile tab — the account's own (primary) patient, plus account actions.
/// Editing the profile (PATCH) is a later slice; this is read-only for now.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(patientsProvider);
    final list = patients.valueOrNull;
    final me = (list == null || list.isEmpty) ? null : primaryPatientOf(list);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (me != null)
            IconButton(
              tooltip: 'Edit profile',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () =>
                  context.push('/patients/${me.id}/edit', extra: me),
            ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(patientsProvider);
            ref.invalidate(_sessionsProvider);
            await ref.read(patientsProvider.future);
          },
          child: patients.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => ListView(
              padding: const EdgeInsets.all(HealynSpacing.screenEdge),
              children: const [
                ErrorBanner(
                  message: 'Could not load your profile. Pull down to retry.',
                ),
              ],
            ),
            data: (all) {
              final me = primaryPatientOf(all);
              if (me == null) {
                return ListView(
                  padding: const EdgeInsets.all(HealynSpacing.screenEdge),
                  children: const [
                    ErrorBanner(message: 'No patient profile found.'),
                  ],
                );
              }
              return _ProfileBody(patient: me);
            },
          ),
        ),
      ),
    );
  }
}

class _ProfileBody extends ConsumerWidget {
  const _ProfileBody({required this.patient});

  final Patient patient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = <(String, String)>[
      (
        'Date of birth',
        '${formatBirthDate(patient.dateOfBirth)} '
            '(age ${patientAgeInYears(patient.dateOfBirth)})',
      ),
      if (patient.sex != null) ('Sex', patient.sex!.label),
      if (_has(patient.email)) ('Email', patient.email!),
      if (_has(patient.phoneE164)) ('Phone', patient.phoneE164!),
    ];
    final medical = <(String, String)>[
      if (_has(patient.bloodGroup)) ('Blood group', patient.bloodGroup!),
      if (_has(patient.allergies)) ('Allergies', patient.allergies!),
    ];

    return ListView(
      padding: const EdgeInsets.all(HealynSpacing.screenEdge),
      children: [
        _Header(patient: patient),
        const SizedBox(height: HealynSpacing.s6),
        const _SectionTitle('Personal details'),
        const SizedBox(height: HealynSpacing.s3),
        _DetailCard(rows: details),
        if (medical.isNotEmpty) ...[
          const SizedBox(height: HealynSpacing.s6),
          const _SectionTitle('Medical'),
          const SizedBox(height: HealynSpacing.s3),
          _DetailCard(rows: medical),
        ],
        const SizedBox(height: HealynSpacing.s6),
        const _SectionTitle('Signed-in devices'),
        const SizedBox(height: HealynSpacing.s3),
        const _Sessions(),
        const SizedBox(height: HealynSpacing.s6),
        OutlinedButton.icon(
          onPressed: () =>
              ref.read(authControllerProvider.notifier).logout(),
          icon: const Icon(Icons.logout),
          label: const Text('Sign out'),
          style: OutlinedButton.styleFrom(
            foregroundColor: HealynColors.statusDanger,
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: HealynColors.borderSubtle),
          ),
        ),
      ],
    );
  }

  static bool _has(String? s) => s != null && s.trim().isNotEmpty;
}

class _Header extends StatelessWidget {
  const _Header({required this.patient});

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: HealynColors.brandPrimarySubtle,
            child: Text(
              patientInitials(patient.fullName),
              style: HealynTypography.h3.copyWith(
                color: HealynColors.brandPrimaryHover,
              ),
            ),
          ),
          const SizedBox(width: HealynSpacing.s4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(patient.fullName, style: HealynTypography.h2),
                const SizedBox(height: HealynSpacing.s1),
                Text(
                  'Primary patient',
                  style: HealynTypography.caption.copyWith(
                    color: HealynColors.brandPrimaryHover,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text.toUpperCase(), style: HealynTypography.overline);
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const Divider(height: HealynSpacing.s5),
            _DetailRow(label: rows[i].$1, value: rows[i].$2),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(label, style: HealynTypography.caption),
        ),
        const SizedBox(width: HealynSpacing.s3),
        Expanded(child: Text(value, style: HealynTypography.body)),
      ],
    );
  }
}

class _Sessions extends ConsumerWidget {
  const _Sessions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(_sessionsProvider);
    return SectionCard(
      child: sessions.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: HealynSpacing.s3),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => const Text(
          'Could not load your devices.',
          style: HealynTypography.caption,
        ),
        data: (items) => Column(
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) const Divider(height: HealynSpacing.s5),
              _SessionRow(session: items[i]),
            ],
          ],
        ),
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.session});

  final SessionView session;

  @override
  Widget build(BuildContext context) {
    final label = session.deviceLabel?.isNotEmpty == true
        ? session.deviceLabel!
        : session.deviceId;
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
              Text(label, style: HealynTypography.bodyStrong),
              Text(
                'Last active ${_shortDateTime(session.lastSeenAt)}',
                style: HealynTypography.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String _shortDateTime(DateTime d) {
  final local = d.toLocal();
  return '${formatBirthDate(local)} '
      '${local.hour.toString().padLeft(2, '0')}:'
      '${local.minute.toString().padLeft(2, '0')}';
}
