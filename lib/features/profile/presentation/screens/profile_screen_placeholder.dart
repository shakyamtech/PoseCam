import 'package:flutter/material.dart';
import '../../../../core/widgets/empty_state_widget.dart';

class ProfileScreenPlaceholder extends StatelessWidget {
  const ProfileScreenPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile & Saved'),
      ),
      body: Center(
        child: EmptyStateWidget(
          icon: Icons.person_outline_rounded,
          title: 'My Profile & Collection',
          description:
              'Manage your favorite pose presets, saved photo shots, and account configurations.',
          buttonText: 'Back to Home',
          onButtonPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
