import 'dart:math';

import 'package:kdbush/kdbush.dart';
import 'package:supercluster/src/cluster_data_base.dart';
import 'package:supercluster/src/immutable/immutable_layer_element.dart';
import 'package:supercluster/src/util.dart' as util;

class ImmutableLayer<T> {
  final KDBush<ImmutableLayerElement<T>, double> _tree;
  final List<ImmutableLayerElement<T>> _elements;
  final double Function(T) getX;
  final double Function(T) getY;

  ImmutableLayer(
    this._elements, {
    required this.getX,
    required this.getY,
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

  List<ImmutableLayerElement<T>> search(
    double westLng,
    double southLat,
    double eastLng,
    double northLat,
  ) {
    var minLng = ((westLng + 180) % 360 + 360) % 360 - 180;
    final minLat = max(-90.0, min(90.0, southLat));
    var maxLng =
        eastLng == 180 ? 180.0 : ((eastLng + 180) % 360 + 360) % 360 - 180;
    final maxLat = max(-90.0, min(90.0, northLat));

    if (eastLng - westLng >= 360) {
      minLng = -180.0;
      maxLng = 180.0;
    } else if (minLng > maxLng) {
      final easternHem = search(minLng, minLat, 180, maxLat);
      final westernHem = search(-180, minLat, maxLng, maxLat);
      return easternHem..addAll(westernHem);
    }

    return _withinBounds(minLng, maxLat, maxLng, minLat);
  }

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

  bool containsPoint(T point) => layerPointOf(point) != null;

  ImmutableLayerPoint<T>? layerPointOf(T point) {
    final longitude = getX(point);
    final latitude = getY(point);

    for (final searchResult in search(
      longitude - 0.000001,
      latitude - 0.000001,
      longitude + 0.000001,
      latitude + 0.000001,
    )) {
      if (searchResult is ImmutableLayerPoint<T> &&
          searchResult.originalPoint == point) {
        return searchResult;
      }
    }

    return null;
  }

  List<ImmutableLayerElement<T>> _withinBounds(
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
