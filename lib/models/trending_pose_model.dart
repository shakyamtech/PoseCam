import 'package:equatable/equatable.dart';

enum PoseDifficulty { easy, medium, pro }

/// Data Model representing a Trending Pose.
class TrendingPoseModel extends Equatable {
  final String id;
  final String title;
  final String category;
  final PoseDifficulty difficulty;
  final String likesCount;
  final String imageUrl;
  final String guideTip;

  const TrendingPoseModel({
    required this.id,
    required this.title,
    required this.category,
    required this.difficulty,
    required this.likesCount,
    required this.imageUrl,
    required this.guideTip,
  });

  String get difficultyLabel {
    switch (difficulty) {
      case PoseDifficulty.easy:
        return 'Easy';
      case PoseDifficulty.medium:
        return 'Medium';
      case PoseDifficulty.pro:
        return 'Pro';
    }
  }

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        difficulty,
        likesCount,
        imageUrl,
        guideTip,
      ];
}
