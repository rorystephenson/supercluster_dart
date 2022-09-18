import 'package:supercluster/supercluster.dart';

import 'map_point.dart';

void main() {
  final points = [
    MapPoint(name: 'first', lat: 46, lon: 1.5),
    MapPoint(name: 'second', lat: 46.4, lon: 0.9),
    MapPoint(name: 'third', lat: 45, lon: 19),
  ];
  final supercluster = Supercluster<MapPoint>(
    points: points,
    getX: (p) => p.lon,
    getY: (p) => p.lat,
  );

  final clustersAndPoints = supercluster.search(0, 40, 20, 50, 5).map(
        (e) => e.map(
            cluster: (cluster) => 'cluster (${cluster.numPoints} points)',
            point: (point) => 'point ${point.originalPoint}'),
      );

  print(clustersAndPoints.join(', '));
  // prints: cluster (2 points), point "third" (45.0, 19.0)
}
