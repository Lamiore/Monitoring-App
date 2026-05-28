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
      'http://127.0.0.1:5001/video_feed';
}
