import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Riverpod StateNotifier managing persistent user favorite pose IDs in SharedPreferences.
class FavoritesNotifier extends StateNotifier<Set<String>> {
  static const _key = 'user_favorite_pose_ids';

  FavoritesNotifier() : super({}) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_key) ?? [];
      state = list.toSet();
    } catch (_) {}
  }

  Future<void> toggleFavorite(String poseId) async {
    final updated = Set<String>.from(state);
    if (updated.contains(poseId)) {
      updated.remove(poseId);
    } else {
      updated.add(poseId);
    }
    state = updated;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_key, updated.toList());
    } catch (_) {}
  }

  bool isFavorite(String poseId) => state.contains(poseId);
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});
