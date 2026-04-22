// Manual Firebase config for project otaapp-8f7d0.
//
// Dihasilkan tanpa `flutterfire configure` — pakai satu set config (web) untuk
// semua platform. Cukup buat development dan Firebase Auth + RTDB.
//
// Untuk build release Android/iOS proper, jalankan:
//   dart pub global activate flutterfire_cli
//   flutterfire configure --project=otaapp-8f7d0
// yang akan overwrite file ini + generate google-services.json.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return ios;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAKgYsz2pV7o_Cz8KPK6If18CdPftHHMQw',
    authDomain: 'otaapp-8f7d0.firebaseapp.com',
    databaseURL: 'https://otaapp-8f7d0-default-rtdb.firebaseio.com',
    projectId: 'otaapp-8f7d0',
    storageBucket: 'otaapp-8f7d0.firebasestorage.app',
    messagingSenderId: '315158680682',
    appId: '1:315158680682:web:4d71d03d0d97fea7abe613',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAKgYsz2pV7o_Cz8KPK6If18CdPftHHMQw',
    databaseURL: 'https://otaapp-8f7d0-default-rtdb.firebaseio.com',
    projectId: 'otaapp-8f7d0',
    storageBucket: 'otaapp-8f7d0.firebasestorage.app',
    messagingSenderId: '315158680682',
    appId: '1:315158680682:web:4d71d03d0d97fea7abe613',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAKgYsz2pV7o_Cz8KPK6If18CdPftHHMQw',
    databaseURL: 'https://otaapp-8f7d0-default-rtdb.firebaseio.com',
    projectId: 'otaapp-8f7d0',
    storageBucket: 'otaapp-8f7d0.firebasestorage.app',
    messagingSenderId: '315158680682',
    appId: '1:315158680682:web:4d71d03d0d97fea7abe613',
    iosBundleId: 'com.example.monitoringapp',
  );
}
