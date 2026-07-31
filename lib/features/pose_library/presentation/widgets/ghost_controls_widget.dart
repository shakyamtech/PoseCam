import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../providers/ghost_overlay_provider.dart';

/// Top-Right Glassmorphic HUD overlay controller for Ghost Pose (ON/OFF, Opacity Slider, Reset).
class GhostControlsWidget extends ConsumerStatefulWidget {
  const GhostControlsWidget({super.key});

  @override
  ConsumerState<GhostControlsWidget> createState() => _GhostControlsWidgetState();
}

class _GhostControlsWidgetState extends ConsumerState<GhostControlsWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final ghostState = ref.watch(ghostOverlayProvider);
    final notifier = ref.read(ghostOverlayProvider.notifier);

    if (ghostState.activePose == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 80, right: 16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Header Bar with Toggle & Expand
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ghost Active Badge / Title
                Text(
                  'Ghost Overlay',
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),

                // Ghost ON/OFF Switch Icon Button
                IconButton(
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    ghostState.isGhostVisible
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: ghostState.isGhostVisible ? AppColors.primary : Colors.white54,
                    size: 22,
                  ),
                  onPressed: () => notifier.toggleGhost(),
                  tooltip: 'Toggle Ghost Overlay',
                ),
                const SizedBox(width: 8),

                // Expand Sliders Menu Toggle
                IconButton(
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    _isExpanded ? Icons.tune_rounded : Icons.tune_outlined,
                    color: AppColors.secondary,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  tooltip: 'Overlay Settings',
                ),
              ],
            ),
          ),

          // Expanded Sliders & Action Panel
          if (_isExpanded && ghostState.isGhostVisible)
            Container(
              width: 220,
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Opacity Label & Value
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Opacity',
                        style: AppTypography.labelSmall.copyWith(color: Colors.white70),
                      ),
                      Text(
                        '${(ghostState.opacity * 100).toInt()}%',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Opacity Slider (0.1 - 1.0)
                  SliderTheme(
                    data: const SliderThemeData(
                      thumbColor: AppColors.primary,
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: Colors.white24,
                      trackHeight: 3,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                    ),
                    child: Slider(
                      value: ghostState.opacity,
                      min: 0.1,
                      max: 1.0,
                      onChanged: (val) => notifier.setOpacity(val),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Reset Position & Clear Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () => notifier.resetPosition(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(Icons.center_focus_strong_rounded, size: 14, color: Colors.white70),
                        label: const Text('Reset', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ),
                      TextButton.icon(
                        onPressed: () => notifier.clearPose(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(Icons.close_rounded, size: 14, color: AppColors.error),
                        label: const Text('Remove', style: TextStyle(color: AppColors.error, fontSize: 11)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
