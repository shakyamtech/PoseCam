import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Riverpod StateNotifier managing persistent recently used pose IDs.
class RecentPosesNotifier extends StateNotifier<List<String>> {
  static const _key = 'user_recent_pose_ids';

  RecentPosesNotifier() : super([]) {
    _loadRecents();
  }

  Future<void> _loadRecents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = prefs.getStringList(_key) ?? [];
    } catch (_) {}
  }

  Future<void> addRecent(String poseId) async {
    final updated = List<String>.from(state);
    updated.remove(poseId);
    updated.insert(0, poseId);

    if (updated.length > 10) {
      updated.removeLast();
    }
    state = updated;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_key, updated);
    } catch (_) {}
  }

  String? get lastUsedPoseId => state.isNotEmpty ? state.first : null;
}

final recentPosesProvider =
    StateNotifierProvider<RecentPosesNotifier, List<String>>((ref) {
  return RecentPosesNotifier();
});
