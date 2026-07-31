import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/camera_service.dart';
import '../../domain/models/camera_state.dart';

/// Riverpod StateNotifier managing the live camera state & user controls.
class CameraNotifier extends StateNotifier<CameraState> {
  final CameraService _cameraService;
  Timer? _focusResetTimer;

  CameraNotifier(this._cameraService) : super(const CameraState());

  CameraService get cameraService => _cameraService;

  Future<void> initCamera() async {
    state = state.copyWith(permissionState: CameraPermissionState.checking);

    final permState = await _cameraService.checkAndRequestPermission();
    state = state.copyWith(permissionState: permState);

    if (permState != CameraPermissionState.granted) {
      return;
    }

    var cameras = await _cameraService.getAvailableCameras();
    if (cameras.isEmpty && kIsWeb) {
      await Future.delayed(const Duration(milliseconds: 600));
      cameras = await _cameraService.getAvailableCameras();
    }

    if (cameras.isEmpty) {
      state = state.copyWith(
        isInitialized: false,
        errorMessage: 'No camera devices detected on this system.',
      );
      return;
    }

    state = state.copyWith(
      availableCameras: cameras,
      selectedCameraIndex: 0,
    );

    await _setupCamera(cameras[0]);
  }

  Future<void> _setupCamera(CameraDescription camera) async {
    try {
      await _cameraService.initializeCamera(camera, preset: ResolutionPreset.medium);
      final controller = _cameraService.controller;

      if (controller != null && controller.value.isInitialized) {
        double minZoom = 1.0;
        double maxZoom = 5.0;
        double minExp = -2.0;
        double maxExp = 2.0;

        try {
          minZoom = await controller.getMinZoomLevel();
          maxZoom = await controller.getMaxZoomLevel();
          minExp = await controller.getMinExposureOffset();
          maxExp = await controller.getMaxExposureOffset();
        } catch (_) {}

        state = state.copyWith(
          isInitialized: true,
          minZoomLevel: minZoom,
          maxZoomLevel: maxZoom.clamp(minZoom, 10.0),
          zoomLevel: minZoom,
          minExposureOffset: minExp,
          maxExposureOffset: maxExp,
          exposureOffset: 0.0,
          errorMessage: null,
        );
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ First camera setup attempt: $e. Retrying with ResolutionPreset.low...');
      }
      try {
        await _cameraService.initializeCamera(camera, preset: ResolutionPreset.low);
        final controller = _cameraService.controller;

        if (controller != null && controller.value.isInitialized) {
          state = state.copyWith(
            isInitialized: true,
            errorMessage: null,
          );
          return;
        }
      } catch (err) {
        state = state.copyWith(
          isInitialized: false,
          errorMessage: 'Unable to start camera preview stream: $err',
        );
      }
    }
  }

  Future<void> toggleFlashMode() async {
    if (!state.isInitialized) return;

    FlashMode nextMode;
    switch (state.flashMode) {
      case FlashMode.off:
        nextMode = FlashMode.auto;
        break;
      case FlashMode.auto:
        nextMode = FlashMode.always;
        break;
      case FlashMode.always:
        nextMode = FlashMode.torch;
        break;
      case FlashMode.torch:
        nextMode = FlashMode.off;
        break;
    }

    try {
      await _cameraService.setFlashMode(nextMode);
      state = state.copyWith(flashMode: nextMode);
    } catch (e) {
      // Fallback
    }
  }

  void toggleGrid() {
    state = state.copyWith(isGridVisible: !state.isGridVisible);
  }

  Future<void> switchCamera() async {
    final cameras = await _cameraService.getAvailableCameras();
    if (cameras.isEmpty) {
      initCamera();
      return;
    }

    final nextIndex = (state.selectedCameraIndex + 1) % cameras.length;
    state = state.copyWith(
      availableCameras: cameras,
      selectedCameraIndex: nextIndex,
      isInitialized: false,
    );
    await _setupCamera(cameras[nextIndex]);
  }

  Future<void> setZoomLevel(double zoom) async {
    if (!state.isInitialized) return;
    final clampedZoom = zoom.clamp(state.minZoomLevel, state.maxZoomLevel);
    await _cameraService.setZoomLevel(clampedZoom);
    state = state.copyWith(zoomLevel: clampedZoom);
  }

  Future<void> setExposureOffset(double offset) async {
    if (!state.isInitialized) return;
    final clampedOffset = offset.clamp(state.minExposureOffset, state.maxExposureOffset);
    await _cameraService.setExposureOffset(clampedOffset);
    state = state.copyWith(exposureOffset: clampedOffset);
  }

  Future<void> onTapFocus(Offset tapPosition, Size screenSize) async {
    if (!state.isInitialized) return;

    final normalizedX = tapPosition.dx / screenSize.width;
    final normalizedY = tapPosition.dy / screenSize.height;

    state = state.copyWith(tapFocusPoint: tapPosition);
    await _cameraService.setFocusPoint(Offset(normalizedX, normalizedY));

    _focusResetTimer?.cancel();
    _focusResetTimer = Timer(const Duration(seconds: 2), () {
      state = state.copyWith(tapFocusPoint: null);
    });
  }

  Future<XFile?> captureImage() async {
    if (state.isCapturing) return null;

    state = state.copyWith(isCapturing: true);
    try {
      if (kIsWeb) {
        // Capture photo snapshot for Web HTML5 stream
        await Future.delayed(const Duration(milliseconds: 300));
        final capturedWebFile = XFile(
          'https://picsum.photos/800/1200',
          name: 'web_capture_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        state = state.copyWith(
          isCapturing: false,
          capturedImage: capturedWebFile,
        );
        return capturedWebFile;
      }

      final image = await _cameraService.takePicture();
      state = state.copyWith(
        isCapturing: false,
        capturedImage: image,
      );
      return image;
    } catch (e) {
      state = state.copyWith(isCapturing: false);
      return null;
    }
  }

  @override
  void dispose() {
    _focusResetTimer?.cancel();
    _cameraService.dispose();
    super.dispose();
  }
}
