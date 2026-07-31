import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentTheme = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Theme'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Appearance',
            style: AppTypography.titleLarge.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          CustomCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildThemeTile(
                  context,
                  title: 'System Default',
                  icon: Icons.settings_suggest_rounded,
                  isSelected: currentTheme == ThemeMode.system,
                  onTap: () => ref.read(themeProvider.notifier).setThemeMode(ThemeMode.system),
                ),
                const Divider(height: 24),
                _buildThemeTile(
                  context,
                  title: 'Light Theme',
                  icon: Icons.light_mode_rounded,
                  isSelected: currentTheme == ThemeMode.light,
                  onTap: () => ref.read(themeProvider.notifier).setThemeMode(ThemeMode.light),
                ),
                const Divider(height: 24),
                _buildThemeTile(
                  context,
                  title: 'Dark Obsidian Theme',
                  icon: Icons.dark_mode_rounded,
                  isSelected: currentTheme == ThemeMode.dark,
                  onTap: () => ref.read(themeProvider.notifier).setThemeMode(ThemeMode.dark),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'About Application',
            style: AppTypography.titleLarge.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          CustomCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Application Name'),
                  subtitle: const Text(AppConstants.appName),
                  trailing: const Icon(Icons.info_outline, size: 20),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Version'),
                  subtitle: const Text(AppConstants.appVersion),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Architecture'),
                  subtitle: const Text('Clean Architecture + Feature-First + Riverpod'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Icon(icon, color: isSelected ? AppColors.primary : AppColors.darkTextMuted),
          const SizedBox(width: 14),
          Text(
            title,
            style: AppTypography.titleMedium.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          const Spacer(),
          if (isSelected)
            const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 22),
        ],
      ),
    );
  }
}
