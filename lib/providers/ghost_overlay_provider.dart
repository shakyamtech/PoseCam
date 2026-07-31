import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/pose_library/presentation/controllers/ghost_overlay_controller.dart';

/// Riverpod StateNotifierProvider for Ghost Pose Overlay System.
final ghostOverlayProvider =
    StateNotifierProvider<GhostOverlayNotifier, GhostOverlayState>((ref) {
  return GhostOverlayNotifier();
});
