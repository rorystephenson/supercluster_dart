import 'package:supercluster/supercluster.dart';

void main() {
  final supercluster =
      Supercluster<CustomMapPoint>(getX: (p) => p.lon, getY: (p) => p.lat);
  supercluster.load([
    CustomMapPoint(name: 'first', lat: 46, lon: 1.5),
    CustomMapPoint(name: 'second', lat: 46.4, lon: 0.9),
    CustomMapPoint(name: 'third', lat: 45, lon: 19),
  ]);

  final clustersAndPoints =
      supercluster.getClustersAndPoints(0.0, 43, 8, 47, 10).map(
            (e) => e.map(
              cluster: (cluster) => 'A cluster',
              mapPoint: (mapPoint) => mapPoint.data.toString(),
            ),
          );

  print(clustersAndPoints.join(', '));
  // Output: result: first (46.0, 1.5), second (46.4, 0.9)
}

class CustomMapPoint {
  String name;
  final double lat;
  final double lon;

  CustomMapPoint({
    required this.name,
    required this.lat,
    required this.lon,
  });

  @override
  String toString() => '$name ($lat, $lon)';
}
