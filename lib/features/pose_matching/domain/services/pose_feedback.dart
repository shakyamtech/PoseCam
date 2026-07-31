import '../../../pose/domain/models/pose_model.dart';

/// Natural language feedback generator converting wrong joint sets into actionable guidance text.
class PoseFeedbackGenerator {
  static String generateFeedback({
    required Set<LandmarkType> wrongJoints,
    required double score,
  }) {
    if (score >= 90.0) {
      return '🔥 Perfect Match! Hold still for photo!';
    }
    if (score >= 80.0) {
      return '✨ Almost there! Slight adjustment needed.';
    }
    if (wrongJoints.isEmpty) {
      return 'Align your body with the Ghost Overlay';
    }

    // Priority feedback rules
    if (wrongJoints.contains(LandmarkType.leftWrist) ||
        wrongJoints.contains(LandmarkType.leftElbow)) {
      return '✋ Adjust Left Arm position';
    }
    if (wrongJoints.contains(LandmarkType.rightWrist) ||
        wrongJoints.contains(LandmarkType.rightElbow)) {
      return '🤚 Adjust Right Arm position';
    }
    if (wrongJoints.contains(LandmarkType.leftShoulder) ||
        wrongJoints.contains(LandmarkType.rightShoulder)) {
      return '📐 Align Shoulder angle';
    }
    if (wrongJoints.contains(LandmarkType.leftKnee) ||
        wrongJoints.contains(LandmarkType.rightKnee)) {
      return '🦵 Adjust Knee & Leg stance';
    }
    if (wrongJoints.contains(LandmarkType.nose) ||
        wrongJoints.contains(LandmarkType.leftEye)) {
      return '👤 Center your Head position';
    }

    return 'Center your body in camera viewfinder';
  }
}
