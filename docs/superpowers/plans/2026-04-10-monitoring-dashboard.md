# Monitoring Dashboard Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Membangun halaman utama monitoring terumbu karang dengan camera view placeholder di atas dan tiga sensor card (arus air, suhu, kelembapan) di bawahnya.

**Architecture:** StatelessWidget murni — semua data sensor disimpan sebagai konstanta di `HomePage`. `SensorCard` dan `CameraView` adalah widget reusable yang menerima data via constructor. Tidak ada state management untuk saat ini.

**Tech Stack:** Flutter 3.x, Dart, Material 3, tidak ada package tambahan.

---

## File Structure

| File | Status | Tanggung Jawab |
|---|---|---|
| `lib/main.dart` | Modify | Entry point, MaterialApp dengan dark ocean theme |
| `lib/pages/home_page.dart` | Create | Scaffold, AppBar, layout Column |
| `lib/widgets/sensor_card.dart` | Create | Card reusable untuk satu sensor |
| `lib/widgets/camera_view.dart` | Create | Placeholder camera feed 16:9 |
| `test/widgets/sensor_card_test.dart` | Create | Widget test untuk SensorCard |
| `test/widgets/camera_view_test.dart` | Create | Widget test untuk CameraView |

---

## Task 1: Update `main.dart` dengan ocean theme

**Files:**
- Modify: `lib/main.dart`

- [ ] **Step 1: Ganti isi `main.dart` dengan theme dark ocean**

```dart
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
```

- [ ] **Step 2: Jalankan app untuk pastikan tidak ada error compile**

```bash
flutter run
```

Expected: App terbuka dengan background gelap, AppBar "Coral Monitor", body kosong (HomePage belum ada — akan error sampai Task 2 selesai). Oke untuk sekarang.

- [ ] **Step 3: Commit**

```bash
git add lib/main.dart
git commit -m "feat: setup dark ocean theme in main.dart"
```

---

## Task 2: Buat `SensorCard` widget

**Files:**
- Create: `lib/widgets/sensor_card.dart`
- Create: `test/widgets/sensor_card_test.dart`

- [ ] **Step 1: Buat direktori dan file test dulu**

```bash
mkdir -p lib/widgets test/widgets
```

Buat `test/widgets/sensor_card_test.dart`:

```dart
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
              accentColor: Color(0xFF00D4FF),
            ),
          ),
        ),
      );
      expect(find.text('Arus Air'), findsOneWidget);
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
              accentColor: Color(0xFFFF6B6B),
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
              accentColor: Color(0xFF00FFB3),
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.water_drop), findsOneWidget);
    });
  });
}
```

- [ ] **Step 2: Jalankan test — pastikan GAGAL dulu**

```bash
flutter test test/widgets/sensor_card_test.dart
```

Expected: Error `Target file "lib/widgets/sensor_card.dart" not found`

- [ ] **Step 3: Buat `lib/widgets/sensor_card.dart`**

```dart
import 'package:flutter/material.dart';

class SensorCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color accentColor;

  const SensorCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0xFF0D2137),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1A4A6B), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: accentColor, size: 32),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF8BAABE),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: accentColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              color: Color(0xFF8BAABE),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Jalankan test — pastikan LULUS**

```bash
flutter test test/widgets/sensor_card_test.dart
```

Expected: `All tests passed!`

- [ ] **Step 5: Commit**

```bash
git add lib/widgets/sensor_card.dart test/widgets/sensor_card_test.dart
git commit -m "feat: add SensorCard widget"
```

---

## Task 3: Buat `CameraView` widget

**Files:**
- Create: `lib/widgets/camera_view.dart`
- Create: `test/widgets/camera_view_test.dart`

- [ ] **Step 1: Buat file test `test/widgets/camera_view_test.dart`**

```dart
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
```

- [ ] **Step 2: Jalankan test — pastikan GAGAL dulu**

```bash
flutter test test/widgets/camera_view_test.dart
```

Expected: Error `Target file "lib/widgets/camera_view.dart" not found`

- [ ] **Step 3: Buat `lib/widgets/camera_view.dart`**

```dart
import 'package:flutter/material.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0D2137),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1A4A6B), width: 1),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam_outlined,
              color: Color(0xFF8BAABE),
              size: 48,
            ),
            SizedBox(height: 12),
            Text(
              'Camera Feed',
              style: TextStyle(
                color: Color(0xFF8BAABE),
                fontSize: 14,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Jalankan test — pastikan LULUS**

```bash
flutter test test/widgets/camera_view_test.dart
```

Expected: `All tests passed!`

- [ ] **Step 5: Commit**

```bash
git add lib/widgets/camera_view.dart test/widgets/camera_view_test.dart
git commit -m "feat: add CameraView placeholder widget"
```

---

## Task 4: Buat `HomePage`

**Files:**
- Create: `lib/pages/home_page.dart`

- [ ] **Step 1: Buat direktori dan file**

```bash
mkdir -p lib/pages
```

Buat `lib/pages/home_page.dart`:

```dart
import 'package:flutter/material.dart';
import '../widgets/camera_view.dart';
import '../widgets/sensor_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Coral Monitor'),
            const SizedBox(width: 10),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF00FFB3),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CameraView(),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: const [
                    SensorCard(
                      icon: Icons.water,
                      label: 'Arus Air',
                      value: '0.8',
                      unit: 'm/s',
                      accentColor: Color(0xFF00D4FF),
                    ),
                    SizedBox(width: 12),
                    SensorCard(
                      icon: Icons.thermostat,
                      label: 'Suhu',
                      value: '28.5',
                      unit: '°C',
                      accentColor: Color(0xFFFF6B6B),
                    ),
                    SizedBox(width: 12),
                    SensorCard(
                      icon: Icons.water_drop,
                      label: 'Kelembapan',
                      value: '85',
                      unit: '%',
                      accentColor: Color(0xFF00FFB3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Jalankan semua test**

```bash
flutter test
```

Expected: `All tests passed!`

- [ ] **Step 3: Jalankan app dan cek tampilan**

```bash
flutter run
```

Expected: App tampil dengan background navy gelap, AppBar "Coral Monitor" + titik hijau, camera placeholder 16:9, dan tiga sensor card di bawahnya.

- [ ] **Step 4: Commit**

```bash
git add lib/pages/home_page.dart
git commit -m "feat: add HomePage with camera view and sensor cards"
```

---

## Task 5: Inisialisasi git dan final check

**Files:**
- Modify: `lib/main.dart` (pastikan import sudah benar)

- [ ] **Step 1: Pastikan semua test hijau**

```bash
flutter test
```

Expected: semua test pass.

- [ ] **Step 2: Jalankan app sekali lagi untuk visual check**

```bash
flutter run
```

Checklist visual:
- [ ] Background seluruh app navy gelap `#0A1628`
- [ ] AppBar "Coral Monitor" dengan titik hijau kecil di samping
- [ ] Camera placeholder dengan border biru gelap, icon kamera + teks "Camera Feed"
- [ ] Tiga card: Arus Air (cyan), Suhu (merah muda), Kelembapan (seafoam)
- [ ] Card bisa di-scroll horizontal kalau layar kecil

- [ ] **Step 3: Commit final**

```bash
git add -A
git commit -m "feat: complete coral reef monitoring dashboard UI"
```
