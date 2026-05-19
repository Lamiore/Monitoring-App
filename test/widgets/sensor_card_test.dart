import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monitoringapp/widgets/sensor_card.dart';

void main() {
  group('SensorCard', () {
    testWidgets('menampilkan label sensor', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SensorCard(
              icon: Icons.water,
              label: 'Arus Air',
              value: '0.8',
              unit: 'm/s',
            ),
          ),
        ),
      );
      expect(find.text('ARUS AIR'), findsOneWidget);
    });

    testWidgets('menampilkan value dan unit', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SensorCard(
              icon: Icons.thermostat,
              label: 'Suhu',
              value: '28.5',
              unit: '°C',
            ),
          ),
        ),
      );
      expect(find.text('28.5'), findsOneWidget);
      expect(find.text('°C'), findsOneWidget);
    });

    testWidgets('menampilkan icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SensorCard(
              icon: Icons.water_drop,
              label: 'Kelembapan',
              value: '85',
              unit: '%',
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.water_drop), findsOneWidget);
    });
  });
}
