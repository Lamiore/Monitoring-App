import 'package:flutter/material.dart';

import '../config.dart';
import '../models/sensor_data.dart';
import '../services/sensor_history.dart';
import '../widgets/camera_view.dart';
import '../widgets/sensor_card.dart';

class DashboardPage extends StatelessWidget {
  final SensorHistory history;

  const DashboardPage({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SensorData>(
      valueListenable: history.latest,
      builder: (context, data, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: history.connected,
          builder: (context, connected, _) => _buildBody(connected, data),
        );
      },
    );
  }

  Widget _buildBody(bool connected, SensorData data) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _statusRow(connected),
            const SizedBox(height: 12),
            const CameraView(streamUrl: AppConfig.cameraStreamUrl),
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
                    icon: Icons.thermostat,
                    label: 'Suhu Udara',
                    value: data.tempDHT.toStringAsFixed(1),
                    unit: '°C',
                  ),
                  const SizedBox(width: 12),
                  SensorCard(
                    icon: Icons.water_drop,
                    label: 'Kelembapan',
                    value: data.humidity.toStringAsFixed(0),
                    unit: '%',
                  ),
                  const SizedBox(width: 12),
                  SensorCard(
                    icon: Icons.device_thermostat,
                    label: 'Suhu Air',
                    value: data.tempDS18.toStringAsFixed(1),
                    unit: '°C',
                  ),
                  const SizedBox(width: 12),
                  SensorCard(
                    icon: Icons.cloud,
                    label: 'Cuaca',
                    value: data.rainStatus,
                    unit: '',
                  ),
                  const SizedBox(width: 12),
                  SensorCard(
                    icon: Icons.air,
                    label: 'Angin',
                    value: data.windSpeed.toStringAsFixed(1),
                    unit: 'km/h',
                  ),
                  const SizedBox(width: 12),
                  SensorCard(
                    icon: Icons.water,
                    label: 'Debit Air',
                    value: data.flowRate.toStringAsFixed(2),
                    unit: 'L/min',
                  ),
                  const SizedBox(width: 12),
                  SensorCard(
                    icon: Icons.bolt,
                    label: 'Nutrisi EC',
                    value: data.ecValue.toStringAsFixed(2),
                    unit: 'ms/cm',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusRow(bool connected) {
    final color =
        connected ? const Color(0xFF4ADE80) : const Color(0xFFFF6B6B);
    final label = connected ? 'ONLINE' : 'OFFLINE';
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
