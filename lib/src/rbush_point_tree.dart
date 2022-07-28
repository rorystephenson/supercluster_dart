import 'package:rbush/rbush.dart';

import 'cluster_or_map_point.dart';
import 'point_tree.dart';

class RBushPointTree<T> extends PointTree<T> {
  final RBush<ClusterOrMapPoint<T>> _innerTree;

  final int maxEntries;

  RBushPointTree({
    required this.maxEntries,
  }) : _innerTree = RBush<ClusterOrMapPoint<T>>(maxEntries);

  @override
  void initialize(List<ClusterOrMapPoint<T>> clusters) {
    for (final cluster in clusters) {
      _innerTree.insert(
        RBushElement(
          minX: cluster.x,
          minY: cluster.y,
          maxX: cluster.x,
          maxY: cluster.y,
          data: cluster,
        ),
      );
    }
  }

  @override
  int get size => _innerTree.all().length;

  @override
  ClusterOrMapPoint<T> pointWithId(int id) => _innerTree.all()[id].data;

  @override
  ClusterOrMapPoint<T> firstPointWhere(
      bool Function(ClusterOrMapPoint<T>) test) {
    return _innerTree.all().firstWhere((e) => test(e.data)).data;
  }

  @override
  List<ClusterOrMapPoint<T>> withinBounds(
          double minX, double minY, double maxX, double maxY) =>
      _innerTree
          .search(RBushBox(minX: minX, minY: minY, maxX: maxX, maxY: maxY))
          .map((e) => e.data)
          .toList();

  @override
  List<ClusterOrMapPoint<T>> withinRadius(double x, double y, double radius) {
    throw 'not implemeneted';
    //return _innerTree.withinRadius(x, y, radius);
  }
}
