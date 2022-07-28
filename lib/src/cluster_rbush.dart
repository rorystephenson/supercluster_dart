import 'package:rbush/rbush.dart';
import 'package:supercluster/src/mutable_cluster_or_point.dart';

class ClusterRBush<T> {
  final int maxPoints;
  final double Function(T) getX;
  final double Function(T) getY;
  final RBush<MutableClusterOrPoint<T>> _innerTree;

  final Map<T, RBushElement<MutableClusterOrPoint<T>>>
      _pointToIndexElementMapping = {};

  ClusterRBush({
    required this.maxPoints,
    required this.getX,
    required this.getY,
  }) : _innerTree = RBush(maxPoints);

  void load(List<RBushElement<MutableClusterOrPoint<T>>> elements) {
    for (final element in elements) {
      for (final point in element.data.points) {
        _pointToIndexElementMapping[point] = element;
      }
    }
    _innerTree.load(elements);
  }

  List<RBushElement<MutableClusterOrPoint<T>>> search(RBushBox rBushBox) {
    return _innerTree.search(rBushBox);
  }

  int get size => _innerTree.all().length;

  void remove(T point) {
    final element = _pointToIndexElementMapping.remove(point);
    if (element == null) return;

    element.data.map(
      point: (point) {
        _innerTree.remove(element);
      },
      cluster: (cluster) {
        cluster.originalPoints.remove(point);

        if (cluster.numPoints > 1) {
          // TODO: recalculate x/y/wx/wy/clusterData
        } else {
          final remainingPoint = cluster.originalPoints.single;
          final x = getX(remainingPoint);
          final y = getY(remainingPoint);

          _innerTree.remove(element);
          _innerTree.insert(
            RBushElement(
              minX: x,
              minY: y,
              maxX: x,
              maxY: y,
              data: MutablePoint(
                  originalPoint: remainingPoint, x: x, y: y, wX: x, wY: y),
            ),
          );
        }
      },
    );
  }
}
