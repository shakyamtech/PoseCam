import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/models/pose_item_model.dart';

/// Asynchronous JSON parser service loading local pose templates from assets.
class PoseJsonLoader {
  static List<PoseItemModel>? _cachedPoses;

  static Future<List<PoseItemModel>> loadPoseLibrary() async {
    if (_cachedPoses != null && _cachedPoses!.isNotEmpty) {
      return _cachedPoses!;
    }

    try {
      final jsonString = await rootBundle.loadString('assets/data/pose_library_data.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      final rawList = jsonMap['poses'] as List<dynamic>? ?? [];

      _cachedPoses = rawList
          .map((item) => PoseItemModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return _cachedPoses!;
    } catch (e) {
      return [];
    }
  }
}
