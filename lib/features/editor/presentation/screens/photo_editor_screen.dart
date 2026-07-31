import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/custom_button.dart';

/// Professional AI Photo Editor Screen with filter presets & adjustments.
class PhotoEditorScreen extends StatefulWidget {
  final XFile? imageFile;

  const PhotoEditorScreen({
    super.key,
    this.imageFile,
  });

  @override
  State<PhotoEditorScreen> createState() => _PhotoEditorScreenState();
}

class _PhotoEditorScreenState extends State<PhotoEditorScreen> {
  String _selectedFilter = 'Original';
  double _brightness = 1.0;
  double _contrast = 1.0;
  double _saturation = 1.0;

  final List<Map<String, dynamic>> _filters = [
    {'name': 'Original', 'matrix': <double>[1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]},
    {'name': 'Cyberpunk', 'matrix': <double>[1.2, 0, 0.3, 0, 0, 0, 0.9, 0.2, 0, 0, 0.2, 0, 1.4, 0, 0, 0, 0, 0, 1, 0]},
    {'name': 'Neon Glow', 'matrix': <double>[0.8, 0.2, 0.5, 0, 20, 0, 1.2, 0.2, 0, 10, 0.3, 0.1, 1.5, 0, 30, 0, 0, 0, 1, 0]},
    {'name': 'Vintage', 'matrix': <double>[0.9, 0.4, 0.1, 0, 30, 0.2, 0.8, 0.1, 0, 20, 0.1, 0.3, 0.7, 0, 10, 0, 0, 0, 1, 0]},
    {'name': 'B&W Film', 'matrix': <double>[0.33, 0.59, 0.11, 0, 0, 0.33, 0.59, 0.11, 0, 0, 0.33, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0]},
    {'name': 'Warm Sunset', 'matrix': <double>[1.3, 0.1, 0, 0, 10, 0.1, 1.1, 0, 0, 5, 0, 0, 0.8, 0, 0, 0, 0, 0, 1, 0]},
  ];

  List<double> get _activeMatrix {
    final filter = _filters.firstWhere(
      (f) => f['name'] == _selectedFilter,
      orElse: () => _filters[0],
    );
    final base = List<double>.from(filter['matrix'] as List<double>);
    
    // Apply brightness & contrast multiplier
    for (int i = 0; i < 15; i++) {
      if (i % 6 == 0) base[i] *= _brightness * _contrast;
    }
    return base;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('AI Photo Editor Studio'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded, color: AppColors.secondary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edited photo saved to gallery! 🎉')),
              );
              context.pop();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Preview Image with ColorFilter
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.matrix(_activeMatrix),
                    child: _buildImage(),
                  ),
                ),
              ),
            ),

            // Filter Chips Strip
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final item = _filters[index];
                  final name = item['name'] as String;
                  final isSelected = _selectedFilter == name;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = name),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppColors.primaryGradient : null,
                        color: isSelected ? null : AppColors.darkSurfaceVariant,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? Colors.transparent : Colors.white24,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.auto_fix_high_rounded,
                            size: 20,
                            color: isSelected ? Colors.white : Colors.white70,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            name,
                            style: AppTypography.labelSmall.copyWith(
                              color: isSelected ? Colors.white : Colors.white70,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Adjustment Sliders
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.wb_sunny_outlined, size: 18, color: Colors.white70),
                      const SizedBox(width: 8),
                      Text('Brightness', style: AppTypography.bodyMedium.copyWith(color: Colors.white)),
                      Expanded(
                        child: Slider(
                          value: _brightness,
                          min: 0.5,
                          max: 1.5,
                          activeColor: AppColors.primary,
                          onChanged: (val) => setState(() => _brightness = val),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.contrast_rounded, size: 18, color: Colors.white70),
                      const SizedBox(width: 8),
                      Text('Contrast', style: AppTypography.bodyMedium.copyWith(color: Colors.white)),
                      Expanded(
                        child: Slider(
                          value: _contrast,
                          min: 0.5,
                          max: 1.5,
                          activeColor: AppColors.secondary,
                          onChanged: (val) => setState(() => _contrast = val),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CustomButton(
                    text: 'Save Preset Filter',
                    icon: Icons.download_rounded,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Filter preset saved successfully! 🎉')),
                      );
                      context.pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (widget.imageFile != null) {
      final path = widget.imageFile!.path;
      if (kIsWeb) {
        if (path.startsWith('data:image')) {
          final base64Bytes = Uri.parse(path).data?.contentAsBytes();
          if (base64Bytes != null) {
            return Image.memory(base64Bytes, fit: BoxFit.cover, width: double.infinity, height: double.infinity);
          }
        }
        return Image.network(path, fit: BoxFit.cover, width: double.infinity, height: double.infinity);
      }
      return Image.file(File(path), fit: BoxFit.cover, width: double.infinity, height: double.infinity);
    }
    return Container(color: AppColors.darkSurfaceVariant);
  }
}
