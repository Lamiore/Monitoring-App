import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'line_chart.dart';

class StatChartCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String unit;
  final List<double> data;
  final int fractionDigits;

  const StatChartCard({
    super.key,
    required this.icon,
    required this.label,
    required this.unit,
    required this.data,
    this.fractionDigits = 1,
  });

  @override
  Widget build(BuildContext context) {
    final hasData = data.isNotEmpty;
    final current = hasData ? data.last : 0.0;
    final lo = hasData ? data.reduce(math.min) : 0.0;
    final hi = hasData ? data.reduce(math.max) : 0.0;
    final avg = hasData ? data.reduce((a, b) => a + b) / data.length : 0.0;
    final delta = data.length > 1 ? data.last - data.first : 0.0;
    final trendUp = delta > 0;
    final trendColor = !hasData
        ? const Color(0xFF555555)
        : (delta == 0
              ? const Color(0xFF888888)
              : (trendUp
                    ? const Color(0xFF4ADE80)
                    : const Color(0xFFFF8888)));

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1F1F1F), Color(0xFF141414)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF232323),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: const Color(0xFFAAAAAA), size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 10,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF2A2A2A),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      delta == 0
                          ? Icons.remove
                          : (trendUp
                                ? Icons.arrow_upward
                                : Icons.arrow_downward),
                      color: trendColor,
                      size: 10,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      hasData
                          ? delta.abs().toStringAsFixed(fractionDigits)
                          : '--',
                      style: TextStyle(
                        color: trendColor,
                        fontSize: 10,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                hasData ? current.toStringAsFixed(fractionDigits) : '--',
                style: const TextStyle(
                  color: Color(0xFFEEEEEE),
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -1,
                  height: 1,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    unit,
                    style: const TextStyle(
                      color: Color(0xFF777777),
                      fontSize: 11,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 56,
            child: LineChart(
              data: data,
              showDots: true,
              fillColor: const Color(0x22EEEEEE),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MiniStat(
                label: 'MIN',
                value: hasData ? lo.toStringAsFixed(fractionDigits) : '--',
              ),
              _MiniStat(
                label: 'AVG',
                value: hasData ? avg.toStringAsFixed(fractionDigits) : '--',
              ),
              _MiniStat(
                label: 'MAX',
                value: hasData ? hi.toStringAsFixed(fractionDigits) : '--',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF555555),
            fontSize: 8,
            letterSpacing: 2.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFCCCCCC),
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
