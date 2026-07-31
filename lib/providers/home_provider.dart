import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/trending_pose_model.dart';
import '../models/recent_photo_model.dart';

/// Available Pose Category Filter Chips
final poseCategoryChipsProvider = Provider<List<String>>((ref) {
  return const [
    'All',
    'Men',
    'Women',
    'Couple',
    'Friends',
    'Travel',
    'Fashion',
    'Wedding',
    'Street',
    'Cafe',
  ];
});

/// Currently Selected Category Chip Provider
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

/// Mock Trending Poses Raw Data
final rawTrendingPosesProvider = Provider<List<TrendingPoseModel>>((ref) {
  return const [
    TrendingPoseModel(
      id: 'pose_1',
      title: 'Urban Stride Portrait',
      category: 'Street',
      difficulty: PoseDifficulty.easy,
      likesCount: '4.8k',
      imageUrl: '',
      guideTip: 'Slightly turn shoulder 30° toward camera while walking forward.',
    ),
    TrendingPoseModel(
      id: 'pose_2',
      title: 'Coffee Cup Aesthetic',
      category: 'Cafe',
      difficulty: PoseDifficulty.easy,
      likesCount: '5.2k',
      imageUrl: '',
      guideTip: 'Hold mug with both hands, look soft towards window light.',
    ),
    TrendingPoseModel(
      id: 'pose_3',
      title: 'Cinematic Sunset Silhouette',
      category: 'Travel',
      difficulty: PoseDifficulty.medium,
      likesCount: '6.1k',
      imageUrl: '',
      guideTip: 'Stand backlighted, lift chin, and frame profile against sky.',
    ),
    TrendingPoseModel(
      id: 'pose_4',
      title: 'Classic Duo Lean',
      category: 'Couple',
      difficulty: PoseDifficulty.easy,
      likesCount: '3.9k',
      imageUrl: '',
      guideTip: 'Gentle head tilt towards partner with natural smiles.',
    ),
    TrendingPoseModel(
      id: 'pose_5',
      title: 'Fashion Blazer Cross',
      category: 'Fashion',
      difficulty: PoseDifficulty.pro,
      likesCount: '7.4k',
      imageUrl: '',
      guideTip: 'One hand resting in pocket, cross legs softly for height.',
    ),
    TrendingPoseModel(
      id: 'pose_6',
      title: 'Golden Hour Laugh',
      category: 'Friends',
      difficulty: PoseDifficulty.easy,
      likesCount: '4.3k',
      imageUrl: '',
      guideTip: 'Spontaneous candid grouping with warm ambient fill.',
    ),
    TrendingPoseModel(
      id: 'pose_7',
      title: 'Sharp Jawline Angle',
      category: 'Men',
      difficulty: PoseDifficulty.medium,
      likesCount: '5.9k',
      imageUrl: '',
      guideTip: 'Slightly drop shoulder, tilt head 15° away from main keylight.',
    ),
    TrendingPoseModel(
      id: 'pose_8',
      title: 'Elegance Veil Flow',
      category: 'Wedding',
      difficulty: PoseDifficulty.pro,
      likesCount: '8.1k',
      imageUrl: '',
      guideTip: 'Soft hand positioning touching dress hem with floating veil.',
    ),
  ];
});

/// Filtered Trending Poses based on active selected category chip
final filteredTrendingPosesProvider = Provider<List<TrendingPoseModel>>((ref) {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final allPoses = ref.watch(rawTrendingPosesProvider);

  if (selectedCategory == 'All') {
    return allPoses;
  }
  return allPoses.where((pose) => pose.category.toLowerCase() == selectedCategory.toLowerCase()).toList();
});

/// Mock Recent Photos Provider
final recentPhotosProvider = Provider<List<RecentPhotoModel>>((ref) {
  return const [
    RecentPhotoModel(
      id: 'photo_1',
      poseTitle: 'Urban Stride',
      timeAgo: '2h ago',
      aspectRatio: '4:5',
      filterUsed: 'Obsidian Glow',
      thumbnailUrl: '',
    ),
    RecentPhotoModel(
      id: 'photo_2',
      poseTitle: 'Cafe Mug Tilt',
      timeAgo: 'Yesterday',
      aspectRatio: '9:16',
      filterUsed: 'Warm Retro',
      thumbnailUrl: '',
    ),
    RecentPhotoModel(
      id: 'photo_3',
      poseTitle: 'Golden Sunset',
      timeAgo: '3 days ago',
      aspectRatio: '1:1',
      filterUsed: 'Cyber Teal',
      thumbnailUrl: '',
    ),
    RecentPhotoModel(
      id: 'photo_4',
      poseTitle: 'Fashion Suit',
      timeAgo: '5 days ago',
      aspectRatio: '4:5',
      filterUsed: 'Monochrome Pro',
      thumbnailUrl: '',
    ),
  ];
});
