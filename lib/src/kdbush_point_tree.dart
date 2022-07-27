import 'package:kdbush/kdbush.dart';

import 'cluster_or_map_point.dart';
import 'point_tree.dart';

class KDBushPointTree<T> extends PointTree<T> {
  final double? Function(T) getX;
  final double? Function(T) getY;
  final int nodeSize;

  KDBushPointTree({
    required this.getX,
    required this.getY,
    required this.nodeSize,
  });

  late KDBush<ClusterOrMapPoint<T>, double> _innerTree;

  @override
  void initialize(List<ClusterOrMapPoint<T>> clusters) {
    _innerTree = KDBush<ClusterOrMapPoint<T>, double>(
      points: clusters,
      getX: ClusterOrMapPoint.getX,
      getY: ClusterOrMapPoint.getY,
      nodeSize: nodeSize,
    );
  }

  @override
  int get size => _innerTree.points.length;

  @override
  ClusterOrMapPoint<T> point(int id) => _innerTree.points[id];

  @override
  ClusterOrMapPoint<T> firstPointWhere(
      bool Function(ClusterOrMapPoint<T>) test) {
    return _innerTree.points.firstWhere(test);
  }

  @override
  List<int> withinBounds(double minX, double minY, double maxX, double maxY) =>
      _innerTree.withinBounds(minX, minY, maxX, maxY);

  @override
  List<int> idsWithinRadius(double x, double y, double radius) {
    return _innerTree.withinRadius(x, y, radius);
  }
}
