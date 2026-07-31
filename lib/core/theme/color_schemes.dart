import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Material 3 ColorSchemes for Light and Dark themes.
abstract class AppColorSchemes {
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: Colors.white,
    secondary: AppColors.secondary,
    onSecondary: Colors.black,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: Colors.white,
    tertiary: AppColors.tertiary,
    onTertiary: Colors.white,
    error: AppColors.error,
    onError: Colors.white,
    background: AppColors.darkBackground,
    onBackground: AppColors.darkTextPrimary,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkTextPrimary,
    surfaceVariant: AppColors.darkSurfaceVariant,
    onSurfaceVariant: AppColors.darkTextSecondary,
    outline: AppColors.darkBorder,
  );

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFEADDFF),
    onPrimaryContainer: Color(0xFF21005D),
    secondary: Color(0xFF00838F),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFB4F2FA),
    onSecondaryContainer: Color(0xFF001F24),
    tertiary: AppColors.tertiary,
    onTertiary: Colors.white,
    error: AppColors.error,
    onError: Colors.white,
    background: AppColors.lightBackground,
    onBackground: AppColors.lightTextPrimary,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightTextPrimary,
    surfaceVariant: AppColors.lightSurfaceVariant,
    onSurfaceVariant: AppColors.lightTextSecondary,
    outline: AppColors.lightBorder,
  );
}
