import 'package:equatable/equatable.dart';

/// Data Model representing a Pose Category.
class PoseCategoryModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final int poseCount;
  final String iconName;
  final String bannerImageUrl;
  final bool isTrending;

  const PoseCategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.poseCount,
    required this.iconName,
    required this.bannerImageUrl,
    this.isTrending = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        poseCount,
        iconName,
        bannerImageUrl,
        isTrending,
      ];
}
