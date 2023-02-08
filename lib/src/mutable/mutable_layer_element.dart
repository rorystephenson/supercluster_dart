import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supercluster/src/cluster_data_base.dart';
import 'package:supercluster/src/util.dart' as util;

import '../layer_element.dart';
import 'rbush_point.dart';

part 'mutable_layer_element.freezed.dart';

@unfreezed
class MutableLayerElement<T> with _$MutableLayerElement<T>, LayerElement<T> {
  MutableLayerElement._();

  @With.fromString("LayerCluster<T>")
  factory MutableLayerElement.cluster({
    required String uuid,
    required double x,
    required double y,
    required double wX,
    required double wY,
    required int childPointCount,
    ClusterDataBase? clusterData,
    required int visitedAtZoom,
    required int lowestZoom,
    required int highestZoom,
    String? parentUuid,
  }) = MutableLayerCluster<T>;

  @With.fromString("LayerPoint<T>")
  factory MutableLayerElement.point({
    required String uuid,
    required final T originalPoint,
    required double x,
    required double y,
    required double wX,
    required double wY,
    ClusterDataBase? clusterData,
    required int visitedAtZoom,
    required int lowestZoom,
    required int highestZoom,
    String? parentUuid,
  }) = MutableLayerPoint<T>;

  static MutableLayerCluster<T> initializeCluster<T>({
    required String uuid,
    required double x,
    required double y,
    required int childPointCount,
    required int zoom,
    ClusterDataBase? clusterData,
  }) {
    return MutableLayerCluster<T>(
      uuid: uuid,
      x: x,
      y: y,
      wX: x,
      wY: y,
      visitedAtZoom: zoom,
      lowestZoom: zoom,
      highestZoom: zoom,
      childPointCount: childPointCount,
      clusterData: clusterData,
    );
  }

  static MutableLayerPoint<T> initializePoint<T>({
    required String uuid,
    required T point,
    required double lon,
    required double lat,
    required int zoom,
    ClusterDataBase? clusterData,
  }) {
    final x = util.lngX(lon);
    final y = util.latY(lat);

    return MutableLayerPoint(
      uuid: uuid,
      originalPoint: point,
      x: x,
      y: y,
      wX: x,
      wY: y,
      visitedAtZoom: zoom,
      lowestZoom: zoom,
      highestZoom: zoom,
      clusterData: clusterData,
    );
  }

  int get numPoints =>
      map(cluster: (cluster) => cluster.childPointCount, point: (point) => 1);

  static double getX(MutableLayerElement clusterOrMapPoint) =>
      clusterOrMapPoint.x;

  static double getY(MutableLayerElement clusterOrMapPoint) =>
      clusterOrMapPoint.y;

  RBushPoint<MutableLayerElement<T>> positionRBushPoint() {
    return RBushPoint(x: x, y: y, data: this);
  }

  RBushPoint<MutableLayerElement<T>> weightedPositionRBushPoint() {
    return RBushPoint(x: wX, y: wY, data: this);
  }

  @override
  TResult handle<TResult extends Object?>({
    required TResult Function(LayerCluster<T> cluster) cluster,
    required TResult Function(LayerPoint<T> point) point,
  }) =>
      map(cluster: cluster, point: point);

  String get summary =>
      '${map(cluster: (cluster) => 'cluster', point: (point) => 'point')} ($uuid - $parentUuid)';
}
