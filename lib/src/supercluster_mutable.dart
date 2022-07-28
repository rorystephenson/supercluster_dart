import 'dart:math';

import 'package:rbush/rbush.dart';

import '../supercluster.dart';
import 'cluster_data_base.dart';
import 'rbush_point_index.dart';

class SuperclusterMutable<T> extends Supercluster<RBushElement<T>> {
  static const _defaultMinZoom = 0;
  static const _defaultMaxZoom = 16;
  static const _defaultMinPoints = 2;
  static const _defaultRadius = 40;
  static const _defaultExtent = 512;
  static const _defaultNodeSize = 64;

  @override
  final List<RBushPointIndex<T>> trees;

  SuperclusterMutable({
    required List<T> points,
    required double? Function(T) getX,
    required double? Function(T) getY,
    required int maxPoints,
    int? minZoom,
    int? maxZoom,
    int? minPoints,
    int? radius,
    int? extent,
    int? nodeSize,
    ClusterDataBase Function(T point)? extractClusterData,
  })  : trees = List.generate(
          (maxZoom ?? _defaultMaxZoom) + 2,
          (_) => RBushPointIndex<T>(maxPoints: maxPoints),
        ),
        super.init(
          points: points,
          getX: getX,
          getY: getY,
          minZoom: minZoom ?? _defaultMinZoom,
          maxZoom: maxZoom ?? _defaultMaxZoom,
          minPoints: minPoints ?? _defaultMinPoints,
          radius: radius ?? _defaultRadius,
          extent: extent ?? _defaultExtent,
          nodeSize: nodeSize ?? _defaultNodeSize,
          extractClusterData: extractClusterData,
        );

  @override
  Cluster<T>? parentOf(ClusterOrMapPoint<T> clusterOrMapPoint) {
    if (clusterOrMapPoint.parentId == -1) return null;

    final parentZoom = getOriginZoom(clusterOrMapPoint.parentId) - 1;

    return trees[_limitZoom(parentZoom)].pointWithId(clusterOrMapPoint.parentId)
        as Cluster<T>?;
  }

  @override
  List<ClusterOrMapPoint<T>> getChildren(int clusterId) {
    final originId = _getOriginId(clusterId);
    final originZoom = getOriginZoom(clusterId);
    final errorMsg = 'No cluster with the specified id.';

    final index = trees[originZoom];

    if (originId >= index.size) throw errorMsg;
    final origin = index.pointWithId(originId)!;

    final r = radius / (extent * pow(2, originZoom - 1));
    final points = index.withinRadius(origin.x, origin.y, r);
    final children = <ClusterOrMapPoint<T>>[];
    for (final point in points) {
      if (point.parentId == clusterId) {
        children.add(point);
      }
    }

    if (children.isEmpty) throw errorMsg;

    return children;
  }

  // get index of the point from which the cluster originated
  int _getOriginId(int clusterId) {
    return (clusterId - points!.length) >> 5;
  }

  int _limitZoom(num z) {
    return max(minZoom, min(z.floor(), maxZoom + 1));
  }
}
