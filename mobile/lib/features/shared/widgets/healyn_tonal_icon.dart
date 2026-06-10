import 'package:flutter/material.dart';

import '../design/radii.dart';

/// The recurring *Refined Indigo* motif: a small rounded tile holding a single
/// icon, filled with a 12% tint of the icon's own hue. Used in stat cards,
/// banners and list leading slots so a status/brand colour reads at a glance
/// without shouting.
///
/// Pure presentation — pass any [color] from the `Healyn*` palette; the tile
/// derives its fill from it.
class HealynTonalIcon extends StatelessWidget {
  const HealynTonalIcon({
    required this.icon,
    required this.color,
    this.size = 34,
    this.iconSize,
    super.key,
  });

  /// The glyph to render, centred in the tile.
  final IconData icon;

  /// The icon hue; the tile fill is this colour at 12% opacity.
  final Color color;

  /// The tile's width and height. Defaults to the 34dp standard.
  final double size;

  /// The glyph size. Defaults to ~53% of [size] (≈18 at the standard 34).
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: HealynRadii.brMd,
      ),
      child: Icon(icon, size: iconSize ?? size * 0.53, color: color),
    );
  }
}
