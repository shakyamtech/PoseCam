import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../providers/camera_provider.dart';

/// Floating Zoom Pills (1x, 2x, 5x) for Google Pixel style zooming.
class CameraZoomControls extends ConsumerWidget {
  const CameraZoomControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraProvider);
    final notifier = ref.read(cameraProvider.notifier);

    final zoomLevels = [1.0, 2.0, 5.0];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: zoomLevels.map((zoom) {
          final isSelected = (cameraState.zoomLevel - zoom).abs() < 0.3;
          final isSupported = zoom <= cameraState.maxZoomLevel;

          return GestureDetector(
            onTap: isSupported ? () => notifier.setZoomLevel(zoom) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${zoom.toInt()}x',
                style: AppTypography.labelSmall.copyWith(
                  color: isSupported
                      ? (isSelected ? Colors.white : Colors.white70)
                      : Colors.white24,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
