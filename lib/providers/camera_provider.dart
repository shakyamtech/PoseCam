import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/camera/data/services/camera_service.dart';
import '../features/camera/domain/models/camera_state.dart';
import '../features/camera/presentation/controllers/camera_notifier.dart';

/// Camera Service DI Provider
final cameraServiceProvider = Provider<CameraService>((ref) {
  return CameraServiceImpl();
});

/// Camera State Notifier Provider
final cameraProvider = StateNotifierProvider.autoDispose<CameraNotifier, CameraState>((ref) {
  final service = ref.watch(cameraServiceProvider);
  final notifier = CameraNotifier(service);
  notifier.initCamera();
  return notifier;
});
