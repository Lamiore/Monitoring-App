import 'package:flutter/material.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Stack(
          children: [
            // Grid lines untuk kesan camera feed
            CustomPaint(
              painter: _GridPainter(),
              child: const SizedBox.expand(),
            ),
            // Center content
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.videocam_outlined,
                  color: Color(0xFF444444),
                  size: 36,
                ),
                SizedBox(height: 10),
                Text(
                  'LIVE FEED',
                  style: TextStyle(
                    color: Color(0xFF444444),
                    fontSize: 11,
                    letterSpacing: 3.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            // REC indicator
            Positioned(
              top: 14,
              left: 14,
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF666666),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'REC',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 10,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Timestamp
            const Positioned(
              bottom: 14,
              right: 14,
              child: Text(
                '00:00:00',
                style: TextStyle(
                  color: Color(0xFF444444),
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF222222)
      ..strokeWidth = 0.5;

    // Vertical lines (rule of thirds)
    canvas.drawLine(
      Offset(size.width / 3, 0),
      Offset(size.width / 3, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 2 / 3, 0),
      Offset(size.width * 2 / 3, size.height),
      paint,
    );

    // Horizontal lines (rule of thirds)
    canvas.drawLine(
      Offset(0, size.height / 3),
      Offset(size.width, size.height / 3),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height * 2 / 3),
      Offset(size.width, size.height * 2 / 3),
      paint,
    );
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => false;
}
