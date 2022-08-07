import 'dart:math';

import 'package:rbush/rbush.dart';
import 'package:supercluster/src/mutable_cluster_or_point.dart';
import 'package:uuid/uuid.dart';

import 'cluster_data_base.dart';
import 'util.dart' as util;

class ClusterRBush<T> {
  final int zoom;
  final int extent;
  final int radius;

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
    required this.extent,
    required this.radius,
    required this.maxPoints,
    required this.getX,
    required this.getY,
    required this.childrenOf,
    this.extractClusterData,
  }) : _innerTree = RBush(maxPoints);

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
    final r = radius / (extent * pow(2, zoom));
    final x = util.lngX(getX(point));
    final y = util.latY(getY(point));

    final searchResults = _innerTree.search(RBushBox(
      minX: x - r,
      minY: y - r,
      maxX: x + r,
      maxY: y + r,
    ));

    final index = searchResults.indexWhere((element) {
      final data = element.data;
      return data is MutablePoint<T> && data.originalPoint == point;
    });

    if (index != -1) return null;

    _innerTree.remove(searchResults[index]);
    return searchResults[index].data as MutablePoint<T>;
  }

  // Remove all the parents/matching of the ?
  //

  // 1. Do the re-clustering within the new point boundary + 2r.
  // 2. Remove all
  RBushModification<T> recluster(RBushModification<T> modification) {
    assert(modification.removed.isNotEmpty);

    final r = radius / (extent * pow(2, zoom));

    final rbushModification = RBushModification<T>(
      zoomCluster: this,
      added: [],
      removed: [],
    );

    ////////////////////////////////////////////////////////////////////////////
    // Removal /////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
    final removalBounds = RBushBox.fromList(
      modification.removed.map((e) => e.toRBushPoint()).toList(),
    );
    removalBounds.minX -= r;
    removalBounds.minY -= r;
    removalBounds.maxX += r;
    removalBounds.maxY += r;

    final elementsWithinRemovalBounds = _innerTree.search(removalBounds);
    for (final removedClusterOrPoint in modification.removed) {
      final toRemove = elementsWithinRemovalBounds.firstWhere((element) {
        final elementData = element.data;
        return elementData == removedClusterOrPoint ||
            (elementData is MutableCluster<T> &&
                elementData.uuid == removedClusterOrPoint.parentUuid);
      });
      _innerTree.remove(toRemove);
      rbushModification.removed.add(toRemove.data);
    }

    ////////////////////////////////////////////////////////////////////////////
    // Re-clustering ///////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////
    final reclusterBounds = RBushBox.fromList([removalBounds]);
    reclusterBounds.minX -= r;
    reclusterBounds.minY -= r;
    reclusterBounds.maxX += r;
    reclusterBounds.maxY += r;

    // First check in this zoom if there is a cluster I can add to... if there
    // is then remove that cluster and add a new one. If not then look on the
    // next zoom down to see if I can cluster (say because a cluster was split
    // and now it's possible for a new cluster to be formed from one of the
    // split points)... Or just re-cluster the whole area broooooo

    for (final newClusterOrPoint in modification.added) {
      // if we've already visited the point at this zoom level, skip it
      if (newClusterOrPoint.zoom <= zoom) continue;
      newClusterOrPoint.zoom = zoom;

      final neighborsInThisZoom = search(RBushBox(
        minX: newClusterOrPoint.wX - r,
        minY: newClusterOrPoint.wY - r,
        maxX: newClusterOrPoint.wX + r,
        maxY: newClusterOrPoint.wY + r,
      ));

      final existingNearbyClusterIndex = neighborsInThisZoom
          .indexWhere((element) => element is MutableCluster<T>);

      if (existingNearbyClusterIndex != -1) {
        final existingNearbyClusterElement =
            neighborsInThisZoom[existingNearbyClusterIndex];

        _innerTree.remove(existingNearbyClusterElement);
        rbushModification.removed.add(existingNearbyClusterElement.data);

        final newCluster = _createCluster(
          existingNearbyClusterElement.data,
          [newClusterOrPoint],
        );
        _innerTree.insert(newCluster.toRBushPoint());
        rbushModification.added.add(newCluster);
        continue;
      }

      final bboxNeighbors = modification.zoomCluster.search(RBushBox(
        minX: newClusterOrPoint.wX - r,
        minY: newClusterOrPoint.wY - r,
        maxX: newClusterOrPoint.wX + r,
        maxY: newClusterOrPoint.wY + r,
      ));

      final higherZoomNeighborsNotInCluster = bboxNeighbors.where((element) =>
          element.data != newClusterOrPoint &&
          (element.data.parentUuid == null || element.data.lowestZoom > zoom));

      if (higherZoomNeighborsNotInCluster.isEmpty) {
        _innerTree.insert(newClusterOrPoint.toRBushPoint());
        modification.added.add(newClusterOrPoint);
      } else {
        final pointsGettingClustered =
            higherZoomNeighborsNotInCluster.map((e) => e.data).toList();
        final newCluster = _createCluster(
          newClusterOrPoint,
          pointsGettingClustered,
        );
        modification.added.add(newCluster);
        _innerTree.insert(newCluster.toRBushPoint());
      }
    }

    return rbushModification;
  }

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
    final r = radius / (extent * pow(2, zoom));
    final searchResults = nextHigherZoom.search(RBushBox(
      minX: x - r,
      minY: y - r,
      maxX: x + r,
      maxY: y + r,
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
