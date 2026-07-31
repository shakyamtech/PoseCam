import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/smart_pose_model.dart';

/// Scalable Repository service loading, caching and querying 1000+ local poses.
class PoseRepository {
  static List<SmartPoseModel>? _cachedPoses;

  /// Loads all poses from local JSON asset bundle with memory caching.
  static Future<List<SmartPoseModel>> getAllPoses() async {
    if (_cachedPoses != null && _cachedPoses!.isNotEmpty) {
      return _cachedPoses!;
    }

    try {
      final jsonString = await rootBundle.loadString('assets/data/pose_library_data.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final rawList = jsonMap['poses'] as List<dynamic>? ?? [];

      _cachedPoses = rawList
          .map((item) => SmartPoseModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return _cachedPoses!;
    } catch (e) {
      return [];
    }
  }

  /// Filters dataset by category, difficulty, posture, and framing distance.
  static Future<List<SmartPoseModel>> getFilteredPoses({
    String? category,
    String? difficulty,
    String? postureType,
    String? framingDistance,
  }) async {
    final all = await getAllPoses();
    return all.where((pose) {
      if (category != null && category != 'All' && pose.category.toLowerCase() != category.toLowerCase()) {
        return false;
      }
      if (difficulty != null && difficulty != 'All' && pose.difficulty.toLowerCase() != difficulty.toLowerCase()) {
        return false;
      }
      if (postureType != null && postureType != 'All' && pose.postureType.toLowerCase() != postureType.toLowerCase()) {
        return false;
      }
      if (framingDistance != null && framingDistance != 'All' && pose.recommendedDistance.toLowerCase() != framingDistance.toLowerCase()) {
        return false;
      }
      return true;
    }).toList();
  }
}
