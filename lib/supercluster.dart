/// Support for doing something awesome.
///
/// More dartdocs go here.
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
  })  : assert(minPoints == null || minPoints > 1),
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

  Iterable<T> getLeaves();

  ClusterDataBase? aggregatedClusterData();
}
