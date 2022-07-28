import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supercluster/src/cluster_data_base.dart';
import 'package:supercluster/src/util.dart' as util;

part 'mutable_cluster_or_point.freezed.dart';

@unfreezed
class MutableClusterOrPoint<T> with _$MutableClusterOrPoint<T> {
  static const _maxInt = 9007199254740992; // 2^53

  MutableClusterOrPoint._();

  factory MutableClusterOrPoint.cluster({
    required double x,
    required double y,
    required double wX,
    required double wY,
    required List<T> originalPoints,
    ClusterDataBase? clusterData,
    @Default(MutableClusterOrPoint._maxInt) int zoom,
  }) = MutableCluster<T>;

  factory MutableClusterOrPoint.point({
    required final T originalPoint,
    required double x,
    required double y,
    required double wX,
    required double wY,
    ClusterDataBase? clusterData,
    @Default(MutableClusterOrPoint._maxInt) int zoom,
  }) = MutablePoint<T>;

  int get numPoints => map(
      cluster: (cluster) => cluster.originalPoints.length, point: (point) => 1);

  List<T> get points => map(
      cluster: (cluster) => cluster.originalPoints,
      point: (point) => [point.originalPoint]);

  static double getX(MutableClusterOrPoint clusterOrMapPoint) =>
      clusterOrMapPoint.x;

  static double getY(MutableClusterOrPoint clusterOrMapPoint) =>
      clusterOrMapPoint.y;
}

extension ClusterLatLngExtension<T> on MutableCluster<T> {
  double get latitude => util.yLat(y);

  double get longitude => util.xLng(x);
}
