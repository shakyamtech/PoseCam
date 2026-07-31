import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../providers/home_provider.dart';
import 'trending_pose_card.dart';

/// Trending Poses horizontal list section widget.
class TrendingPosesSection extends ConsumerWidget {
  const TrendingPosesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredPoses = ref.watch(filteredTrendingPosesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.whatshot_rounded, color: AppColors.tertiary, size: 22),
                  const SizedBox(width: 6),
                  Text(
                    'Trending Poses',
                    style: AppTypography.titleLarge.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => context.pushNamed(RouteNames.pose),
                child: Text(
                  'Explore All',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (filteredPoses.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'No trending poses found in this category.',
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          SizedBox(
            height: 245,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: filteredPoses.length,
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final pose = filteredPoses[index];
                return TrendingPoseCard(
                  pose: pose,
                  onTap: () => context.pushNamed(RouteNames.camera),
                );
              },
            ),
          ),
      ],
    );
  }
}
