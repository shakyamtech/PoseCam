import 'package:flutter/material.dart';
import '../../../../core/widgets/empty_state_widget.dart';

class CameraScreenPlaceholder extends StatelessWidget {
  const CameraScreenPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Camera Viewfinder'),
      ),
      body: Center(
        child: EmptyStateWidget(
          icon: Icons.camera_alt_outlined,
          title: 'AI Camera Ready',
          description:
              'Camera hardware integration and AI real-time pose detection overlay modules will be attached here.',
          buttonText: 'Back to Home',
          onButtonPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
