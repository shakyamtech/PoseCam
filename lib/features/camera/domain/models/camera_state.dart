import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum CameraPermissionState { granted, denied, permanentlyDenied, checking }

/// Immutable Camera State model.
class CameraState extends Equatable {
  final bool isInitialized;
  final bool isCapturing;
  final CameraPermissionState permissionState;
  final List<CameraDescription> availableCameras;
  final int selectedCameraIndex;
  final FlashMode flashMode;
  final bool isGridVisible;
  final double zoomLevel;
  final double minZoomLevel;
  final double maxZoomLevel;
  final double exposureOffset;
  final double minExposureOffset;
  final double maxExposureOffset;
  final Offset? tapFocusPoint;
  final XFile? capturedImage;
  final String? errorMessage;

  const CameraState({
    this.isInitialized = false,
    this.isCapturing = false,
    this.permissionState = CameraPermissionState.checking,
    this.availableCameras = const [],
    this.selectedCameraIndex = 0,
    this.flashMode = FlashMode.off,
    this.isGridVisible = false,
    this.zoomLevel = 1.0,
    this.minZoomLevel = 1.0,
    this.maxZoomLevel = 5.0,
    this.exposureOffset = 0.0,
    this.minExposureOffset = -2.0,
    this.maxExposureOffset = 2.0,
    this.tapFocusPoint,
    this.capturedImage,
    this.errorMessage,
  });

  CameraState copyWith({
    bool? isInitialized,
    bool? isCapturing,
    CameraPermissionState? permissionState,
    List<CameraDescription>? availableCameras,
    int? selectedCameraIndex,
    FlashMode? flashMode,
    bool? isGridVisible,
    double? zoomLevel,
    double? minZoomLevel,
    double? maxZoomLevel,
    double? exposureOffset,
    double? minExposureOffset,
    double? maxExposureOffset,
    Offset? tapFocusPoint,
    XFile? capturedImage,
    String? errorMessage,
  }) {
    return CameraState(
      isInitialized: isInitialized ?? this.isInitialized,
      isCapturing: isCapturing ?? this.isCapturing,
      permissionState: permissionState ?? this.permissionState,
      availableCameras: availableCameras ?? this.availableCameras,
      selectedCameraIndex: selectedCameraIndex ?? this.selectedCameraIndex,
      flashMode: flashMode ?? this.flashMode,
      isGridVisible: isGridVisible ?? this.isGridVisible,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      minZoomLevel: minZoomLevel ?? this.minZoomLevel,
      maxZoomLevel: maxZoomLevel ?? this.maxZoomLevel,
      exposureOffset: exposureOffset ?? this.exposureOffset,
      minExposureOffset: minExposureOffset ?? this.minExposureOffset,
      maxExposureOffset: maxExposureOffset ?? this.maxExposureOffset,
      tapFocusPoint: tapFocusPoint,
      capturedImage: capturedImage ?? this.capturedImage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isInitialized,
        isCapturing,
        permissionState,
        availableCameras,
        selectedCameraIndex,
        flashMode,
        isGridVisible,
        zoomLevel,
        minZoomLevel,
        maxZoomLevel,
        exposureOffset,
        minExposureOffset,
        maxExposureOffset,
        tapFocusPoint,
        capturedImage,
        errorMessage,
      ];
}
