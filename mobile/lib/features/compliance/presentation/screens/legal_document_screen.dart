import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/error_banner.dart';
import '../../../shared/widgets/healyn_skeletons.dart';
import '../../data/models/compliance_models.dart';
import '../compliance_providers.dart';

/// Reader for a Privacy Policy / Terms document (API_STANDARDS §9.9). Public —
/// reachable from the registration consent links before sign-in. The body is
/// served as Markdown; it is rendered as plain selectable text (no Markdown
/// dependency in Phase 1).
class LegalDocumentScreen extends ConsumerWidget {
  const LegalDocumentScreen({required this.kindPath, super.key});

  /// The path segment, e.g. `privacy_policy` (LegalDocumentKind.path).
  final String kindPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fallbackTitle = LegalDocumentKind.fromPath(kindPath)?.title ?? 'Legal';
    final doc = ref.watch(legalDocumentProvider(kindPath));
    return Scaffold(
      backgroundColor: HealynColors.surfaceAlt,
      appBar: HealynAppBar(title: fallbackTitle),
      body: SafeArea(
        child: doc.when(
          loading: () => const HealynListSkeleton(
            hasLeading: false,
            hasFooter: false,
            count: 6,
          ),
          error: (_, _) => ListView(
            padding: const EdgeInsets.all(HealynSpacing.screenEdge),
            children: [
              const ErrorBanner(
                message: 'Could not load this document. Try again.',
              ),
              const SizedBox(height: HealynSpacing.s4),
              OutlinedButton(
                onPressed: () =>
                    ref.invalidate(legalDocumentProvider(kindPath)),
                child: const Text('Try again'),
              ),
            ],
          ),
          data: (d) => _Body(doc: d),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.doc});

  final LegalDocument doc;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(HealynSpacing.screenEdge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(doc.title, style: HealynTypography.h2),
          const SizedBox(height: HealynSpacing.s1),
          Text(
            _versionLine(doc),
            style: HealynTypography.caption.copyWith(
              color: HealynColors.textMuted,
            ),
          ),
          const SizedBox(height: HealynSpacing.s5),
          SelectableText(doc.bodyMarkdown, style: HealynTypography.body),
        ],
      ),
    );
  }

  static String _versionLine(LegalDocument d) {
    final effective = d.effectiveAt;
    final when = effective == null ? null : _formatDate(effective.toLocal());
    return when == null
        ? 'Version ${d.version}'
        : 'Version ${d.version} · Effective $when';
  }

  static String _formatDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
