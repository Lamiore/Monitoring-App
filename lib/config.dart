/// Konfigurasi runtime aplikasi monitoring.
///
/// Ganti [cameraStreamUrl] dengan URL ngrok / Cloudflare Tunnel yang
/// meneruskan port 5001 dari laptop yang menjalankan `Proyek_Karang/app_web.py`.
/// Contoh: 'https://abcd-1234.ngrok-free.app/video_feed'
///
/// Untuk testing di emulator/HP yang satu jaringan WiFi, pakai IP LAN laptop:
/// 'http://192.168.1.10:5001/video_feed'
class AppConfig {
  static const String cameraStreamUrl =
      'https://7800-2001-448a-7062-2209-e4b7-5d5f-5d4c-4c2e.ngrok-free.app/video_feed';
}
