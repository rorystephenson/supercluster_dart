import 'dart:collection';
import 'dart:math';

import 'package:rbush/rbush.dart';
import 'package:supercluster/src/mutable/boundary_extensions.dart';
import 'package:supercluster/src/mutable/layer_element_modification.dart';
import 'package:supercluster/src/mutable/layer_modification.dart';
import 'package:supercluster/src/mutable/mutable_layer_element.dart';
import 'package:supercluster/src/mutable/rbush_element_set.dart';
import 'package:supercluster/src/mutable/rbush_point.dart';

class MutableLayer<T> {
  final int zoom;

  // Radius for clustering.
  final double r;

  // Squared cluster radius, for distance comparison.
  final double r2;

  final RBush<MutableLayerElement<T>> _innerTree;

  MutableLayer({
    required int nodeSize,
    required this.zoom,
    required this.r,
  })  : _innerTree = RBush(nodeSize),
        r2 = r * r;

  void clear() {
    _innerTree.clear();
  }

  void load(List<RBushElement<MutableLayerElement<T>>> elements) {
    assert(
      !elements
          .any((element) => element is! RBushPoint<MutableLayerElement<T>>),
    );
    _innerTree.load(elements);
  }

  List<RBushElement<MutableLayerElement<T>>> search(RBushBox rBushBox) {
    return _innerTree.search(rBushBox);
  }

  void addWithoutClustering(
    RBushPoint<MutableLayerElement<T>> layerPoint, {
    bool updateZooms = true,
  }) {
    if (updateZooms) {
      layerPoint.data.lowestZoom = zoom;
      layerPoint.data.visitedAtZoom = zoom;
    }

    _innerTree.insert(layerPoint);
  }

  RBushElement<MutableLayerPoint<T>>? removePointWithoutClustering(
    MutableLayerPoint<T> point,
  ) {
    final searchResults = _innerTree.search(point.indexRBushPoint());

    final removalIndex = searchResults.indexWhere((element) {
      final data = element.data;
      return data is MutableLayerPoint<T> &&
          data.originalPoint == point.originalPoint;
    });

    if (removalIndex == -1) return null;
    _innerTree.remove(searchResults[removalIndex]);
    return RBushPoint.cast<MutableLayerElement<T>, MutableLayerPoint<T>>(
      searchResults[removalIndex] as RBushPoint<MutableLayerElement<T>>,
    );
  }

  LayerModification<T> removeElementsAndParents(
    LayerModification<T> previousModification,
  ) {
    final result = LayerModification<T>(layer: this);

    // Radius is 2x searchRadius because a cluster may be that far away from
    // a point with a very low relative weight compared to the cluster's other
    // points.
    final removalBounds = previousModification.removed.paddedBoundary(r * 2);
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
          elementData.visitedAtZoom = max(elementData.visitedAtZoom, zoom + 1);
          result.recordRemoval(elementData);

          if (elementData.uuid == removal.parentUuid) {
            // Search the next layer down nullify the parent uuids of the children
            // and set their zoom value.
            final potentialChildren = previousModification.layer
                .search(elementWithinRemovalBounds.expandBy(r * 2));

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

  RBushElementSet<T> removeAncestors(RBushElementSet<T> descendants) {
    final removedAncestors = <RBushElement<MutableLayerElement<T>>>{};
    final visited = <RBushElement<MutableLayerElement<T>>>{};

    for (final descendant in descendants) {
      // Radius is 2x searchRadius because a cluster may be that far away from
      // a point with a very low relative weight compared to the cluster's other
      // points.
      // TODO not * 2 because we should have all the cluster's children and one
      // of them is the origin
      final ancestorBounds = descendant.expandBy(r);

      final ancestorPoints = _innerTree.search(ancestorBounds).where(
          (element) =>
              !visited.contains(element) &&
                  element.data.uuid == descendant.data.uuid ||
              element.data.uuid == descendant.data.parentUuid);
      for (final ancestorPoint in ancestorPoints) {
        ancestorPoint.data
          ..visitedAtZoom = max(
            zoom + 1,
            ancestorPoint.data.visitedAtZoom,
          )
          ..lowestZoom = max(ancestorPoint.data.lowestZoom, zoom + 1);

        removedAncestors.add(ancestorPoint);
        _innerTree.remove(ancestorPoint);
      }
    }

    return removedAncestors;
  }

  /// Recursively visits all the elements withing [parentClusterRadius] of
  /// [elements] and marks them as visited. Returns a set containing the input
  /// [elements] plus all visited elements.
  RBushElementSet<T> visitContiguous(
    double parentClusterRadius,
    RBushElementSet<T> elements,
  ) {
    final result = <RBushElement<MutableLayerElement<T>>>{};
    final searchQueue =
        Queue<RBushElement<MutableLayerElement<T>>>.from(elements);
    while (searchQueue.isNotEmpty) {
      final searchElement = searchQueue.removeFirst();
      final searchBounds = searchElement.expandBy(parentClusterRadius);

      for (final contiguousPoint in _innerTree.search(searchBounds)) {
        final unvisited = !result.contains(contiguousPoint);
        if (unvisited) {
          contiguousPoint.data.visitedAtZoom =
              max(zoom, contiguousPoint.data.visitedAtZoom);
          result.add(contiguousPoint);
          searchQueue.addLast(contiguousPoint);
        }
      }
    }
    return result;
  }

  List<MutableLayerElement<T>> descendants(
    double clusterRadius,
    MutableLayerCluster<T> layerCluster,
  ) {
    return _innerTree
        .search(layerCluster.descendantsBounds(clusterRadius))
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

  LayerElementModification<T> modifyElementAndParents(
    LayerElementModification<T> lastModification,
  ) {
    // Radius is 2x searchRadius because a cluster may be that far away from
    // a point with a very low relative weight compared to the cluster's other
    // points.
    final removalBounds =
        lastModification.oldLayerElement.paddedBoundary(r * 2);
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
              .search(parentOrMatchingRBushElement.expandBy(r * 2))
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
