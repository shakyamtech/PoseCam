import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Responsive helper utility for adaptive scaling across screen sizes.
class ResponsiveUtils {
  final BuildContext context;

  ResponsiveUtils(this.context);

  static ResponsiveUtils of(BuildContext context) => ResponsiveUtils(context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
  EdgeInsets get padding => MediaQuery.of(context).padding;

  bool get isMobile => width < AppConstants.mobileBreakpoint;
  bool get isTablet =>
      width >= AppConstants.mobileBreakpoint && width < AppConstants.tabletBreakpoint;
  bool get isDesktop => width >= AppConstants.tabletBreakpoint;

  double widthPercent(double percent) => width * (percent / 100);
  double heightPercent(double percent) => height * (percent / 100);

  /// Scales font size based on mobile base reference width (390dp)
  double scaleFont(double fontSize) {
    final double scale = width / 390.0;
    return (fontSize * scale).clamp(fontSize * 0.85, fontSize * 1.3);
  }
}

/// Extension on BuildContext for quick access to responsive properties.
extension ResponsiveContextX on BuildContext {
  ResponsiveUtils get responsive => ResponsiveUtils.of(this);
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
