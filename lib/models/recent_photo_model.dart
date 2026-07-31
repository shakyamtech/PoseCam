import 'package:equatable/equatable.dart';

/// Data Model representing a Recent Photo captured by the user.
class RecentPhotoModel extends Equatable {
  final String id;
  final String poseTitle;
  final String timeAgo;
  final String aspectRatio;
  final String filterUsed;
  final String thumbnailUrl;

  const RecentPhotoModel({
    required this.id,
    required this.poseTitle,
    required this.timeAgo,
    required this.aspectRatio,
    required this.filterUsed,
    required this.thumbnailUrl,
  });

  @override
  List<Object?> get props => [
        id,
        poseTitle,
        timeAgo,
        aspectRatio,
        filterUsed,
        thumbnailUrl,
      ];
}
