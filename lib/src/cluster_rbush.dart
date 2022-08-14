import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rbush/rbush.dart';
import 'package:supercluster/src/mutable_cluster_or_point.dart';
import 'package:supercluster/src/uuid_stub.dart';

import 'cluster_data_base.dart';
import 'rbush_modification.dart';
import 'util.dart' as util;

class ClusterRBush<T> {
  final int zoom;
  final double searchRadius;

  final int maxPoints;
  final double Function(T) getX;
  final double Function(T) getY;
  final MutableClusterDataBase Function(T point)? extractClusterData;

  final RBush<MutableClusterOrPoint<T>> _innerTree;
  final List<MutableClusterOrPoint<T>> Function(MutableCluster<T> cluster)
      childrenOf;

  ClusterRBush({
    required this.zoom,
    required int extent,
    required int radius,
    required this.maxPoints,
    required this.getX,
    required this.getY,
    required this.childrenOf,
    this.extractClusterData,
  })  : searchRadius = radius / (extent * pow(2, zoom)),
        _innerTree = RBush(maxPoints);

  void load(List<RBushElement<MutableClusterOrPoint<T>>> elements) {
    _innerTree.load(elements);
  }

  List<RBushElement<MutableClusterOrPoint<T>>> search(RBushBox rBushBox) {
    return _innerTree.search(rBushBox);
  }

  MutablePoint<T> addPointWithoutClustering(T point) {
    final mutablePoint = MutableClusterOrPoint.initializePoint(
      point: point,
      lon: getX(point),
      lat: getY(point),
      zoom: zoom,
    );
    mutablePoint.zoom = zoom;

    _innerTree.insert(mutablePoint.toRBushPoint());
    return mutablePoint;
  }

  MutablePoint<T>? removePointWithoutClustering(T point) {
    final x = util.lngX(getX(point));
    final y = util.latY(getY(point));

    final searchResults = _innerTree.search(RBushBox(
      minX: x - searchRadius,
      minY: y - searchRadius,
      maxX: x + searchRadius,
      maxY: y + searchRadius,
    ));

    final index = searchResults.indexWhere((element) {
      final data = element.data;
      return data is MutablePoint<T> && data.originalPoint == point;
    });

    if (index == -1) return null;

    _innerTree.remove(searchResults[index]);
    return searchResults[index].data as MutablePoint<T>;
  }

  RBushModification<T> recluster(RBushModification<T> modification) {
    int? numPointsBeforeRecluster;
    assert((numPointsBeforeRecluster = numPoints) > 0);

    final rbushModification = RBushModification<T>(
      zoomCluster: this,
      added: List.from(modification.added),
      removed: [],
    );

    ////////////////////////////////////////////////////////////////////////////
    // Removal                                                                //
    ////////////////////////////////////////////////////////////////////////////

    if (modification.removed.isNotEmpty) {
      final removalBounds = _boundary(modification.removed);
      removalBounds.minX -= searchRadius;
      removalBounds.minY -= searchRadius;
      removalBounds.maxX += searchRadius;
      removalBounds.maxY += searchRadius;

      final elementsWithinRemovalBounds = _innerTree.search(removalBounds);
      Map<RBushElement<MutableClusterOrPoint<T>>,
          List<MutableClusterOrPoint<T>>> clusterToRemovals = {};

      for (final removedClusterOrPoint in modification.removed) {
        bool removed = false;

        for (final elementWithinRemovalBounds in elementsWithinRemovalBounds) {
          final elementData = elementWithinRemovalBounds.data;
          if (elementData.uuid == removedClusterOrPoint.uuid) {
            removed = true;
            _innerTree.remove(elementWithinRemovalBounds);
            rbushModification.remove(elementData);

            break;
          } else if (elementData is MutableCluster<T> &&
              elementData.uuid == removedClusterOrPoint.parentUuid) {
            removed = true;
            clusterToRemovals[elementWithinRemovalBounds] ??= [];
            clusterToRemovals[elementWithinRemovalBounds]!
                .add(removedClusterOrPoint);
            break;
          }
        }

        if (!removed) {
          if (removedClusterOrPoint is MutableCluster<T>) {
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
        final cluster = clusterElement.data as MutableCluster<T>;

        rbushModification.remove(cluster);

        final children = modification.zoomCluster
            .search(
              RBushBox(
                minX: cluster.x - searchRadius,
                minY: cluster.y - searchRadius,
                maxX: cluster.x + searchRadius,
                maxY: cluster.y + searchRadius,
              ),
            )
            .where((element) => element.data.parentUuid == cluster.uuid)
            .toList();
        assert(children.isNotEmpty, 'No cluster children at zoom $zoom');

        if (children.length == 1) {
          // Must split cluster
          final childData = children.single.data;
          if (!rbushModification.added
              .any((element) => element.uuid == childData.uuid)) {
            rbushModification.insert(childData);
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

          rbushModification.insert(newCluster);
        }
      });
    }

    ////////////////////////////////////////////////////////////////////////////
    // Re-clustering                                                          //
    ////////////////////////////////////////////////////////////////////////////

    // Add to existing clusters where possible.
    Map<MutableCluster<T>, List<MutableClusterOrPoint<T>>> clusterToNewPoints =
        {};
    //final newClusterOrPoints = SplayTreeSet<MutableClusterOrPoint<T>>(
    //    (a, b) => a.uuid.compareTo(b.uuid))
    //  ..addAll(rbushModification.added);
    final newClusterOrPoints =
        Set<MutableClusterOrPoint<T>>.from(rbushModification.added);

    for (final newClusterOrPoint in newClusterOrPoints) {
      final existingNearbyClusterElement = _nearbyCluster(newClusterOrPoint);

      if (existingNearbyClusterElement != null) {
        final existingCluster =
            existingNearbyClusterElement.data as MutableCluster<T>;
        clusterToNewPoints[existingCluster] ??= [];
        clusterToNewPoints[existingCluster]!.add(newClusterOrPoint);
      }
    }

    clusterToNewPoints.forEach((cluster, points) {
      for (var element in points) {
        rbushModification.added
            .removeWhere((added) => element.uuid == added.uuid);
      }
      newClusterOrPoints.removeAll(points);
      rbushModification.remove(cluster);
      _innerTree.remove(cluster.toRBushPoint());

      final newCluster =
          _addToCluster(modification.zoomCluster, cluster, points);
      _innerTree.insert(newCluster.toRBushPoint());
      rbushModification.insert(newCluster);
    });

    // Try to create new clusters or just add the points if it is not possible
    // to add to an existing cluster.
    for (final newClusterOrPoint in newClusterOrPoints) {
      if (newClusterOrPoint.zoom <= zoom) continue;
      newClusterOrPoint.zoom = zoom;

      // Find nearby points in the child layer whose parent uuid is not in this
      // layer.
      final neighborUuids =
          _neighbors(newClusterOrPoint).map((e) => e.uuid).toList();
      final childLayerNeighbors =
          modification.zoomCluster._neighbors(newClusterOrPoint).toList();
      childLayerNeighbors
          .removeWhere((e) => neighborUuids.contains(e.parentUuid));

      if (childLayerNeighbors.isNotEmpty) {
        for (final clusteredPoint in [
          newClusterOrPoint,
          ...childLayerNeighbors
        ]) {
          rbushModification.remove(clusteredPoint);
          _innerTree.remove(clusteredPoint.toRBushPoint());
        }

        final newCluster = _createCluster(
          newClusterOrPoint,
          childLayerNeighbors,
        );

        rbushModification.insert(newCluster);
        _innerTree.insert(newCluster.toRBushPoint());
      } else {
        _innerTree.insert(newClusterOrPoint.toRBushPoint());
        rbushModification.insert(newClusterOrPoint);
        newClusterOrPoint.parentUuid = null;
      }
    }

    var debug = false;
    assert(debug = true);
    if (debug) {
      // Ensure the number of points has changed as expected
      final numPointsAfter = numPoints;
      final expectedDifference = modification.numPointsChange;
      final expectedNumPointsAfter =
          numPointsBeforeRecluster! + expectedDifference;
      assert(
        numPointsAfter == expectedNumPointsAfter,
        'zoom $zoom has $numPointsAfter instead of $expectedNumPointsAfter points after clustering',
      );

      // Ensure the modification of this layer matches the higher zoom layer.
      assert(
        modification.numPointsChange == rbushModification.numPointsChange,
        "This change of numPoints (${rbushModification.numPointsChange}) in this zoom ($zoom) should match the previous layer (${modification.numPointsChange})",
      );
    }
    return rbushModification;
  }

  RBushElement<MutableClusterOrPoint<T>>? _nearbyCluster(
      MutableClusterOrPoint<T> point) {
    final neighborsInThisZoom = _innerTree.search(RBushBox(
      minX: point.wX - searchRadius,
      minY: point.wY - searchRadius,
      maxX: point.wX + searchRadius,
      maxY: point.wY + searchRadius,
    ));

    final nearbyClusterIndex = neighborsInThisZoom
        .indexWhere((element) => element.data is MutableCluster<T>);
    return nearbyClusterIndex == -1
        ? null
        : neighborsInThisZoom[nearbyClusterIndex];
  }

  MutableCluster<T> _addToCluster(
    ClusterRBush<T> zoomCluster,
    MutableCluster<T> cluster,
    List<MutableClusterOrPoint<T>> points,
  ) {
    final pointUuids = points.map((e) => e.uuid).toList();
    final children = zoomCluster._innerTree
        .search(RBushBox(
          minX: cluster.x - searchRadius,
          minY: cluster.y - searchRadius,
          maxX: cluster.x + searchRadius,
          maxY: cluster.y + searchRadius,
        ))
        .map((e) => e.data)
        .where((potentialChild) =>
            potentialChild.uuid == cluster.uuid ||
            potentialChild.parentUuid == cluster.uuid ||
            pointUuids.contains(potentialChild.uuid))
        .toList();

    final sourceIndex = children.indexWhere(
        (element) => element.x == cluster.x && element.y == cluster.y);
    final clusterSource = children.removeAt(sourceIndex);

    final newCluster = _createCluster(clusterSource, children);
    newCluster.parentUuid = cluster.parentUuid;
    return newCluster;
  }

  List<MutableClusterOrPoint<T>> _neighbors(
    MutableClusterOrPoint<T> point,
  ) {
    final neighbors = _innerTree
        .search(RBushBox(
          minX: point.wX - searchRadius,
          minY: point.wY - searchRadius,
          maxX: point.wX + searchRadius,
          maxY: point.wY + searchRadius,
        ))
        .map((e) => e.data);

    return neighbors.where((element) => element.uuid != point.uuid).toList();
  }

  MutableCluster<T> _createCluster(MutableClusterOrPoint<T> sourcePoint,
      List<MutableClusterOrPoint<T>> clusteringPoints) {
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
    final cluster = MutableClusterOrPoint.initializeCluster(
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

  MutableClusterDataBase _extractClusterData(
      MutableClusterOrPoint<T> clusterOrPoint) {
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
  List<T> allPoints() {
    return _innerTree.all().map((e) => e.data.points).expand((e) => e).toList();
  }

  RBushBox _boundary(List<MutableClusterOrPoint<T>> clusterOrPoints) {
    RBushBox result = clusterOrPoints.first.toRBushPoint();

    for (final clusterOrPoint in clusterOrPoints.skip(1)) {
      result.extend(clusterOrPoint.toRBushPoint());
    }

    return result;
  }
}
