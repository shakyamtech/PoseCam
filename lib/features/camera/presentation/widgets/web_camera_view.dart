import 'package:flutter/material.dart';
import 'web_camera_stub.dart'
    if (dart.library.html) 'web_camera_web.dart' as web_cam;

/// Renders HTML5 live WebCam video stream on Web platform.
class WebCameraView extends StatelessWidget {
  const WebCameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return web_cam.buildWebCameraView();
  }
}

String? getWebCameraSnapshot() {
  return web_cam.captureWebCameraSnapshot();
}

void setWebCameraZoom(double zoom) {
  web_cam.applyWebCameraZoom(zoom);
}
