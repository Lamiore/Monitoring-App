import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MonitoringApp());
}

class MonitoringApp extends StatelessWidget {
  const MonitoringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coral Monitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A1628),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00D4FF),
          secondary: Color(0xFF00FFB3),
          surface: Color(0xFF0D2137),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A1628),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
