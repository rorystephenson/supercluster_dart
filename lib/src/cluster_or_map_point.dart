import 'package:freezed_annotation/freezed_annotation.dart';

part 'cluster_or_map_point.freezed.dart';

@unfreezed
class ClusterOrMapPoint<T> with _$ClusterOrMapPoint<T> {
  static const _maxInt = 9007199254740992; // 2^53

  ClusterOrMapPoint._();

  factory ClusterOrMapPoint.cluster({
    required final double x,
    required final double y,
    @Default(ClusterOrMapPoint._maxInt) int zoom,
    required int id,
    @Default(-1) int parentId,
    required int numPoints,
  }) = Cluster;

  factory ClusterOrMapPoint.mapPoint({
    required final T data,
    required final double x,
    required final double y,
    required final int index,
    @Default(-1) int parentId,
    @Default(ClusterOrMapPoint._maxInt) int zoom,
  }) = MapPoint;

  int get numPoints =>
      map(cluster: (cluster) => cluster.numPoints, mapPoint: (mapPoint) => 1);

  static double getX(ClusterOrMapPoint clusterOrMapPoint) =>
      clusterOrMapPoint.x;

  static double getY(ClusterOrMapPoint clusterOrMapPoint) =>
      clusterOrMapPoint.y;
}
