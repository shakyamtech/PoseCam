// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

html.VideoElement? _globalVideoElement;
double _globalZoomLevel = 1.0;

Widget buildWebCameraView() {
  return const WebCameraViewWidget();
}

String? captureWebCameraSnapshot() {
  if (_globalVideoElement == null) return null;
  try {
    final video = _globalVideoElement!;
    final width = video.videoWidth > 0 ? video.videoWidth : 720;
    final height = video.videoHeight > 0 ? video.videoHeight : 1280;

    final canvas = html.CanvasElement(width: width, height: height);
    final ctx = canvas.context2D;
    ctx.drawImage(video, 0, 0);
    return canvas.toDataUrl('image/jpeg');
  } catch (e) {
    return null;
  }
}

void applyWebCameraZoom(double zoom) {
  _globalZoomLevel = zoom;
  if (_globalVideoElement != null) {
    _globalVideoElement!.style.transform = 'scale($zoom)';
    _globalVideoElement!.style.transformOrigin = 'center center';
    _globalVideoElement!.style.transition = 'transform 0.2s ease-out';
  }
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
      ..style.transform = 'scale($_globalZoomLevel)'
      ..style.transformOrigin = 'center center'
      ..autoplay = true
      ..muted = true;

    _globalVideoElement = _videoElement;

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
    if (_globalVideoElement == _videoElement) {
      _globalVideoElement = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}
