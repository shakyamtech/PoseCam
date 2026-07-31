import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../domain/models/camera_state.dart';

/// Camera Service abstraction layer managing hardware camera lifecycle.
abstract class CameraService {
  Future<CameraPermissionState> checkAndRequestPermission();
  Future<List<CameraDescription>> getAvailableCameras();
  CameraController? get controller;
  Future<void> initializeCamera(CameraDescription camera);
  Future<void> setFlashMode(FlashMode mode);
  Future<void> setZoomLevel(double zoom);
  Future<void> setExposureOffset(double offset);
  Future<void> setFocusPoint(Offset point);
  Future<XFile?> takePicture();
  Future<void> dispose();
}

class CameraServiceImpl implements CameraService {
  CameraController? _controller;

  @override
  CameraController? get controller => _controller;

  @override
  Future<CameraPermissionState> checkAndRequestPermission() async {
    if (kIsWeb) {
      return CameraPermissionState.granted;
    }

    final status = await Permission.camera.status;
    if (status.isGranted) {
      return CameraPermissionState.granted;
    }

    final requestResult = await Permission.camera.request();
    if (requestResult.isGranted) {
      return CameraPermissionState.granted;
    } else if (requestResult.isPermanentlyDenied) {
      return CameraPermissionState.permanentlyDenied;
    } else {
      return CameraPermissionState.denied;
    }
  }

  @override
  Future<List<CameraDescription>> getAvailableCameras() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) return cameras;
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ [CameraService] Error fetching available cameras: $e');
      }
    }
    return [];
  }

  @override
  Future<void> initializeCamera(CameraDescription camera) async {
    await dispose();

    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: kIsWeb ? null : ImageFormatGroup.jpeg,
    );

    await _controller!.initialize();
  }

  @override
  Future<void> setFlashMode(FlashMode mode) async {
    if (_controller != null && _controller!.value.isInitialized && !kIsWeb) {
      try {
        await _controller!.setFlashMode(mode);
      } catch (_) {}
    }
  }

  @override
  Future<void> setZoomLevel(double zoom) async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        await _controller!.setZoomLevel(zoom);
      } catch (_) {}
    }
  }

  @override
  Future<void> setExposureOffset(double offset) async {
    if (_controller != null && _controller!.value.isInitialized && !kIsWeb) {
      try {
        await _controller!.setExposureOffset(offset);
      } catch (_) {}
    }
  }

  @override
  Future<void> setFocusPoint(Offset point) async {
    if (_controller != null && _controller!.value.isInitialized && !kIsWeb) {
      try {
        await _controller!.setFocusMode(FocusMode.auto);
        await _controller!.setFocusPoint(point);
      } catch (_) {}
    }
  }

  @override
  Future<XFile?> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return null;
    }
    if (_controller!.value.isTakingPicture) {
      return null;
    }
    return await _controller!.takePicture();
  }

  @override
  Future<void> dispose() async {
    if (_controller != null) {
      try {
        await _controller!.dispose();
      } catch (_) {}
      _controller = null;
    }
  }
}
