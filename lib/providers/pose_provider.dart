import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/pose/data/services/pose_service.dart';
import '../features/pose/presentation/controllers/pose_controller.dart';

/// Pose Service DI Provider
final poseServiceProvider = Provider<PoseService>((ref) {
  return PoseServiceImpl();
});

/// Pose Detection State Notifier Provider
final poseProvider = StateNotifierProvider.autoDispose<PoseNotifier, PoseDetectionState>((ref) {
  final service = ref.watch(poseServiceProvider);
  return PoseNotifier(service);
});
