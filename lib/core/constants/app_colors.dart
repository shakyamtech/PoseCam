import 'package:flutter/material.dart';

/// Centralized app color tokens for PoseSnap AI.
/// Provides rich, HSL-tailored dark and light palette tokens.
abstract class AppColors {
  // Brand Primary & Accent Palette
  static const Color primary = Color(0xFF7C4DFF); // Neon Violet / Purple
  static const Color primaryContainer = Color(0xFF651FFF);
  static const Color secondary = Color(0xFF00E5FF); // Vibrant Cyan
  static const Color secondaryContainer = Color(0xFF00B8D4);
  static const Color tertiary = Color(0xFFFF4081); // Trendy Magenta / Pink

  // Dark Theme Neutral Colors
  static const Color darkBackground = Color(0xFF0F1017); // Obsidian Midnight
  static const Color darkSurface = Color(0xFF191B26); // Deep Charcoal
  static const Color darkSurfaceVariant = Color(0xFF232635);
  static const Color darkCard = Color(0xFF202332);
  static const Color darkBorder = Color(0xFF2E3247);

  // Light Theme Neutral Colors
  static const Color lightBackground = Color(0xFFF7F8FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFEEF1F8);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E6F0);

  // Text Colors (Dark Theme)
  static const Color darkTextPrimary = Color(0xFFF8F9FE);
  static const Color darkTextSecondary = Color(0xFFA0A7C2);
  static const Color darkTextMuted = Color(0xFF6C7393);

  // Text Colors (Light Theme)
  static const Color lightTextPrimary = Color(0xFF121420);
  static const Color lightTextSecondary = Color(0xFF555B77);
  static const Color lightTextMuted = Color(0xFF8C93B0);

  // Functional Status Colors
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFAB00);
  static const Color error = Color(0xFFFF1744);
  static const Color info = Color(0xFF2979FF);

  // Gradient Definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7C4DFF), Color(0xFF00E5FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFF4081), Color(0xFF7C4DFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF232635), Color(0xFF191B26)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
