import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../providers/home_provider.dart';

/// Recent Photos horizontal list section.
class RecentPhotosSection extends ConsumerWidget {
  const RecentPhotosSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentPhotos = ref.watch(recentPhotosProvider);
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
                  const Icon(Icons.history_toggle_off_rounded, color: AppColors.secondary, size: 22),
                  const SizedBox(width: 6),
                  Text(
                    'Recent Captures',
                    style: AppTypography.titleLarge.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => context.pushNamed(RouteNames.profile),
                child: Text(
                  'Gallery',
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
        SizedBox(
          height: 140,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: recentPhotos.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final photo = recentPhotos[index];

              return Container(
                width: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    width: 1,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.25),
                      AppColors.darkSurfaceVariant,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  child: InkWell(
                    onTap: () => context.pushNamed(RouteNames.editor),
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      children: [
                        // Placeholder Visual Graphic
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_rounded,
                                size: 28,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                photo.poseTitle,
                                style: AppTypography.labelSmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Filter Tag
                        Positioned(
                          bottom: 8,
                          left: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.65),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              photo.filterUsed,
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.secondary,
                                fontSize: 9,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                            ),
                          ),
                        ),

                        // Time Badge
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              photo.timeAgo,
                              style: AppTypography.labelSmall.copyWith(
                                color: Colors.white70,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
