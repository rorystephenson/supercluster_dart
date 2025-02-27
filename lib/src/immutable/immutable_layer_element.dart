import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supercluster/src/cluster_data_base.dart';
import 'package:supercluster/src/util.dart' as util;

import '../layer_element.dart';

part 'immutable_layer_element.freezed.dart';

@unfreezed
abstract class ImmutableLayerElement<T>
    with _$ImmutableLayerElement<T>, LayerElement<T> {
  ImmutableLayerElement._();

  @With.fromString("LayerCluster<T>")
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

  @With.fromString("LayerPoint<T>")
  factory ImmutableLayerElement.point({
    required T originalPoint,
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

  int get numPoints => switch (this) {
        ImmutableLayerCluster(childPointCount: var count) => count,
        ImmutableLayerPoint() => 1,
        ImmutableLayerElement<T>() => throw UnimplementedError(),
      };

  static double getX(ImmutableLayerElement clusterOrMapPoint) =>
      clusterOrMapPoint.x;

  static double getY(ImmutableLayerElement clusterOrMapPoint) =>
      clusterOrMapPoint.y;

  @override
  String get uuid => switch (this) {
        ImmutableLayerCluster(:var id) => id.toString(),
        ImmutableLayerPoint(:var highestZoom, index: var index) =>
          "$highestZoom-$index",
        ImmutableLayerElement<T>() => throw UnimplementedError(),
      };

  @override
  TResult handle<TResult extends Object?>({
    required TResult Function(LayerCluster<T> cluster) cluster,
    required TResult Function(LayerPoint<T> point) point,
  }) =>
      switch (this) {
        ImmutableLayerCluster<T> clusterInstance => cluster(clusterInstance),
        ImmutableLayerPoint<T> pointInstance => point(pointInstance),
        _ => throw UnimplementedError(),
      };
}

extension ClusterLatLngExtension<T> on ImmutableLayerCluster<T> {
  double get latitude => util.yLat(y);

  double get longitude => util.xLng(x);
}
