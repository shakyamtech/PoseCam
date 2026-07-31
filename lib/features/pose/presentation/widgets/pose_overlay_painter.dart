import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/models/pose_model.dart';

/// High Performance CustomPainter rendering 33 MediaPipe Body Landmarks & Skeleton Connections.
class PoseOverlayPainter extends CustomPainter {
  final PoseData? poseData;
  final bool showSkeletonMesh;
  final bool showLandmarkLabels;

  PoseOverlayPainter({
    required this.poseData,
    this.showSkeletonMesh = true,
    this.showLandmarkLabels = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (poseData == null || poseData!.landmarks.isEmpty) return;

    final landmarks = poseData!.landmarks;
    final landmarkMap = <LandmarkType, Offset>{};

    for (var lm in landmarks) {
      final dx = lm.x * size.width;
      final dy = lm.y * size.height;
      landmarkMap[lm.type] = Offset(dx, dy);
    }

    // 1. Draw Skeletal Connections (Bones)
    if (showSkeletonMesh) {
      final bonePaint = Paint()
        ..color = AppColors.secondary
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final glowBonePaint = Paint()
        ..color = AppColors.primary.withValues(alpha: 0.4)
        ..strokeWidth = 7.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      for (var connection in PoseData.connections) {
        final start = landmarkMap[connection.start];
        final end = landmarkMap[connection.end];

        if (start != null && end != null) {
          // Draw outer glow line
          canvas.drawLine(start, end, glowBonePaint);
          // Draw sharp bone line
          canvas.drawLine(start, end, bonePaint);
        }
      }
    }

    // 2. Draw 33 MediaPipe Joint Nodes (Landmarks)
    final nodePaint = Paint()..style = PaintingStyle.fill;
    final outerRingPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (var lm in landmarks) {
      final offset = landmarkMap[lm.type];
      if (offset == null) continue;

      final double confidence = lm.likelihood;
      final Color nodeColor = confidence > 0.9
          ? AppColors.secondary
          : (confidence > 0.7 ? AppColors.warning : AppColors.error);

      // Glowing aura
      nodePaint.color = nodeColor.withValues(alpha: 0.35);
      canvas.drawCircle(offset, 9.0, nodePaint);

      // Solid inner core
      nodePaint.color = Colors.white;
      canvas.drawCircle(offset, 4.0, nodePaint);

      // Outer accent border ring
      outerRingPaint.color = nodeColor;
      canvas.drawCircle(offset, 6.0, outerRingPaint);

      // 3. Optional Landmark Label Tags
      if (showLandmarkLabels && confidence > 0.8) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: lm.type.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              backgroundColor: Colors.black54,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(offset.dx + 8, offset.dy - 6));
      }
    }
  }

  @override
  bool shouldRepaint(covariant PoseOverlayPainter oldDelegate) {
    return oldDelegate.poseData != poseData ||
        oldDelegate.showSkeletonMesh != showSkeletonMesh ||
        oldDelegate.showLandmarkLabels != showLandmarkLabels;
  }
}
