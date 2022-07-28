import 'package:rbush/rbush.dart';

import 'cluster_or_map_point.dart';
import 'point_index.dart';

class RBushPointIndex<T> extends PointIndex<RBushElement<T>> {
  final RBush<ClusterOrMapPoint<T>> _innerIndex;

  final int nodeSize;
  final int maxPoints;

  RBushPointIndex({
    required this.nodeSize,
    required this.maxPoints,
  }) : _innerIndex = RBush<ClusterOrMapPoint<T>>(maxPoints);

  @override
  void load(List<ClusterOrMapPoint<T>> clusterOrMapPoints) {
    _innerIndex.load(
      clusterOrMapPoints.map(
            (clusterOrMapPoint) =>
            RBushElement(
              minX: clusterOrMapPoint.x,
              minY: clusterOrMapPoint.y,
              maxX: clusterOrMapPoint.x,
              maxY: clusterOrMapPoint.y,
              data: clusterOrMapPoint,
            ),
      ),
    );
  }

  @override
  int get size =>
      _innerIndex
          .all()
          .length;

  ClusterOrMapPoint<T>? pointWithId(int id) {
    _innerIndex.data
    .
    if (id < 0 || id >= _innerIndex.points.length) return null;

    return _innerIndex.points
    [
    id
    ];
  }

  @override
  List<ClusterOrMapPoint<T>> withinRadius(double x, double y, double radius) {
    // TODO Optional haversine (or custom) distance
    return _innerIndex
        .knn(x, y, maxPoints, maxDistance: radius)
        .map((element) => element.data)
        .toList();
  }

  @override
  List<ClusterOrMapPoint<T>> withinBounds(double minX,
      double minY,
      double maxX,
      double maxY,) {
    // TODO Optional haversine (or custom) distance
    return _innerIndex
        .search(RBushBox(minX: minX, minY: minY, maxX: maxX, maxY: maxY))
        .map((element) => element.data)
        .toList();
  }
}
