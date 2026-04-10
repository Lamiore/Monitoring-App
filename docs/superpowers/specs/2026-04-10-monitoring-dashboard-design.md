# Coral Reef Monitoring App — Dashboard Design

**Date:** 2026-04-10  
**Status:** Approved

---

## Overview

Halaman utama monitoring terumbu karang. Menampilkan live feed kamera di bagian atas dan tiga card sensor di bawahnya. Data sensor untuk saat ini menggunakan nilai mock statis; backend akan diintegrasikan di iterasi berikutnya.

---

## Layout

```
┌─────────────────────────────┐
│         AppBar              │  Judul "Coral Monitor" + status indicator
├─────────────────────────────┤
│                             │
│       Camera View           │  Rasio 16:9, placeholder icon + label
│    (placeholder dulu)       │
│                             │
├─────────────────────────────┤
│  ┌─────┐ ┌─────┐ ┌─────┐  │
│  │Arus │ │Suhu │ │Lemb │  │  3 card horizontal, scrollable
│  │Air  │ │     │ │apan │  │
│  └─────┘ └─────┘ └─────┘  │
└─────────────────────────────┘
```

Layout menggunakan `Column`:
1. `CameraView` widget (fixed 16:9 aspect ratio)
2. `SingleChildScrollView` horizontal berisi 3 `SensorCard`

---

## Color Palette — Ocean Aesthetic

| Peran | Warna | Hex |
|---|---|---|
| Background | Deep ocean navy | `#0A1628` |
| Card background | Dark navy | `#0D2137` |
| Card border | Ocean blue | `#1A4A6B` |
| Aksen 1 (cyan) | Bioluminescent cyan | `#00D4FF` |
| Aksen 2 (hijau) | Seafoam green | `#00FFB3` |
| Teks primer | Putih | `#FFFFFF` |
| Teks sekunder | Abu terang | `#8BAABE` |

---

## Komponen

### `HomePage` (StatelessWidget)
- Scaffold dengan background `#0A1628`
- AppBar transparan dengan judul "Coral Monitor" dan status dot hijau (indikator live)
- Body: Column → CameraView + Row card

### `CameraView` widget
- Container dengan aspect ratio 16:9
- Placeholder: background gelap + icon kamera + teks "Camera Feed"
- Border radius 12, border warna `#1A4A6B`
- Mudah diganti dengan widget kamera nyata nanti

### `SensorCard` widget
- Parameter: `icon`, `label`, `value`, `unit`, `accentColor`
- Tampilan: icon di atas, label, nilai besar, satuan kecil
- Background `#0D2137`, border `#1A4A6B`, border radius 16
- Lebar fixed ~140px, tinggi ~160px

### Data sensor (mock statis)

| Sensor | Nilai | Satuan | Icon | Warna aksen |
|---|---|---|---|---|
| Arus Air | 0.8 | m/s | `water` | `#00D4FF` |
| Suhu | 28.5 | °C | `thermostat` | `#FF6B6B` |
| Kelembapan | 85 | % | `water_drop` | `#00FFB3` |

---

## Struktur File

```
lib/
  main.dart              # Entry point, MaterialApp
  pages/
    home_page.dart       # HomePage widget
  widgets/
    camera_view.dart     # CameraView placeholder widget
    sensor_card.dart     # SensorCard reusable widget
```

---

## Out of Scope (untuk sekarang)

- Koneksi ke backend / API
- Real-time kamera feed
- Data dinamis / animasi nilai
- Navigasi ke halaman lain
