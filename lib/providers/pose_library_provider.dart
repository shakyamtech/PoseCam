import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/pose_library/data/services/pose_json_loader.dart';
import '../features/pose_library/domain/models/pose_item_model.dart';

final poseLibraryCategoryProvider = StateProvider<String>((ref) => 'All');

final poseLibraryItemsProvider = FutureProvider<List<PoseItemModel>>((ref) async {
  final category = ref.watch(poseLibraryCategoryProvider);
  final allPoses = await PoseJsonLoader.loadPoseLibrary();

  if (category == 'All') {
    return allPoses;
  }
  return allPoses.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
});
