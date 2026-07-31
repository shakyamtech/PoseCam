import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../providers/home_provider.dart';

/// Horizontal scrolling chip filter selector for pose categories.
class PoseCategoryChips extends ConsumerWidget {
  const PoseCategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(poseCategoryChipsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pose Categories',
                style: AppTypography.titleLarge.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  fontSize: 19,
                ),
              ),
              Text(
                '${categories.length - 1} Tags',
                style: AppTypography.labelSmall.copyWith(
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 42,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = category == selectedCategory;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      ref.read(selectedCategoryProvider.notifier).state = category;
                    }
                  },
                  showCheckmark: false,
                  avatar: isSelected
                      ? const Icon(Icons.auto_awesome, size: 14, color: Colors.white)
                      : null,
                  labelStyle: AppTypography.labelLarge.copyWith(
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 13,
                  ),
                  selectedColor: AppColors.primary,
                  backgroundColor: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      width: 1,
                    ),
                  ),
                  elevation: isSelected ? 4 : 0,
                  shadowColor: AppColors.primary.withOpacity(0.3),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
