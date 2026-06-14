import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/healyn_list_row.dart';
import '../../../shared/widgets/healyn_section_header.dart';
import '../../../shared/widgets/healyn_skeletons.dart';
import '../../../shared/widgets/healyn_state_switcher.dart';
import '../../data/appointments_repository.dart';
import '../../data/models/appointment_models.dart';
import '../appointment_format.dart';
import '../appointments_providers.dart';
import '../widgets/appointment_status_chip.dart';

/// Who is viewing the per-patient appointment history. The list is identical;
/// only the appointment route a row opens (the patient app vs the `/physio/*`
/// area, so the role redirect never bounces the physio out) differs.
enum AppointmentHistoryViewer { patient, physio }

/// Every appointment for one patient, newest-first, cursor-paged and loaded as
/// the list nears its end. Split into Upcoming (still open) and Past sections.
/// Reached from a patient's profile (the physiotherapist's patient detail, or
/// the patient's own Profile) so the whole record is in one place. Tapping a row
/// opens the appointment detail. Read-only.
class PatientAppointmentsScreen extends ConsumerStatefulWidget {
  const PatientAppointmentsScreen({
    required this.patientId,
    this.patientName,
    this.viewer = AppointmentHistoryViewer.patient,
    super.key,
  });

  final String patientId;

  /// Shown as the app-bar subtitle so a family member's (or roster) history is
  /// identifiable.
  final String? patientName;

  final AppointmentHistoryViewer viewer;

  /// The route a row opens — the same appointment in each app's own area.
  String get appointmentRoutePrefix => switch (viewer) {
    AppointmentHistoryViewer.patient => '/appointments',
    AppointmentHistoryViewer.physio => '/physio/appointments',
  };

  @override
  ConsumerState<PatientAppointmentsScreen> createState() =>
      _PatientAppointmentsScreenState();
}

class _PatientAppointmentsScreenState
    extends ConsumerState<PatientAppointmentsScreen> {
  final _scroll = ScrollController();
  final List<Appointment> _appointments = [];
  String? _nextCursor;
  bool _loading = true;
  bool _loadingMore = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _loadInitial();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 240) {
      _loadMore();
    }
  }

  Future<void> _loadInitial() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final page = await ref
          .read(appointmentsRepositoryProvider)
          .list(patientId: widget.patientId, limit: 20);
      if (!mounted) return;
      setState(() {
        _appointments
          ..clear()
          ..addAll(page.items);
        _nextCursor = page.nextCursor;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _loadError = e.message;
          _loading = false;
        });
      }
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || _nextCursor == null) return;
    setState(() => _loadingMore = true);
    try {
      final page = await ref
          .read(appointmentsRepositoryProvider)
          .list(patientId: widget.patientId, cursor: _nextCursor, limit: 20);
      if (!mounted) return;
      setState(() {
        _appointments.addAll(page.items);
        _nextCursor = page.nextCursor;
        _loadingMore = false;
      });
    } on ApiException catch (_) {
      // A failed page-load shouldn't wipe what's shown; leave the cursor so the
      // next scroll retries.
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: HealynAppBar(
        titleWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Appointment history'),
            if (widget.patientName != null)
              Text(
                widget.patientName!,
                style: HealynTypography.caption.copyWith(
                  color: HealynColors.textInverse.withValues(alpha: 0.8),
                ),
              ),
          ],
        ),
      ),
      body: SafeArea(child: _body()),
    );
  }

  Widget _body() {
    return HealynStateSwitcher(
      child: _loading
          ? const HealynListSkeleton(
              key: ValueKey('appts-loading'),
              hasLeading: false,
              hasFooter: true,
              showHeader: true,
            )
          : RefreshIndicator(
              key: const ValueKey('appts-data'),
              onRefresh: _loadInitial,
              child: _list(),
            ),
    );
  }

  Widget _list() {
    if (_loadError != null) {
      return ListView(
        padding: const EdgeInsets.all(HealynSpacing.screenEdge),
        children: [
          ErrorBanner(message: _loadError!),
          const SizedBox(height: HealynSpacing.s4),
          Center(
            child: TextButton(
              onPressed: _loadInitial,
              child: const Text('Retry'),
            ),
          ),
        ],
      );
    }
    if (_appointments.isEmpty) {
      return const _EmptyHistory();
    }
    final upcoming = upcomingOf(_appointments);
    final past = pastOf(_appointments);
    return ListView(
      controller: _scroll,
      padding: const EdgeInsets.all(HealynSpacing.screenEdge),
      children: [
        if (upcoming.isNotEmpty) ...[
          const HealynSectionHeader(title: 'Upcoming'),
          const SizedBox(height: HealynSpacing.s3),
          for (final a in upcoming) ...[
            _AppointmentTile(
              appointment: a,
              routePrefix: widget.appointmentRoutePrefix,
            ),
            const SizedBox(height: HealynSpacing.s3),
          ],
        ],
        if (past.isNotEmpty) ...[
          if (upcoming.isNotEmpty) const SizedBox(height: HealynSpacing.s4),
          const HealynSectionHeader(title: 'Past'),
          const SizedBox(height: HealynSpacing.s3),
          for (final a in past) ...[
            _AppointmentTile(
              appointment: a,
              routePrefix: widget.appointmentRoutePrefix,
            ),
            const SizedBox(height: HealynSpacing.s3),
          ],
        ],
        if (_nextCursor != null)
          const Padding(
            padding: EdgeInsets.all(HealynSpacing.s4),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
      ],
    );
  }
}

class _AppointmentTile extends StatelessWidget {
  const _AppointmentTile({required this.appointment, required this.routePrefix});

  final Appointment appointment;
  final String routePrefix;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if (appointment.isScheduled) formatDuration(appointment.durationMinutes),
      ?appointment.appointmentNumber,
    ].join(' · ');
    return HealynListRow(
      title: formatAppointmentWhenShort(appointment),
      subtitle: subtitle.isEmpty ? null : subtitle,
      footer: AppointmentStatusChip(status: appointment.status),
      onTap: () => context.push(
        '$routePrefix/${appointment.id}',
        extra: appointment,
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    // A scrollable so pull-to-refresh works with no appointments.
    return ListView(
      padding: const EdgeInsets.all(HealynSpacing.s8),
      children: [
        const SizedBox(height: HealynSpacing.s8),
        const Icon(
          Icons.event_outlined,
          size: 48,
          color: HealynColors.textMuted,
        ),
        const SizedBox(height: HealynSpacing.s4),
        const Text(
          'No appointments yet',
          style: HealynTypography.h3,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: HealynSpacing.s2),
        Text(
          'Appointments for this patient will appear here.',
          style: HealynTypography.body.copyWith(
            color: HealynColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
