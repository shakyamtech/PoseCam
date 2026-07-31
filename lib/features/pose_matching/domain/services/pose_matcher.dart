import 'dart:math' as math;
import '../../../pose/domain/models/pose_model.dart';
import '../../../pose_library/domain/models/pose_item_model.dart';
import '../models/pose_score.dart';
import 'pose_feedback.dart';

/// Normalized Biomechanical Pose Matcher comparing Live MediaPipe 33 Landmarks with Ghost Target Pose.
class PoseMatcherService {
  /// Compares live landmarks with target pose landmarks and returns similarity score & wrong joint highlights.
  static PoseMatchResult comparePoses({
    required List<PoseLandmark>? liveLandmarks,
    required PoseItemModel? targetPose,
    double toleranceDegree = 20.0,
  }) {
    if (liveLandmarks == null ||
        liveLandmarks.isEmpty ||
        targetPose == null ||
        targetPose.landmarks.isEmpty) {
      return PoseMatchResult.initial();
    }

    final liveMap = <LandmarkType, math.Point<double>>{};
    for (var lm in liveLandmarks) {
      liveMap[lm.type] = math.Point(lm.x, lm.y);
    }

    final targetMap = <LandmarkType, math.Point<double>>{};
    for (var lm in targetPose.landmarks) {
      targetMap[lm.type] = math.Point(lm.x, lm.y);
    }

    // Biomechanical joint angle triplets (A -> B -> C) where B is the vertex joint
    final jointTriplets = <LandmarkType, List<LandmarkType>>{
      LandmarkType.leftElbow: [LandmarkType.leftShoulder, LandmarkType.leftElbow, LandmarkType.leftWrist],
      LandmarkType.rightElbow: [LandmarkType.rightShoulder, LandmarkType.rightElbow, LandmarkType.rightWrist],
      LandmarkType.leftShoulder: [LandmarkType.leftHip, LandmarkType.leftShoulder, LandmarkType.leftElbow],
      LandmarkType.rightShoulder: [LandmarkType.rightHip, LandmarkType.rightShoulder, LandmarkType.rightElbow],
      LandmarkType.leftKnee: [LandmarkType.leftHip, LandmarkType.leftKnee, LandmarkType.leftAnkle],
      LandmarkType.rightKnee: [LandmarkType.rightHip, LandmarkType.rightKnee, LandmarkType.rightAnkle],
      LandmarkType.leftHip: [LandmarkType.leftShoulder, LandmarkType.leftHip, LandmarkType.leftKnee],
      LandmarkType.rightHip: [LandmarkType.rightShoulder, LandmarkType.rightHip, LandmarkType.rightKnee],
      LandmarkType.nose: [LandmarkType.leftShoulder, LandmarkType.nose, LandmarkType.rightShoulder],
    };

    final wrongJoints = <LandmarkType>{};
    double totalAngleDelta = 0.0;
    int validJointCount = 0;

    jointTriplets.forEach((joint, triplet) {
      final paLive = liveMap[triplet[0]];
      final pbLive = liveMap[triplet[1]];
      final pcLive = liveMap[triplet[2]];

      final paTarget = targetMap[triplet[0]];
      final pbTarget = targetMap[triplet[1]];
      final pcTarget = targetMap[triplet[2]];

      if (paLive != null && pbLive != null && pcLive != null &&
          paTarget != null && pbTarget != null && pcTarget != null) {
        final angleLive = _calculateAngle(paLive, pbLive, pcLive);
        final angleTarget = _calculateAngle(paTarget, pbTarget, pcTarget);

        final delta = (angleLive - angleTarget).abs();
        totalAngleDelta += delta;
        validJointCount++;

        if (delta > toleranceDegree) {
          wrongJoints.add(joint);
          // Add wrist/ankle as secondary highlights if elbow/knee fails
          if (joint == LandmarkType.leftElbow) wrongJoints.add(LandmarkType.leftWrist);
          if (joint == LandmarkType.rightElbow) wrongJoints.add(LandmarkType.rightWrist);
          if (joint == LandmarkType.leftKnee) wrongJoints.add(LandmarkType.leftAnkle);
          if (joint == LandmarkType.rightKnee) wrongJoints.add(LandmarkType.rightAnkle);
        }
      }
    });

    if (validJointCount == 0) {
      return PoseMatchResult.initial();
    }

    final avgDelta = totalAngleDelta / validJointCount;
    // Map average angle delta (0° - 45°) to score percentage (100% - 0%)
    final score = (100.0 - (avgDelta * 2.2)).clamp(0.0, 100.0);
    final feedback = PoseFeedbackGenerator.generateFeedback(
      wrongJoints: wrongJoints,
      score: score,
    );

    return PoseMatchResult(
      score: score,
      isPerfectMatch: score >= 85.0,
      wrongJoints: wrongJoints,
      feedbackMessage: feedback,
      toleranceDegree: toleranceDegree,
    );
  }

  /// Calculates interior 2D angle (in degrees) between three points (A -> B -> C) at vertex B.
  static double _calculateAngle(
    math.Point<double> a,
    math.Point<double> b,
    math.Point<double> c,
  ) {
    final radians = math.atan2(c.y - b.y, c.x - b.x) - math.atan2(a.y - b.y, a.x - b.x);
    var degrees = (radians * 180.0 / math.pi).abs();
    if (degrees > 180.0) {
      degrees = 360.0 - degrees;
    }
    return degrees;
  }
}
