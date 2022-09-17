import 'cluster_data_base.dart';
import 'layer_element.dart';

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

  Iterable<LayerElement<T>> search(
    double westLng,
    double southLat,
    double eastLng,
    double northLat,
    int zoom,
  );

  Iterable<T> getLeaves();
}
