import 'package:equatable/equatable.dart';

/// User Profile entity.
class UserProfileModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final int savedPosesCount;
  final int capturedPhotosCount;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.savedPosesCount = 0,
    this.capturedPhotosCount = 0,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        avatarUrl,
        savedPosesCount,
        capturedPhotosCount,
      ];
}
