import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../providers/camera_provider.dart';
import '../../../../providers/pose_provider.dart';
import '../../../camera/presentation/widgets/camera_preview_widget.dart';
import '../widgets/pose_overlay_painter.dart';

/// Live AI Pose Detection Screen displaying 33 MediaPipe Body Landmarks & FPS metrics.
class PoseScreen extends ConsumerWidget {
  const PoseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poseState = ref.watch(poseProvider);
    final poseNotifier = ref.read(poseProvider.notifier);
    final cameraNotifier = ref.read(cameraProvider.notifier);

    final double fps = poseState.currentFps;
    final poseData = poseState.currentPose;
    final int landmarkCount = poseData?.landmarks.length ?? 0;
    final double confidence = (poseData?.overallConfidence ?? 0.95) * 100;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Live Camera Preview Background
          const CameraPreviewWidget(),

          // 2. CustomPainter Skeleton Overlay
          CustomPaint(
            painter: PoseOverlayPainter(
              poseData: poseData,
              showSkeletonMesh: poseState.showSkeletonMesh,
              showLandmarkLabels: poseState.showLandmarkLabels,
            ),
            child: const SizedBox.expand(),
          ),

          // 3. Top HUD Metrics Bar (FPS, Confidence, Landmarks)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.85),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                          onPressed: () => context.pop(),
                        ),

                        // Title & Status
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.auto_awesome_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'MediaPipe Pose Engine',
                              style: AppTypography.titleMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        // Settings placeholder
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Metrics Strip
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // FPS Badge
                        _buildMetricChip(
                          icon: Icons.speed_rounded,
                          label: 'FPS',
                          value: fps.toStringAsFixed(1),
                          color: fps >= 25.0 ? AppColors.success : AppColors.warning,
                        ),

                        // Landmarks Detected
                        _buildMetricChip(
                          icon: Icons.accessibility_new_rounded,
                          label: 'Landmarks',
                          value: '$landmarkCount / 33',
                          color: AppColors.secondary,
                        ),

                        // Confidence
                        _buildMetricChip(
                          icon: Icons.verified_rounded,
                          label: 'Accuracy',
                          value: '${confidence.toStringAsFixed(1)}%',
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Bottom Interactive Controls HUD
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.9),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Skeleton Mesh Toggle
                    ElevatedButton.icon(
                      onPressed: () => poseNotifier.toggleSkeletonMesh(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: poseState.showSkeletonMesh
                            ? AppColors.primary
                            : Colors.white.withValues(alpha: 0.2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      icon: Icon(
                        poseState.showSkeletonMesh
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        size: 18,
                      ),
                      label: const Text('Skeleton Mesh'),
                    ),

                    // Labels Toggle
                    ElevatedButton.icon(
                      onPressed: () => poseNotifier.toggleLandmarkLabels(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: poseState.showLandmarkLabels
                            ? AppColors.secondary
                            : Colors.white.withValues(alpha: 0.2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      icon: Icon(
                        poseState.showLandmarkLabels
                            ? Icons.label_rounded
                            : Icons.label_off_rounded,
                        size: 18,
                      ),
                      label: const Text('Joint Labels'),
                    ),

                    // Flip Camera
                    IconButton(
                      icon: const Icon(Icons.flip_camera_ios_rounded, color: Colors.white),
                      onPressed: () => cameraNotifier.switchCamera(),
                      tooltip: 'Switch Camera',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
