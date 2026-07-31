import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../providers/favorites_provider.dart';
import '../../../../providers/pose_library_provider.dart';
import '../../../../providers/recent_poses_provider.dart';
import '../../../../providers/smart_pose_provider.dart';
import '../../../home/presentation/widgets/home_bottom_nav_bar.dart';
import '../../../pose_dataset/domain/models/smart_pose_model.dart';
import 'pose_preview_screen.dart';

/// Professional Pose Library Screen with Instant Search, Filter Chips, AI Recommendations & Favorites.
class PoseLibraryScreen extends ConsumerStatefulWidget {
  const PoseLibraryScreen({super.key});

  @override
  ConsumerState<PoseLibraryScreen> createState() => _PoseLibraryScreenState();
}

class _PoseLibraryScreenState extends ConsumerState<PoseLibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  static const categories = [
    'All',
    'Men',
    'Women',
    'Couple',
    'Friends',
    'Wedding',
    'Travel',
    'Fashion',
    'Cafe',
    'Street',
  ];

  static const postureFilters = ['All', 'Standing', 'Sitting', 'Walking'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedCategory = ref.watch(poseLibraryCategoryProvider);
    final selectedPosture = ref.watch(selectedPostureFilterProvider);
    final poseItemsAsync = ref.watch(filteredSmartPosesProvider);
    final recommendationsAsync = ref.watch(recommendationsProvider);
    final favoriteIds = ref.watch(favoritesProvider);
    final recentIds = ref.watch(recentPosesProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('AI Pose Studio & Library'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: isDark ? Colors.white : AppColors.lightTextPrimary,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: 'Discover 🌟'),
            Tab(text: 'All Poses 📚'),
            Tab(text: 'Favorites ⭐️'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            // Tab 1: Discover & AI Recommendations
            _buildDiscoverTab(context, ref, recommendationsAsync, isDark),

            // Tab 2: All Poses & Search & Filters
            _buildAllPosesTab(context, ref, selectedCategory, selectedPosture, poseItemsAsync, isDark),

            // Tab 3: Favorites & Recently Used
            _buildFavoritesTab(context, ref, favoriteIds, recentIds, isDark),
          ],
        ),
      ),
      bottomNavigationBar: const HomeBottomNavBar(selectedIndex: 1),
    );
  }

  Widget _buildDiscoverTab(
    BuildContext context,
    WidgetRef ref,
    AsyncValue recommendationsAsync,
    bool isDark,
  ) {
    return recommendationsAsync.when(
      data: (recommendations) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('🔥 Trending Poses', 'Popular shots right now'),
              _buildHorizontalCarousel(context, ref, recommendations.trending, isDark),

              const SizedBox(height: 20),
              _buildSectionHeader('🌟 Editor\'s Choice', 'Curated aesthetic posture guide'),
              _buildHorizontalCarousel(context, ref, recommendations.editorsChoice, isDark),

              const SizedBox(height: 20),
              _buildSectionHeader('🌱 Beginner Friendly', 'Easy and comfortable postures'),
              _buildHorizontalCarousel(context, ref, recommendations.beginnerFriendly, isDark),

              const SizedBox(height: 20),
              _buildSectionHeader('🏆 Most Popular', 'Top rated by creator community'),
              _buildHorizontalCarousel(context, ref, recommendations.mostPopular, isDark),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildAllPosesTab(
    BuildContext context,
    WidgetRef ref,
    String selectedCategory,
    String selectedPosture,
    AsyncValue<List<SmartPoseModel>> poseItemsAsync,
    bool isDark,
  ) {
    return Column(
      children: [
        // Search Bar Input
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            onChanged: (val) {
              ref.read(smartSearchQueryProvider.notifier).state = val;
            },
            decoration: InputDecoration(
              hintText: 'Search poses by title, tags (e.g. coffee, street)...',
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(smartSearchQueryProvider.notifier).state = '';
                      },
                    )
                  : null,
              filled: true,
              fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),

        // Horizontal Category Chips
        SizedBox(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = cat == selectedCategory;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      ref.read(poseLibraryCategoryProvider.notifier).state = cat;
                    }
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : (isDark ? Colors.white70 : AppColors.lightTextPrimary),
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 6),

        // Posture Filter Chips (Standing, Sitting, Walking)
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: postureFilters.length,
            itemBuilder: (context, index) {
              final posture = postureFilters[index];
              final isSelected = posture == selectedPosture;

              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChip(
                  label: Text(posture),
                  selected: isSelected,
                  onSelected: (selected) {
                    ref.read(selectedPostureFilterProvider.notifier).state =
                        selected ? posture : 'All';
                  },
                  selectedColor: AppColors.secondary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.white60,
                    fontSize: 11,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),

        // Pose Grid
        Expanded(
          child: poseItemsAsync.when(
            data: (poses) {
              if (poses.isEmpty) {
                return Center(
                  child: Text('No Poses Found', style: AppTypography.bodyMedium),
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
                itemCount: poses.length,
                itemBuilder: (context, index) {
                  final item = poses[index];
                  return _buildPoseCard(context, ref, item, isDark);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesTab(
    BuildContext context,
    WidgetRef ref,
    Set<String> favoriteIds,
    List<String> recentIds,
    bool isDark,
  ) {
    final allPosesAsync = ref.watch(allSmartPosesProvider);

    return allPosesAsync.when(
      data: (allPoses) {
        final favoritePoses = allPoses.where((p) => favoriteIds.contains(p.id)).toList();

        if (favoritePoses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_outline_rounded, size: 64, color: isDark ? Colors.white38 : Colors.black38),
                const SizedBox(height: 12),
                Text('No Favorite Poses Saved', style: AppTypography.titleMedium),
                const SizedBox(height: 4),
                Text('Tap the star icon on any pose card to save it here!', style: AppTypography.labelSmall),
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
          itemCount: favoritePoses.length,
          itemBuilder: (context, index) {
            final item = favoritePoses[index];
            return _buildPoseCard(context, ref, item, isDark);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
          Text(subtitle, style: AppTypography.labelSmall.copyWith(color: Colors.white54)),
        ],
      ),
    );
  }

  Widget _buildHorizontalCarousel(
    BuildContext context,
    WidgetRef ref,
    List<SmartPoseModel> poses,
    bool isDark,
  ) {
    return SizedBox(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        itemCount: poses.length,
        itemBuilder: (context, index) {
          final item = poses[index];
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 12),
            child: _buildPoseCard(context, ref, item, isDark),
          );
        },
      ),
    );
  }

  Widget _buildPoseCard(
    BuildContext context,
    WidgetRef ref,
    SmartPoseModel pose,
    bool isDark,
  ) {
    final favoritesNotifier = ref.read(favoritesProvider.notifier);
    final isFav = ref.watch(favoritesProvider).contains(pose.id);

    return GestureDetector(
      onTap: () {
        ref.read(recentPosesProvider.notifier).addRecent(pose.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PosePreviewScreen(pose: pose.toPoseItemModel()),
          ),
        );
      },
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
              Image.network(
                pose.thumbnailUrl,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    isFav ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: isFav ? AppColors.secondary : Colors.white70,
                    size: 22,
                  ),
                  onPressed: () => favoritesNotifier.toggleFavorite(pose.id),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pose.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleMedium.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${pose.category} • ${pose.postureType}',
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
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
