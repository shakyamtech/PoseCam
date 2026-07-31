import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'main_action_card.dart';

/// Grid displaying the 4 primary action cards (AI Camera, Pose Library, AI Editor, My Gallery).
class MainActionsGrid extends StatelessWidget {
  const MainActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = context.responsive.isTablet || context.responsive.isDesktop;
    final crossAxisCount = isTablet ? 4 : 2;
    final childAspectRatio = isTablet ? 1.1 : 0.95;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: childAspectRatio,
        children: [
          // 1. AI Camera Card
          MainActionCard(
            title: 'AI Camera',
            description: 'Real-time pose overlay & instant AI guidance',
            icon: Icons.camera_rounded,
            gradient: AppColors.primaryGradient,
            iconBackgroundColor: AppColors.primary,
            isFeatured: true,
            onTap: () => context.pushNamed(RouteNames.camera),
          ),

          // 2. Pose Library Card
          MainActionCard(
            title: 'Pose Library',
            description: '100+ curated posture & aesthetic guides',
            icon: Icons.style_rounded,
            gradient: const LinearGradient(
              colors: [Color(0xFF00E5FF), Color(0xFF0091EA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            iconBackgroundColor: AppColors.secondary,
            onTap: () => context.pushNamed(RouteNames.pose),
          ),

          // 3. AI Editor Card
          MainActionCard(
            title: 'AI Editor',
            description: 'Retouch, filters & lighting enhancements',
            icon: Icons.auto_fix_high_rounded,
            gradient: const LinearGradient(
              colors: [Color(0xFFFF4081), Color(0xFFD500F9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            iconBackgroundColor: AppColors.tertiary,
            onTap: () => context.pushNamed(RouteNames.editor),
          ),

          // 4. My Gallery Card
          MainActionCard(
            title: 'My Gallery',
            description: 'Your captured pose masterpieces & shots',
            icon: Icons.photo_library_rounded,
            gradient: const LinearGradient(
              colors: [Color(0xFFFFAB00), Color(0xFFFF6D00)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            iconBackgroundColor: AppColors.warning,
            onTap: () => context.pushNamed(RouteNames.profile),
          ),
        ],
      ),
    );
  }
}
