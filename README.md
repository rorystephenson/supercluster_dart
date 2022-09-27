# Supercluster

This package contains two very fast point clustering algorithms:

- `Supercluster`: A port
  of [MapBox's javascript supercluster library](https://github.com/mapbox/supercluster)
  for fast marker clustering which is blazingly fast but doesn't allow addition/removal of points.
- `SuperclusterMutable`: An adaptation of the same supercluster library but modified to use a
  mutable underlying index which means that points may be added/removed.

## Usage

Note: For the sake of these examples the following class is used to represent points on the map:

```dart
class MapPoint {
  String name;
  final double lat;
  final double lon;

  MapPoint({
    required this.name,
    required this.lat,
    required this.lon,
  });

  @override
  String toString() => '"$name" ($lat, $lon)';
}
```

### Supercluster example

```dart
void main() {
  final points = [
    MapPoint(name: 'first', lat: 46, lon: 1.5),
    MapPoint(name: 'second', lat: 46.4, lon: 0.9),
    MapPoint(name: 'third', lat: 45, lon: 19),
  ];
  final supercluster = SuperclusterImmutable<MapPoint>(
    getX: (p) => p.lon,
    getY: (p) => p.lat,
  )
    ..load(points);

  final clustersAndPoints = supercluster.search(0, 40, 20, 50, 5).map(
        (e) =>
        e.map(
          cluster: (cluster) => 'cluster (${cluster.numPoints} points)',
          point: (point) => 'point ${point.originalPoint}',
        ),
  );

  print(clustersAndPoints.join(', '));
  // prints: cluster (2 points), point "third" (45.0, 19.0)
}
```

### SuperclusterMutable example

```dart
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
  )
    ..load(points);

  var clustersAndPoints = supercluster.search(0.0, 40, 20, 50, 5).map(
        (e) =>
        e.map(
          cluster: (cluster) => 'cluster (${cluster.numPoints} points)',
          point: (point) => 'point ${point.originalPoint}',
        ),
  );

  print(clustersAndPoints.join(', '));
  // prints: cluster (2 points), point "third" (45.0, 19.0)

  supercluster.insert(MapPoint(name: 'fourth', lat: 45.1, lon: 18));
  supercluster.remove(points[1]);

  clustersAndPoints = supercluster.search(0.0, 40, 20, 50, 5).map(
        (e) =>
        e.map(
            cluster: (cluster) => 'cluster (${cluster.numPoints} points)',
            point: (point) => 'point ${point.originalPoint}'),
  );

  print(clustersAndPoints.join(', '));
  // prints: point "third" (45.0, 19.0), point "fourth" (45.1, 18.0), point "first" (46.0, 1.5)
}
```
