import 'dart:math';

import 'package:supercluster/src/immutable/immutable_layer.dart';
import 'package:supercluster/src/util.dart' as util;

import '../../supercluster.dart';

class SuperclusterImmutable<T> extends Supercluster<T> {
  late final List<ImmutableLayer<T>?> _trees;
  late int _length;

  SuperclusterImmutable({
    required super.getX,
    required super.getY,
    super.minZoom,
    super.maxZoom,
    super.minPoints,
    super.radius,
    super.extent,
    super.nodeSize = 64,
    super.extractClusterData,
  }) {
    _trees = List.filled(maxZoom + 2, null);
  }

  int get length => _length;

  @override
  void load(List<T> points) {
    _length = points.length;

    // generate a cluster object for each point and index input points into a KD-tree
    var elements = <ImmutableLayerElement<T>>[];
    for (var i = 0; i < points.length; i++) {
      elements.add(_initializePoint(i, points[i]));
    }

    _trees[maxZoom + 1] = ImmutableLayer(elements, nodeSize: nodeSize);

    // cluster points on max zoom, then cluster the results on previous zoom, etc.;
    // results in a cluster hierarchy across zoom levels
    for (var z = maxZoom; z >= minZoom; z--) {
      // create a new set of clusters for the zoom and index them with a KD-tree
      elements = _cluster(elements, z);
      _trees[z] = ImmutableLayer(elements, nodeSize: nodeSize);
    }
  }

  @override
  List<ImmutableLayerElement<T>> search(
    double westLng,
    double southLat,
    double eastLng,
    double northLat,
    int zoom,
  ) {
    return _searchImpl(westLng, southLat, eastLng, northLat, _limitZoom(zoom));
  }

  List<ImmutableLayerElement<T>> _searchImpl(
    double westLng,
    double southLat,
    double eastLng,
    double northLat,
    int zoom,
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
      final easternHem = search(minLng, minLat, 180, maxLat, zoom);
      final westernHem = search(-180, minLat, maxLng, maxLat, zoom);
      return easternHem..addAll(westernHem);
    }

    return _trees[_limitZoom(zoom)]!
        .withinBounds(minLng, maxLat, maxLng, minLat);
  }

  @override
  Iterable<T> getLeaves() => _trees[maxZoom + 1]!.originalPoints;

  List<ImmutableLayerElement<T>> childrenOf(int clusterId) {
    final originId = _getOriginId(clusterId);
    final originZoom = getOriginZoom(clusterId);
    final errorMsg = 'No cluster with the specified id.';

    final index = _trees[originZoom];
    if (index == null) throw errorMsg;

    if (originId >= index.length) throw errorMsg;
    final origin = index.elementAt(originId);

    final r = radius / (extent * pow(2, originZoom - 1));

    final children = index
        .withinRadius(origin.x, origin.y, r)
        .where((element) => element.parentId == clusterId);

    if (children.isEmpty) throw errorMsg;

    return children.toList();
  }

  List<ImmutableLayerPoint<T>> pointsWithin(
    int clusterId, {
    int limit = 10,
    int offset = 0,
  }) {
    final leaves = <ImmutableLayerPoint<T>>[];
    _appendLeaves(leaves, clusterId, limit, offset, 0);

    return leaves;
  }

  int expansionZoomOf(int clusterId) {
    var expansionZoom = getOriginZoom(clusterId) - 1;
    while (expansionZoom <= maxZoom) {
      final children = childrenOf(clusterId);
      expansionZoom++;
      if (children.length != 1) break;
      clusterId = (children[0] as ImmutableLayerCluster).id;
    }
    return expansionZoom;
  }

  ImmutableLayerCluster<T>? parentOf(ImmutableLayerElement<T> element) {
    if (element.parentId == -1) return null;
    final parentZoom = getOriginZoom(element.parentId) - 1;

    return _trees[parentZoom]!.parentOf(element);
  }

  /// Returns the zoom level at which the cluster with the given id appears
  int getOriginZoom(int clusterId) {
    return (clusterId - _length) % 32;
  }

  @override
  void replacePoints(List<T> newPoints) =>
      _trees[maxZoom + 1]!.replacePoints(newPoints);

  @override
  bool contains(T point) {
    final longitude = getX(point);
    final latitude = getY(point);

    for (final searchResult in _searchImpl(
        longitude - 0.000001,
        latitude - 0.000001,
        longitude + 0.000001,
        latitude + 0.000001,
        maxZoom + 1)) {
      if (searchResult is ImmutableLayerPoint<T> &&
          searchResult.originalPoint == point) {
        return true;
      }
    }

    return false;
  }

  int _appendLeaves(List<ImmutableLayerPoint<T>> result, int clusterId,
      int limit, int offset, int skipped) {
    final children = childrenOf(clusterId);

    for (final child in children) {
      final cluster = child is ImmutableLayerCluster
          ? child as ImmutableLayerCluster
          : null;
      final mapPoint = child is ImmutableLayerPoint<T> ? child : null;

      if (cluster != null) {
        if (skipped + cluster.numPoints <= offset) {
          // skip the whole cluster
          skipped += cluster.numPoints;
        } else {
          // enter the cluster
          skipped = _appendLeaves(result, cluster.id, limit, offset, skipped);
          // exit the cluster
        }
      } else if (skipped < offset) {
        // skip a single point
        skipped++;
      } else {
        // add a single point
        result.add(mapPoint!);
      }
      if (result.length == limit) break;
    }

    return skipped;
  }

  int _limitZoom(num z) {
    return max(minZoom, min(z.floor(), maxZoom + 1));
  }

  List<ImmutableLayerElement<T>> _cluster(
    List<ImmutableLayerElement<T>> points,
    int zoom,
  ) {
    final elements = <ImmutableLayerElement<T>>[];
    final r = radius / (extent * pow(2, zoom));

    // loop through each point
    for (var i = 0; i < points.length; i++) {
      final p = points[i];
      // if we've already visited the point at this zoom level, skip it
      if (p.visitedAtZoom <= zoom) continue;
      p.visitedAtZoom = zoom;

      // find all nearby points
      final tree = _trees[zoom + 1]!;
      final neighbors = tree.withinRadius(p.x, p.y, r);

      final numPointsOrigin = p.numPoints;
      var numPoints = numPointsOrigin;

      // count the number of points in a potential cluster
      for (final neighbor in neighbors) {
        // filter out neighbors that are already processed
        if (neighbor.visitedAtZoom > zoom) numPoints += neighbor.numPoints;
      }

      // if there were neighbors to merge, and there are enough points to form a cluster
      if (numPoints > numPointsOrigin && numPoints >= minPoints) {
        var wx = p.x * numPointsOrigin;
        var wy = p.y * numPointsOrigin;

        var clusterData = p.clusterData ??
            (extractClusterData != null ? _extractClusterData(p) : null);

        // encode both zoom and point index on which the cluster originated -- offset by total length of features
        final id = (i << 5) + (zoom + 1) + _length;

        for (final neighbor in neighbors) {
          if (neighbor.visitedAtZoom <= zoom) continue;
          neighbor.visitedAtZoom =
              zoom; // save the zoom (so it doesn't get processed twice)

          final numPoints2 = neighbor.numPoints;
          wx += neighbor.x *
              numPoints2; // accumulate coordinates for calculating weighted center
          wy += neighbor.y * numPoints2;

          neighbor.parentId = id;

          if (extractClusterData != null) {
            clusterData ??= _extractClusterData(p);
            clusterData = clusterData.combine(_extractClusterData(neighbor));
          }
        }

        p.parentId = id;
        elements.add(
          ImmutableLayerElement.initializeCluster(
            clusterData: clusterData,
            id: id,
            x: wx / numPoints,
            y: wy / numPoints,
            childPointCount: numPoints,
            zoom: zoom,
          ),
        );
      } else {
        // left points as unclustered
        elements.add(p);
        p.lowestZoom = zoom;

        if (numPoints > 1) {
          for (final neighbor in neighbors) {
            if (neighbor.visitedAtZoom <= zoom) continue;
            neighbor.visitedAtZoom = zoom;
            elements.add(neighbor);
            neighbor.lowestZoom = zoom;
          }
        }
      }
    }

    return elements;
  }

  ClusterDataBase _extractClusterData(
      ImmutableLayerElement<T> clusterOrMapPoint) {
    return clusterOrMapPoint.map(
        cluster: (cluster) => cluster.clusterData!,
        point: (mapPoint) => extractClusterData!(mapPoint.originalPoint));
  }

  // get index of the point from which the cluster originated
  int _getOriginId(int clusterId) {
    return (clusterId - _length) >> 5;
  }

  ImmutableLayerPoint<T> _initializePoint(int index, T point) {
    final x = getX(point);
    final y = getY(point);

    return ImmutableLayerElement.initializePoint<T>(
      originalPoint: point,
      x: util.lngX(x),
      y: util.latY(y),
      index: index,
      clusterData: extractClusterData?.call(point),
      zoom: maxZoom + 1,
    );
  }

  @override
  ClusterDataBase? aggregatedClusterData() =>
      _trees[minZoom]!.aggregatedClusterData;
}
