import 'package:supercluster/supercluster.dart';

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

class TestClusterData extends ClusterDataBase {
  final int sum;

  TestClusterData(this.sum);

  @override
  ClusterDataBase combine(covariant TestClusterData data) =>
      TestClusterData(sum + data.sum);
}

class TestPoint2 {
  final int version;
  final String name;
  final double latitude;
  final double longitude;

  TestPoint2({
    this.version = 1,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  TestPoint2 copyWithVersion(int version) => TestPoint2(
        version: version,
        name: name,
        longitude: longitude,
        latitude: latitude,
      );

  factory TestPoint2.fromFeature(Map<String, dynamic> feature) {
    final coordinates = feature['geometry']?['coordinates'];
    final x = coordinates[0].toDouble();
    final y = coordinates[1].toDouble();
    final name = feature['properties']['name'];

    return TestPoint2(
      name: name,
      longitude: x,
      latitude: y,
    );
  }
}
