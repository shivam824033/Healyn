import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design/colors.dart';
import '../design/radii.dart';
import '../design/spacing.dart';
import '../design/typography.dart';

/// A compact, tappable identifier (e.g. an appointment or patient number) with a
/// copy affordance. Tapping copies [value] to the clipboard and shows a brief
/// "Copied" confirmation. These are display-only business ids — safe to copy and
/// share (never the internal UUID, never PHI).
class CopyableId extends StatelessWidget {
  const CopyableId({required this.value, this.style, this.color, super.key});

  final String value;

  /// Text style for the id; defaults to [HealynTypography.caption].
  final TextStyle? style;

  /// Foreground for the text + icon; defaults to [HealynColors.textMuted].
  final Color? color;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Copied')));
  }

  @override
  Widget build(BuildContext context) {
    final fg = color ?? HealynColors.textMuted;
    final textStyle = (style ?? HealynTypography.caption).copyWith(color: fg);
    return Semantics(
      button: true,
      label: 'Copy $value',
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
                    value,
                    style: textStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: HealynSpacing.s1),
                Icon(Icons.copy_rounded, size: 14, color: fg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
