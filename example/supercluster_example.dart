import 'package:supercluster/supercluster.dart';

void main() {
  final points = [
    CustomMapPoint(name: 'first', lat: 46, lon: 1.5),
    CustomMapPoint(name: 'second', lat: 46.4, lon: 0.9),
    CustomMapPoint(name: 'third', lat: 45, lon: 19),
  ];
  final supercluster = Supercluster<CustomMapPoint>(
    points: points,
    getX: (p) => p.lon,
    getY: (p) => p.lat,
    extractClusterData: (customMapPoint) =>
        ClusterNameData([customMapPoint.name]),
  );

  final clustersAndPoints =
      supercluster.getClustersAndPoints(0.0, 43, 8, 47, 10).map(
            (e) => e.map(
              cluster: (cluster) =>
                  'A cluster of: ${(cluster.clusterData as ClusterNameData).pointNames.join(', ')}',
              mapPoint: (mapPoint) => mapPoint.originalPoint.toString(),
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

class ClusterNameData extends ClusterDataBase {
  final List<String> pointNames;

  ClusterNameData(this.pointNames);

  @override
  ClusterNameData combine(ClusterNameData other) {
    return ClusterNameData(
      List.from(pointNames)..addAll(other.pointNames),
    );
  }
}
