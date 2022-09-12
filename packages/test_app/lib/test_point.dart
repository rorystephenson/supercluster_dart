class TestPoint {
  static int _sequence = 0;
  final int id;
  final double longitude;
  final double latitude;

  static double getX(TestPoint p) => p.longitude;

  static double getY(TestPoint p) => p.latitude;

  TestPoint._({
    required this.id,
    required this.longitude,
    required this.latitude,
  });

  factory TestPoint({required double longitude, required double latitude}) {
    final int id = _sequence;
    _sequence++;
    return TestPoint._(id: id, longitude: longitude, latitude: latitude);
  }

  @override
  int get hashCode => id.hashCode + latitude.hashCode + longitude.hashCode;

  @override
  bool operator ==(Object other) {
    return other is TestPoint &&
        other.longitude == longitude &&
        other.latitude == latitude;
  }
}
