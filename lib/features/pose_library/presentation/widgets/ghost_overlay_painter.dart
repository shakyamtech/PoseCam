import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../pose/domain/models/pose_model.dart';
import '../../domain/models/pose_item_model.dart';

/// High-performance CustomPainter rendering 40% purple neon ghost pose overlay centered on camera view.
class GhostOverlayPainter extends CustomPainter {
  final PoseItemModel? activePose;
  final double opacity;
  final Offset positionOffset;

  GhostOverlayPainter({
    required this.activePose,
    required this.opacity,
    required this.positionOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (activePose == null || activePose!.landmarks.isEmpty) return;

    final landmarks = activePose!.landmarks;
    final landmarkMap = <LandmarkType, Offset>{};

    for (var lm in landmarks) {
      final dx = (lm.x * size.width) + positionOffset.dx;
      final dy = (lm.y * size.height) + positionOffset.dy;
      landmarkMap[lm.type] = Offset(dx, dy);
    }

    // 1. Ghost Vector Bones (Purple Neon Outline)
    final ghostBonePaint = Paint()
      ..color = AppColors.primary.withValues(alpha: opacity.clamp(0.0, 1.0))
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final glowBonePaint = Paint()
      ..color = AppColors.secondary.withValues(alpha: (opacity * 0.5).clamp(0.0, 1.0))
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (var connection in PoseData.connections) {
      final start = landmarkMap[connection.start];
      final end = landmarkMap[connection.end];

      if (start != null && end != null) {
        // Outer ambient glow
        canvas.drawLine(start, end, glowBonePaint);
        // Purple neon ghost bone line
        canvas.drawLine(start, end, ghostBonePaint);
      }
    }

    // 2. Ghost Joint Nodes
    final nodePaint = Paint()
      ..color = Colors.white.withValues(alpha: opacity.clamp(0.0, 1.0))
      ..style = PaintingStyle.fill;

    final outerRingPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: opacity.clamp(0.0, 1.0))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (var lm in landmarks) {
      final offset = landmarkMap[lm.type];
      if (offset == null) continue;

      // Inner white node core
      canvas.drawCircle(offset, 4.5, nodePaint);
      // Outer purple ring accent
      canvas.drawCircle(offset, 7.0, outerRingPaint);
    }
  }

  @override
  bool shouldRepaint(covariant GhostOverlayPainter oldDelegate) {
    return oldDelegate.activePose != activePose ||
        oldDelegate.opacity != opacity ||
        oldDelegate.positionOffset != positionOffset;
  }
}
