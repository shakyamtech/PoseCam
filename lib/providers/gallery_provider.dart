import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recent_photo_model.dart';

/// Riverpod StateNotifier for managing saved user gallery photos.
class GalleryNotifier extends StateNotifier<List<RecentPhotoModel>> {
  GalleryNotifier()
      : super([
          const RecentPhotoModel(
            id: 'photo_init_1',
            poseTitle: 'AI Portrait',
            timeAgo: '2 hours ago',
            aspectRatio: '9:16',
            filterUsed: 'Neon Glow',
            thumbnailUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500',
          ),
          const RecentPhotoModel(
            id: 'photo_init_2',
            poseTitle: 'Fashion Standing',
            timeAgo: '1 day ago',
            aspectRatio: '9:16',
            filterUsed: 'Cyberpunk',
            thumbnailUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500',
          ),
        ]);

  void addPhoto(String photoPath, {String category = 'AI Pose'}) {
    final newPhoto = RecentPhotoModel(
      id: 'photo_${DateTime.now().millisecondsSinceEpoch}',
      poseTitle: category,
      timeAgo: 'Just now',
      aspectRatio: '9:16',
      filterUsed: 'Original',
      thumbnailUrl: photoPath,
    );
    state = [newPhoto, ...state];
  }

  void deletePhoto(String id) {
    state = state.where((photo) => photo.id != id).toList();
  }
}

final galleryProvider =
    StateNotifierProvider<GalleryNotifier, List<RecentPhotoModel>>((ref) {
  return GalleryNotifier();
});
