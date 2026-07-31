import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

/// Reusable Main Action Card for the 2x2 / 4x1 dashboard grid.
class MainActionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Gradient gradient;
  final Color iconBackgroundColor;
  final VoidCallback onTap;
  final bool isFeatured;

  const MainActionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.iconBackgroundColor,
    required this.onTap,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        splashColor: iconBackgroundColor.withOpacity(0.2),
        highlightColor: iconBackgroundColor.withOpacity(0.1),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isFeatured
                  ? AppColors.primary.withOpacity(0.5)
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              width: isFeatured ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isFeatured
                    ? AppColors.primary.withOpacity(0.18)
                    : (isDark ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.04)),
                blurRadius: isFeatured ? 20 : 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon Container
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: gradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: iconBackgroundColor.withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),

                  // Arrow Indicator
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title & Description
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleLarge.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      fontSize: 12.5,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
