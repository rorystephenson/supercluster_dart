A port of [MapBox's javascript supercluster library](https://github.com/mapbox/supercluster) for fast marker clustering.

## Usage

```dart
final supercluster = Supercluster<CustomMapPoint>(
  getX: (p) => p.x,
  getY: (p) => p.y,
);
supercluster.load([
  Point(1.5, 46),
  Point(0.9, 46.4),
  Point(19, 45),
]);

// Returns the first two points.
supercluster.getClustersAndPoints(0.0, 43, 8, 47, 10);

// Returns a cluster.
supercluster.getClustersAndPoints(0.0, 43, 8, 47, 5);

```
