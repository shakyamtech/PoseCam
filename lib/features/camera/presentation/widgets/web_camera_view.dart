import 'package:flutter/material.dart';
import 'web_camera_stub.dart'
    if (dart.library.html) 'web_camera_web.dart';

/// Renders HTML5 live WebCam video stream on Web platform or empty widget on native.
class WebCameraView extends StatelessWidget {
  const WebCameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return buildWebCameraView();
  }
}
