import 'package:kdbush/kdbush.dart';

import 'cluster_or_map_point.dart';
import 'point_index.dart';

class KDBushPointIndex<T> extends PointIndex<ClusterOrMapPoint<T>> {
  late final KDBush<ClusterOrMapPoint<T>, double> _innerIndex;

  final double? Function(T point) getX;
  final double? Function(T point) getY;
  final int nodeSize;

  KDBushPointIndex({
    required this.getX,
    required this.getY,
    required this.nodeSize,
  });

  @override
  void load(List<ClusterOrMapPoint<T>> clusterOrMapPoints) {
    _innerIndex = KDBush<ClusterOrMapPoint<T>, double>(
      points: clusterOrMapPoints,
      getX: ClusterOrMapPoint.getX,
      getY: ClusterOrMapPoint.getY,
      nodeSize: nodeSize,
    );
  }

  @override
  int get size => _innerIndex.points.length;

  ClusterOrMapPoint<T>? pointWithId(int id) {
    if (id < 0 || id >= _innerIndex.points.length) return null;

    return _innerIndex.points[id];
  }

  @override
  List<ClusterOrMapPoint<T>> withinRadius(double x, double y, double radius) {
    // TODO Optional haversine (or custom) distance
    return _innerIndex
        .withinRadius(x, y, radius)
        .map((index) => _innerIndex.points[index])
        .toList();
  }

  @override
  List<ClusterOrMapPoint<T>> withinBounds(
    double minX,
    double minY,
    double maxX,
    double maxY,
  ) {
    // TODO Optional haversine (or custom) distance
    return _innerIndex
        .withinBounds(minX, minY, maxX, maxY)
        .map((index) => _innerIndex.points[index])
        .toList();
  }
}
