import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../design/radii.dart';
import '../design/typography.dart';

/// A circular initials avatar on a deterministic tonal fill. The colour is
/// chosen by hashing [seed] (falling back to [name]) into a small brand-adjacent
/// palette, so the same patient always gets the same hue across the app while
/// the set stays calm and on-brand.
///
/// Pure presentation: no image loading, no network. Initials are derived from
/// [name]; the glyph auto-scales to the avatar [size].
class HealynAvatar extends StatelessWidget {
  const HealynAvatar({
    required this.name,
    this.seed,
    this.size = 40,
    super.key,
  });

  /// The display name the initials are taken from.
  final String name;

  /// A stable key (e.g. a patient id) used to pick the fill colour. When null,
  /// [name] is used so the colour is still deterministic.
  final String? seed;

  /// The avatar's diameter.
  final double size;

  /// Brand-adjacent hues; each row is paired with a 14% tonal fill below.
  static const List<Color> _palette = [
    HealynColors.brandPrimary,
    HealynColors.statusInfo,
    HealynColors.statusSuccess,
    HealynColors.statusWarning,
  ];

  @override
  Widget build(BuildContext context) {
    final color = _palette[_hash(seed ?? name) % _palette.length];
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(HealynRadii.full),
      ),
      child: Padding(
        padding: EdgeInsets.all(size * 0.2),
        child: FittedBox(
          child: Text(
            _initials(name),
            // Avatars are fixed graphics — don't let system text scaling
            // distort them; FittedBox already fits the glyph to the tile.
            textScaler: TextScaler.noScaling,
            style: HealynTypography.bodyStrong.copyWith(color: color),
          ),
        ),
      ),
    );
  }

  /// Up to two initials, uppercased. Empty/blank names fall back to "?".
  static String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  /// A small, platform-stable hash of [key] (String.hashCode is not guaranteed
  /// stable across runs, so sum the code units instead).
  static int _hash(String key) {
    var h = 0;
    for (final unit in key.codeUnits) {
      h = (h + unit) % 100000;
    }
    return h;
  }
}
