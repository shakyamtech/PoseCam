import 'package:equatable/equatable.dart';
import '../../../pose/domain/models/pose_model.dart';

/// Data model representing real-time AI Pose Matching result.
class PoseMatchResult extends Equatable {
  final double score; // 0.0 to 100.0%
  final bool isPerfectMatch; // score >= 85.0
  final Set<LandmarkType> wrongJoints;
  final String feedbackMessage;
  final double toleranceDegree;

  const PoseMatchResult({
    required this.score,
    required this.isPerfectMatch,
    required this.wrongJoints,
    required this.feedbackMessage,
    required this.toleranceDegree,
  });

  factory PoseMatchResult.initial() {
    return const PoseMatchResult(
      score: 0.0,
      isPerfectMatch: false,
      wrongJoints: {},
      feedbackMessage: 'Align your body with the Ghost Overlay',
      toleranceDegree: 20.0,
    );
  }

  @override
  List<Object?> get props => [
        score,
        isPerfectMatch,
        wrongJoints,
        feedbackMessage,
        toleranceDegree,
      ];
}
