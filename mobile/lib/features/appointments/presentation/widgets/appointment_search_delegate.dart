import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../patients/presentation/widgets/patient_avatar.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../data/models/appointment_models.dart';
import '../appointment_format.dart';
import '../appointments_providers.dart';
import 'appointment_status_chip.dart';

/// The header search: a Material app-bar search field with live (debounced)
/// autocomplete over [appointmentSearchProvider]. Backs both roles — selecting a
/// row closes the overlay and returns the chosen [AppointmentSuggestion], leaving
/// navigation to the caller (so the same delegate can route into either app).
///
/// Open it with `showSearch<AppointmentSuggestion?>(...)`; a null result means the
/// user dismissed without choosing.
class AppointmentSearchDelegate extends SearchDelegate<AppointmentSuggestion?> {
  AppointmentSearchDelegate() : super(searchFieldLabel: 'Search appointments');

  @override
  List<Widget>? buildActions(BuildContext context) => [
    if (query.isNotEmpty)
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    tooltip: 'Back',
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  // Autocomplete and "submit" render the same list — the result is the live set.
  @override
  Widget buildResults(BuildContext context) => _body(context);

  @override
  Widget buildSuggestions(BuildContext context) => _body(context);

  Widget _body(BuildContext context) => _AppointmentSearchBody(
    query: query,
    onSelect: (suggestion) => close(context, suggestion),
  );
}

/// The debounced results body. Holds the live [query] from the delegate and only
/// queries the backend after a short pause, watching the per-term provider so
/// re-typing a prefix re-uses the cached result.
class _AppointmentSearchBody extends ConsumerStatefulWidget {
  const _AppointmentSearchBody({required this.query, required this.onSelect});

  final String query;
  final void Function(AppointmentSuggestion) onSelect;

  @override
  ConsumerState<_AppointmentSearchBody> createState() =>
      _AppointmentSearchBodyState();
}

class _AppointmentSearchBodyState
    extends ConsumerState<_AppointmentSearchBody> {
  static const _debounce = Duration(milliseconds: 300);

  Timer? _timer;
  String _debounced = '';

  @override
  void initState() {
    super.initState();
    _debounced = widget.query.trim();
  }

  @override
  void didUpdateWidget(covariant _AppointmentSearchBody old) {
    super.didUpdateWidget(old);
    if (old.query == widget.query) return;
    _timer?.cancel();
    final next = widget.query.trim();
    // Below the minimum we never hit the network, so reflect it immediately;
    // otherwise wait out the debounce before swapping the watched term.
    if (next.length < appointmentSearchMinLength) {
      setState(() => _debounced = next);
    } else {
      _timer = Timer(_debounce, () {
        if (mounted) setState(() => _debounced = next);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _debounced;
    if (q.length < appointmentSearchMinLength) {
      return const _SearchMessage(
        icon: Icons.search,
        text: 'Search by appointment number, patient name or patient number.',
      );
    }
    final results = ref.watch(appointmentSearchProvider(q));
    return results.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => const _SearchMessage(
        icon: Icons.error_outline,
        text: 'Could not search right now. Try again.',
      ),
      data: (items) {
        if (items.isEmpty) {
          return _SearchMessage(
            icon: Icons.search_off,
            text: 'No appointments match "$q".',
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: HealynSpacing.s2),
          itemCount: items.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (_, i) =>
              _SuggestionTile(suggestion: items[i], onTap: widget.onSelect),
        );
      },
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({required this.suggestion, required this.onTap});

  final AppointmentSuggestion suggestion;
  final void Function(AppointmentSuggestion) onTap;

  @override
  Widget build(BuildContext context) {
    final number = suggestion.appointmentNumber;
    final subtitle = [
      ?number,
      _whenLine(suggestion),
    ].join(' · ');
    return ListTile(
      leading: PatientAvatar(name: suggestion.patientName ?? '', radius: 18),
      title: Text(
        suggestion.patientName ?? 'Unknown patient',
        style: HealynTypography.bodyStrong,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        subtitle,
        style: HealynTypography.caption.copyWith(color: HealynColors.textMuted),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: AppointmentStatusChip(status: suggestion.status),
      onTap: () => onTap(suggestion),
    );
  }

  /// `Wed, 10 Jun · 9:00 AM` once scheduled, else the requested day.
  static String _whenLine(AppointmentSuggestion s) {
    final at = s.scheduledAt;
    if (at != null) return '${formatDateShort(at)} · ${formatTimeOfDay(at)}';
    return formatDateShort(s.requestedDate);
  }
}

class _SearchMessage extends StatelessWidget {
  const _SearchMessage({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(HealynSpacing.s8),
      children: [
        const SizedBox(height: HealynSpacing.s8),
        Icon(icon, size: 48, color: HealynColors.textMuted),
        const SizedBox(height: HealynSpacing.s4),
        Text(
          text,
          style: HealynTypography.body.copyWith(
            color: HealynColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
