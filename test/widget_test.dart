// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:monitoringapp/main.dart';

void main() {
  testWidgets('MonitoringApp renders HomePage', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MonitoringApp());

    // Verify that HomePage is rendered with Coral Monitor title
    expect(find.text('Coral Monitor'), findsOneWidget);

    // Verify that sensor cards are displayed
    expect(find.text('Arus Air'), findsOneWidget);
    expect(find.text('Suhu'), findsOneWidget);
    expect(find.text('Kelembapan'), findsOneWidget);
  });
}
