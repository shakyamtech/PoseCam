import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../providers/camera_provider.dart';

/// Pixel-style Bottom Control Bar for capture, camera switch & gallery preview.
class CameraBottomBar extends ConsumerWidget {
  const CameraBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraProvider);
    final notifier = ref.read(cameraProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.85),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Gallery Thumbnail Button
            GestureDetector(
              onTap: () => context.pushNamed(RouteNames.profile),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white38, width: 2),
                  color: AppColors.darkSurfaceVariant,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: const Icon(
                    Icons.photo_library_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),

            // Google Pixel Large Capture Button
            GestureDetector(
              onTap: cameraState.isCapturing
                  ? null
                  : () async {
                      final image = await notifier.captureImage();
                      if (image != null && context.mounted) {
                        context.pushNamed(
                          RouteNames.cameraPreview,
                          extra: image,
                        );
                      }
                    },
              child: Container(
                width: 78,
                height: 78,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3.5),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: cameraState.isCapturing ? AppColors.tertiary : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: cameraState.isCapturing
                      ? const Center(
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ),

            // Camera Flip Button
            GestureDetector(
              onTap: () => notifier.switchCamera(),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
                child: const Icon(
                  Icons.flip_camera_ios_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
