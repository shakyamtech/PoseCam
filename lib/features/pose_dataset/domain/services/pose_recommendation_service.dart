import '../models/smart_pose_model.dart';

/// Recommendation channels container.
class PoseRecommendations {
  final List<SmartPoseModel> trending;
  final List<SmartPoseModel> editorsChoice;
  final List<SmartPoseModel> beginnerFriendly;
  final List<SmartPoseModel> mostPopular;

  const PoseRecommendations({
    required this.trending,
    required this.editorsChoice,
    required this.beginnerFriendly,
    required this.mostPopular,
  });
}

/// AI Pose Recommendation engine generating categorized channels based on metadata & context.
class PoseRecommendationService {
  static PoseRecommendations getRecommendations(List<SmartPoseModel> dataset) {
    final trending = dataset.where((p) => p.popularity >= 93.0 || p.isEditorsChoice).toList();
    final editorsChoice = dataset.where((p) => p.isEditorsChoice).toList();
    final beginner = dataset.where((p) => p.difficulty.toLowerCase() == 'easy').toList();
    final popular = List<SmartPoseModel>.from(dataset)
      ..sort((a, b) => b.popularity.compareTo(a.popularity));

    return PoseRecommendations(
      trending: trending.take(5).toList(),
      editorsChoice: editorsChoice.take(5).toList(),
      beginnerFriendly: beginner.take(5).toList(),
      mostPopular: popular.take(5).toList(),
    );
  }
}
