import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Styled Icon Button component.
class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final Color? color;
  final Color? backgroundColor;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 20,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, size: size),
        color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
        onPressed: onTap,
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints(),
      ),
    );
  }
}
