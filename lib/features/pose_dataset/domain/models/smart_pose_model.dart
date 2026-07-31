import 'package:equatable/equatable.dart';
import '../../../pose/domain/models/pose_model.dart';
import '../../../pose_library/domain/models/pose_item_model.dart';

/// Rich domain model representing a Smart Pose with tags, popularity, posture & framing metadata.
class SmartPoseModel extends Equatable {
  final String id;
  final String title;
  final String category;
  final String difficulty;
  final List<String> tags;
  final String thumbnailUrl;
  final String previewUrl;
  final String description;
  final double popularity;
  final String recommendedDistance; // Close-up, Half Body, Full Body
  final String recommendedOrientation; // Portrait, Landscape
  final String postureType; // Standing, Sitting, Walking
  final bool isEditorsChoice;
  final List<PoseLandmark> landmarks;

  const SmartPoseModel({
    required this.id,
    required this.title,
    required this.category,
    required this.difficulty,
    required this.tags,
    required this.thumbnailUrl,
    required this.previewUrl,
    required this.description,
    required this.popularity,
    required this.recommendedDistance,
    required this.recommendedOrientation,
    required this.postureType,
    required this.isEditorsChoice,
    required this.landmarks,
  });

  factory SmartPoseModel.fromJson(Map<String, dynamic> json) {
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

    final rawTags = json['tags'] as List<dynamic>? ?? [];
    final tags = rawTags.map((e) => e.toString()).toList();

    return SmartPoseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String? ?? 'Easy',
      tags: tags,
      thumbnailUrl: json['thumbnailUrl'] as String,
      previewUrl: json['previewUrl'] as String,
      description: json['description'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 85.0,
      recommendedDistance: json['recommendedDistance'] as String? ?? 'Full Body',
      recommendedOrientation: json['recommendedOrientation'] as String? ?? 'Portrait',
      postureType: json['postureType'] as String? ?? 'Standing',
      isEditorsChoice: json['isEditorsChoice'] as bool? ?? false,
      landmarks: landmarks,
    );
  }

  /// Converts to legacy PoseItemModel for backward compatibility
  PoseItemModel toPoseItemModel() {
    return PoseItemModel(
      id: id,
      title: title,
      category: category,
      difficulty: difficulty,
      thumbnailUrl: thumbnailUrl,
      previewUrl: previewUrl,
      description: description,
      landmarks: landmarks,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        difficulty,
        tags,
        thumbnailUrl,
        previewUrl,
        description,
        popularity,
        recommendedDistance,
        recommendedOrientation,
        postureType,
        isEditorsChoice,
        landmarks,
      ];
}
