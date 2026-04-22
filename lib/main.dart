import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, st) {
    debugPrint('Firebase.initializeApp failed: $e\n$st');
    runApp(_ErrorApp(message: 'Firebase init gagal:\n$e'));
    return;
  }
  runApp(const MonitoringApp());
}

class MonitoringApp extends StatefulWidget {
  const MonitoringApp({super.key});

  @override
  State<MonitoringApp> createState() => _MonitoringAppState();
}

class _MonitoringAppState extends State<MonitoringApp> {
  late final Future<void> _signIn = FirebaseService().signIn();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coral Monitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFFFFF),
          secondary: Color(0xFF888888),
          surface: Color(0xFF1A1A1A),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F0F0F),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 2.0,
          ),
        ),
        useMaterial3: true,
      ),
      home: FutureBuilder<void>(
        future: _signIn,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const _LoadingScreen(message: 'Signing in…');
          }
          if (snapshot.hasError) {
            return _ErrorScreen(
              message: 'Sign-in gagal:\n${snapshot.error}',
            );
          }
          return const HomePage();
        },
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  final String message;
  const _LoadingScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Color(0xFF888888)),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(color: Color(0xFF888888), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  final String message;
  const _ErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SelectableText(
            message,
            style: const TextStyle(color: Color(0xFFFF6B6B), fontSize: 13),
          ),
        ),
      ),
    );
  }
}

class _ErrorApp extends StatelessWidget {
  final String message;
  const _ErrorApp({required this.message});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: _ErrorScreen(message: message),
    );
  }
}
