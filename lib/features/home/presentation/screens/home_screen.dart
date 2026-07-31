import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_welcome_header.dart';
import '../widgets/main_actions_grid.dart';
import '../widgets/pose_category_chips.dart';
import '../widgets/trending_poses_section.dart';
import '../widgets/recent_photos_section.dart';
import '../widgets/home_bottom_nav_bar.dart';

/// Complete Apple/Pixel/Instagram-inspired Home Screen for PoseSnap AI.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      appBar: HomeAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Welcome Section
              HomeWelcomeHeader(),

              // 2. Main Action Cards Grid (AI Camera, Pose Library, AI Editor, My Gallery)
              MainActionsGrid(),
              SizedBox(height: 28),

              // 3. Pose Categories Chips (Men, Women, Couple, Friends, Travel, etc.)
              PoseCategoryChips(),
              SizedBox(height: 28),

              // 4. Trending Pose Section Cards
              TrendingPosesSection(),
              SizedBox(height: 28),

              // 5. Recent Photos Horizontal Gallery Strip
              RecentPhotosSection(),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNavBar(selectedIndex: 0),
    );
  }
}
