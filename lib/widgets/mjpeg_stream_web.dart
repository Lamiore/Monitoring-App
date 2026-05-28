import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

/// Web implementation: render MJPEG via an HTML `<img>` element.
///
/// Browsers natively decode `multipart/x-mixed-replace` streams when used as
/// an `<img src>` source. The Dart-side stream parser used by the native
/// implementation does not work on the web because `package:http` cannot
/// stream chunked responses from a browser fetch.
class MjpegStream extends StatefulWidget {
  final String url;
  final BoxFit fit;
  final Duration reconnectDelay;

  const MjpegStream({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.reconnectDelay = const Duration(seconds: 2),
  });

  @override
  State<MjpegStream> createState() => _MjpegStreamState();
}

class _MjpegStreamState extends State<MjpegStream> {
  late String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = _registerView(widget.url, widget.fit);
  }

  @override
  void didUpdateWidget(covariant MjpegStream oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url || oldWidget.fit != widget.fit) {
      setState(() {
        _viewType = _registerView(widget.url, widget.fit);
      });
    }
  }

  String _registerView(String url, BoxFit fit) {
    final viewType =
        'mjpeg-${url.hashCode}-${DateTime.now().microsecondsSinceEpoch}';
    ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      final img = web.HTMLImageElement()
        ..src = url
        ..alt = 'camera stream';
      img.style
        ..width = '100%'
        ..height = '100%'
        ..objectFit = _objectFit(fit)
        ..display = 'block'
        ..backgroundColor = '#121212';
      return img;
    });
    return viewType;
  }

  String _objectFit(BoxFit fit) {
    switch (fit) {
      case BoxFit.contain:
      case BoxFit.fitHeight:
      case BoxFit.fitWidth:
        return 'contain';
      case BoxFit.cover:
        return 'cover';
      case BoxFit.fill:
        return 'fill';
      case BoxFit.scaleDown:
        return 'scale-down';
      case BoxFit.none:
        return 'none';
    }
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}
