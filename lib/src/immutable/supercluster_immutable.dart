import 'dart:math';

import 'package:kdbush/kdbush.dart';
import 'package:supercluster/src/util.dart' as util;

import '../../supercluster.dart';

class SuperclusterImmutable<T> extends Supercluster<T> {
  List<T> points;

  late final List<KDBush<ImmutableLayerElement<T>, double>?> _trees;

  SuperclusterImmutable({
    required this.points,
    required super.getX,
    required super.getY,
    super.minZoom,
    super.maxZoom,
    super.minPoints,
    super.radius,
    super.extent,
    super.nodeSize = 64,
    super.extractClusterData,
    super.onClusterDataChange,
  }) {
    _trees = List.filled(maxZoom + 2, null);
    _load(points);
  }

  void _load(List<T> points) {
    this.points = points;

    // generate a cluster object for each point and index input points into a KD-tree
    var clusters = <ImmutableLayerElement<T>>[];
    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final x = getX(point);
      final y = getY(point);
      clusters.add(
        ImmutableLayerElement.initializePoint<T>(
          originalPoint: point,
          x: util.lngX(x),
          y: util.latY(y),
          index: i,
          clusterData: extractClusterData?.call(point),
          zoom: maxZoom + 1,
        ),
      );
    }

    _trees[maxZoom + 1] = KDBush<ImmutableLayerElement<T>, double>(
      points: clusters,
      getX: ImmutableLayerElement.getX,
      getY: ImmutableLayerElement.getY,
      nodeSize: nodeSize,
    );

    // cluster points on max zoom, then cluster the results on previous zoom, etc.;
    // results in a cluster hierarchy across zoom levels
    for (var z = maxZoom; z >= minZoom; z--) {
      // create a new set of clusters for the zoom and index them with a KD-tree
      clusters = _cluster(clusters, z);
      _trees[z] = KDBush<ImmutableLayerElement<T>, double>(
        points: clusters,
        getX: ImmutableLayerElement.getX,
        getY: ImmutableLayerElement.getY,
        nodeSize: nodeSize,
      );
    }

    _onPointsChanged();
  }

  @override
  List<ImmutableLayerElement<T>> search(
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

    final tree = _trees[_limitZoom(zoom)]!;
    final ids = tree.withinBounds(
      util.lngX(minLng),
      util.latY(maxLat),
      util.lngX(maxLng),
      util.latY(minLat),
    );
    final clusters = <ImmutableLayerElement<T>>[];
    for (final id in ids) {
      clusters.add(tree.points[id]);
    }
    return clusters;
  }

  @override
  Iterable<T> getLeaves() => _trees[maxZoom + 1]!
      .points
      .map((e) => (e as ImmutableLayerPoint<T>).originalPoint);

  List<ImmutableLayerElement<T>> childrenOf(int clusterId) {
    final originId = _getOriginId(clusterId);
    final originZoom = getOriginZoom(clusterId);
    final errorMsg = 'No cluster with the specified id.';

    final index = _trees[originZoom];
    if (index == null) throw errorMsg;

    if (originId >= index.points.length) throw errorMsg;
    final origin = index.points[originId];

    final r = radius / (extent * pow(2, originZoom - 1));
    final ids = index.withinRadius(origin.x, origin.y, r);
    final children = <ImmutableLayerElement<T>>[];
    for (final id in ids) {
      final c = index.points[id];
      if (c.parentId == clusterId) {
        children.add(c);
      }
    }

    if (children.isEmpty) throw errorMsg;

    return children;
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

  ImmutableLayerCluster<T>? parentOf(
      ImmutableLayerElement<T> clusterOrMapPoint) {
    if (clusterOrMapPoint.parentId == -1) return null;

    final parentZoom = getOriginZoom(clusterOrMapPoint.parentId) - 1;

    return _trees[parentZoom]!.points.firstWhere(
          (e) =>
              e is ImmutableLayerCluster<T> &&
              e.id == clusterOrMapPoint.parentId,
        ) as ImmutableLayerCluster<T>;
  }

  /// Returns the zoom level at which the cluster with the given id appears
  int getOriginZoom(int clusterId) {
    return (clusterId - points.length) % 32;
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
    final clusters = <ImmutableLayerElement<T>>[];
    final r = radius / (extent * pow(2, zoom));

    // loop through each point
    for (var i = 0; i < points.length; i++) {
      final p = points[i];
      // if we've already visited the point at this zoom level, skip it
      if (p.visitedAtZoom <= zoom) continue;
      p.visitedAtZoom = zoom;

      // find all nearby points
      final tree = _trees[zoom + 1]!;
      final neighborIds = tree.withinRadius(p.x, p.y, r);

      final numPointsOrigin = p.numPoints;
      var numPoints = numPointsOrigin;

      // count the number of points in a potential cluster
      for (final neighborId in neighborIds) {
        final b = tree.points[neighborId];
        // filter out neighbors that are already processed
        if (b.visitedAtZoom > zoom) numPoints += b.numPoints;
      }

      // if there were neighbors to merge, and there are enough points to form a cluster
      if (numPoints > numPointsOrigin && numPoints >= minPoints) {
        var wx = p.x * numPointsOrigin;
        var wy = p.y * numPointsOrigin;

        var clusterData = p.clusterData ??
            (extractClusterData != null ? _extractClusterData(p) : null);

        // encode both zoom and point index on which the cluster originated -- offset by total length of features
        final id = (i << 5) + (zoom + 1) + this.points.length;

        for (final neighborId in neighborIds) {
          final b = tree.points[neighborId];

          if (b.visitedAtZoom <= zoom) continue;
          b.visitedAtZoom =
              zoom; // save the zoom (so it doesn't get processed twice)

          final numPoints2 = b.numPoints;
          wx += b.x *
              numPoints2; // accumulate coordinates for calculating weighted center
          wy += b.y * numPoints2;

          b.parentId = id;

          if (extractClusterData != null) {
            clusterData ??= _extractClusterData(p);
            clusterData = clusterData.combine(_extractClusterData(b));
          }
        }

        p.parentId = id;
        clusters.add(
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
        clusters.add(p);
        p.lowestZoom = zoom;

        if (numPoints > 1) {
          for (final neighborId in neighborIds) {
            final b = tree.points[neighborId];
            if (b.visitedAtZoom <= zoom) continue;
            b.visitedAtZoom = zoom;
            clusters.add(b);
            b.lowestZoom = zoom;
          }
        }
      }
    }

    return clusters;
  }

  ClusterDataBase _extractClusterData(
      ImmutableLayerElement<T> clusterOrMapPoint) {
    return clusterOrMapPoint.map(
        cluster: (cluster) => cluster.clusterData!,
        point: (mapPoint) => extractClusterData!(mapPoint.originalPoint));
  }

// get index of the point from which the cluster originated
  int _getOriginId(int clusterId) {
    return (clusterId - points.length) >> 5;
  }

  void _onPointsChanged() {
    if (onClusterDataChange == null) return;

    final topLevelClusterData =
        _trees[minZoom]!.points.map((e) => e.clusterData);

    final aggregatedData = topLevelClusterData.isEmpty
        ? null
        : topLevelClusterData
            .reduce((value, element) => value?.combine(element!));

    onClusterDataChange!.call(aggregatedData);
  }
}
