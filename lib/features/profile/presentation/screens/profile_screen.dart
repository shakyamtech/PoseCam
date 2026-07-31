import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../models/recent_photo_model.dart';
import '../../../../providers/gallery_provider.dart';
import '../../../home/presentation/widgets/home_bottom_nav_bar.dart';

/// Premium Apple/Pixel-inspired My Gallery & User Collection Screen.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final photos = ref.watch(galleryProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('My Profile & Gallery'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.goNamed(RouteNames.home);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.pushNamed(RouteNames.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Profile Header Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Avatar Badge
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                        color: Colors.white24,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // User Info & Metrics
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PoseSnap Creator',
                            style: AppTypography.titleLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'AI Pose Pro Member ✨',
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildStatItem('${photos.length}', 'Captures'),
                              const SizedBox(width: 20),
                              _buildStatItem('12', 'Favorites'),
                              const SizedBox(width: 20),
                              _buildStatItem('33', 'Landmarks'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Tab Bar
            TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              labelColor: isDark ? Colors.white : AppColors.lightTextPrimary,
              unselectedLabelColor: Colors.white54,
              tabs: const [
                Tab(text: 'Captured Shots 📸'),
                Tab(text: 'Saved Poses ⭐️'),
              ],
            ),

            // 3. Tab Views (Shots Grid & Poses List)
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Captured Shots Grid View
                  _buildShotsGrid(context, ref, photos, isDark),

                  // Saved Poses View
                  _buildSavedPoses(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const HomeBottomNavBar(selectedIndex: 2),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          count,
          style: AppTypography.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildShotsGrid(
    BuildContext context,
    WidgetRef ref,
    List<RecentPhotoModel> photos,
    bool isDark,
  ) {
    if (photos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined, size: 64, color: isDark ? Colors.white38 : Colors.black38),
            const SizedBox(height: 12),
            Text('No Captured Shots Yet', style: AppTypography.titleMedium),
            const SizedBox(height: 4),
            Text('Take photos from AI Camera to see them here!', style: AppTypography.labelSmall),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.75,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final item = photos[index];

        return GestureDetector(
          onTap: () => _showPhotoDetailModal(context, ref, item),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildPhotoWidget(item.thumbnailUrl),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.75),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            item.poseTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.white70, size: 20),
                          onPressed: () => ref.read(galleryProvider.notifier).deletePhoto(item.id),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhotoWidget(String path) {
    if (kIsWeb) {
      if (path.startsWith('data:image')) {
        final base64Bytes = Uri.parse(path).data?.contentAsBytes();
        if (base64Bytes != null) {
          return Image.memory(base64Bytes, fit: BoxFit.cover);
        }
      }
      return Image.network(path, fit: BoxFit.cover);
    }
    if (path.startsWith('http')) {
      return Image.network(path, fit: BoxFit.cover);
    }
    return Image.file(File(path), fit: BoxFit.cover);
  }

  Widget _buildSavedPoses(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSavedPoseTile('Standing Fashion Pose', 'Fashion', '33 Landmarks Verified', isDark),
        _buildSavedPoseTile('Couple Walking Pose', 'Couple', '33 Landmarks Verified', isDark),
        _buildSavedPoseTile('Streetwear Side Angle', 'Street', '33 Landmarks Verified', isDark),
      ],
    );
  }

  Widget _buildSavedPoseTile(String title, String category, String subtitle, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.accessibility_new_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTypography.labelSmall.copyWith(color: AppColors.secondary)),
              ],
            ),
          ),
          const Icon(Icons.bookmark_rounded, color: AppColors.primary),
        ],
      ),
    );
  }

  void _showPhotoDetailModal(BuildContext context, WidgetRef ref, RecentPhotoModel photo) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 380,
                  width: double.infinity,
                  child: _buildPhotoWidget(photo.thumbnailUrl),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ref.read(galleryProvider.notifier).deletePhoto(photo.id);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                    icon: const Icon(Icons.delete_rounded, size: 18),
                    label: const Text('Delete'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.check_rounded, size: 18),
                    label: const Text('Close'),
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
