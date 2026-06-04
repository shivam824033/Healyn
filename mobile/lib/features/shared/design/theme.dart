import 'package:flutter/material.dart';

import 'colors.dart';
import 'radii.dart';
import 'spacing.dart';
import 'typography.dart';

/// Builds Flutter's [ThemeData] from the Healyn design tokens. One source of
/// truth: components read the theme, never hard-coded colors. Theming is
/// provider-scoped (see app wiring) so dark mode (Phase 2) is a config swap.
abstract final class HealynTheme {
  static ThemeData light() {
    const scheme = ColorScheme.light(
      primary: HealynColors.brandPrimary,
      onPrimary: HealynColors.textInverse,
      primaryContainer: HealynColors.brandPrimarySubtle,
      onPrimaryContainer: HealynColors.brandPrimaryHover,
      surface: HealynColors.surfaceBase,
      onSurface: HealynColors.textPrimary,
      error: HealynColors.statusDanger,
      onError: HealynColors.textInverse,
      outline: HealynColors.borderSubtle,
    );

    const textTheme = TextTheme(
      displaySmall: HealynTypography.display,
      headlineMedium: HealynTypography.h1,
      headlineSmall: HealynTypography.h2,
      titleMedium: HealynTypography.h3,
      bodyMedium: HealynTypography.body,
      bodySmall: HealynTypography.caption,
      labelSmall: HealynTypography.overline,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: HealynColors.surfaceBase,
      textTheme: textTheme,
      fontFamily: HealynTypography.fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: HealynColors.surfaceBase,
        foregroundColor: HealynColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: HealynTypography.h2,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: HealynColors.surfaceAlt,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: HealynSpacing.s4,
          vertical: HealynSpacing.s3,
        ),
        constraints: const BoxConstraints(minHeight: 48), // §5.2
        border: const OutlineInputBorder(
          borderRadius: HealynRadii.brMd,
          borderSide: BorderSide(color: HealynColors.borderSubtle),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: HealynRadii.brMd,
          borderSide: BorderSide(color: HealynColors.borderSubtle),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: HealynRadii.brMd,
          borderSide: BorderSide(color: HealynColors.brandPrimary, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: HealynRadii.brMd,
          borderSide: BorderSide(color: HealynColors.statusDanger),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: HealynRadii.brMd,
          borderSide: BorderSide(color: HealynColors.statusDanger, width: 2),
        ),
        labelStyle: HealynTypography.caption,
        errorStyle: HealynTypography.caption.copyWith(
          color: HealynColors.statusDanger,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: HealynColors.brandPrimary,
          foregroundColor: HealynColors.textInverse,
          disabledBackgroundColor: HealynColors.borderSubtle,
          disabledForegroundColor: HealynColors.textMuted,
          elevation: 0,
          minimumSize: const Size.fromHeight(48), // §5.1 tap target
          padding: const EdgeInsets.symmetric(
            horizontal: HealynSpacing.s4,
            vertical: HealynSpacing.s3,
          ),
          textStyle: HealynTypography.bodyStrong,
          shape: const RoundedRectangleBorder(borderRadius: HealynRadii.brLg),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: HealynColors.brandPrimary,
          textStyle: HealynTypography.bodyStrong,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: HealynColors.borderSubtle,
        thickness: 1,
        space: HealynSpacing.s4,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: HealynColors.surfaceBase,
        indicatorColor: HealynColors.brandPrimarySubtle,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? HealynTypography.caption.copyWith(
                  color: HealynColors.brandPrimaryHover,
                  fontWeight: FontWeight.w600,
                )
              : HealynTypography.caption,
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? HealynColors.brandPrimaryHover
                : HealynColors.textSecondary,
          ),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: HealynColors.textPrimary,
        contentTextStyle: TextStyle(color: HealynColors.textInverse),
      ),
    );
  }
}
