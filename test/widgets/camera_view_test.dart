import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monitoringapp/widgets/camera_view.dart';

void main() {
  group('CameraView', () {
    testWidgets('menampilkan teks Camera Feed', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CameraView()),
        ),
      );
      expect(find.text('Camera Feed'), findsOneWidget);
    });

    testWidgets('menampilkan icon kamera', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CameraView()),
        ),
      );
      expect(find.byIcon(Icons.videocam_outlined), findsOneWidget);
    });
  });
}
