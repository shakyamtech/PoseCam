import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../providers/camera_provider.dart';
import 'focus_ring_widget.dart';
import 'web_camera_view.dart';

/// Interactive Live Camera Preview widget with Rule of Thirds grid overlay and tap-to-focus.
class CameraPreviewWidget extends ConsumerWidget {
  const CameraPreviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraProvider);
    final notifier = ref.read(cameraProvider.notifier);
    final controller = notifier.cameraService.controller;

    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTapUp: (details) {
        notifier.onTapFocus(details.localPosition, screenSize);
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Hardware Camera Preview or Web HTML5 Stream or Fallback Graphic
          if (cameraState.isInitialized && controller != null && controller.value.isInitialized)
            Center(
              child: CameraPreview(controller),
            )
          else if (kIsWeb)
            const WebCameraView()
          else
            _buildFallbackPreview(context, cameraState.errorMessage),

          // 2. Rule of Thirds Grid Overlay
          if (cameraState.isGridVisible) _buildGridOverlay(),

          // 3. Tap-to-Focus Ring
          if (cameraState.tapFocusPoint != null)
            FocusRingWidget(position: cameraState.tapFocusPoint!),
        ],
      ),
    );
  }

  Widget _buildFallbackPreview(BuildContext context, String? errorMessage) {
    return Container(
      color: AppColors.darkBackground,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                size: 54,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Google Pixel Camera Viewfinder',
              style: AppTypography.titleLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                errorMessage ??
                    'Live Viewfinder Active. Connect physical mobile device for hardware camera stream.',
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.white60,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridOverlay() {
    return IgnorePointer(
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: Container(decoration: _gridBorderDecoration())),
                Expanded(child: Container(decoration: _gridBorderDecoration())),
                Expanded(child: Container(decoration: _gridBorderDecoration())),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(child: Container(decoration: _gridBorderDecoration())),
                Expanded(child: Container(decoration: _gridBorderDecoration())),
                Expanded(child: Container(decoration: _gridBorderDecoration())),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(child: Container(decoration: _gridBorderDecoration())),
                Expanded(child: Container(decoration: _gridBorderDecoration())),
                Expanded(child: Container(decoration: _gridBorderDecoration())),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _gridBorderDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.22),
        width: 0.5,
      ),
    );
  }
}
