import 'package:flutter/material.dart';
import '../../../../core/widgets/empty_state_widget.dart';

class PoseScreenPlaceholder extends StatelessWidget {
  const PoseScreenPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trendy Pose Library'),
      ),
      body: Center(
        child: EmptyStateWidget(
          icon: Icons.style_outlined,
          title: 'Pose Library Engine',
          description:
              'Browse, filter, and preview pose cards categorized by fashion, portrait, and street styles.',
          buttonText: 'Back to Home',
          onButtonPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
