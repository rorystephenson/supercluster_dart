import 'package:rbush/rbush.dart';
import 'package:supercluster/src/mutable/layer_element_modification.dart';
import 'package:supercluster/src/mutable/rbush_point.dart';

import 'layer_clusterer.dart';
import 'layer_modification.dart';
import 'mutable_layer_element.dart';

class MutableLayer<T> {
  final int zoom;
  final double searchRadius;

  final RBush<MutableLayerElement<T>> _innerTree;

  MutableLayer({
    required int nodeSize,
    required this.zoom,
    required this.searchRadius,
  }) : _innerTree = RBush(nodeSize);

  void clear() {
    _innerTree.clear();
  }

  void load(List<RBushElement<MutableLayerElement<T>>> elements) {
    _innerTree.load(elements);
  }

  List<RBushElement<MutableLayerElement<T>>> search(RBushBox rBushBox) {
    return _innerTree.search(rBushBox);
  }

  void addPointWithoutClustering(
    MutableLayerPoint<T> layerPoint, {
    bool updateZooms = true,
  }) {
    if (updateZooms) {
      layerPoint.lowestZoom = zoom;
      layerPoint.visitedAtZoom = zoom;
    }

    _innerTree.insert(layerPoint.indexRBushPoint());
  }

  LayerModification<T> removePointWithoutClustering(
      MutableLayerPoint<T> point) {
    final searchResults = _innerTree.search(point.indexRBushPoint());

    final index = searchResults.indexWhere((element) {
      final data = element.data;
      return data is MutableLayerPoint<T> &&
          data.originalPoint == point.originalPoint;
    });

    if (index == -1) return LayerModification<T>(layer: this);

    _innerTree.remove(searchResults[index]);
    return LayerModification<T>(layer: this)
      ..recordRemoval(searchResults[index].data as MutableLayerPoint<T>);
  }

  LayerModification<T> removeElementsAndAncestors(
      LayerModification<T> previousModification) {
    final result = LayerModification<T>(layer: this);

    // Radius is 2x searchRadius because a cluster may be that far away from
    // a point with a very low relative weight compared to the cluster's other
    // points.
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
                potentialChild.data.visitedAtZoom =
                    previousModification.layer.zoom;
                potentialChild.data.lowestZoom =
                    previousModification.layer.zoom;
                result.recordOrphan(potentialChild.data);
              }
            }
          } else {
            final matchingElement = previousModification.layer
                .search(elementWithinRemovalBounds)
                .where((element) => element.data.uuid == elementData.uuid);
            if (matchingElement.isNotEmpty) {
              matchingElement.single.data.visitedAtZoom =
                  previousModification.layer.zoom;
              matchingElement.single.data.lowestZoom =
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

  // This rebuilds a layer after elements were [removed] from [previousLayer].
  // It will attempt to build new clusters in the bounds of said removals.
  void rebuildLayer(
    LayerClusterer<T> layerClusterer,
    MutableLayer<T> previousLayer,
    List<MutableLayerElement<T>> removed,
  ) {
    // Radius is NOT 2x because we are looking for potential clustering
    // candidates which can only be searchRadius away from a child. Only once
    // the x/y is weighted based on the contained points can a cluster be more
    // than searchRadius away from its points (its originX/originY remain the
    // original search center).
    final removalBounds = _boundary(removed).expandBy(searchRadius);
    final points = previousLayer
        .search(removalBounds)
        .where((element) => element.data.visitedAtZoom > zoom)
        .map((e) => e.data.indexRBushPoint())
        .toList();
    final result = layerClusterer
        .cluster(points, zoom, previousLayer)
        .map((e) => e.indexRBushPoint())
        .toList();
    load(result);
  }

  List<MutableLayerElement<T>> elementsToClusterWith(
      MutableLayerPoint<T> layerPoint) {
    final nearbyElements =
        _innerTree.search(layerPoint.indexRBushPoint().expandBy(searchRadius));

    if (nearbyElements.isEmpty) {
      return [];
    }

    final clusterIndex = nearbyElements
        .indexWhere((element) => element.data is MutableLayerCluster<T>);
    if (clusterIndex != -1) {
      return [nearbyElements[clusterIndex].data];
    } else {
      return nearbyElements.map((e) => e.data).toList();
    }
  }

  List<MutableLayerElement<T>> descendants(
      MutableLayerCluster<T> layerCluster) {
    return _innerTree
        .search(layerCluster.originRBushPoint().expandBy(searchRadius))
        .where((element) =>
            element.data.uuid == layerCluster.uuid ||
            element.data.parentUuid == layerCluster.uuid)
        .map((e) => e.data)
        .toList();
  }

  Iterable<MutableLayerElement<T>> all() {
    return _innerTree.all().map((e) => e.data);
  }

  bool containsPoint(MutableLayerPoint<T> layerPoint) =>
      layerPointOf(layerPoint) != null;

  MutableLayerPoint<T>? layerPointOf(MutableLayerPoint<T> layerPoint) {
    for (final element in _innerTree.search(layerPoint.indexRBushPoint())) {
      final data = element.data;
      if (data is MutableLayerPoint<T> &&
          data.originalPoint == layerPoint.originalPoint) {
        return data;
      }
    }

    return null;
  }

  RBushBox _boundary(List<MutableLayerElement<T>> elements) {
    RBushBox result = elements.first.indexRBushPoint();

    for (final element in elements.skip(1)) {
      result.extend(element.indexRBushPoint());
    }

    return result;
  }

  LayerElementModification<T> modifyElementAndAncestors(
      LayerClusterer<T> layerClusterer,
      LayerElementModification<T> lastModification) {
    // Radius is 2x searchRadius because a cluster may be that far away from
    // a point with a very low relative weight compared to the cluster's other
    // points.
    final removalBounds = _boundary([lastModification.oldLayerElement])
        .expandBy(searchRadius * 2);
    final parentOrMatchingRBushElement = search(removalBounds).firstWhere(
        (element) =>
            element.data.uuid == lastModification.oldLayerElement.uuid ||
            element.data.uuid == lastModification.oldLayerElement.parentUuid);

    if (parentOrMatchingRBushElement.data.uuid ==
        lastModification.oldLayerElement.uuid) {
      _innerTree.remove(lastModification.oldLayerElement.indexRBushPoint());
      _innerTree.insert(lastModification.newLayerElement.indexRBushPoint());
      return LayerElementModification(
        layer: this,
        oldLayerElement: lastModification.oldLayerElement,
        newLayerElement: lastModification.newLayerElement,
      );
    } else {
      _innerTree.remove(parentOrMatchingRBushElement);
      final removedElement =
          parentOrMatchingRBushElement.data as MutableLayerCluster<T>;
      final updatedClusterData = removedElement.clusterData == null
          ? null
          : lastModification.layer
              .search(parentOrMatchingRBushElement.expandBy(searchRadius * 2))
              .where(
                  (element) => element.data.parentUuid == removedElement.uuid)
              .map((e) => e.data.clusterData)
              .reduce((value, element) => value!.combine(element!));

      final newLayerElement = removedElement.copyWith(
        clusterData: updatedClusterData,
      );
      _innerTree.insert(newLayerElement.indexRBushPoint());
      return LayerElementModification(
        layer: this,
        oldLayerElement: removedElement,
        newLayerElement: newLayerElement,
      );
    }
  }

  /// This will replace the inner points with the provided this one. It should
  /// only be called on the (maxZoom + 1) layer since it contains all of the
  /// points unclustered. See [Supercluster.replacePoints] for more information
  /// on what this is used for.
  void replacePoints(List<T> points) {
    final allElements = all().toList();
    assert(allElements.length == points.length);
    for (int i = 0; i < points.length; i++) {
      final mutablePoint = allElements[i] as MutableLayerPoint<T>;
      mutablePoint.originalPoint = points[mutablePoint.index];
    }
  }
}
