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
      builder: (context, data, _) => _buildBody(data),
    );
  }

  Widget _buildBody(SensorData data) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            _SensorGrid(data: data),
          ],
        ),
      ),
    );
  }
}

class _SensorGrid extends StatelessWidget {
  final SensorData data;

  const _SensorGrid({required this.data});

  @override
  Widget build(BuildContext context) {
    final cards = <Widget>[
      SensorCard(
        icon: Icons.thermostat,
        label: 'Suhu Udara',
        value: data.tempDHT.toStringAsFixed(1),
        unit: '°C',
      ),
      SensorCard(
        icon: Icons.water_drop,
        label: 'Kelembapan',
        value: data.humidity.toStringAsFixed(0),
        unit: '%',
      ),
      SensorCard(
        icon: Icons.device_thermostat,
        label: 'Suhu Air',
        value: data.tempDS18.toStringAsFixed(1),
        unit: '°C',
      ),
      SensorCard(
        icon: Icons.cloud,
        label: 'Cuaca',
        value: data.rainStatus,
        unit: '',
      ),
      SensorCard(
        icon: Icons.air,
        label: 'Angin',
        value: data.windSpeed.toStringAsFixed(1),
        unit: 'km/h',
      ),
      SensorCard(
        icon: Icons.water,
        label: 'Debit Air',
        value: data.flowRate.toStringAsFixed(2),
        unit: 'L/min',
      ),
      SensorCard(
        icon: Icons.bolt,
        label: 'Nutrisi EC',
        value: data.ecValue.toStringAsFixed(2),
        unit: 'ms/cm',
      ),
    ];

    const spacing = 12.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1000
            ? 4
            : width >= 700
                ? 3
                : 2;
        final itemWidth =
            (width - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final card in cards)
              SizedBox(width: itemWidth, child: card),
          ],
        );
      },
    );
  }
}
