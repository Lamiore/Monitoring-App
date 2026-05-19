import 'dart:math' as math;

import 'package:flutter/material.dart';

class LineChart extends StatelessWidget {
  final List<double> data;
  final Color lineColor;
  final Color fillColor;
  final double minY;
  final double maxY;
  final bool showGrid;
  final bool showDots;

  const LineChart({
    super.key,
    required this.data,
    this.lineColor = const Color(0xFFEEEEEE),
    this.fillColor = const Color(0x22EEEEEE),
    this.minY = double.nan,
    this.maxY = double.nan,
    this.showGrid = true,
    this.showDots = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LineChartPainter(
        data: data,
        lineColor: lineColor,
        fillColor: fillColor,
        minY: minY,
        maxY: maxY,
        showGrid: showGrid,
        showDots: showDots,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;
  final Color fillColor;
  final double minY;
  final double maxY;
  final bool showGrid;
  final bool showDots;

  _LineChartPainter({
    required this.data,
    required this.lineColor,
    required this.fillColor,
    required this.minY,
    required this.maxY,
    required this.showGrid,
    required this.showDots,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (showGrid) _paintGrid(canvas, size);
    if (data.isEmpty) {
      _paintEmpty(canvas, size);
      return;
    }
    if (data.length == 1) {
      _paintSingle(canvas, size);
      return;
    }

    final lo = minY.isNaN
        ? data.reduce(math.min)
        : math.min(minY, data.reduce(math.min));
    final hi = maxY.isNaN
        ? data.reduce(math.max)
        : math.max(maxY, data.reduce(math.max));
    final span = (hi - lo) == 0 ? 1.0 : (hi - lo);

    final pad = 4.0;
    final w = size.width;
    final h = size.height - pad * 2;
    final dx = data.length == 1 ? 0.0 : w / (data.length - 1);

    final points = <Offset>[
      for (var i = 0; i < data.length; i++)
        Offset(i * dx, pad + h - ((data[i] - lo) / span) * h),
    ];

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final p0 = points[i - 1];
      final p1 = points[i];
      final cx = (p0.dx + p1.dx) / 2;
      linePath.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }

    final fillPath = Path.from(linePath)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [fillColor, fillColor.withValues(alpha: 0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    canvas.drawPath(
      linePath,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    if (showDots) {
      final dotPaint = Paint()..color = lineColor;
      final innerPaint = Paint()..color = const Color(0xFF0F0F0F);
      final last = points.last;
      canvas.drawCircle(last, 4, dotPaint);
      canvas.drawCircle(last, 2, innerPaint);
      canvas.drawCircle(last, 1.2, dotPaint);
    }
  }

  void _paintGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1F1F1F)
      ..strokeWidth = 0.5;
    const rows = 3;
    for (var i = 1; i < rows; i++) {
      final y = size.height * i / rows;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _paintEmpty(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF333333)
      ..strokeWidth = 1.0;
    final y = size.height / 2;
    final dashWidth = 4.0;
    final dashGap = 4.0;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, y), Offset(x + dashWidth, y), paint);
      x += dashWidth + dashGap;
    }
  }

  void _paintSingle(Canvas canvas, Size size) {
    final paint = Paint()..color = lineColor;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 3, paint);
  }

  @override
  bool shouldRepaint(_LineChartPainter old) =>
      old.data != data ||
      old.lineColor != lineColor ||
      old.minY != minY ||
      old.maxY != maxY;
}
