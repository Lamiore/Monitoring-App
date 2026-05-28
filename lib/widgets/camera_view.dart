import 'package:flutter/material.dart';

import 'mjpeg_view.dart';

class CameraView extends StatelessWidget {
  final String? streamUrl;

  const CameraView({super.key, this.streamUrl});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1F1F1F), Color(0xFF121212)],
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              if (streamUrl != null && streamUrl!.isNotEmpty)
                Positioned.fill(child: MjpegStream(url: streamUrl!))
              else ...[
                // Placeholder: grid lines untuk kesan camera feed
                CustomPaint(
                  painter: _GridPainter(),
                  child: const SizedBox.expand(),
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.videocam_outlined,
                      color: Color(0xFF555555),
                      size: 36,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'LIVE FEED',
                      style: TextStyle(
                        color: Color(0xFF555555),
                        fontSize: 11,
                        letterSpacing: 3.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
              // REC indicator
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF2A2A2A),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF888888),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'REC',
                        style: TextStyle(
                          color: Color(0xFF888888),
                          fontSize: 10,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Timestamp
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF2A2A2A),
                      width: 0.5,
                    ),
                  ),
                  child: const Text(
                    '00:00:00',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 10,
                      letterSpacing: 1.5,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
            ],
          ),
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
