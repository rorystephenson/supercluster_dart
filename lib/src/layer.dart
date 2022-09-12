import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rbush/rbush.dart';
import 'package:supercluster/src/layer_element.dart';
import 'package:supercluster/src/rbush_point.dart';

import 'cluster_data_base.dart';
import 'layer_clusterer.dart';
import 'layer_modification.dart';
import 'util.dart' as util;

class Layer<T> {
  final int zoom;
  final double searchRadius;

  final int maxPoints;
  final double Function(T) getX;
  final double Function(T) getY;
  final ClusterDataBase Function(T point)? extractClusterData;

  final RBush<LayerElement<T>> _innerTree;

  Layer({
    required this.zoom,
    required this.searchRadius,
    required this.maxPoints,
    required this.getX,
    required this.getY,
    this.extractClusterData,
  }) : _innerTree = RBush(maxPoints);

  void load(List<RBushElement<LayerElement<T>>> elements) {
    _innerTree.load(elements);
  }

  List<RBushElement<LayerElement<T>>> search(RBushBox rBushBox) {
    return _innerTree.search(rBushBox);
  }

  LayerPoint<T> addPointWithoutClustering(T point) {
    final mutablePoint = LayerElement.initializePoint(
      point: point,
      lon: getX(point),
      lat: getY(point),
      zoom: zoom,
    );
    mutablePoint.zoom = zoom;

    _innerTree.insert(mutablePoint.positionRBushPoint());
    return mutablePoint;
  }

  LayerPoint<T> addLayerPointWithoutClustering(LayerPoint<T> layerPoint) {
    layerPoint.zoom = zoom;

    _innerTree.insert(layerPoint.positionRBushPoint());
    return layerPoint;
  }

  LayerModification<T> removePointWithoutClustering(T point) {
    final x = util.lngX(getX(point));
    final y = util.latY(getY(point));

    final searchResults = _innerTree.search(RBushBox(
      minX: x,
      minY: y,
      maxX: x,
      maxY: y,
    ));

    final index = searchResults.indexWhere((element) {
      final data = element.data;
      return data is LayerPoint<T> && data.originalPoint == point;
    });

    if (index == -1) return LayerModification<T>(layer: this);

    _innerTree.remove(searchResults[index]);
    return LayerModification<T>(layer: this)
      ..recordRemoval(searchResults[index].data as LayerPoint<T>);
  }

  LayerModification<T> removeElementsAndAncestors(
      LayerModification<T> previousModification) {
    final result = LayerModification<T>(layer: this);

    // Must search withing searchRadius * 2 because the a parent of a removed
    // layer element may be that far away if it's weighted position is as far
    // as possible from its position.
    final removalBounds =
        _boundary(previousModification.removed).expandBy(searchRadius * 2);
    final elementsWithinRemovalBounds = _innerTree.search(removalBounds);

    for (final removal in previousModification.removed) {
      if (result.removed
          .any((alreadyRemoved) => alreadyRemoved.uuid == removal.parentUuid)) {
        continue;
      }

      bool removed = false;

      for (final elementWithinRemovalBounds in elementsWithinRemovalBounds) {
        final elementData = elementWithinRemovalBounds.data;
        if (elementData.uuid == removal.uuid ||
            elementData.uuid == removal.parentUuid) {
          removed = true;

          _innerTree.remove(elementWithinRemovalBounds);
          result.recordRemoval(elementData);

          if (elementData.uuid == removal.parentUuid) {
            // Search the next layer down nullify the parent uuids of the children
            // and set their zoom value.
            final potentialChildren = previousModification.layer
                .search(elementWithinRemovalBounds.expandBy(searchRadius * 2));

            for (final potentialChild in potentialChildren) {
              if (potentialChild.data.parentUuid == elementData.uuid) {
                potentialChild.data.zoom = previousModification.layer.zoom;
                result.recordOrphan(potentialChild.data);
              }
            }
          } else {
            final matchingElement = previousModification.layer
                .search(elementWithinRemovalBounds)
                .where((element) => element.data.uuid == elementData.uuid);
            if (matchingElement.isNotEmpty) {
              matchingElement.single.data.zoom =
                  previousModification.layer.zoom;
            }
          }

          break;
        }
      }
      if (!removed) {
        throw 'Failed to find ${removal.summary} to remove from zoom ($zoom)';
      }
    }

    return result;
  }

  void rebuildLayer(
    LayerClusterer<T> layerClusterer,
    Layer<T> previousLayer,
    List<LayerElement<T>> removed,
  ) {
    // Must search withing searchRadius * 2 because the a parent of a removed
    // layer element may be that far away if it's weighted position is as far
    // as possible from its position.
    final removalBounds = _boundary(removed).expandBy(searchRadius * 2);
    final points = previousLayer
        .search(removalBounds)
        .where((element) => element.data.zoom > zoom)
        .map((e) => e.data.positionRBushPoint())
        .toList();
    final result = layerClusterer
        .cluster(points, zoom, previousLayer)
        .map((e) => e.positionRBushPoint())
        .toList();
    load(result);
  }

  List<LayerElement<T>> elementsToClusterWith(LayerPoint<T> layerPoint) {
    final nearbyElements = _innerTree.search(layerPoint
        .positionRBushPoint()
        .expandBy(searchRadius)); // TODO Should be wX?

    if (nearbyElements.isEmpty) {
      return [];
    }

    final clusterIndex =
        nearbyElements.indexWhere((element) => element.data is LayerCluster<T>);
    if (clusterIndex != -1) {
      return [nearbyElements[clusterIndex].data];
    } else {
      return nearbyElements.map((e) => e.data).toList();
    }
  }

  List<LayerElement<T>> descendants(LayerCluster<T> layerCluster) {
    return _innerTree
        .search(layerCluster.positionRBushPoint().expandBy(searchRadius * 2))
        .where((element) =>
            element.data.uuid == layerCluster.uuid ||
            element.data.parentUuid == layerCluster.uuid)
        .map((e) => e.data)
        .toList();
  }

  @visibleForTesting
  int get numLayerElements => _innerTree.all().length;

  @visibleForTesting
  int get numPoints => _innerTree.all().fold(
        0,
        (previousValue, element) => previousValue + element.data.numPoints,
      );

  @visibleForTesting
  List<LayerElement<T>> all() {
    return _innerTree.all().map((e) => e.data).toList();
  }

  RBushBox _boundary(List<LayerElement<T>> clusterOrPoints) {
    RBushBox result = clusterOrPoints.first.positionRBushPoint();

    for (final clusterOrPoint in clusterOrPoints.skip(1)) {
      result.extend(clusterOrPoint.positionRBushPoint());
    }

    return result;
  }
}
