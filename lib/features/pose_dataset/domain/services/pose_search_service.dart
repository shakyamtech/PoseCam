import '../models/smart_pose_model.dart';

/// Instant multi-keyword search engine matching query against pose titles, tags, and categories.
class PoseSearchService {
  static List<SmartPoseModel> searchPoses(
    List<SmartPoseModel> dataset,
    String query,
  ) {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return dataset;

    return dataset.where((pose) {
      final titleMatch = pose.title.toLowerCase().contains(cleanQuery);
      final categoryMatch = pose.category.toLowerCase().contains(cleanQuery);
      final tagMatch = pose.tags.any((tag) => tag.toLowerCase().contains(cleanQuery));

      return titleMatch || categoryMatch || tagMatch;
    }).toList();
  }
}
