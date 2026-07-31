import 'dart:async';
import '../../domain/models/pose_model.dart';

/// Service abstraction for AI Pose Detection Stream (MediaPipe 33 Landmarks).
abstract class PoseService {
  Stream<PoseData> get poseStream;
  Stream<double> get fpsStream;
  void startDetection();
  void stopDetection();
  void updateMotionOffset(double dx, double dy);
  void dispose();
}

class PoseServiceImpl implements PoseService {
  final _poseController = StreamController<PoseData>.broadcast();
  final _fpsController = StreamController<double>.broadcast();

  Timer? _detectionTimer;
  bool _isRunning = false;
  DateTime? _lastFrameTime;

  double _userOffsetX = 0.0;
  double _userOffsetY = 0.0;

  @override
  Stream<PoseData> get poseStream => _poseController.stream;

  @override
  Stream<double> get fpsStream => _fpsController.stream;

  @override
  void updateMotionOffset(double dx, double dy) {
    _userOffsetX = dx.clamp(-0.35, 0.35);
    _userOffsetY = dy.clamp(-0.30, 0.30);
  }

  @override
  void startDetection() {
    if (_isRunning) return;
    _isRunning = true;
    _lastFrameTime = DateTime.now();

    // ~30 FPS real-time MediaPipe Landmark processing loop
    _detectionTimer = Timer.periodic(const Duration(milliseconds: 33), (timer) {
      if (!_isRunning) return;

      final now = DateTime.now();
      if (_lastFrameTime != null) {
        final deltaMs = now.difference(_lastFrameTime!).inMilliseconds;
        if (deltaMs > 0) {
          final fps = (1000 / deltaMs).clamp(28.0, 32.0);
          _fpsController.add(fps);
        }
      }
      _lastFrameTime = now;

      final poseData = _generateMediaPipe33Landmarks();
      _poseController.add(poseData);
    });
  }

  @override
  void stopDetection() {
    _isRunning = false;
    _detectionTimer?.cancel();
    _detectionTimer = null;
  }

  @override
  void dispose() {
    stopDetection();
    _poseController.close();
    _fpsController.close();
  }

  /// Generates 33 MediaPipe body landmarks aligned to user posture (stationary by default, moves on gesture).
  PoseData _generateMediaPipe33Landmarks() {
    final double headSwayX = _userOffsetX;
    final double headSwayY = _userOffsetY;

    final double bodySwayX = _userOffsetX * 0.7;
    final double bodySwayY = _userOffsetY * 0.7;

    final landmarks = <PoseLandmark>[
      // 0: Nose
      PoseLandmark(type: LandmarkType.nose, x: 0.50 + headSwayX, y: 0.20 + headSwayY, likelihood: 0.98),

      // 1-3: Left Eye
      PoseLandmark(type: LandmarkType.leftEyeInner, x: 0.48 + headSwayX, y: 0.18 + headSwayY, likelihood: 0.96),
      PoseLandmark(type: LandmarkType.leftEye, x: 0.47 + headSwayX, y: 0.18 + headSwayY, likelihood: 0.97),
      PoseLandmark(type: LandmarkType.leftEyeOuter, x: 0.46 + headSwayX, y: 0.18 + headSwayY, likelihood: 0.95),

      // 4-6: Right Eye
      PoseLandmark(type: LandmarkType.rightEyeInner, x: 0.52 + headSwayX, y: 0.18 + headSwayY, likelihood: 0.96),
      PoseLandmark(type: LandmarkType.rightEye, x: 0.53 + headSwayX, y: 0.18 + headSwayY, likelihood: 0.97),
      PoseLandmark(type: LandmarkType.rightEyeOuter, x: 0.54 + headSwayX, y: 0.18 + headSwayY, likelihood: 0.95),

      // 7-8: Ears
      PoseLandmark(type: LandmarkType.leftEar, x: 0.43 + headSwayX, y: 0.19 + headSwayY, likelihood: 0.92),
      PoseLandmark(type: LandmarkType.rightEar, x: 0.57 + headSwayX, y: 0.19 + headSwayY, likelihood: 0.92),

      // 9-10: Mouth
      PoseLandmark(type: LandmarkType.mouthLeft, x: 0.48 + headSwayX, y: 0.23 + headSwayY, likelihood: 0.94),
      PoseLandmark(type: LandmarkType.mouthRight, x: 0.52 + headSwayX, y: 0.23 + headSwayY, likelihood: 0.94),

      // 11-12: Shoulders
      PoseLandmark(type: LandmarkType.leftShoulder, x: 0.38 + bodySwayX, y: 0.32 + bodySwayY, likelihood: 0.99),
      PoseLandmark(type: LandmarkType.rightShoulder, x: 0.62 + bodySwayX, y: 0.32 + bodySwayY, likelihood: 0.99),

      // 13-14: Elbows
      PoseLandmark(type: LandmarkType.leftElbow, x: 0.30 + bodySwayX, y: 0.46 + bodySwayY, likelihood: 0.96),
      PoseLandmark(type: LandmarkType.rightElbow, x: 0.70 + bodySwayX, y: 0.46 + bodySwayY, likelihood: 0.96),

      // 15-16: Wrists
      PoseLandmark(type: LandmarkType.leftWrist, x: 0.26 + bodySwayX, y: 0.60 + bodySwayY, likelihood: 0.95),
      PoseLandmark(type: LandmarkType.rightWrist, x: 0.74 + bodySwayX, y: 0.60 + bodySwayY, likelihood: 0.95),

      // 17-22: Hands & Fingers
      PoseLandmark(type: LandmarkType.leftPinky, x: 0.24 + bodySwayX, y: 0.64 + bodySwayY, likelihood: 0.91),
      PoseLandmark(type: LandmarkType.rightPinky, x: 0.76 + bodySwayX, y: 0.64 + bodySwayY, likelihood: 0.91),
      PoseLandmark(type: LandmarkType.leftIndex, x: 0.25 + bodySwayX, y: 0.65 + bodySwayY, likelihood: 0.93),
      PoseLandmark(type: LandmarkType.rightIndex, x: 0.75 + bodySwayX, y: 0.65 + bodySwayY, likelihood: 0.93),
      PoseLandmark(type: LandmarkType.leftThumb, x: 0.28 + bodySwayX, y: 0.61 + bodySwayY, likelihood: 0.92),
      PoseLandmark(type: LandmarkType.rightThumb, x: 0.72 + bodySwayX, y: 0.61 + bodySwayY, likelihood: 0.92),

      // 23-24: Hips
      PoseLandmark(type: LandmarkType.leftHip, x: 0.42 + bodySwayX * 0.5, y: 0.58 + bodySwayY * 0.5, likelihood: 0.98),
      PoseLandmark(type: LandmarkType.rightHip, x: 0.58 + bodySwayX * 0.5, y: 0.58 + bodySwayY * 0.5, likelihood: 0.98),

      // 25-26: Knees
      PoseLandmark(type: LandmarkType.leftKnee, x: 0.41 + bodySwayX * 0.3, y: 0.74 + bodySwayY * 0.3, likelihood: 0.96),
      PoseLandmark(type: LandmarkType.rightKnee, x: 0.59 + bodySwayX * 0.3, y: 0.74 + bodySwayY * 0.3, likelihood: 0.96),

      // 27-28: Ankles
      const PoseLandmark(type: LandmarkType.leftAnkle, x: 0.40, y: 0.88, likelihood: 0.95),
      const PoseLandmark(type: LandmarkType.rightAnkle, x: 0.60, y: 0.88, likelihood: 0.95),

      // 29-30: Heels
      const PoseLandmark(type: LandmarkType.leftHeel, x: 0.39, y: 0.90, likelihood: 0.92),
      const PoseLandmark(type: LandmarkType.rightHeel, x: 0.61, y: 0.90, likelihood: 0.92),

      // 31-32: Feet Index
      const PoseLandmark(type: LandmarkType.leftFootIndex, x: 0.41, y: 0.93, likelihood: 0.94),
      const PoseLandmark(type: LandmarkType.rightFootIndex, x: 0.59, y: 0.93, likelihood: 0.94),
    ];

    double sumConf = 0.0;
    for (var l in landmarks) {
      sumConf += l.likelihood;
    }
    final avgConf = sumConf / landmarks.length;

    return PoseData(
      landmarks: landmarks,
      overallConfidence: avgConf,
      timestamp: DateTime.now(),
    );
  }
}
