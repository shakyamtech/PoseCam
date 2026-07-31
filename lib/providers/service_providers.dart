import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/storage_service.dart';
import '../repositories/settings_repository.dart';
import '../models/pose_category_model.dart';

/// Provider for SharedPreferences instance (must be overridden in ProviderScope at startup).
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize sharedPreferencesProvider in main.dart');
});

/// Storage Service Provider
final storageServiceProvider = Provider<StorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SharedPreferencesStorageService(prefs);
});

/// Settings Repository Provider
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return SettingsRepositoryImpl(storage);
});

/// Trending Pose Categories Mock Provider
final poseCategoriesProvider = Provider<List<PoseCategoryModel>>((ref) {
  return const [
    PoseCategoryModel(
      id: 'cat_1',
      name: 'Solo Aesthetic',
      description: 'Chic, relaxed individual poses for daily fashion & portrait photography.',
      poseCount: 42,
      iconName: 'person',
      bannerImageUrl: '',
      isTrending: true,
    ),
    PoseCategoryModel(
      id: 'cat_2',
      name: 'Streetwear Vibes',
      description: 'Urban, dynamic, and full-body posture guides for street style.',
      poseCount: 38,
      iconName: 'style',
      bannerImageUrl: '',
      isTrending: true,
    ),
    PoseCategoryModel(
      id: 'cat_3',
      name: 'Couples & Duo',
      description: 'Romantic and friendly duo framing and interaction angles.',
      poseCount: 29,
      iconName: 'favorite',
      bannerImageUrl: '',
      isTrending: false,
    ),
    PoseCategoryModel(
      id: 'cat_4',
      name: 'Studio Portrait',
      description: 'Professional headshots, lighting angles, and subtle hand poses.',
      poseCount: 35,
      iconName: 'camera',
      bannerImageUrl: '',
      isTrending: true,
    ),
  ];
});
