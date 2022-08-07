import 'dart:math';

import 'package:kdbush/kdbush.dart';
import 'package:supercluster/src/cluster_or_map_point.dart';
import 'package:supercluster/src/util.dart' as util;

import 'cluster_data_base.dart';

class Supercluster<T> {
  final double? Function(T) getX;
  final double? Function(T) getY;

  final int minZoom;
  final int maxZoom;
  final int minPoints;
  final int radius;
  final int extent;
  final int nodeSize;

  final ClusterDataBase Function(T point)? extractClusterData;

  final List<KDBush<ClusterOrMapPoint<T>, double>?> trees;
  List<T>? points;

  Supercluster({
    required List<T> points,
    required this.getX,
    required this.getY,
    int? minZoom,
    int? maxZoom,
    int? minPoints,
    int? radius,
    int? extent,
    int? nodeSize,
    this.extractClusterData,
  })  : minZoom = minZoom ?? 0,
        maxZoom = maxZoom ?? 16,
        minPoints = minPoints ?? 2,
        radius = radius ?? 40,
        extent = extent ?? 512,
        nodeSize = nodeSize ?? 64,
        trees = List.filled((maxZoom ?? 16) + 2, null) {
    _load(points);
  }

  void _load(List<T> points) {
    this.points = points;

    // generate a cluster object for each point and index input points into a KD-tree
    var clusters = <ClusterOrMapPoint<T>>[];
    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final x = getX(point);
      final y = getY(point);
      if (x == null || y == null) continue;
      clusters.add(
        ClusterOrMapPoint<T>.mapPoint(
          originalPoint: point,
          x: util.lngX(x),
          y: util.latY(y),
          index: i,
          clusterData: extractClusterData?.call(point),
        ),
      );
    }

    trees[maxZoom + 1] = KDBush<ClusterOrMapPoint<T>, double>(
      points: clusters,
      getX: ClusterOrMapPoint.getX,
      getY: ClusterOrMapPoint.getY,
      nodeSize: nodeSize,
    );

    // cluster points on max zoom, then cluster the results on previous zoom, etc.;
    // results in a cluster hierarchy across zoom levels
    for (var z = maxZoom; z >= minZoom; z--) {
      // create a new set of clusters for the zoom and index them with a KD-tree
      clusters = _cluster(clusters, z);
      trees[z] = KDBush<ClusterOrMapPoint<T>, double>(
        points: clusters,
        getX: ClusterOrMapPoint.getX,
        getY: ClusterOrMapPoint.getY,
        nodeSize: nodeSize,
      );
    }
  }

  List<ClusterOrMapPoint<T>> getClustersAndPoints(
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
      final easternHem =
          getClustersAndPoints(minLng, minLat, 180, maxLat, zoom);
      final westernHem =
          getClustersAndPoints(-180, minLat, maxLng, maxLat, zoom);
      return easternHem..addAll(westernHem);
    }

    final tree = trees[_limitZoom(zoom)]!;
    final ids = tree.withinBounds(
      util.lngX(minLng),
      util.latY(maxLat),
      util.lngX(maxLng),
      util.latY(minLat),
    );
    final clusters = <ClusterOrMapPoint<T>>[];
    for (final id in ids) {
      clusters.add(tree.points[id]);
    }
    return clusters;
  }

  List<ClusterOrMapPoint<T>> getChildren(int clusterId) {
    final originId = _getOriginId(clusterId);
    final originZoom = getOriginZoom(clusterId);
    final errorMsg = 'No cluster with the specified id.';

    final index = trees[originZoom];
    if (index == null) throw errorMsg;

    if (originId >= index.points.length) throw errorMsg;
    final origin = index.points[originId];

    final r = radius / (extent * pow(2, originZoom - 1));
    final ids = index.withinRadius(origin.x, origin.y, r);
    final children = <ClusterOrMapPoint<T>>[];
    for (final id in ids) {
      final c = index.points[id];
      if (c.parentId == clusterId) {
        children.add(c);
      }
    }

    if (children.isEmpty) throw errorMsg;

    return children;
  }

  List<MapPoint<T>> getLeaves(int clusterId, {int limit = 10, int offset = 0}) {
    final leaves = <MapPoint<T>>[];
    _appendLeaves(leaves, clusterId, limit, offset, 0);

    return leaves;
  }

  int getClusterExpansionZoom(int clusterId) {
    var expansionZoom = getOriginZoom(clusterId) - 1;
    while (expansionZoom <= maxZoom) {
      final children = getChildren(clusterId);
      expansionZoom++;
      if (children.length != 1) break;
      clusterId = (children[0] as Cluster).id;
    }
    return expansionZoom;
  }

  Cluster<T>? parentOf(ClusterOrMapPoint<T> clusterOrMapPoint) {
    if (clusterOrMapPoint.parentId == -1) return null;

    final parentZoom = getOriginZoom(clusterOrMapPoint.parentId) - 1;

    return trees[parentZoom]!.points.firstWhere(
          (e) => e is Cluster<T> && e.id == clusterOrMapPoint.parentId,
        ) as Cluster<T>;
  }

  /// Returns the zoom level at which the cluster with the given id appears
  int getOriginZoom(int clusterId) {
    return (clusterId - points!.length) % 32;
  }

  int _appendLeaves(List<MapPoint<T>> result, int clusterId, int limit,
      int offset, int skipped) {
    final children = getChildren(clusterId);

    for (final child in children) {
      final cluster = child is Cluster ? child as Cluster : null;
      final mapPoint = child is MapPoint<T> ? child : null;

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

  List<ClusterOrMapPoint<T>> _cluster(
    List<ClusterOrMapPoint<T>> points,
    int zoom,
  ) {
    final clusters = <ClusterOrMapPoint<T>>[];
    final r = radius / (extent * pow(2, zoom));

    // loop through each point
    for (var i = 0; i < points.length; i++) {
      final p = points[i];
      // if we've already visited the point at this zoom level, skip it
      if (p.zoom <= zoom) continue;
      p.zoom = zoom;

      // find all nearby points
      final tree = trees[zoom + 1]!;
      final neighborIds = tree.withinRadius(p.x, p.y, r);

      final numPointsOrigin = p.numPoints;
      var numPoints = numPointsOrigin;

      // count the number of points in a potential cluster
      for (final neighborId in neighborIds) {
        final b = tree.points[neighborId];
        // filter out neighbors that are already processed
        if (b.zoom > zoom) numPoints += b.numPoints;
      }

      // if there were neighbors to merge, and there are enough points to form a cluster
      if (numPoints > numPointsOrigin && numPoints >= minPoints) {
        var wx = p.x * numPointsOrigin;
        var wy = p.y * numPointsOrigin;

        var clusterData = p.clusterData ??
            (extractClusterData != null ? _extractClusterData(p) : null);

        // encode both zoom and point index on which the cluster originated -- offset by total length of features
        final id = (i << 5) + (zoom + 1) + this.points!.length;

        for (final neighborId in neighborIds) {
          final b = tree.points[neighborId];

          if (b.zoom <= zoom) continue;
          b.zoom = zoom; // save the zoom (so it doesn't get processed twice)

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
          ClusterOrMapPoint.cluster(
            clusterData: clusterData,
            id: id,
            x: wx / numPoints,
            y: wy / numPoints,
            numPoints: numPoints,
          ),
        );
      } else {
        // left points as unclustered
        clusters.add(p);

        if (numPoints > 1) {
          for (final neighborId in neighborIds) {
            final b = tree.points[neighborId];
            if (b.zoom <= zoom) continue;
            b.zoom = zoom;
            clusters.add(b);
          }
        }
      }
    }

    return clusters;
  }

  ClusterDataBase _extractClusterData(ClusterOrMapPoint<T> clusterOrMapPoint) {
    return clusterOrMapPoint.map(
        cluster: (cluster) => cluster.clusterData!,
        mapPoint: (mapPoint) => extractClusterData!(mapPoint.originalPoint));
  }

  // get index of the point from which the cluster originated
  int _getOriginId(int clusterId) {
    return (clusterId - points!.length) >> 5;
  }

  Map<String, dynamic> extend(
      Map<String, dynamic> dest, Map<String, dynamic> src) {
    for (final id in src.keys) {
      dest[id] = src[id];
    }
    return dest;
  }
}
