import 'package:flutter/material.dart';
import '../widgets/camera_view.dart';
import '../widgets/sensor_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Coral Monitor'),
            const SizedBox(width: 10),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(color: Color(0xFF00FFB3), shape: BoxShape.circle),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CameraView(),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: const [
                    SensorCard(
                      icon: Icons.water,
                      label: 'Arus Air',
                      value: '0.8',
                      unit: 'm/s',
                      accentColor: Color(0xFF00D4FF),
                    ),
                    SizedBox(width: 12),
                    SensorCard(
                      icon: Icons.thermostat,
                      label: 'Suhu',
                      value: '28.5',
                      unit: '°C',
                      accentColor: Color(0xFFFF6B6B),
                    ),
                    SizedBox(width: 12),
                    SensorCard(
                      icon: Icons.water_drop,
                      label: 'Kelembapan',
                      value: '85',
                      unit: '%',
                      accentColor: Color(0xFF00FFB3),
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
