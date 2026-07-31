import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../providers/camera_provider.dart';
import '../../../../providers/ghost_overlay_provider.dart';
import '../../../pose_library/presentation/widgets/ghost_controls_widget.dart';
import '../../../pose_library/presentation/widgets/ghost_overlay_painter.dart';
import '../../domain/models/camera_state.dart';
import '../widgets/camera_bottom_bar.dart';
import '../widgets/camera_permission_widget.dart';
import '../widgets/camera_preview_widget.dart';
import '../widgets/camera_top_bar.dart';
import '../widgets/camera_zoom_controls.dart';

/// Primary Camera Viewfinder Screen for PoseSnap AI with Ghost Pose Overlay.
class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initialize camera once when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cameraProvider.notifier).initCamera();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final notifier = ref.read(cameraProvider.notifier);
    final controller = notifier.cameraService.controller;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      notifier.cameraService.dispose();
    } else if (state == AppLifecycleState.resumed) {
      notifier.initCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraState = ref.watch(cameraProvider);
    final ghostState = ref.watch(ghostOverlayProvider);
    final notifier = ref.read(cameraProvider.notifier);

    // Permission handling screens
    if (cameraState.permissionState == CameraPermissionState.denied) {
      return CameraPermissionWidget(
        isPermanentlyDenied: false,
        onRetry: () => notifier.initCamera(),
      );
    }

    if (cameraState.permissionState == CameraPermissionState.permanentlyDenied) {
      return CameraPermissionWidget(
        isPermanentlyDenied: true,
        onRetry: () => notifier.initCamera(),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Fullscreen Live Viewfinder
          const CameraPreviewWidget(),

          // 2. Ghost Pose Overlay (Wrapped in RepaintBoundary for 60 FPS performance)
          if (ghostState.activePose != null && ghostState.isGhostVisible)
            RepaintBoundary(
              child: CustomPaint(
                painter: GhostOverlayPainter(
                  activePose: ghostState.activePose,
                  opacity: ghostState.opacity,
                  positionOffset: ghostState.positionOffset,
                ),
                child: const SizedBox.expand(),
              ),
            ),

          // 3. Top Controls Glass Bar
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CameraTopBar(),
          ),

          // 4. Ghost Pose Controls HUD (Top Right)
          const Positioned(
            top: 0,
            right: 0,
            child: GhostControlsWidget(),
          ),

          // 5. Floating Zoom Controls
          const Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Center(
              child: CameraZoomControls(),
            ),
          ),

          // 6. Bottom Controls Shutter Bar
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CameraBottomBar(),
          ),
        ],
      ),
    );
  }
}
