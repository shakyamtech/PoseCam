import 'dart:async';
import 'package:camera/camera.dart';
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

    final cameras = await _cameraService.getAvailableCameras();
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
      await _cameraService.initializeCamera(camera);
      final controller = _cameraService.controller;

      if (controller != null && controller.value.isInitialized) {
        final minZoom = await controller.getMinZoomLevel();
        final maxZoom = await controller.getMaxZoomLevel();
        final minExp = await controller.getMinExposureOffset();
        final maxExp = await controller.getMaxExposureOffset();

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
      }
    } catch (e) {
      state = state.copyWith(
        isInitialized: false,
        errorMessage: 'Failed to initialize camera preview: $e',
      );
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
    if (state.availableCameras.length < 2) return;

    final nextIndex = (state.selectedCameraIndex + 1) % state.availableCameras.length;
    state = state.copyWith(
      selectedCameraIndex: nextIndex,
      isInitialized: false,
    );
    await _setupCamera(state.availableCameras[nextIndex]);
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

    // Normalize tap point to (0..1)
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
    if (!state.isInitialized || state.isCapturing) return null;

    state = state.copyWith(isCapturing: true);
    try {
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
