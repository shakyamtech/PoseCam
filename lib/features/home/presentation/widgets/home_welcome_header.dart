import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

/// Welcome Header component displaying greeting & tagline.
class HomeWelcomeHeader extends StatelessWidget {
  const HomeWelcomeHeader({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning ☀️';
    if (hour < 17) return 'Good Afternoon 🌤️';
    return 'Good Evening 🌙';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _getGreeting(),
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Hello, Creator ✨',
            style: AppTypography.displayMedium.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Capture perfect photos with AI pose guidance.',
            style: AppTypography.bodyLarge.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
