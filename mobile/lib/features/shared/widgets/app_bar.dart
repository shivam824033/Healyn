import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design/colors.dart';
import '../design/elevation.dart';
import '../design/typography.dart';

/// The app's premium header: a brand indigo gradient ([HealynColors.brandGradient])
/// behind a white title and white icons, with a soft drop shadow that lifts the
/// bar off the content below. Drop-in for Material's [AppBar] — pass a [title]
/// string (or a custom [titleWidget]) plus optional [actions] / [leading].
///
/// Implements [PreferredSizeWidget] so it can be handed straight to
/// `Scaffold.appBar`, accounting for an optional [bottom] band.
class HealynAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HealynAppBar({
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.bottom,
    this.centerTitle = false,
    super.key,
  }) : assert(
         title == null || titleWidget == null,
         'Pass either a title string or a titleWidget, not both.',
       );

  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      actions: actions,
      leading: leading,
      bottom: bottom,
      centerTitle: centerTitle,
      // The gradient lives in flexibleSpace; keep the bar itself transparent so
      // it shows through, and suppress M3's scroll-under surface tint.
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      foregroundColor: HealynColors.textInverse,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: const IconThemeData(color: HealynColors.textInverse),
      actionsIconTheme: const IconThemeData(color: HealynColors.textInverse),
      titleTextStyle: HealynTypography.h2.copyWith(
        color: HealynColors.textInverse,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      // A bare DecoratedBox here collapses to zero height (flexibleSpace passes
      // loose constraints), leaving the header transparent — so fill it.
      flexibleSpace: DecoratedBox(
        decoration: BoxDecoration(
          gradient: HealynColors.brandGradient,
          boxShadow: HealynElevation.e2,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}
