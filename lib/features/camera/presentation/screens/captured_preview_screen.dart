import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../providers/gallery_provider.dart';

/// Screen displaying the captured image with actions: Retake, AI Pose overlay, Edit Photo, and Save.
class CapturedPreviewScreen extends ConsumerWidget {
  final XFile? capturedFile;

  const CapturedPreviewScreen({
    super.key,
    this.capturedFile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Captured Photo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing captured photo...')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Image Preview Container
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.darkBorder, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: _buildImageWidget(),
                ),
              ),
            ),

            // Action Buttons Panel
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Retake Button
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.refresh_rounded, size: 20),
                          label: const Text('Retake'),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Continue to AI Pose Screen
                      Expanded(
                        child: CustomButton(
                          text: 'AI Pose',
                          icon: Icons.auto_awesome_rounded,
                          onPressed: () => context.pushNamed(RouteNames.pose),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Edit Photo Button
                      Expanded(
                        child: CustomButton(
                          text: 'Edit Photo',
                          variant: ButtonVariant.secondary,
                          icon: Icons.auto_fix_high_rounded,
                          onPressed: () => context.pushNamed(
                            RouteNames.editor,
                            extra: capturedFile,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Save Photo to Gallery
                      Expanded(
                        child: CustomButton(
                          text: 'Save Photo',
                          variant: ButtonVariant.primary,
                          icon: Icons.download_rounded,
                          onPressed: () {
                            if (capturedFile != null) {
                              ref.read(galleryProvider.notifier).addPhoto(capturedFile!.path);
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Photo saved to gallery successfully! 🎉'),
                              ),
                            );
                            context.pushNamed(RouteNames.profile);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (capturedFile != null) {
      final path = capturedFile!.path;
      if (kIsWeb) {
        if (path.startsWith('data:image')) {
          final base64Bytes = Uri.parse(path).data?.contentAsBytes();
          if (base64Bytes != null) {
            return Image.memory(
              base64Bytes,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            );
          }
        }
        return Image.network(
          path,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      }
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    // Fallback Mock Preview Graphic
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.6),
            AppColors.secondary.withValues(alpha: 0.3),
            AppColors.darkSurfaceVariant,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt_rounded,
              size: 64,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Text(
              'High Resolution Capture',
              style: AppTypography.titleLarge.copyWith(
                color: Colors.white,
              ),
            ),
            Text(
              'Captured Photo Preview',
              style: AppTypography.labelSmall.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
