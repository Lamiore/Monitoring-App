import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/sensor_data.dart';

class SensorHistory {
  static const int maxSamples = 60;
  static const Duration staleAfter = Duration(seconds: 15);
  static const Duration heartbeat = Duration(seconds: 3);

  final ValueNotifier<SensorData> latest = ValueNotifier(SensorData.empty);
  final ValueNotifier<List<SensorData>> history = ValueNotifier(
    const <SensorData>[],
  );
  final ValueNotifier<bool> connected = ValueNotifier(false);

  StreamSubscription<SensorData>? _sub;
  Timer? _freshnessTimer;
  DateTime? _lastFreshAt;

  void bind(Stream<SensorData> stream) {
    _sub?.cancel();
    _sub = stream.listen((data) {
      latest.value = data;
      if (_isFresh(data)) {
        _lastFreshAt = DateTime.now();
        connected.value = true;
        final next = List<SensorData>.from(history.value)..add(data);
        if (next.length > maxSamples) {
          next.removeRange(0, next.length - maxSamples);
        }
        history.value = next;
      } else {
        connected.value = false;
      }
    });
    _freshnessTimer?.cancel();
    _freshnessTimer = Timer.periodic(heartbeat, (_) => _checkFreshness());
  }

  bool _isFresh(SensorData data) {
    if (data.timestamp <= 0) return false;
    final ageMs = DateTime.now().millisecondsSinceEpoch - data.timestamp;
    return ageMs < staleAfter.inMilliseconds;
  }

  void _checkFreshness() {
    final last = _lastFreshAt;
    if (last == null) {
      if (connected.value) connected.value = false;
      return;
    }
    final stale = DateTime.now().difference(last) >= staleAfter;
    if (stale && connected.value) connected.value = false;
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
    _freshnessTimer?.cancel();
    _freshnessTimer = null;
    latest.dispose();
    history.dispose();
    connected.dispose();
  }
}
