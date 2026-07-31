import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/custom_button.dart';

/// Clean Material 3 screen for Camera Permission Request & Denied Handling.
class CameraPermissionWidget extends StatelessWidget {
  final bool isPermanentlyDenied;
  final VoidCallback onRetry;

  const CameraPermissionWidget({
    super.key,
    required this.isPermanentlyDenied,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_enhance_outlined,
                  size: 64,
                  color: AppColors.tertiary,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Camera Access Required',
                style: AppTypography.displayMedium.copyWith(
                  color: Colors.white,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                isPermanentlyDenied
                    ? 'Camera permission is permanently denied. Please enable camera access in your device settings to use PoseSnap AI.'
                    : 'PoseSnap AI needs camera permission to display live pose overlays and capture photos.',
                style: AppTypography.bodyLarge.copyWith(
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              if (isPermanentlyDenied)
                CustomButton(
                  text: 'Open Settings',
                  icon: Icons.settings_rounded,
                  onPressed: () => openAppSettings(),
                )
              else
                CustomButton(
                  text: 'Allow Camera Access',
                  icon: Icons.check_circle_outline_rounded,
                  onPressed: onRetry,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
