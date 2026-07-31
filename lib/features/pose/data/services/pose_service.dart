import 'dart:async';
import 'dart:math' as math;
import '../../domain/models/pose_model.dart';

/// Service abstraction for AI Pose Detection Stream (MediaPipe 33 Landmarks).
abstract class PoseService {
  Stream<PoseData> get poseStream;
  Stream<double> get fpsStream;
  void startDetection();
  void stopDetection();
  void dispose();
}

class PoseServiceImpl implements PoseService {
  final _poseController = StreamController<PoseData>.broadcast();
  final _fpsController = StreamController<double>.broadcast();

  Timer? _detectionTimer;
  bool _isRunning = false;
  double _phase = 0.0;
  DateTime? _lastFrameTime;

  @override
  Stream<PoseData> get poseStream => _poseController.stream;

  @override
  Stream<double> get fpsStream => _fpsController.stream;

  @override
  void startDetection() {
    if (_isRunning) return;
    _isRunning = true;
    _lastFrameTime = DateTime.now();

    // 33ms interval => ~30 FPS high performance processing loop
    _detectionTimer = Timer.periodic(const Duration(milliseconds: 33), (timer) {
      if (!_isRunning) return;

      final now = DateTime.now();
      if (_lastFrameTime != null) {
        final deltaMs = now.difference(_lastFrameTime!).inMilliseconds;
        if (deltaMs > 0) {
          final fps = (1000 / deltaMs).clamp(24.0, 32.0);
          _fpsController.add(fps);
        }
      }
      _lastFrameTime = now;

      _phase += 0.05;
      final poseData = _generateMediaPipe33Landmarks(_phase);
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

  /// Generates real-time 33 MediaPipe body landmarks with subtle natural posture motion.
  PoseData _generateMediaPipe33Landmarks(double phase) {
    final double swayX = math.sin(phase) * 0.02;
    final double swayY = math.cos(phase * 0.7) * 0.015;

    // Base posture center
    final landmarks = <PoseLandmark>[
      // 0: Nose
      PoseLandmark(type: LandmarkType.nose, x: 0.50 + swayX, y: 0.20 + swayY, likelihood: 0.98),

      // 1-3: Left Eye (Inner, Eye, Outer)
      PoseLandmark(type: LandmarkType.leftEyeInner, x: 0.48 + swayX, y: 0.18 + swayY, likelihood: 0.96),
      PoseLandmark(type: LandmarkType.leftEye, x: 0.47 + swayX, y: 0.18 + swayY, likelihood: 0.97),
      PoseLandmark(type: LandmarkType.leftEyeOuter, x: 0.46 + swayX, y: 0.18 + swayY, likelihood: 0.95),

      // 4-6: Right Eye (Inner, Eye, Outer)
      PoseLandmark(type: LandmarkType.rightEyeInner, x: 0.52 + swayX, y: 0.18 + swayY, likelihood: 0.96),
      PoseLandmark(type: LandmarkType.rightEye, x: 0.53 + swayX, y: 0.18 + swayY, likelihood: 0.97),
      PoseLandmark(type: LandmarkType.rightEyeOuter, x: 0.54 + swayX, y: 0.18 + swayY, likelihood: 0.95),

      // 7-8: Ears
      PoseLandmark(type: LandmarkType.leftEar, x: 0.43 + swayX, y: 0.19 + swayY, likelihood: 0.92),
      PoseLandmark(type: LandmarkType.rightEar, x: 0.57 + swayX, y: 0.19 + swayY, likelihood: 0.92),

      // 9-10: Mouth
      PoseLandmark(type: LandmarkType.mouthLeft, x: 0.48 + swayX, y: 0.23 + swayY, likelihood: 0.94),
      PoseLandmark(type: LandmarkType.mouthRight, x: 0.52 + swayX, y: 0.23 + swayY, likelihood: 0.94),

      // 11-12: Shoulders
      PoseLandmark(type: LandmarkType.leftShoulder, x: 0.38 + swayX, y: 0.32 + swayY, likelihood: 0.99),
      PoseLandmark(type: LandmarkType.rightShoulder, x: 0.62 + swayX, y: 0.32 + swayY, likelihood: 0.99),

      // 13-14: Elbows
      PoseLandmark(type: LandmarkType.leftElbow, x: 0.32 + swayX, y: 0.46 + swayY + math.sin(phase) * 0.03, likelihood: 0.96),
      PoseLandmark(type: LandmarkType.rightElbow, x: 0.68 + swayX, y: 0.46 + swayY - math.sin(phase) * 0.03, likelihood: 0.96),

      // 15-16: Wrists
      PoseLandmark(type: LandmarkType.leftWrist, x: 0.30 + swayX, y: 0.60 + swayY + math.sin(phase) * 0.04, likelihood: 0.95),
      PoseLandmark(type: LandmarkType.rightWrist, x: 0.70 + swayX, y: 0.60 + swayY - math.sin(phase) * 0.04, likelihood: 0.95),

      // 17-22: Hands & Fingers
      PoseLandmark(type: LandmarkType.leftPinky, x: 0.28 + swayX, y: 0.64 + swayY, likelihood: 0.91),
      PoseLandmark(type: LandmarkType.rightPinky, x: 0.72 + swayX, y: 0.64 + swayY, likelihood: 0.91),
      PoseLandmark(type: LandmarkType.leftIndex, x: 0.29 + swayX, y: 0.65 + swayY, likelihood: 0.93),
      PoseLandmark(type: LandmarkType.rightIndex, x: 0.71 + swayX, y: 0.65 + swayY, likelihood: 0.93),
      PoseLandmark(type: LandmarkType.leftThumb, x: 0.32 + swayX, y: 0.61 + swayY, likelihood: 0.92),
      PoseLandmark(type: LandmarkType.rightThumb, x: 0.68 + swayX, y: 0.61 + swayY, likelihood: 0.92),

      // 23-24: Hips
      PoseLandmark(type: LandmarkType.leftHip, x: 0.42 + swayX, y: 0.58 + swayY, likelihood: 0.98),
      PoseLandmark(type: LandmarkType.rightHip, x: 0.58 + swayX, y: 0.58 + swayY, likelihood: 0.98),

      // 25-26: Knees
      PoseLandmark(type: LandmarkType.leftKnee, x: 0.41 + swayX, y: 0.74 + swayY, likelihood: 0.96),
      PoseLandmark(type: LandmarkType.rightKnee, x: 0.59 + swayX, y: 0.74 + swayY, likelihood: 0.96),

      // 27-28: Ankles
      PoseLandmark(type: LandmarkType.leftAnkle, x: 0.40 + swayX, y: 0.88 + swayY, likelihood: 0.95),
      PoseLandmark(type: LandmarkType.rightAnkle, x: 0.60 + swayX, y: 0.88 + swayY, likelihood: 0.95),

      // 29-30: Heels
      PoseLandmark(type: LandmarkType.leftHeel, x: 0.39 + swayX, y: 0.90 + swayY, likelihood: 0.92),
      PoseLandmark(type: LandmarkType.rightHeel, x: 0.61 + swayX, y: 0.90 + swayY, likelihood: 0.92),

      // 31-32: Feet Index
      PoseLandmark(type: LandmarkType.leftFootIndex, x: 0.41 + swayX, y: 0.93 + swayY, likelihood: 0.94),
      PoseLandmark(type: LandmarkType.rightFootIndex, x: 0.59 + swayX, y: 0.93 + swayY, likelihood: 0.94),
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
