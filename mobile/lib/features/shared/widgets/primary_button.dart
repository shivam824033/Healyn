import 'package:flutter/material.dart';

import '../design/colors.dart';

/// The single primary action on a screen (UI_UX_GUIDELINES §5.1). Shows an
/// inline spinner while [loading] and disables itself so the action can't fire
/// twice.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.loading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      child: loading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: HealynColors.textInverse,
              ),
            )
          : Text(label),
    );
  }
}
