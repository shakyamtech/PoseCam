import 'package:equatable/equatable.dart';
import '../../../pose/domain/models/pose_model.dart';

/// Data model representing a Pose Library Item with MediaPipe landmark definitions.
class PoseItemModel extends Equatable {
  final String id;
  final String title;
  final String category;
  final String difficulty;
  final String thumbnailUrl;
  final String previewUrl;
  final String description;
  final List<PoseLandmark> landmarks;

  const PoseItemModel({
    required this.id,
    required this.title,
    required this.category,
    required this.difficulty,
    required this.thumbnailUrl,
    required this.previewUrl,
    required this.description,
    required this.landmarks,
  });

  factory PoseItemModel.fromJson(Map<String, dynamic> json) {
    final rawLandmarks = json['landmarks'] as List<dynamic>? ?? [];
    final landmarks = rawLandmarks.map((lm) {
      final map = lm as Map<String, dynamic>;
      final typeStr = map['type'] as String;
      final type = LandmarkType.values.firstWhere(
        (e) => e.name == typeStr,
        orElse: () => LandmarkType.nose,
      );
      return PoseLandmark(
        type: type,
        x: (map['x'] as num).toDouble(),
        y: (map['y'] as num).toDouble(),
        likelihood: (map['likelihood'] as num?)?.toDouble() ?? 0.95,
      );
    }).toList();

    return PoseItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String? ?? 'Easy',
      thumbnailUrl: json['thumbnailUrl'] as String,
      previewUrl: json['previewUrl'] as String,
      description: json['description'] as String? ?? '',
      landmarks: landmarks,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        difficulty,
        thumbnailUrl,
        previewUrl,
        description,
        landmarks,
      ];
}
