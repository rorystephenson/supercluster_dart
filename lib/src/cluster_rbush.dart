import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rbush/rbush.dart';
import 'package:supercluster/src/mutable_cluster_or_point.dart';
import 'package:uuid/uuid.dart';

import 'cluster_data_base.dart';
import 'util.dart' as util;

class ClusterRBush<T> {
  final int zoom;
  final double searchRadius;

  final int maxPoints;
  final double Function(T) getX;
  final double Function(T) getY;
  final MutableClusterDataBase Function(T point)? extractClusterData;

  final RBush<MutableClusterOrPoint<T>> _innerTree;
  final Map<T, RBushElement<MutableClusterOrPoint<T>>>
      _pointToIndexElementMapping = {};
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
    for (final element in elements) {
      for (final point in element.data.points) {
        _pointToIndexElementMapping[point] = element;
      }
    }
    _innerTree.load(elements);
  }

  List<RBushElement<MutableClusterOrPoint<T>>> search(RBushBox rBushBox) {
    return _innerTree.search(rBushBox);
  }

  int get size => _innerTree.all().length;

  MutablePoint<T>? removePoint(T point) {
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
    assert(modification.removed.isNotEmpty);

    final rbushModification = RBushModification<T>(
      zoomCluster: this,
      added: [],
      removed: [],
    );

    ////////////////////////////////////////////////////////////////////////////
    // Removal                                                                //
    ////////////////////////////////////////////////////////////////////////////

    final removalBounds = _boundary(modification.removed);
    removalBounds.minX -= searchRadius;
    removalBounds.minY -= searchRadius;
    removalBounds.maxX += searchRadius;
    removalBounds.maxY += searchRadius;

    final splitPoints = <MutableClusterOrPoint<T>>[];

    final elementsWithinRemovalBounds = _innerTree.search(removalBounds);
    for (final removedClusterOrPoint in modification.removed) {
      bool removed = false;

      for (final elementWithinRemovalBounds in elementsWithinRemovalBounds) {
        final elementData = elementWithinRemovalBounds.data;
        if (elementData == removedClusterOrPoint) {
          removed = true;
          _innerTree.remove(elementWithinRemovalBounds);
          rbushModification.removed.add(elementData);

          break;
        } else if (elementData is MutableCluster<T> &&
            elementData.uuid == removedClusterOrPoint.parentUuid) {
          removed = true;
          _innerTree.remove(elementWithinRemovalBounds);
          rbushModification.removed.add(elementData);

          final children = modification.zoomCluster
              .search(
                RBushBox(
                  minX: elementData.x - searchRadius,
                  minY: elementData.y - searchRadius,
                  maxX: elementData.x + searchRadius,
                  maxY: elementData.y + searchRadius,
                ),
              )
              .where((element) => element.data.parentUuid == elementData.uuid)
              .toList();

          assert(children.isNotEmpty,
              'Unable to find cluster children at zoom $zoom');
          if (children.length == 1) {
            final childData = children.single.data;
            _innerTree.insert(childData.toRBushPoint());
            rbushModification.added.add(childData);
            splitPoints.add(childData);
          } else {
            final clusterSourceIndex = children.indexWhere(
              (e) => e.data.x == elementData.x && e.data.y == elementData.y,
            );
            final clusterSource = children
                .removeAt(clusterSourceIndex == -1 ? 0 : clusterSourceIndex)
                .data;

            final newCluster = _createCluster(
              clusterSource,
              children.map((e) => e.data).toList(),
            );
            newCluster.parentUuid = elementData.parentUuid;

            _innerTree.insert(newCluster.toRBushPoint());
            rbushModification.added.add(newCluster);
          }

          break;
        }
      }

      assert(removed,
          'Removals from previous zoom are made on current zoom ($zoom)');
    }

    ////////////////////////////////////////////////////////////////////////////
    // Re-clustering                                                          //
    ////////////////////////////////////////////////////////////////////////////
    for (final newClusterOrPoint in modification.added) {
      newClusterOrPoint.zoom = zoom;

      final existingNearbyClusterElement = _nearbyCluster(newClusterOrPoint);

      if (existingNearbyClusterElement != null) {
        // Found a cluster to add this point to.
        _innerTree.remove(existingNearbyClusterElement);
        rbushModification.removed.add(existingNearbyClusterElement.data);

        final parentUuid = existingNearbyClusterElement.data.parentUuid;
        final newCluster = _createCluster(
          existingNearbyClusterElement.data,
          [newClusterOrPoint],
        );
        newCluster.parentUuid = parentUuid;

        _innerTree.insert(newCluster.toRBushPoint());
        rbushModification.added.add(newCluster);
      } else {
        // No nearby cluster, see if there are nearby points to cluster.

        final higherZoomClusterableNeighbors = _higherZoomClusterableNeighbors(
          modification.zoomCluster,
          newClusterOrPoint,
        );
        if (higherZoomClusterableNeighbors.isEmpty) {
          // No nearby points, add this one to this layer.
          _innerTree.insert(newClusterOrPoint.toRBushPoint());
          rbushModification.added.add(newClusterOrPoint);
        } else {
          // One or more nearby points found, create a new cluster.
          final pointsGettingClustered =
              higherZoomClusterableNeighbors.map((e) => e.data).toList();
          final newCluster = _createCluster(
            newClusterOrPoint,
            pointsGettingClustered,
          );
          rbushModification.added.add(newCluster);
          _innerTree.insert(newCluster.toRBushPoint());
        }
      }
    }

    ////////////////////////////////////////////////////////////////////////////
    // Re-clustering split points                                             //
    ////////////////////////////////////////////////////////////////////////////

    for (final splitPoint in splitPoints) {
      // TODO
      // 1. Search for nearby points in this layer.
      // 2. If there is a nearby cluster add this to it.
      // 3. Otherwise if there are any nearby points form a cluster.
      // 4. If any nearby cluster or point was found this splitPoint should be
      //    removed from the rbushModification.added and the tree in favour of
      //    the new one.
      // 5. Try to refactor re-clustering so that I'm not repeating 90% of the
      //    code.
      //  ...
      //  Basically it's re-clustering without adding... but maybe these points
      //  already got clustered with the new ones above?
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

  Iterable<RBushElement<MutableClusterOrPoint<T>>>
      _higherZoomClusterableNeighbors(
    ClusterRBush<T> higherZoom,
    MutableClusterOrPoint<T> point,
  ) {
    final higherZoomNeighbors = higherZoom._innerTree.search(RBushBox(
      minX: point.wX - searchRadius,
      minY: point.wY - searchRadius,
      maxX: point.wX + searchRadius,
      maxY: point.wY + searchRadius,
    ));

    return higherZoomNeighbors.where((element) =>
        element.data != point &&
        (element.data.parentUuid == null || element.data.lowestZoom > zoom));
  }

  @visibleForTesting
  int get numPoints => _innerTree.all().fold(
        0,
        (previousValue, element) => previousValue + element.data.numPoints,
      );

  MutableCluster<T> _createCluster(MutableClusterOrPoint<T> sourcePoint,
      List<MutableClusterOrPoint<T>> clusteringPoints) {
    List<T> clusteredPoints = [];
    var numPoints = sourcePoint.numPoints;
    var wx = sourcePoint.wX * numPoints;
    var wy = sourcePoint.wY * numPoints;
    MutableClusterDataBase? clusterData;
    final clusterUuid = Uuid().v4();

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

      if (b is MutableCluster<T> && b.uuid == b.parentUuid) {
        print('4.');
      }
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

  void addWithoutClustering(T point) {
    final mutablePoint = MutableClusterOrPoint.initializePoint(
      point: point,
      lon: getX(point),
      lat: getY(point),
      zoom: zoom,
    );
    mutablePoint.zoom = zoom;

    _insertPoint(mutablePoint);
  }

  void update(ClusterRBush<T> nextHigherZoom, double x, double y) {
    final searchResults = nextHigherZoom.search(RBushBox(
      minX: x - searchRadius,
      minY: y - searchRadius,
      maxX: x + searchRadius,
      maxY: y + searchRadius,
    ));

    assert(searchResults.isNotEmpty);

    if (searchResults.length == 1) {
      // Duplicate
      final searchResult = searchResults.single.data.toRBushPoint();

      if (searchResult is RBushElement<MutablePoint<T>>) {
        searchResult.data.zoom = zoom;
        _pointToIndexElementMapping[(searchResult.data as MutablePoint<T>)
            .originalPoint] = searchResult;
        _innerTree.insert(searchResult);
      } else {
        final Set<RBushElement<MutableClusterOrPoint<T>>> toRemove = {};
        final originalPoints = searchResult.data.map(
          cluster: (cluster) => cluster.originalPoints,
          point: (point) => [point.originalPoint],
        );

        for (final originalPoint in originalPoints) {
          final existingElement = _pointToIndexElementMapping[originalPoint];
          if (existingElement != null) toRemove.add(existingElement);
          _pointToIndexElementMapping[originalPoint] = searchResult;
        }
        for (final element in toRemove) {
          _innerTree.remove(element);
        }
        searchResult.data.zoom = zoom;
        _innerTree.insert(searchResult);
      }
    } else {
      final firstPoint = searchResults.first.data;
      final cluster = MutableClusterOrPoint.initializeCluster<T>(
        uuid: Uuid().v4(),
        x: firstPoint.x,
        y: firstPoint.y,
        points: [],
        zoom: zoom,
      );
      final clusterElement = cluster.toRBushPoint();

      int numPoints = 0;
      double wx = 0;
      double wy = 0;
      MutableClusterDataBase? clusterData;

      final Set<RBushElement<MutableClusterOrPoint<T>>> toRemove = {};

      for (var j = 0; j < searchResults.length; j++) {
        var b = searchResults[j].data;
        for (final originalPoint in b.points) {
          numPoints++;

          final existingElement = _pointToIndexElementMapping[originalPoint];
          if (existingElement != null) toRemove.add(existingElement);
          _pointToIndexElementMapping[originalPoint] = clusterElement;
          cluster.originalPoints.add(originalPoint);
        }
        b.parentUuid = cluster.uuid;
        b.zoom = zoom; // save the zoom (so it doesn't get processed twice)
        wx += b.wX *
            b.numPoints; // accumulate coordinates for calculating weighted center
        wy += b.wY * b.numPoints;

        if (extractClusterData != null) {
          clusterData = clusterData == null
              ? _extractClusterData(b)
              : clusterData.combine(_extractClusterData(b));
        }
      }

      for (final element in toRemove) {
        _innerTree.remove(element);
      }
      cluster.wX = wx / numPoints;
      cluster.wY = wy / numPoints;

      _innerTree.insert(clusterElement);
    }

    // Remove points which this one contained and update mapping
  }

  void _insertPoint(MutablePoint<T> mutablePoint) {
    final element = mutablePoint.toRBushPoint();
    _pointToIndexElementMapping[mutablePoint.originalPoint] = element;
    _innerTree.insert(element);
  }

  MutableClusterDataBase _extractClusterData(
      MutableClusterOrPoint<T> clusterOrPoint) {
    return clusterOrPoint.map(
        cluster: (cluster) => cluster.clusterData!,
        point: (mapPoint) => extractClusterData!(mapPoint.originalPoint));
  }

  List<T> allPoints() {
    return _innerTree.all().map((e) => e.data.points).expand((e) => e).toList();
  }

  RBushBox _boundary(List<MutableClusterOrPoint<T>> clusterOrPoints) {
    RBushBox result = clusterOrPoints.first.toRBushPoint();

    for (int i = 0; i < clusterOrPoints.length; i++) {
      result.extend(clusterOrPoints[i].toRBushPoint());
    }

    return result;
  }
}

class RBushModification<T> {
  final ClusterRBush<T> zoomCluster;
  final List<MutableClusterOrPoint<T>> removed;
  final List<MutableClusterOrPoint<T>> added;

  RBushModification({
    required this.zoomCluster,
    required this.removed,
    required this.added,
  });
}

abstract class RBushRemoval<T> {
  MutableClusterOrPoint<T> get removed;
}

class RBushPointRemoval<T> extends RBushRemoval<T> {
  @override
  final MutablePoint<T> removed;

  RBushPointRemoval(this.removed);
}

class RBushClusterModification<T> extends RBushRemoval<T> {
  @override
  final MutableCluster<T> removed;
  final MutableCluster<T> updatedCluster;

  RBushClusterModification({
    required this.removed,
    required this.updatedCluster,
  });
}

class RBushClusterSplit<T> extends RBushRemoval<T> {
  @override
  final MutableCluster<T> removed;
  final List<MutableClusterOrPoint<T>> addedChildren;

  RBushClusterSplit({
    required this.removed,
    required this.addedChildren,
  });
}

class RBushPoint<T> extends RBushElement<T> {
  RBushPoint({
    required double x,
    required double y,
    required T data,
  }) : super(
          minX: x,
          minY: y,
          maxX: x,
          maxY: y,
          data: data,
        );

  double get x => minX;

  double get y => minY;

  @override
  bool operator ==(Object other) {
    if (other is! RBushPoint<T>) return false;
    return x == other.x && y == other.y && data == other.data;
  }

  @override
  int get hashCode => x.hashCode + y.hashCode + data.hashCode;
}
