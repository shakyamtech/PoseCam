import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/widgets/custom_icon_button.dart';

/// Premium Top App Bar for PoseSnap AI Home Screen.
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 20,
      title: Row(
        children: [
          // Premium Glass Logo Badge
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.camera_alt_rounded,
              size: 22,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),

          // App Name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    'PoseSnap ',
                    style: AppTypography.titleLarge.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                    child: Text(
                      'AI',
                      style: AppTypography.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                'Camera Studio',
                style: AppTypography.labelSmall.copyWith(
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Settings Icon Button
        CustomIconButton(
          icon: Icons.tune_rounded,
          size: 20,
          onTap: () => context.pushNamed(RouteNames.settings),
        ),
        const SizedBox(width: 12),

        // Profile Avatar with Online Status Indicator
        GestureDetector(
          onTap: () => context.pushNamed(RouteNames.profile),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.accentGradient,
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
                  child: Text(
                    'AI',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
