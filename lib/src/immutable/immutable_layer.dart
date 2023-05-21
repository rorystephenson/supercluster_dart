import 'package:kdbush/kdbush.dart';
import 'package:supercluster/src/cluster_data_base.dart';
import 'package:supercluster/src/immutable/immutable_layer_element.dart';
import 'package:supercluster/src/util.dart' as util;

class ImmutableLayer<T> {
  final KDBush<ImmutableLayerElement<T>, double> _tree;
  final List<ImmutableLayerElement<T>> _elements;

  ImmutableLayer(
    this._elements, {
    required int nodeSize,
  }) : _tree = KDBush<ImmutableLayerElement<T>, double>(
          points: _elements,
          getX: ImmutableLayerElement.getX,
          getY: ImmutableLayerElement.getY,
          nodeSize: nodeSize,
        );

  Iterable<T> get originalPoints => _elements
      .whereType<ImmutableLayerPoint<T>>()
      .map((layerPoint) => layerPoint.originalPoint);

  int get length => _elements.length;

  ImmutableLayerElement elementAt(int index) => _elements[index];

  ImmutableLayerCluster<T>? parentOf(ImmutableLayerElement<T> element) {
    if (element.parentId == -1) return null;

    return _elements.firstWhere(
      (e) => e is ImmutableLayerCluster<T> && e.id == element.parentId,
    ) as ImmutableLayerCluster<T>;
  }

  List<ImmutableLayerElement<T>> withinBounds(
    double minX,
    double minY,
    double maxX,
    double maxY,
  ) =>
      _tree
          .withinBounds(
            util.lngX(minX),
            util.latY(minY),
            util.lngX(maxX),
            util.latY(maxY),
          )
          .map((index) => _elements[index])
          .toList();

  List<ImmutableLayerElement<T>> withinRadius(
    double x,
    double y,
    double radius,
  ) =>
      _tree
          .withinRadius(x, y, radius)
          .map((index) => _elements[index])
          .toList();

  ClusterDataBase? get aggregatedClusterData {
    final topLevelClusterData = _elements.map((e) => e.clusterData);

    return topLevelClusterData.isEmpty
        ? null
        : topLevelClusterData
            .reduce((value, element) => value?.combine(element!));
  }

  /// This will replace the inner points with the provided this one. It should
  /// only be called on the (maxZoom + 1) layer since it contains all of the
  /// points unclustered. See [Supercluster.replacePoints] for more information
  /// on what this is used for.
  void replacePoints(List<T> points) {
    assert(_elements.length == points.length);
    for (int i = 0; i < points.length; i++) {
      (_elements[i] as ImmutableLayerPoint<T>).originalPoint = points[i];
    }
  }
}
