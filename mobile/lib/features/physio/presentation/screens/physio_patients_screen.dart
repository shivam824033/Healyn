import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../patients/data/models/patient_models.dart';
import '../../../patients/data/patients_repository.dart';
import '../../../patients/presentation/patient_format.dart';
import '../../../shared/domain/patient_sex.dart';
import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/network/api_exception.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/healyn_avatar.dart';
import '../../../shared/widgets/healyn_list_row.dart';
import '../../../shared/widgets/healyn_reveal.dart';
import '../../../shared/widgets/healyn_skeletons.dart';

/// The physiotherapist's patient roster (C6, F1.16). The practice can grow
/// large, so the list is loaded a page at a time newest-first (`GET /patients`
/// returns a cursor page for a physio) with infinite scroll, and search runs
/// server-side over patient **name** and **Patient ID** (PAT-NNNNNN). Tapping a
/// patient opens their detail + history.
class PhysioPatientsScreen extends ConsumerStatefulWidget {
  const PhysioPatientsScreen({super.key});

  @override
  ConsumerState<PhysioPatientsScreen> createState() =>
      _PhysioPatientsScreenState();
}

class _PhysioPatientsScreenState extends ConsumerState<PhysioPatientsScreen> {
  static const _debounce = Duration(milliseconds: 350);

  final _search = TextEditingController();
  final _scroll = ScrollController();
  Timer? _debounceTimer;

  final List<Patient> _items = [];
  String _query = '';
  String? _cursor;
  bool _loading = false;
  bool _loadedOnce = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _load(reset: true);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scroll.dispose();
    _search.dispose();
    super.dispose();
  }

  bool get _hasMore => _cursor != null;

  void _onScroll() {
    // Pull the next page once scrolled near the bottom — only when one exists
    // and we're idle, so we never fire overlapping requests.
    if (_hasMore &&
        !_loading &&
        _scroll.position.pixels >= _scroll.position.maxScrollExtent - 320) {
      _load();
    }
  }

  void _onSearchChanged(String value) {
    final next = value.trim();
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounce, () {
      if (next == _query) return;
      _query = next;
      _load(reset: true);
    });
  }

  Future<void> _load({bool reset = false}) async {
    if (_loading) return;
    setState(() {
      _loading = true;
      if (reset) {
        _error = null;
        // Keep the old items on screen until the new first page arrives only on
        // refresh; for a fresh search we clear so stale rows don't linger.
        _items.clear();
        _cursor = null;
        _loadedOnce = false;
      }
    });
    try {
      final page = await ref
          .read(patientsRepositoryProvider)
          .listRoster(cursor: reset ? null : _cursor, q: _query.isEmpty ? null : _query);
      if (!mounted) return;
      setState(() {
        _items.addAll(page.patients);
        _cursor = page.nextCursor;
        _loading = false;
        _loadedOnce = true;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadedOnce = true;
        _error = e.message;
      });
    }
  }

  Future<void> _refresh() => _load(reset: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: const HealynAppBar(title: 'Patients'),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                HealynSpacing.screenEdge,
                HealynSpacing.s3,
                HealynSpacing.screenEdge,
                HealynSpacing.s2,
              ),
              child: TextField(
                controller: _search,
                textInputAction: TextInputAction.search,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search by name or Patient ID',
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                  border: const OutlineInputBorder(),
                  suffixIcon: _search.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear',
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _search.clear();
                            _onSearchChanged('');
                          },
                        ),
                ),
              ),
            ),
            Expanded(child: _body()),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    if (!_loadedOnce && _loading) {
      return const HealynListSkeleton(hasFooter: false);
    }
    if (_error != null && _items.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(HealynSpacing.screenEdge),
          children: [
            ErrorBanner(message: _error ?? 'Could not load patients.'),
          ],
        ),
      );
    }
    if (_items.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refresh,
        child: _EmptyRoster(searching: _query.isNotEmpty),
      );
    }
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.separated(
        controller: _scroll,
        padding: const EdgeInsets.all(HealynSpacing.screenEdge),
        // One extra slot for the bottom loader / load-more affordance.
        itemCount: _items.length + (_hasMore ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: HealynSpacing.s3),
        itemBuilder: (_, i) {
          if (i >= _items.length) return const _PageLoader();
          return HealynReveal.staggered(
            index: i < 6 ? i : 6,
            child: _PatientTile(patient: _items[i]),
          );
        },
      ),
    );
  }
}

class _PatientTile extends StatelessWidget {
  const _PatientTile({required this.patient});

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    final age = patientAgeInYears(patient.dateOfBirth);
    final sex = patient.sex?.label;
    final demographics = sex == null ? 'Age $age' : 'Age $age · $sex';
    // Lead with the Patient ID so the physio can confirm an exact match at a glance.
    final number = patient.patientNumber;
    final subtitle = number == null ? demographics : '$number · $demographics';
    return HealynListRow(
      leading: HealynAvatar(name: patient.fullName, seed: patient.id, size: 44),
      title: patient.fullName,
      subtitle: subtitle,
      onTap: () =>
          context.push('/physio/patients/${patient.id}', extra: patient),
    );
  }
}

class _PageLoader extends StatelessWidget {
  const _PageLoader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: HealynSpacing.s4),
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

class _EmptyRoster extends StatelessWidget {
  const _EmptyRoster({required this.searching});

  final bool searching;

  @override
  Widget build(BuildContext context) {
    // A scrollable so pull-to-refresh works with an empty roster.
    return ListView(
      padding: const EdgeInsets.all(HealynSpacing.s8),
      children: [
        const SizedBox(height: HealynSpacing.s8),
        Icon(
          searching ? Icons.search_off : Icons.people_outline,
          size: 48,
          color: HealynColors.textMuted,
        ),
        const SizedBox(height: HealynSpacing.s4),
        Text(
          searching ? 'No matches' : 'No patients yet',
          style: HealynTypography.h3,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: HealynSpacing.s2),
        Text(
          searching
              ? 'No patient matches that name or Patient ID.'
              : 'Patients appear here once they register and book.',
          style: HealynTypography.body.copyWith(
            color: HealynColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
