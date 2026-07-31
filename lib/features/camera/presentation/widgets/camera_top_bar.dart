import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../providers/camera_provider.dart';

/// Glassmorphic Google Pixel style Top Bar for Camera Controls with Back button.
class CameraTopBar extends ConsumerWidget {
  const CameraTopBar({super.key});

  IconData _getFlashIcon(FlashMode mode) {
    switch (mode) {
      case FlashMode.off:
        return Icons.flash_off_rounded;
      case FlashMode.auto:
        return Icons.flash_auto_rounded;
      case FlashMode.always:
        return Icons.flash_on_rounded;
      case FlashMode.torch:
        return Icons.highlight_rounded;
    }
  }

  Color _getFlashColor(FlashMode mode) {
    switch (mode) {
      case FlashMode.off:
        return Colors.white70;
      case FlashMode.auto:
        return AppColors.secondary;
      case FlashMode.always:
      case FlashMode.torch:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraProvider);
    final notifier = ref.read(cameraProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withValues(alpha: 0.75),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back to Home Button
            IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.goNamed(RouteNames.home);
                }
              },
              tooltip: 'Back to Home',
            ),

            // Flash Toggle Button
            IconButton(
              icon: Icon(
                _getFlashIcon(cameraState.flashMode),
                color: _getFlashColor(cameraState.flashMode),
                size: 24,
              ),
              onPressed: () => notifier.toggleFlashMode(),
              tooltip: 'Flash Mode',
            ),

            // Grid Toggle Button
            IconButton(
              icon: Icon(
                cameraState.isGridVisible ? Icons.grid_on_rounded : Icons.grid_off_rounded,
                color: cameraState.isGridVisible ? AppColors.secondary : Colors.white70,
                size: 24,
              ),
              onPressed: () => notifier.toggleGrid(),
              tooltip: 'Grid Lines',
            ),

            // AI Indicator Badge (Placeholder)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.6),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'AI Ready',
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // Settings Button
            IconButton(
              icon: const Icon(
                Icons.settings_outlined,
                color: Colors.white70,
                size: 24,
              ),
              onPressed: () => context.pushNamed(RouteNames.settings),
              tooltip: 'Camera Settings',
            ),
          ],
        ),
      ),
    );
  }
}
