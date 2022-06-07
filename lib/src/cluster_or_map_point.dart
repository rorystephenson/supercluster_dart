import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supercluster/src/cluster_data_base.dart';
import 'package:supercluster/src/util.dart' as util;

part 'cluster_or_map_point.freezed.dart';

@unfreezed
class ClusterOrMapPoint<T> with _$ClusterOrMapPoint<T> {
  static const _maxInt = 9007199254740992; // 2^53

  ClusterOrMapPoint._();

  factory ClusterOrMapPoint.cluster({
    required final double x,
    required final double y,
    required final int numPoints,
    required final int id,
    ClusterDataBase? clusterData,
    @Default(ClusterOrMapPoint._maxInt) int zoom,
    @Default(-1) int parentId,
  }) = Cluster<T>;

  factory ClusterOrMapPoint.mapPoint({
    required final T originalPoint,
    required final double x,
    required final double y,
    required final int index,
    ClusterDataBase? clusterData,
    @Default(-1) int parentId,
    @Default(ClusterOrMapPoint._maxInt) int zoom,
  }) = MapPoint<T>;

  int get numPoints =>
      map(cluster: (cluster) => cluster.numPoints, mapPoint: (mapPoint) => 1);

  static double getX(ClusterOrMapPoint clusterOrMapPoint) =>
      clusterOrMapPoint.x;

  static double getY(ClusterOrMapPoint clusterOrMapPoint) =>
      clusterOrMapPoint.y;
}

extension ClusterLatLngExtension<T> on Cluster<T> {
  double get latitude => util.yLat(y);

  double get longitude => util.xLng(x);
}
