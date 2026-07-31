import 'package:flutter/material.dart';
import '../../../../core/widgets/empty_state_widget.dart';

class EditorScreenPlaceholder extends StatelessWidget {
  const EditorScreenPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Editor Studio'),
      ),
      body: Center(
        child: EmptyStateWidget(
          icon: Icons.auto_fix_high_rounded,
          title: 'Photo Retouching Studio',
          description:
              'Aesthetic photo filters, posture adjustments, and export controls will be featured here.',
          buttonText: 'Back to Home',
          onButtonPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
