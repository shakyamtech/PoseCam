import 'package:equatable/equatable.dart';

/// 33 Standard MediaPipe Body Landmark Identifiers.
enum LandmarkType {
  nose(0, 'Nose'),
  leftEyeInner(1, 'L Eye Inner'),
  leftEye(2, 'L Eye'),
  leftEyeOuter(3, 'L Eye Outer'),
  rightEyeInner(4, 'R Eye Inner'),
  rightEye(5, 'R Eye'),
  rightEyeOuter(6, 'R Eye Outer'),
  leftEar(7, 'L Ear'),
  rightEar(8, 'R Ear'),
  mouthLeft(9, 'Mouth L'),
  mouthRight(10, 'Mouth R'),
  leftShoulder(11, 'L Shoulder'),
  rightShoulder(12, 'R Shoulder'),
  leftElbow(13, 'L Elbow'),
  rightElbow(14, 'R Elbow'),
  leftWrist(15, 'L Wrist'),
  rightWrist(16, 'R Wrist'),
  leftPinky(17, 'L Pinky'),
  rightPinky(18, 'R Pinky'),
  leftIndex(19, 'L Index'),
  rightIndex(20, 'R Index'),
  leftThumb(21, 'L Thumb'),
  rightThumb(22, 'R Thumb'),
  leftHip(23, 'L Hip'),
  rightHip(24, 'R Hip'),
  leftKnee(25, 'L Knee'),
  rightKnee(26, 'R Knee'),
  leftAnkle(27, 'L Ankle'),
  rightAnkle(28, 'R Ankle'),
  leftHeel(29, 'L Heel'),
  rightHeel(30, 'R Heel'),
  leftFootIndex(31, 'L Foot'),
  rightFootIndex(32, 'R Foot');

  final int id;
  final String label;
  const LandmarkType(this.id, this.label);
}

/// Represents an individual detected 3D body landmark.
class PoseLandmark extends Equatable {
  final LandmarkType type;
  final double x; // Normalized 0.0 to 1.0
  final double y; // Normalized 0.0 to 1.0
  final double z;
  final double likelihood; // Confidence 0.0 to 1.0

  const PoseLandmark({
    required this.type,
    required this.x,
    required this.y,
    this.z = 0.0,
    this.likelihood = 1.0,
  });

  @override
  List<Object?> get props => [type, x, y, z, likelihood];
}

/// Helper pair representing a skeletal bone connection between two landmarks.
class PoseConnection extends Equatable {
  final LandmarkType start;
  final LandmarkType end;

  const PoseConnection(this.start, this.end);

  @override
  List<Object?> get props => [start, end];
}

/// Complete Pose Data model containing all 33 detected landmarks.
class PoseData extends Equatable {
  final List<PoseLandmark> landmarks;
  final double overallConfidence;
  final DateTime timestamp;

  const PoseData({
    required this.landmarks,
    required this.overallConfidence,
    required this.timestamp,
  });

  /// Standard MediaPipe 33 Landmark Skeletal Bone Connections.
  static const List<PoseConnection> connections = [
    // Face
    PoseConnection(LandmarkType.nose, LandmarkType.leftEye),
    PoseConnection(LandmarkType.leftEye, LandmarkType.leftEar),
    PoseConnection(LandmarkType.nose, LandmarkType.rightEye),
    PoseConnection(LandmarkType.rightEye, LandmarkType.rightEar),
    PoseConnection(LandmarkType.mouthLeft, LandmarkType.mouthRight),

    // Shoulders & Torso
    PoseConnection(LandmarkType.leftShoulder, LandmarkType.rightShoulder),
    PoseConnection(LandmarkType.leftShoulder, LandmarkType.leftHip),
    PoseConnection(LandmarkType.rightShoulder, LandmarkType.rightHip),
    PoseConnection(LandmarkType.leftHip, LandmarkType.rightHip),

    // Left Arm
    PoseConnection(LandmarkType.leftShoulder, LandmarkType.leftElbow),
    PoseConnection(LandmarkType.leftElbow, LandmarkType.leftWrist),
    PoseConnection(LandmarkType.leftWrist, LandmarkType.leftPinky),
    PoseConnection(LandmarkType.leftWrist, LandmarkType.leftIndex),
    PoseConnection(LandmarkType.leftWrist, LandmarkType.leftThumb),

    // Right Arm
    PoseConnection(LandmarkType.rightShoulder, LandmarkType.rightElbow),
    PoseConnection(LandmarkType.rightElbow, LandmarkType.rightWrist),
    PoseConnection(LandmarkType.rightWrist, LandmarkType.rightPinky),
    PoseConnection(LandmarkType.rightWrist, LandmarkType.rightIndex),
    PoseConnection(LandmarkType.rightWrist, LandmarkType.rightThumb),

    // Left Leg
    PoseConnection(LandmarkType.leftHip, LandmarkType.leftKnee),
    PoseConnection(LandmarkType.leftKnee, LandmarkType.leftAnkle),
    PoseConnection(LandmarkType.leftAnkle, LandmarkType.leftHeel),
    PoseConnection(LandmarkType.leftAnkle, LandmarkType.leftFootIndex),

    // Right Leg
    PoseConnection(LandmarkType.rightHip, LandmarkType.rightKnee),
    PoseConnection(LandmarkType.rightKnee, LandmarkType.rightAnkle),
    PoseConnection(LandmarkType.rightAnkle, LandmarkType.rightHeel),
    PoseConnection(LandmarkType.rightAnkle, LandmarkType.rightFootIndex),
  ];

  @override
  List<Object?> get props => [landmarks, overallConfidence, timestamp];
}
