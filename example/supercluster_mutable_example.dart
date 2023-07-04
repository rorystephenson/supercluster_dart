import 'package:supercluster/supercluster.dart';

import 'cluster_name_data.dart';
import 'map_point.dart';

void main() {
  final points = [
    MapPoint(name: 'first', lat: 46, lon: 1.5),
    MapPoint(name: 'second', lat: 46.4, lon: 0.9),
    MapPoint(name: 'third', lat: 45, lon: 19),
  ];
  final supercluster = SuperclusterMutable<MapPoint>(
    getX: (p) => p.lon,
    getY: (p) => p.lat,
    extractClusterData: (customMapPoint) =>
        ClusterNameData([customMapPoint.name]),
  )..load(points);

  var clustersAndPoints = supercluster.search(0.0, 40, 20, 50, 5).map(
        (e) => e.map(
          cluster: (cluster) => 'cluster (${cluster.numPoints} points)',
          point: (point) => 'point ${point.originalPoint}',
        ),
      );

  print(clustersAndPoints.join(', '));
  // prints: cluster (2 points), point "third" (45.0, 19.0)

  supercluster.add(MapPoint(name: 'fourth', lat: 45.1, lon: 18));
  supercluster.remove(points[1]);

  clustersAndPoints = supercluster.search(0.0, 40, 20, 50, 5).map(
        (e) => e.map(
            cluster: (cluster) => 'cluster (${cluster.numPoints} points)',
            point: (point) => 'point ${point.originalPoint}'),
      );

  print(clustersAndPoints.join(', '));
  // prints: point "third" (45.0, 19.0), point "fourth" (45.1, 18.0), point "first" (46.0, 1.5)
}
