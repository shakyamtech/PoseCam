import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/pose_dataset/domain/models/smart_pose_model.dart';
import '../features/pose_dataset/domain/services/pose_recommendation_service.dart';
import '../features/pose_dataset/domain/services/pose_repository.dart';
import '../features/pose_dataset/domain/services/pose_search_service.dart';

final allSmartPosesProvider = FutureProvider<List<SmartPoseModel>>((ref) async {
  return await PoseRepository.getAllPoses();
});

final smartSearchQueryProvider = StateProvider<String>((ref) => '');
final selectedPostureFilterProvider = StateProvider<String>((ref) => 'All');
final selectedDifficultyFilterProvider = StateProvider<String>((ref) => 'All');

final filteredSmartPosesProvider = FutureProvider<List<SmartPoseModel>>((ref) async {
  final query = ref.watch(smartSearchQueryProvider);
  final posture = ref.watch(selectedPostureFilterProvider);
  final difficulty = ref.watch(selectedDifficultyFilterProvider);

  final dataset = await PoseRepository.getFilteredPoses(
    postureType: posture,
    difficulty: difficulty,
  );

  return PoseSearchService.searchPoses(dataset, query);
});

final recommendationsProvider = FutureProvider<PoseRecommendations>((ref) async {
  final dataset = await PoseRepository.getAllPoses();
  return PoseRecommendationService.getRecommendations(dataset);
});
