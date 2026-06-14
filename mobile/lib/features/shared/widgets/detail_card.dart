import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design/colors.dart';
import '../design/radii.dart';
import '../design/spacing.dart';
import '../design/typography.dart';
import 'section_card.dart';

/// One labelled key/value row inside a [DetailCard].
///
/// When [copyable] is set the value becomes tappable and copies itself to the
/// clipboard. [onCall] adds a trailing phone affordance; callers pass it only
/// where a call action is appropriate (the physiotherapist's patient view) and
/// omit it everywhere else (the patient's own profile), so the icon never shows
/// to the patient.
class DetailRowData {
  const DetailRowData(
    this.label,
    this.value, {
    this.copyable = false,
    this.onCall,
  });

  final String label;
  final String value;
  final bool copyable;
  final VoidCallback? onCall;
}

/// A card of labelled detail rows (e.g. personal details, medical info).
class DetailCard extends StatelessWidget {
  const DetailCard({required this.rows, super.key});

  final List<DetailRowData> rows;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const Divider(height: HealynSpacing.s5),
            _DetailRow(data: rows[i]),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.data});

  final DetailRowData data;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: data.value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Copied')));
  }

  @override
  Widget build(BuildContext context) {
    final Widget value = data.copyable
        ? Semantics(
            button: true,
            label: 'Copy ${data.value}',
            child: Tooltip(
              message: 'Copy',
              child: InkWell(
                onTap: () => _copy(context),
                borderRadius: HealynRadii.brSm,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          data.value,
                          style: HealynTypography.body,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: HealynSpacing.s1),
                      const Icon(
                        Icons.copy_rounded,
                        size: 14,
                        color: HealynColors.textMuted,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Text(data.value, style: HealynTypography.body);

    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(data.label, style: HealynTypography.caption),
        ),
        const SizedBox(width: HealynSpacing.s3),
        Expanded(child: value),
        if (data.onCall != null) ...[
          const SizedBox(width: HealynSpacing.s2),
          IconButton(
            onPressed: data.onCall,
            tooltip: 'Call',
            color: HealynColors.brandPrimary,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            icon: const Icon(Icons.call_rounded, size: 20),
          ),
        ],
      ],
    );
  }
}
