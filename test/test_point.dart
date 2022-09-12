class TestPoint {
  static int _sequence = 0;
  final int id;
  final double longitude;
  final double latitude;

  TestPoint._(
      {required this.id, required this.longitude, required this.latitude});

  factory TestPoint({required double longitude, required double latitude}) {
    final int id = _sequence;
    _sequence++;
    return TestPoint._(id: id, longitude: longitude, latitude: latitude);
  }

  static double getX(TestPoint p) => p.longitude;

  static double getY(TestPoint p) => p.latitude;
}
