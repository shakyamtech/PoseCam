// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

Widget buildWebCameraView() {
  return const WebCameraViewWidget();
}

class WebCameraViewWidget extends StatefulWidget {
  const WebCameraViewWidget({super.key});

  @override
  State<WebCameraViewWidget> createState() => _WebCameraViewWidgetState();
}

class _WebCameraViewWidgetState extends State<WebCameraViewWidget> {
  static int _viewId = 0;
  late String _viewType;
  html.VideoElement? _videoElement;

  @override
  void initState() {
    super.initState();
    _viewType = 'web-camera-view-${_viewId++}';

    _videoElement = html.VideoElement()
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'cover'
      ..autoplay = true
      ..muted = true;

    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int id) => _videoElement!,
    );

    _startWebcam();
  }

  Future<void> _startWebcam() async {
    try {
      final mediaStream = await html.window.navigator.mediaDevices?.getUserMedia({'video': true});
      if (mediaStream != null && _videoElement != null) {
        _videoElement!.srcObject = mediaStream;
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    if (_videoElement != null && _videoElement!.srcObject != null) {
      final stream = _videoElement!.srcObject as html.MediaStream;
      stream.getTracks().forEach((track) => track.stop());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}
