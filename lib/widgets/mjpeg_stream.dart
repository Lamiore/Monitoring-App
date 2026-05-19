import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Widget yang konsumsi MJPEG stream dari URL HTTP.
///
/// Parse multipart `multipart/x-mixed-replace; boundary=frame` yang dikirim
/// Flask endpoint `/video_feed`, lalu render frame JPEG terakhir lewat
/// [Image.memory] dengan `gaplessPlayback` agar transisi mulus.
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
  static final Uint8List _jpegStart = Uint8List.fromList([0xFF, 0xD8]);
  static final Uint8List _jpegEnd = Uint8List.fromList([0xFF, 0xD9]);

  http.Client? _client;
  StreamSubscription<List<int>>? _sub;
  Uint8List _buffer = Uint8List(0);
  Uint8List? _currentFrame;
  String? _error;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(covariant MjpegStream oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _stop();
      _start();
    }
  }

  Future<void> _start() async {
    if (_disposed) return;
    setState(() => _error = null);

    try {
      _client = http.Client();
      final request = http.Request('GET', Uri.parse(widget.url));
      request.headers['ngrok-skip-browser-warning'] = 'true';
      request.headers['User-Agent'] = 'monitoringapp-flutter';
      final response = await _client!.send(request);

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      _sub = response.stream.listen(
        _onData,
        onError: _onError,
        onDone: () => _scheduleReconnect('stream closed'),
        cancelOnError: true,
      );
    } catch (e) {
      _onError(e);
    }
  }

  void _onData(List<int> chunk) {
    final merged = Uint8List(_buffer.length + chunk.length);
    merged.setRange(0, _buffer.length, _buffer);
    merged.setRange(_buffer.length, merged.length, chunk);
    _buffer = merged;

    while (true) {
      final start = _indexOf(_buffer, _jpegStart, 0);
      if (start < 0) {
        if (_buffer.length > 1024 * 1024) _buffer = Uint8List(0);
        return;
      }
      final end = _indexOf(_buffer, _jpegEnd, start + 2);
      if (end < 0) {
        if (start > 0) _buffer = Uint8List.sublistView(_buffer, start);
        return;
      }
      final frame = Uint8List.sublistView(_buffer, start, end + 2);
      _buffer = Uint8List.sublistView(_buffer, end + 2);

      if (!_disposed && mounted) {
        setState(() => _currentFrame = frame);
      }
    }
  }

  int _indexOf(Uint8List haystack, Uint8List needle, int start) {
    for (var i = start; i <= haystack.length - needle.length; i++) {
      var match = true;
      for (var j = 0; j < needle.length; j++) {
        if (haystack[i + j] != needle[j]) {
          match = false;
          break;
        }
      }
      if (match) return i;
    }
    return -1;
  }

  void _onError(Object error) => _scheduleReconnect(error.toString());

  void _scheduleReconnect(String reason) {
    if (_disposed) return;
    if (mounted) setState(() => _error = reason);
    _client?.close();
    _client = null;
    Future.delayed(widget.reconnectDelay, () {
      if (!_disposed) _start();
    });
  }

  void _stop() {
    _sub?.cancel();
    _sub = null;
    _client?.close();
    _client = null;
    _buffer = Uint8List(0);
  }

  @override
  void dispose() {
    _disposed = true;
    _stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final frame = _currentFrame;
    if (frame != null) {
      return Image.memory(frame, gaplessPlayback: true, fit: widget.fit);
    }
    return Container(
      color: const Color(0xFF121212),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _error == null ? 'CONNECTING…' : 'RECONNECTING…',
            style: const TextStyle(
              color: Color(0xFF555555),
              fontSize: 10,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }
}
