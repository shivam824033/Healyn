import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/design/spacing.dart';
import '../appointments_providers.dart';

/// The horizontal filter row above an appointments list: a single-select status
/// group plus an orthogonal "Follow-ups" toggle. Parameterised by the filter
/// [StateProvider] so the patient and physiotherapist lists each keep their own
/// selection. Selecting any chip updates that provider, which reloads the list's
/// first page.
class AppointmentFilterBar extends ConsumerWidget {
  const AppointmentFilterBar({required this.filterProvider, super.key});

  final StateProvider<AppointmentListFilter> filterProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);
    final notifier = ref.read(filterProvider.notifier);
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: HealynSpacing.screenEdge,
          vertical: HealynSpacing.s2,
        ),
        children: [
          for (final status in AppointmentStatusFilter.values) ...[
            ChoiceChip(
              label: Text(status.label),
              selected: filter.status == status,
              onSelected: (_) =>
                  notifier.state = filter.copyWith(status: status),
            ),
            const SizedBox(width: HealynSpacing.s2),
          ],
          // Orthogonal to the status group: combines with it (AND).
          const SizedBox(width: HealynSpacing.s2),
          FilterChip(
            label: const Text('Follow-ups'),
            selected: filter.followUpOnly,
            onSelected: (v) => notifier.state = filter.copyWith(followUpOnly: v),
          ),
        ],
      ),
    );
  }
}
