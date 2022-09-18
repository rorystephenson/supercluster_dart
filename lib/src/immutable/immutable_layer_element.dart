import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supercluster/src/cluster_data_base.dart';
import 'package:supercluster/src/util.dart' as util;

import '../layer_element.dart';

part 'immutable_layer_element.freezed.dart';

@unfreezed
class ImmutableLayerElement<T>
    with _$ImmutableLayerElement<T>, LayerElement<T> {
  ImmutableLayerElement._();

  // Should be uncommented only when running build_runner until this issue
  // is resolved: https://github.com/rrousselGit/freezed/issues/757
  //@With<LayerCluster<T>>()
  factory ImmutableLayerElement.cluster({
    required final double x,
    required final double y,
    required final int childPointCount,
    required final int id,
    ClusterDataBase? clusterData,
    required int visitedAtZoom,
    required int lowestZoom,
    required int highestZoom,
    @Default(-1) int parentId,
  }) = ImmutableLayerCluster<T>;

  // Should be uncommented only when running build_runner until this issue
  // is resolved: https://github.com/rrousselGit/freezed/issues/757
  //@With<LayerPoint<T>>()
  factory ImmutableLayerElement.point({
    required final T originalPoint,
    required final double x,
    required final double y,
    required final int index,
    ClusterDataBase? clusterData,
    @Default(-1) int parentId,
    required int visitedAtZoom,
    required int lowestZoom,
    required int highestZoom,
  }) = ImmutableLayerPoint<T>;

  static ImmutableLayerCluster<T> initializeCluster<T>({
    required double x,
    required double y,
    required int childPointCount,
    required int id,
    required int zoom,
    ClusterDataBase? clusterData,
  }) =>
      ImmutableLayerCluster<T>(
        x: x,
        y: y,
        childPointCount: childPointCount,
        id: id,
        visitedAtZoom: zoom,
        lowestZoom: zoom,
        highestZoom: zoom,
        clusterData: clusterData,
      );

  static ImmutableLayerPoint<T> initializePoint<T>({
    required final T originalPoint,
    required final double x,
    required final double y,
    required final int index,
    required int zoom,
    ClusterDataBase? clusterData,
  }) =>
      ImmutableLayerPoint<T>(
        originalPoint: originalPoint,
        x: x,
        y: y,
        index: index,
        clusterData: clusterData,
        visitedAtZoom: zoom,
        lowestZoom: zoom,
        highestZoom: zoom,
      );

  int get numPoints => map(
      cluster: (cluster) => cluster.childPointCount, point: (mapPoint) => 1);

  static double getX(ImmutableLayerElement clusterOrMapPoint) =>
      clusterOrMapPoint.x;

  static double getY(ImmutableLayerElement clusterOrMapPoint) =>
      clusterOrMapPoint.y;

  @override
  String get uuid => map(
      cluster: (cluster) => cluster.id.toString(),
      point: (point) => "${point.highestZoom}-${point.index}");

  @override
  TResult handle<TResult extends Object?>({
    required TResult Function(LayerCluster<T> cluster) cluster,
    required TResult Function(LayerPoint<T> point) point,
  }) =>
      map(cluster: cluster, point: point);
}

extension ClusterLatLngExtension<T> on ImmutableLayerCluster<T> {
  double get latitude => util.yLat(y);

  double get longitude => util.xLng(x);
}
