class SensorData {
  final double tempDHT;
  final double humidity;
  final double tempDS18;
  final int rainValue;
  final String rainStatus;
  final double windSpeed;
  final double flowRate;
  final double totalWater;
  final double ecValue;
  final bool gpsValid;
  final double latitude;
  final double longitude;
  final int timestamp;

  const SensorData({
    required this.tempDHT,
    required this.humidity,
    required this.tempDS18,
    required this.rainValue,
    required this.rainStatus,
    required this.windSpeed,
    required this.flowRate,
    required this.totalWater,
    required this.ecValue,
    required this.gpsValid,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  factory SensorData.fromMap(Map<dynamic, dynamic> m) {
    double _d(dynamic v) => (v is num) ? v.toDouble() : 0.0;
    int _i(dynamic v) => (v is num) ? v.toInt() : 0;
    return SensorData(
      tempDHT: _d(m['tempDHT']),
      humidity: _d(m['humidity']),
      tempDS18: _d(m['tempDS18']),
      rainValue: _i(m['rainValue']),
      rainStatus: (m['rainStatus'] ?? '--').toString(),
      windSpeed: _d(m['windSpeed']),
      flowRate: _d(m['flowRate']),
      totalWater: _d(m['totalWater']),
      ecValue: _d(m['ecValue']),
      gpsValid: m['gpsValid'] == true,
      latitude: _d(m['latitude']),
      longitude: _d(m['longitude']),
      timestamp: _i(m['timestamp']),
    );
  }

  static const empty = SensorData(
    tempDHT: 0,
    humidity: 0,
    tempDS18: 0,
    rainValue: 0,
    rainStatus: '--',
    windSpeed: 0,
    flowRate: 0,
    totalWater: 0,
    ecValue: 0,
    gpsValid: false,
    latitude: 0,
    longitude: 0,
    timestamp: 0,
  );
}
