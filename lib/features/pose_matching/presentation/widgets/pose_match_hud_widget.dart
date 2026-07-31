import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../providers/ghost_overlay_provider.dart';
import '../../../../providers/pose_matching_provider.dart';

/// Top Glassmorphic HUD overlay displaying real-time Pose Match Percentage (e.g. 92%) & actionable feedback tips.
class PoseMatchHudWidget extends ConsumerWidget {
  const PoseMatchHudWidget({super.key});

  Color _getScoreColor(double score) {
    if (score >= 85.0) return AppColors.success;
    if (score >= 65.0) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ghostState = ref.watch(ghostOverlayProvider);
    final matchResult = ref.watch(poseMatchingProvider);

    if (ghostState.activePose == null || !ghostState.isGhostVisible) {
      return const SizedBox.shrink();
    }

    final scoreColor = _getScoreColor(matchResult.score);

    return Container(
      margin: const EdgeInsets.only(top: 80, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Live Score Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: scoreColor,
                width: 1.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: scoreColor.withValues(alpha: 0.35),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  matchResult.isPerfectMatch
                      ? Icons.verified_rounded
                      : Icons.center_focus_strong_rounded,
                  color: scoreColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Pose Match',
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${matchResult.score.toInt()}%',
                  style: AppTypography.titleMedium.copyWith(
                    color: scoreColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Actionable Live Feedback Banner
          if (matchResult.feedbackMessage.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white12),
              ),
              child: Text(
                matchResult.feedbackMessage,
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
