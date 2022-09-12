import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supercluster/src/cluster_data_base.dart';
import 'package:supercluster/src/util.dart' as util;
import 'package:supercluster/src/uuid_stub.dart';

import 'rbush_point.dart';

part 'layer_element.freezed.dart';

@unfreezed
class LayerElement<T> with _$LayerElement<T> {
  LayerElement._();

  factory LayerElement.cluster({
    required String uuid,
    required double x,
    required double y,
    required double wX,
    required double wY,
    required List<T> originalPoints,
    ClusterDataBase? clusterData,
    @Default(util.maxInt) int zoom,
    @Default(util.maxInt) int lowestZoom,
    String? parentUuid,
  }) = LayerCluster<T>;

  factory LayerElement.point({
    required String uuid,
    required final T originalPoint,
    required double x,
    required double y,
    required double wX,
    required double wY,
    ClusterDataBase? clusterData,
    @Default(util.maxInt) int zoom,
    @Default(util.maxInt) int lowestZoom,
    String? parentUuid,
  }) = LayerPoint<T>;

  static LayerCluster<T> initializeCluster<T>({
    required String uuid,
    required double x,
    required double y,
    required List<T> points,
    required int zoom,
    ClusterDataBase? clusterData,
  }) {
    return LayerCluster<T>(
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

  static LayerPoint<T> initializePoint<T>({
    required T point,
    required double lon,
    required double lat,
    required int zoom,
    ClusterDataBase? clusterData,
  }) {
    final x = util.lngX(lon);
    final y = util.latY(lat);

    return LayerPoint(
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

  static double getX(LayerElement clusterOrMapPoint) => clusterOrMapPoint.x;

  static double getY(LayerElement clusterOrMapPoint) => clusterOrMapPoint.y;

  RBushPoint<LayerElement<T>> positionRBushPoint() {
    return RBushPoint(x: x, y: y, data: this);
  }

  RBushPoint<LayerElement<T>> weightedPositionRBushPoint() {
    return RBushPoint(x: wX, y: wY, data: this);
  }

  String get summary =>
      '${map(cluster: (cluster) => 'cluster', point: (point) => 'point')} ($uuid - $parentUuid)';
}

extension LayerClusterLatLngExtension<T> on LayerCluster<T> {
  double get latitude => util.yLat(y);

  double get longitude => util.xLng(x);
}
