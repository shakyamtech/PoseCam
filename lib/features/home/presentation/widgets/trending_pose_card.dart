import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../models/trending_pose_model.dart';

/// Card widget representing a single trending pose recommendation.
class TrendingPoseCard extends StatelessWidget {
  final TrendingPoseModel pose;
  final VoidCallback onTap;

  const TrendingPoseCard({
    super.key,
    required this.pose,
    required this.onTap,
  });

  Color _getDifficultyColor(PoseDifficulty difficulty) {
    switch (difficulty) {
      case PoseDifficulty.easy:
        return AppColors.success;
      case PoseDifficulty.medium:
        return AppColors.warning;
      case PoseDifficulty.pro:
        return AppColors.tertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final diffColor = _getDifficultyColor(pose.difficulty);

    return Container(
      width: 230,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.25) : Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pose Preview Image Placeholder Stack
              Stack(
                children: [
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.4),
                          AppColors.secondary.withOpacity(0.2),
                          AppColors.darkSurfaceVariant,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white24, width: 1),
                            ),
                            child: const Icon(
                              Icons.accessibility_new_rounded,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'AI Pose Mesh',
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Difficulty Badge
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: diffColor.withOpacity(0.5), width: 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: diffColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            pose.difficultyLabel,
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Likes Counter Badge
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.favorite_rounded, size: 12, color: AppColors.tertiary),
                          const SizedBox(width: 4),
                          Text(
                            pose.likesCount,
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Details Padding
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pose.title,
                      style: AppTypography.titleMedium.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pose.guideTip,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontSize: 11.5,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
