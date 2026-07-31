import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/pose_service.dart';
import '../../domain/models/pose_model.dart';

/// State representation for AI Pose Detection module.
class PoseDetectionState {
  final bool isDetectionActive;
  final PoseData? currentPose;
  final double currentFps;
  final bool showSkeletonMesh;
  final bool showLandmarkLabels;

  const PoseDetectionState({
    this.isDetectionActive = true,
    this.currentPose,
    this.currentFps = 29.8,
    this.showSkeletonMesh = true,
    this.showLandmarkLabels = false,
  });

  PoseDetectionState copyWith({
    bool? isDetectionActive,
    PoseData? currentPose,
    double? currentFps,
    bool? showSkeletonMesh,
    bool? showLandmarkLabels,
  }) {
    return PoseDetectionState(
      isDetectionActive: isDetectionActive ?? this.isDetectionActive,
      currentPose: currentPose ?? this.currentPose,
      currentFps: currentFps ?? this.currentFps,
      showSkeletonMesh: showSkeletonMesh ?? this.showSkeletonMesh,
      showLandmarkLabels: showLandmarkLabels ?? this.showLandmarkLabels,
    );
  }
}

/// Riverpod StateNotifier managing the real-time AI Pose Detection stream & UI toggles.
class PoseNotifier extends StateNotifier<PoseDetectionState> {
  final PoseService _poseService;
  StreamSubscription<PoseData>? _poseSubscription;
  StreamSubscription<double>? _fpsSubscription;

  PoseNotifier(this._poseService) : super(const PoseDetectionState()) {
    _startListening();
  }

  void _startListening() {
    _poseService.startDetection();

    _poseSubscription = _poseService.poseStream.listen((poseData) {
      if (state.isDetectionActive) {
        state = state.copyWith(currentPose: poseData);
      }
    });

    _fpsSubscription = _poseService.fpsStream.listen((fps) {
      if (state.isDetectionActive) {
        state = state.copyWith(currentFps: fps);
      }
    });
  }

  void updateMotionOffset(double dx, double dy) {
    _poseService.updateMotionOffset(dx, dy);
  }

  void toggleSkeletonMesh() {
    state = state.copyWith(showSkeletonMesh: !state.showSkeletonMesh);
  }

  void toggleLandmarkLabels() {
    state = state.copyWith(showLandmarkLabels: !state.showLandmarkLabels);
  }

  void toggleDetection(bool active) {
    state = state.copyWith(isDetectionActive: active);
  }

  @override
  void dispose() {
    _poseSubscription?.cancel();
    _fpsSubscription?.cancel();
    _poseService.dispose();
    super.dispose();
  }
}
