import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supercluster/src/cluster_data_base.dart';
import 'package:supercluster/src/util.dart' as util;
import 'package:supercluster/src/uuid_stub.dart';

import 'rbush_point.dart';

part 'mutable_cluster_or_point.freezed.dart';

@unfreezed
class MutableClusterOrPoint<T> with _$MutableClusterOrPoint<T> {
  MutableClusterOrPoint._();

  factory MutableClusterOrPoint.cluster({
    required String uuid,
    required double x,
    required double y,
    required double wX,
    required double wY,
    required List<T> originalPoints,
    MutableClusterDataBase? clusterData,
    @Default(util.maxInt) int zoom,
    @Default(util.maxInt) int lowestZoom,
    String? parentUuid,
  }) = MutableCluster<T>;

  factory MutableClusterOrPoint.point({
    required String uuid,
    required final T originalPoint,
    required double x,
    required double y,
    required double wX,
    required double wY,
    MutableClusterDataBase? clusterData,
    @Default(util.maxInt) int zoom,
    @Default(util.maxInt) int lowestZoom,
    String? parentUuid,
  }) = MutablePoint<T>;

  static MutableCluster<T> initializeCluster<T>({
    required String uuid,
    required double x,
    required double y,
    required List<T> points,
    required int zoom,
    MutableClusterDataBase? clusterData,
  }) {
    return MutableCluster<T>(
      uuid: uuid,
      x: x,
      y: y,
      wX: x,
      wY: y,
      zoom: zoom,
      lowestZoom: zoom,
      originalPoints: points,
      clusterData: clusterData,
    );
  }

  static MutablePoint<T> initializePoint<T>({
    required T point,
    required double lon,
    required double lat,
    required int zoom,
    MutableClusterDataBase? clusterData,
  }) {
    final x = util.lngX(lon);
    final y = util.latY(lat);

    return MutablePoint(
      uuid: UuidStub.v4(),
      originalPoint: point,
      x: x,
      y: y,
      wX: x,
      wY: y,
      zoom: zoom,
      lowestZoom: zoom,
      clusterData: clusterData,
    );
  }

  int get numPoints => map(
      cluster: (cluster) => cluster.originalPoints.length, point: (point) => 1);

  List<T> get points => map(
      cluster: (cluster) => cluster.originalPoints,
      point: (point) => [point.originalPoint]);

  static double getX(MutableClusterOrPoint clusterOrMapPoint) =>
      clusterOrMapPoint.x;

  static double getY(MutableClusterOrPoint clusterOrMapPoint) =>
      clusterOrMapPoint.y;

  RBushPoint<MutableClusterOrPoint<T>> toRBushPoint() {
    return map(
      cluster: (cluster) => RBushPoint(
        x: cluster.x,
        y: cluster.y,
        data: cluster,
      ),
      point: (point) => RBushPoint(
        x: point.x,
        y: point.y,
        data: point,
      ),
    );
  }
}

extension ClusterLatLngExtension<T> on MutableCluster<T> {
  double get latitude => util.yLat(y);

  double get longitude => util.xLng(x);
}
