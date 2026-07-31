import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/pose_matching/domain/models/pose_score.dart';
import '../features/pose_matching/presentation/controllers/pose_matching_controller.dart';

/// Riverpod Provider for AI Pose Matching Engine result.
final poseMatchingProvider =
    StateNotifierProvider<PoseMatchingNotifier, PoseMatchResult>((ref) {
  return PoseMatchingNotifier(ref);
});
