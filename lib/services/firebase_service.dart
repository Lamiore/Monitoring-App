import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/sensor_data.dart';

class FirebaseService {
  static const String deviceId = 'station01';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  Future<void> signIn() async {
    if (_auth.currentUser != null) return;
    await _auth.signInAnonymously();
  }

  Stream<SensorData> latestStream() {
    final ref = _db.ref('devices/$deviceId/latest');
    return ref.onValue.map((event) {
      final value = event.snapshot.value;
      if (value is Map) {
        return SensorData.fromMap(value);
      }
      return SensorData.empty;
    });
  }
}
