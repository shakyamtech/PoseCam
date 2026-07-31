/// Application constants, keys, and timing thresholds.
abstract class AppConstants {
  static const String appName = 'PoseSnap AI';
  static const String appTagline = 'Capture Every Pose with AI Intelligence';
  static const String appVersion = '1.0.0';

  // Splash Screen Duration
  static const Duration splashDuration = Duration(milliseconds: 2400);

  // Animation Durations
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animMedium = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 600);

  // Storage Keys
  static const String keyThemeMode = 'pref_theme_mode';
  static const String keyIsFirstRun = 'pref_is_first_run';
  static const String keyUserProfile = 'pref_user_profile';

  // Layout Thresholds
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;
}
