import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/widgets/healyn_state_switcher.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/healyn_list_row.dart';
import '../../../shared/widgets/healyn_skeletons.dart';
import '../../data/models/treatment_note_models.dart';
import '../../data/treatment_notes_repository.dart';
import '../treatment_notes_format.dart';

/// Who is viewing the treatment-note history. The thread of notes is identical;
/// only the appointment a note links to (the patient app vs the `/physio/*`
/// area) and the empty-state wording differ.
enum TreatmentHistoryViewer { patient, physio }

/// A patient's treatment-note history (F1.17) — every note the physiotherapist
/// has written for this patient, newest first, paged with a cursor and loaded as
/// the list nears its end. Reached from the patient's Profile or, for the physio
/// ([TreatmentHistoryViewer.physio]), from a patient in the roster. Tapping a
/// note opens its appointment detail (which renders the full note). Read-only.
class TreatmentNotesTimelineScreen extends ConsumerStatefulWidget {
  const TreatmentNotesTimelineScreen({
    required this.patientId,
    this.patientName,
    this.viewer = TreatmentHistoryViewer.patient,
    super.key,
  });

  final String patientId;

  /// Shown as the app-bar subtitle so a family member's (or roster) history is
  /// identifiable.
  final String? patientName;

  final TreatmentHistoryViewer viewer;

  /// The route a note tile opens — the same appointment in each app's own area,
  /// so the role redirect never bounces the physio out.
  String get appointmentRoutePrefix => switch (viewer) {
    TreatmentHistoryViewer.patient => '/appointments',
    TreatmentHistoryViewer.physio => '/physio/appointments',
  };

  @override
  ConsumerState<TreatmentNotesTimelineScreen> createState() =>
      _TreatmentNotesTimelineScreenState();
}

class _TreatmentNotesTimelineScreenState
    extends ConsumerState<TreatmentNotesTimelineScreen> {
  final _scroll = ScrollController();
  final List<TreatmentNote> _notes = [];
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
          .read(treatmentNotesRepositoryProvider)
          .forPatient(widget.patientId, limit: 20);
      if (!mounted) return;
      setState(() {
        _notes
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
          .read(treatmentNotesRepositoryProvider)
          .forPatient(widget.patientId, cursor: _nextCursor, limit: 20);
      if (!mounted) return;
      setState(() {
        _notes.addAll(page.items);
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
            const Text('Treatment history'),
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
              key: ValueKey('notes-loading'),
              hasLeading: false,
              hasFooter: true,
            )
          : RefreshIndicator(
              key: const ValueKey('notes-data'),
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
    if (_notes.isEmpty) {
      return _EmptyHistory(viewer: widget.viewer);
    }
    return ListView.separated(
      controller: _scroll,
      padding: const EdgeInsets.all(HealynSpacing.screenEdge),
      itemCount: _notes.length + (_nextCursor != null ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: HealynSpacing.s3),
      itemBuilder: (context, i) {
        if (i >= _notes.length) {
          return const Padding(
            padding: EdgeInsets.all(HealynSpacing.s4),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        return _NoteTile(
          note: _notes[i],
          routePrefix: widget.appointmentRoutePrefix,
        );
      },
    );
  }
}

class _NoteTile extends StatelessWidget {
  const _NoteTile({required this.note, required this.routePrefix});

  final TreatmentNote note;
  final String routePrefix;

  @override
  Widget build(BuildContext context) {
    final secondary = _secondaryText(note);
    final reviewAt = note.nextReviewAt;
    // The note's headline (diagnosis/notes) reads on the title; the date anchors
    // the timeline as the strong leading line; details and the next-review
    // accent fall to the footer.
    final footerItems = <Widget>[
      if (secondary != null)
        Text(
          secondary,
          style: HealynTypography.body.copyWith(
            color: HealynColors.textSecondary,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      if (reviewAt != null)
        Row(
          children: [
            const Icon(
              Icons.event_outlined,
              size: 16,
              color: HealynColors.brandPrimaryHover,
            ),
            const SizedBox(width: HealynSpacing.s2),
            Expanded(
              child: Text(
                'Next review · ${formatReviewWhen(reviewAt)}',
                style: HealynTypography.caption.copyWith(
                  color: HealynColors.brandPrimaryHover,
                ),
              ),
            ),
          ],
        ),
    ];

    return HealynListRow(
      title: formatNoteDate(note.createdAt),
      subtitle: _primaryText(note),
      footer: footerItems.isEmpty
          ? null
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                footerItems.first,
                for (final w in footerItems.skip(1)) ...[
                  const SizedBox(height: HealynSpacing.s2),
                  w,
                ],
              ],
            ),
      onTap: () => context.push('$routePrefix/${note.appointmentId}'),
    );
  }

  /// The headline snippet — diagnosis if present, else the most salient text.
  static String _primaryText(TreatmentNote n) {
    if (_has(n.diagnosis)) return n.diagnosis!.trim();
    if (_has(n.notes)) return n.notes!.trim();
    return n.recoveryInstructions!.trim();
  }

  /// A second line only when the headline was the diagnosis (otherwise the
  /// headline already used the remaining text).
  static String? _secondaryText(TreatmentNote n) {
    if (!_has(n.diagnosis)) return null;
    if (_has(n.notes)) return n.notes!.trim();
    if (_has(n.recoveryInstructions)) return n.recoveryInstructions!.trim();
    return null;
  }

  static bool _has(String? s) => s != null && s.trim().isNotEmpty;
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory({required this.viewer});

  final TreatmentHistoryViewer viewer;

  @override
  Widget build(BuildContext context) {
    final subtitle = switch (viewer) {
      TreatmentHistoryViewer.patient =>
        'After a completed appointment, your physiotherapist’s notes will '
            'appear here.',
      TreatmentHistoryViewer.physio =>
        'Notes written after a completed appointment will appear here.',
    };
    // A scrollable so pull-to-refresh works with no notes.
    return ListView(
      padding: const EdgeInsets.all(HealynSpacing.s8),
      children: [
        const SizedBox(height: HealynSpacing.s8),
        const Icon(
          Icons.assignment_outlined,
          size: 48,
          color: HealynColors.textMuted,
        ),
        const SizedBox(height: HealynSpacing.s4),
        const Text(
          'No treatment notes yet',
          style: HealynTypography.h3,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: HealynSpacing.s2),
        Text(
          subtitle,
          style: HealynTypography.body.copyWith(
            color: HealynColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
