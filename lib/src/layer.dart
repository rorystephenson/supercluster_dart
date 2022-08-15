import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rbush/rbush.dart';
import 'package:supercluster/src/layer_element.dart';
import 'package:supercluster/src/rbush_point.dart';
import 'package:supercluster/src/uuid_stub.dart';

import 'cluster_data_base.dart';
import 'layer_modification.dart';
import 'util.dart' as util;

class Layer<T> {
  final int zoom;
  final double searchRadius;

  final int maxPoints;
  final double Function(T) getX;
  final double Function(T) getY;
  final MutableClusterDataBase Function(T point)? extractClusterData;

  final RBush<LayerElement<T>> _innerTree;
  final List<LayerElement<T>> Function(LayerCluster<T> cluster) childrenOf;

  Layer({
    required this.zoom,
    required this.searchRadius,
    required this.maxPoints,
    required this.getX,
    required this.getY,
    required this.childrenOf,
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

  LayerPoint<T>? removePointWithoutClustering(T point) {
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

    if (index == -1) return null;

    _innerTree.remove(searchResults[index]);
    return searchResults[index].data as LayerPoint<T>;
  }

  LayerModification<T> recluster(LayerModification<T> previousModification) {
    int? numPointsBeforeRecluster;
    assert((numPointsBeforeRecluster = numPoints) > 0);

    final currentModification = LayerModification<T>(
      zoomCluster: this,
      added: List.from(previousModification.added),
      removed: [],
    );

    _performRemoval(previousModification, currentModification);
    _insert(List.from(currentModification.added));
    _recluster(previousModification, currentModification);

    var debug = false;
    assert(debug = true);
    if (debug) {
      // Ensure the number of points has changed as expected
      final numPointsAfter = numPoints;
      final expectedDifference = previousModification.numPointsChange;
      final expectedNumPointsAfter =
          numPointsBeforeRecluster! + expectedDifference;
      assert(
        numPointsAfter == expectedNumPointsAfter,
        'zoom $zoom has $numPointsAfter instead of $expectedNumPointsAfter points after clustering',
      );

      // Ensure the modification of this layer matches the higher zoom layer.
      assert(
        previousModification.numPointsChange ==
            currentModification.numPointsChange,
        "This change of numPoints (${currentModification.numPointsChange}) in this zoom ($zoom) should match the previous layer (${previousModification.numPointsChange})",
      );
    }
    return currentModification;
  }

  void _performRemoval(LayerModification<T> previousModification,
      LayerModification<T> currentModification) {
    if (previousModification.removed.isNotEmpty) {
      // Must search withing searchRadius * 2 because the a parent of a removed
      // layer element may be that far away if it's weighted position is as far
      // as possible from its position.
      final removalBounds =
          _boundary(previousModification.removed).expandBy(searchRadius * 2);

      final elementsWithinRemovalBounds = _innerTree.search(removalBounds);
      Map<RBushElement<LayerElement<T>>, List<LayerElement<T>>>
          clusterToRemovals = {};

      for (final removedClusterOrPoint in previousModification.removed) {
        bool removed = false;

        for (final elementWithinRemovalBounds in elementsWithinRemovalBounds) {
          final elementData = elementWithinRemovalBounds.data;
          if (elementData.uuid == removedClusterOrPoint.uuid) {
            removed = true;
            _innerTree.remove(elementWithinRemovalBounds);
            currentModification.recordRemoval(elementData);

            break;
          } else if (elementData is LayerCluster<T> &&
              elementData.uuid == removedClusterOrPoint.parentUuid) {
            removed = true;
            clusterToRemovals[elementWithinRemovalBounds] ??= [];
            clusterToRemovals[elementWithinRemovalBounds]!
                .add(removedClusterOrPoint);
            break;
          }
        }

        if (!removed) {
          if (removedClusterOrPoint is LayerCluster<T>) {
            assert(
              removed,
              'Failed to find cluster (${removedClusterOrPoint.uuid}) with parent id (${removedClusterOrPoint.parentUuid}) to remove from zoom ($zoom)',
            );
          } else {
            assert(
              removed,
              'Failed to find point with parent id (${removedClusterOrPoint.parentUuid}) to remove from zoom ($zoom)',
            );
          }
        }
      }

      clusterToRemovals.forEach((clusterElement, removals) {
        _innerTree.remove(clusterElement);
        final cluster = clusterElement.data as LayerCluster<T>;

        currentModification.recordRemoval(cluster);

        final children = previousModification.zoomCluster._innerTree
            .search(cluster.positionRBushPoint().expandBy(searchRadius * 2))
            .where((element) => element.data.parentUuid == cluster.uuid)
            .toList();
        assert(children.isNotEmpty, 'No cluster children at zoom $zoom');

        if (children.length == 1) {
          // Must split cluster
          final childData = children.single.data;
          if (!currentModification.added
              .any((element) => element.uuid == childData.uuid)) {
            currentModification.recordInsertion(childData);
          }
          childData.parentUuid = cluster.parentUuid;
        } else {
          // Just remove point from cluster
          final clusterSourceIndex = children.indexWhere(
            (e) => e.data.x == cluster.x && e.data.y == cluster.y,
          );
          final clusterSource = children
              .removeAt(clusterSourceIndex == -1 ? 0 : clusterSourceIndex)
              .data;

          final newCluster = _createCluster(
            clusterSource,
            children.map((e) => e.data).toList(),
          );
          newCluster.parentUuid = cluster.parentUuid;

          currentModification.recordInsertion(newCluster);
        }
      });
    }
  }

  void _insert(List<LayerElement<T>> elements) {
    // Try to create new clusters or just add the points if it is not possible
    // to add to an existing cluster.
    for (final newClusterOrPoint in elements) {
      newClusterOrPoint.zoom = zoom;

      _innerTree.insert(newClusterOrPoint.positionRBushPoint());
      newClusterOrPoint.parentUuid = null;
    }
  }

  void _recluster(LayerModification<T> previousModification,
      LayerModification<T> currentModification) {
    assert(numPoints == previousModification.zoomCluster.numPoints);
    final these = all()
        .expand((e) => e.points)
        .map((e) => (e as Map)['properties']['name'])
        .toList()
      ..sort();
    final those = previousModification.zoomCluster
        .all()
        .expand((e) => e.points)
        .map((e) => (e as Map)['properties']['name'])
        .toList()
      ..sort();
    assert(these.length == those.length);
    for (int i = 0; i < these.length; i++) {
      assert(these[i] == those[i]);
    }
    Map<LayerCluster<T>, List<LayerElement<T>>> clusterToNewPoints = {};
    for (final newClusterOrPoint in currentModification.added) {
      if (clusterToNewPoints.containsKey(newClusterOrPoint)) continue;
      final existingNearbyClusterElement = _nearbyCluster(newClusterOrPoint);

      if (existingNearbyClusterElement != null) {
        // Add to existing clusters where possible.
        final existingCluster =
            existingNearbyClusterElement.data as LayerCluster<T>;
        clusterToNewPoints[existingCluster] ??= [];
        clusterToNewPoints[existingCluster]!.add(newClusterOrPoint);
        continue;
      }
    }

    clusterToNewPoints.forEach((cluster, points) {
      currentModification.removeFromAddedOrRecordRemoval(cluster);
      _innerTree.remove(cluster.positionRBushPoint());

      for (final point in points) {
        _innerTree.remove(point.positionRBushPoint());
        currentModification.removeFromAddedOrRecordRemoval(point);
      }

      final newCluster =
          _addToCluster(previousModification.zoomCluster, cluster, points);
      _innerTree.insert(newCluster.positionRBushPoint());
      currentModification.recordInsertion(newCluster);
    });
  }

  RBushElement<LayerElement<T>>? _nearbyCluster(LayerElement<T> point) {
    return _innerTree
        .search(
      point.weightedPositionRBushPoint().expandBy(searchRadius * 2),
    )
        .fold<ClusterWithDistance<T>?>(
      null,
      (previousValue, element) {
        final data = element.data;
        if (data is! LayerCluster<T> || data.uuid == point.uuid) {
          return previousValue;
        }
        final distance = util.distSq(point, data);
        if (distance > searchRadius * searchRadius) return previousValue;
        if (previousValue == null || distance < previousValue.distance) {
          return ClusterWithDistance(element: element, distance: distance);
        }
        return previousValue;
      },
    )?.element;
  }

  LayerCluster<T> _addToCluster(
    Layer<T> zoomCluster,
    LayerCluster<T> cluster,
    List<LayerElement<T>> points,
  ) {
    final pointUuids = points.map((e) => e.uuid).toList();
    final children = zoomCluster._innerTree
        .search(cluster.positionRBushPoint().expandBy(searchRadius * 2))
        .map((e) => e.data)
        .where((potentialChild) =>
            potentialChild.uuid == cluster.uuid ||
            potentialChild.parentUuid == cluster.uuid ||
            pointUuids.contains(potentialChild.uuid) ||
            pointUuids.contains(potentialChild.parentUuid))
        .toList();

    final sourceIndex = children.indexWhere(
        (element) => element.x == cluster.x && element.y == cluster.y);
    final clusterSource = children.removeAt(sourceIndex);

    final newCluster = _createCluster(clusterSource, children);
    assert(
        newCluster.numPoints ==
            cluster.numPoints +
                points
                    .map((e) => e.numPoints)
                    .reduce((value, element) => value + element),
        "$zoom: find all children when adding ${points.map((e) => "${e.uuid} (${e.parentUuid})").join(', ')} to cluster ${cluster.uuid}. ");
    newCluster.parentUuid = cluster.parentUuid;
    return newCluster;
  }

  LayerCluster<T> _createCluster(
      LayerElement<T> sourcePoint, List<LayerElement<T>> clusteringPoints) {
    List<T> clusteredPoints = [];
    var numPoints = sourcePoint.numPoints;
    var wx = sourcePoint.wX * numPoints;
    var wy = sourcePoint.wY * numPoints;
    MutableClusterDataBase? clusterData;
    final clusterUuid = UuidStub.v4(); // TODO Uuid().v4();

    for (var j = 0; j < clusteringPoints.length; j++) {
      var b = clusteringPoints[j];
      // filter out neighbors that are too far or already processed
      clusteredPoints.addAll(
        b.map(
          cluster: (cluster) => cluster.originalPoints,
          point: (point) => [point.originalPoint],
        ),
      );
      b.parentUuid = clusterUuid;
      b.zoom = zoom; // save the zoom (so it doesn't get processed twice)
      wx += b.wX *
          b.numPoints; // accumulate coordinates for calculating weighted center
      wy += b.wY * b.numPoints;
      numPoints += b.numPoints;

      if (extractClusterData != null) {
        clusterData ??= _extractClusterData(sourcePoint);
        clusterData = clusterData.combine(_extractClusterData(b));
      }
    }

    // form a cluster with neighbors
    sourcePoint.parentUuid = clusterUuid;
    final cluster = LayerElement.initializeCluster(
      uuid: clusterUuid,
      x: sourcePoint.x,
      y: sourcePoint.y,
      points: clusteredPoints
        ..insertAll(
            0,
            sourcePoint.map(
                cluster: (cluster) => cluster.originalPoints,
                point: (point) => [point.originalPoint])),
      zoom: zoom,
      clusterData: clusterData,
    );

    // save weighted cluster center for display
    cluster.wX = wx / numPoints;
    cluster.wY = wy / numPoints;

    return cluster;
  }

  MutableClusterDataBase _extractClusterData(LayerElement<T> clusterOrPoint) {
    return clusterOrPoint.map(
        cluster: (cluster) => cluster.clusterData!,
        point: (mapPoint) => extractClusterData!(mapPoint.originalPoint));
  }

  @visibleForTesting
  int get size => _innerTree.all().length;

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

class ClusterWithDistance<T> {
  final RBushElement<LayerElement<T>> element;
  final double distance;

  ClusterWithDistance({required this.element, required this.distance});

  LayerCluster<T> get cluster => element.data as LayerCluster<T>;
}
