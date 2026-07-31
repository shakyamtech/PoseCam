import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/pose_item_model.dart';

/// State representation for the Ghost Pose Overlay System.
class GhostOverlayState {
  final bool isGhostVisible;
  final double opacity;
  final PoseItemModel? activePose;
  final Offset positionOffset;

  const GhostOverlayState({
    this.isGhostVisible = true,
    this.opacity = 0.40,
    this.activePose,
    this.positionOffset = Offset.zero,
  });

  GhostOverlayState copyWith({
    bool? isGhostVisible,
    double? opacity,
    PoseItemModel? activePose,
    Offset? positionOffset,
  }) {
    return GhostOverlayState(
      isGhostVisible: isGhostVisible ?? this.isGhostVisible,
      opacity: opacity ?? this.opacity,
      activePose: activePose ?? this.activePose,
      positionOffset: positionOffset ?? this.positionOffset,
    );
  }
}

/// Riverpod StateNotifier managing ghost pose overlay visibility, opacity, & position offset.
class GhostOverlayNotifier extends StateNotifier<GhostOverlayState> {
  GhostOverlayNotifier() : super(const GhostOverlayState());

  void setGhostPose(PoseItemModel pose) {
    state = state.copyWith(
      activePose: pose,
      isGhostVisible: true,
      opacity: 0.40,
      positionOffset: Offset.zero,
    );
  }

  void toggleGhost() {
    state = state.copyWith(isGhostVisible: !state.isGhostVisible);
  }

  void setOpacity(double opacity) {
    state = state.copyWith(opacity: opacity.clamp(0.1, 1.0));
  }

  void updateOffset(Offset delta) {
    state = state.copyWith(positionOffset: state.positionOffset + delta);
  }

  void resetPosition() {
    state = state.copyWith(
      positionOffset: Offset.zero,
      opacity: 0.40,
      isGhostVisible: true,
    );
  }

  void clearPose() {
    state = const GhostOverlayState();
  }
}
