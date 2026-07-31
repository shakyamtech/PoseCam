import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/routes/route_names.dart';

/// Animated branded Splash Screen for PoseSnap AI.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    _navigationTimer = Timer(AppConstants.splashDuration, () {
      if (mounted) {
        context.go(RouteNames.homePath);
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient glowing background radial effect
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.35),
                      AppColors.secondary.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),

            // Main Logo & Branding
            ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Glassmorphic App Icon Badge
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_rounded,
                        size: 56,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // App Title
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'PoseSnap ',
                          style: AppTypography.displayLarge.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                          child: Text(
                            'AI',
                            style: AppTypography.displayLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Tagline
                    Text(
                      AppConstants.appTagline,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Bottom loading indicator & status
            Positioned(
              bottom: 48,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    const SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Initializing AI Models...',
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
