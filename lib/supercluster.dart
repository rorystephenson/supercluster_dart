library supercluster;

import 'supercluster.dart';

export 'src/cluster_data_base.dart';
export 'src/immutable/immutable_layer_element.dart';
export 'src/immutable/supercluster_immutable.dart';
export 'src/layer_element.dart';
export 'src/mutable/layer_modification.dart';
export 'src/mutable/mutable_layer_element.dart';
export 'src/mutable/supercluster_mutable.dart';

abstract class Supercluster<T> {
  final double Function(T) getX;
  final double Function(T) getY;

  final int minZoom;
  final int maxZoom;
  final int minPoints;
  final int radius;
  final int extent;
  final int nodeSize;

  final ClusterDataBase Function(T point)? extractClusterData;

  Supercluster({
    required this.getX,
    required this.getY,
    required this.nodeSize,
    int? minZoom,
    int? maxZoom,
    int? minPoints,
    int? radius,
    int? extent,
    this.extractClusterData,
  }) : assert(minPoints == null || minPoints > 1),
       minZoom = minZoom ?? 0,
       maxZoom = maxZoom ?? 16,
       minPoints = minPoints ?? 2,
       radius = radius ?? 40,
       extent = extent ?? 512;

  /// Remove any existing points and replace them with [points]. This will
  /// recreate the index completely and may take some time. If you want to
  /// add/remove points in an efficient manner you should use
  /// [SuperclusterImmutable] and call add/remove/modifyPointData.
  void load(List<T> points);

  List<LayerElement<T>> search(
    double westLng,
    double southLat,
    double eastLng,
    double northLat,
    int zoom,
  );

  /// Returns the parent cluster if [element] has one.
  LayerCluster<T>? parentOf(LayerElement<T> element);

  /// Returns the children of the given [LayerCluster]
  List<LayerElement<T>> childrenOf(LayerCluster<T> cluster);

  Iterable<T> getLeaves();

  ClusterDataBase? aggregatedClusterData();

  /// Returns whether the specified point is in the supercluster's index.
  bool containsPoint(T point);

  /// Returns the LayerPoint, if any, which contains the given [point].
  LayerPoint<T>? layerPointOf(T point);

  /// This method exists for a very specific purpose. If you create a
  /// Supercluster index in a separate isolate and your points are Objects dart
  /// will create copies of the points rather than sharing them across
  /// isolates. This means that when the created index is returned to the root
  /// isolate the points are not the same instances as the original ones and
  /// will not have the same hashCodes or be equal to their original
  /// counterparts unless you have overriden hashCode/==.
  ///
  /// If you don't wish to override hashCode/== on your points you can use this
  /// method to replace the copied points with the original ones. This method
  /// should be called from the root isolate with the same [points] that were
  /// passed to [load], in the same order, before adding/removing any of the
  /// index's points.
  void replacePoints(List<T> newPoints);
}
