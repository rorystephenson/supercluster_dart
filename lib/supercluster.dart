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

  /// An optional function which will be called whenever the aggregated cluster
  /// data of all points changes. Note that this will only be calculated if the
  /// callback is set.
  Function(ClusterDataBase? aggregatedClusterData)? onClusterDataChange;

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
    this.onClusterDataChange,
  })  : assert(minPoints == null || minPoints > 1),
        minZoom = minZoom ?? 0,
        maxZoom = maxZoom ?? 16,
        minPoints = minPoints ?? 2,
        radius = radius ?? 40,
        extent = extent ?? 512;

  List<LayerElement<T>> search(
    double westLng,
    double southLat,
    double eastLng,
    double northLat,
    int zoom,
  );

  Iterable<T> getLeaves();
}
