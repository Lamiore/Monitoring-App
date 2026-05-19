import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/sensor_data.dart';
import '../services/sensor_history.dart';
import '../widgets/line_chart.dart';
import '../widgets/stat_chart_card.dart';

class _Metric {
  final String key;
  final String label;
  final String unit;
  final IconData icon;
  final int fractionDigits;
  final double Function(SensorData) extract;

  const _Metric({
    required this.key,
    required this.label,
    required this.unit,
    required this.icon,
    required this.fractionDigits,
    required this.extract,
  });
}

const List<_Metric> _metrics = [
  _Metric(
    key: 'tempDHT',
    label: 'Suhu Udara',
    unit: '°C',
    icon: Icons.thermostat,
    fractionDigits: 1,
    extract: _airTemp,
  ),
  _Metric(
    key: 'humidity',
    label: 'Kelembapan',
    unit: '%',
    icon: Icons.water_drop,
    fractionDigits: 0,
    extract: _humidity,
  ),
  _Metric(
    key: 'tempDS18',
    label: 'Suhu Air',
    unit: '°C',
    icon: Icons.device_thermostat,
    fractionDigits: 1,
    extract: _waterTemp,
  ),
  _Metric(
    key: 'windSpeed',
    label: 'Angin',
    unit: 'km/h',
    icon: Icons.air,
    fractionDigits: 1,
    extract: _wind,
  ),
  _Metric(
    key: 'flowRate',
    label: 'Debit Air',
    unit: 'L/min',
    icon: Icons.water,
    fractionDigits: 2,
    extract: _flow,
  ),
  _Metric(
    key: 'ecValue',
    label: 'Nutrisi EC',
    unit: 'ms/cm',
    icon: Icons.bolt,
    fractionDigits: 2,
    extract: _ec,
  ),
];

double _airTemp(SensorData d) => d.tempDHT;
double _humidity(SensorData d) => d.humidity;
double _waterTemp(SensorData d) => d.tempDS18;
double _wind(SensorData d) => d.windSpeed;
double _flow(SensorData d) => d.flowRate;
double _ec(SensorData d) => d.ecValue;

class StatsPage extends StatefulWidget {
  final SensorHistory history;

  const StatsPage({super.key, required this.history});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int _focusIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<SensorData>>(
      valueListenable: widget.history.history,
      builder: (context, samples, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(samples.length),
              const SizedBox(height: 16),
              _focusChart(samples),
              const SizedBox(height: 16),
              _metricSelector(),
              const SizedBox(height: 24),
              const Text(
                'ALL METRICS',
                style: TextStyle(
                  color: Color(0xFF444444),
                  fontSize: 9,
                  letterSpacing: 3.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              ..._buildMetricCards(samples),
            ],
          ),
        );
      },
    );
  }

  Widget _header(int sampleCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'STATISTICS',
          style: TextStyle(
            color: Color(0xFFCCCCCC),
            fontSize: 11,
            letterSpacing: 3.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
          ),
          child: Text(
            '$sampleCount SAMPLES',
            style: const TextStyle(
              color: Color(0xFF888888),
              fontSize: 10,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _focusChart(List<SensorData> samples) {
    final metric = _metrics[_focusIndex];
    final data = samples.map(metric.extract).toList();
    final hasData = data.isNotEmpty;
    final current = hasData ? data.last : 0.0;
    final lo = hasData ? data.reduce(math.min) : 0.0;
    final hi = hasData ? data.reduce(math.max) : 0.0;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1F1F1F), Color(0xFF141414)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF232323),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(
                  metric.icon,
                  color: const Color(0xFFAAAAAA),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  metric.label.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFFAAAAAA),
                    fontSize: 11,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                hasData
                    ? current.toStringAsFixed(metric.fractionDigits)
                    : '--',
                style: const TextStyle(
                  color: Color(0xFFEEEEEE),
                  fontSize: 44,
                  fontWeight: FontWeight.w200,
                  letterSpacing: -1.5,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  metric.unit,
                  style: const TextStyle(
                    color: Color(0xFF777777),
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 140,
            child: LineChart(data: data, showDots: true, showGrid: true),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _RangeStat(
                label: 'MIN',
                value: hasData
                    ? lo.toStringAsFixed(metric.fractionDigits)
                    : '--',
              ),
              _RangeStat(
                label: 'NOW',
                value: hasData
                    ? current.toStringAsFixed(metric.fractionDigits)
                    : '--',
                accent: true,
              ),
              _RangeStat(
                label: 'MAX',
                value: hasData
                    ? hi.toStringAsFixed(metric.fractionDigits)
                    : '--',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < _metrics.length; i++) ...[
            _SelectorChip(
              label: _metrics[i].label,
              icon: _metrics[i].icon,
              selected: i == _focusIndex,
              onTap: () => setState(() => _focusIndex = i),
            ),
            if (i < _metrics.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildMetricCards(List<SensorData> samples) {
    final cards = <Widget>[];
    for (var i = 0; i < _metrics.length; i++) {
      final m = _metrics[i];
      final data = samples.map(m.extract).toList();
      cards.add(
        StatChartCard(
          icon: m.icon,
          label: m.label,
          unit: m.unit,
          data: data,
          fractionDigits: m.fractionDigits,
        ),
      );
      if (i < _metrics.length - 1) cards.add(const SizedBox(height: 12));
    }
    return cards;
  }
}

class _SelectorChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _SelectorChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFEEEEEE)
              : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? const Color(0xFFEEEEEE)
                : const Color(0xFF2A2A2A),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected
                  ? const Color(0xFF0F0F0F)
                  : const Color(0xFF888888),
              size: 13,
            ),
            const SizedBox(width: 6),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: selected
                    ? const Color(0xFF0F0F0F)
                    : const Color(0xFF888888),
                fontSize: 9,
                letterSpacing: 1.8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RangeStat extends StatelessWidget {
  final String label;
  final String value;
  final bool accent;

  const _RangeStat({
    required this.label,
    required this.value,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF555555),
            fontSize: 9,
            letterSpacing: 2.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: accent
                ? const Color(0xFFEEEEEE)
                : const Color(0xFFAAAAAA),
            fontSize: 15,
            fontWeight: accent ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
