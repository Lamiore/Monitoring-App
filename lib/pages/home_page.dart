import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/camera_view.dart';
import '../widgets/sensor_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _rng = Random();
  Timer? _timer;

  double _arusAir = 0.8;
  double _suhu = 28.5;
  double _kelembapan = 85.0;
  double _angin = 12.4;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _updateSensors());
  }

  void _updateSensors() {
    setState(() {
      _arusAir = (_arusAir + (_rng.nextDouble() - 0.5) * 0.1).clamp(0.3, 1.5);
      _suhu = (_suhu + (_rng.nextDouble() - 0.5) * 0.3).clamp(26.0, 32.0);
      _kelembapan = (_kelembapan + (_rng.nextDouble() - 0.5) * 1.5).clamp(70.0, 95.0);
      _angin = (_angin + (_rng.nextDouble() - 0.5) * 1.2).clamp(3.0, 25.0);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CORAL MONITOR'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: Color(0xFF888888),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'ONLINE',
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 10,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CameraView(),
              const SizedBox(height: 6),
              const Text(
                'CAM 01 — REEF ZONE A',
                style: TextStyle(
                  color: Color(0xFF444444),
                  fontSize: 9,
                  letterSpacing: 2.5,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'SENSOR DATA',
                style: TextStyle(
                  color: Color(0xFF444444),
                  fontSize: 9,
                  letterSpacing: 3.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SensorCard(
                      icon: Icons.water,
                      label: 'Arus Air',
                      value: _arusAir.toStringAsFixed(1),
                      unit: 'm/s',
                    ),
                    const SizedBox(width: 8),
                    SensorCard(
                      icon: Icons.thermostat,
                      label: 'Suhu',
                      value: _suhu.toStringAsFixed(1),
                      unit: '°C',
                    ),
                    const SizedBox(width: 8),
                    SensorCard(
                      icon: Icons.water_drop,
                      label: 'Kelembapan',
                      value: _kelembapan.toStringAsFixed(0),
                      unit: '%',
                    ),
                    const SizedBox(width: 8),
                    SensorCard(
                      icon: Icons.air,
                      label: 'Angin',
                      value: _angin.toStringAsFixed(1),
                      unit: 'km/h',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
