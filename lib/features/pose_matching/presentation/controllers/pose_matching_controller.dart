import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/ghost_overlay_provider.dart';
import '../../../../providers/pose_provider.dart';
import '../../../pose/presentation/controllers/pose_controller.dart';
import '../../../pose_library/presentation/controllers/ghost_overlay_controller.dart';
import '../../domain/models/pose_score.dart';
import '../../domain/services/pose_matcher.dart';

/// Riverpod StateNotifier managing real-time pose matching comparison at 30 FPS.
class PoseMatchingNotifier extends StateNotifier<PoseMatchResult> {
  final Ref _ref;

  PoseMatchingNotifier(this._ref) : super(PoseMatchResult.initial()) {
    _listenToStreams();
  }

  void _listenToStreams() {
    _ref.listen<PoseDetectionState>(poseProvider, (previous, next) {
      _evaluatePoseMatch();
    });

    _ref.listen<GhostOverlayState>(ghostOverlayProvider, (previous, next) {
      _evaluatePoseMatch();
    });
  }

  void _evaluatePoseMatch() {
    final poseState = _ref.read(poseProvider);
    final ghostState = _ref.read(ghostOverlayProvider);

    if (ghostState.activePose == null || !ghostState.isGhostVisible) {
      state = PoseMatchResult.initial();
      return;
    }

    final liveLandmarks = poseState.currentPose?.landmarks;
    final targetPose = ghostState.activePose;

    final result = PoseMatcherService.comparePoses(
      liveLandmarks: liveLandmarks,
      targetPose: targetPose,
      toleranceDegree: 20.0,
    );

    state = result;
  }
}
