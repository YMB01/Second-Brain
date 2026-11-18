import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Reusable Material themes. Widgets should read semantic colors via context.
abstract final class AppTheme {
  static final light = _build(
    ColorScheme.fromSeed(
      seedColor: AppColors.lightPrimary,
      brightness: Brightness.light,
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      surface: AppColors.lightSurface,
      surfaceContainerLow: AppColors.lightCard,
      onSurface: AppColors.lightText,
      onSurfaceVariant: AppColors.lightSecondaryText,
      outlineVariant: AppColors.lightDivider,
    ),
    background: AppColors.lightBackground,
  );

  static final dark = _build(
    ColorScheme.fromSeed(
      seedColor: AppColors.lightPrimary,
      brightness: Brightness.dark,
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      surface: AppColors.darkSurface,
      surfaceContainerLow: AppColors.darkCard,
      onSurface: AppColors.darkText,
      onSurfaceVariant: AppColors.darkSecondaryText,
      outlineVariant: AppColors.darkDivider,
    ),
    background: AppColors.darkBackground,
  );

  static ThemeData _build(ColorScheme colors, {required Color background}) {
    final base = ThemeData(useMaterial3: true, colorScheme: colors);

    return base.copyWith(
      scaffoldBackgroundColor: background,
      textTheme: base.textTheme.apply(
        bodyColor: colors.onSurface,
        displayColor: colors.onSurface,
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
      ),
      dividerColor: colors.outlineVariant,
      dividerTheme: DividerThemeData(color: colors.outlineVariant),
    );
  }
}
