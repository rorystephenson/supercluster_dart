import 'dart:math';

import 'package:supercluster/src/cluster_or_map_point.dart';
import 'package:supercluster/src/util.dart' as util;

import 'cluster_data_base.dart';
import 'point_tree.dart';
import 'rbush_point_tree.dart';

abstract class Supercluster<T> {
  final double? Function(T) getX;
  final double? Function(T) getY;

  final int minZoom;
  final int maxZoom;
  final int minPoints;
  final int radius;
  final int extent;
  final int nodeSize;

  final ClusterDataBase Function(T point)? extractClusterData;

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
  })
      : minZoom = minZoom ?? 0,
        maxZoom = maxZoom ?? 16,
        minPoints = minPoints ?? 2,
        radius = radius ?? 40,
        extent = extent ?? 512,
        nodeSize = nodeSize ?? 64,
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

  trees[maxZoom + 1].initialize(clusters);

  // cluster points on max zoom, then cluster the results on previous zoom, etc.;
  // results in a cluster hierarchy across zoom levels
  for (var z = maxZoom; z >= minZoom; z--) {
    // create a new set of clusters for the zoom and index them with a KD-tree
    clusters = _cluster(clusters, z);
    trees[z].initialize(clusters);
  }
}

List<ClusterOrMapPoint<T>> getClustersAndPoints(double westLng,
    double southLat,
    double eastLng,
    double northLat,
    int zoom,);

List<ClusterOrMapPoint<T>> getChildren(int clusterId);

List<MapPoint<T>> getLeaves(int clusterId, {int limit = 10, int offset = 0});

int getClusterExpansionZoom(int clusterId);

Cluster<T>? parentOf(ClusterOrMapPoint<T> clusterOrMapPoint);

/// Returns the zoom level at which the cluster with the given id appears
int getOriginZoom(int clusterId);

List<ClusterOrMapPoint<T>> _cluster(List<ClusterOrMapPoint<T>> points,
    int zoom,) {
  final clusters = <ClusterOrMapPoint<T>>[];
  final r = radius / (extent * pow(2, zoom));

  // loop through each point
  for (var i = 0; i < points.length; i++) {
    final p = points[i];
    // if we've already visited the point at this zoom level, skip it
    if (p.zoom <= zoom) continue;
    p.zoom = zoom;

    // find all nearby points
    final tree = trees[zoom + 1];
    final neighbors = tree.withinRadius(p.x, p.y, r);

    final numPointsOrigin = p.numPoints;
    var numPoints = numPointsOrigin;

    // count the number of points in a potential cluster
    for (final neighbor in neighbors) {
      // filter out neighbors that are already processed
      if (neighbor.zoom > zoom) numPoints += neighbor.numPoints;
    }

    // if there were neighbors to merge, and there are enough points to form a cluster
    if (numPoints > numPointsOrigin && numPoints >= minPoints) {
      var wx = p.x * numPointsOrigin;
      var wy = p.y * numPointsOrigin;

      var clusterData = p.clusterData ??
          (extractClusterData != null ? _extractClusterData(p) : null);

      // encode both zoom and point index on which the cluster originated -- offset by total length of features
      final id = (i << 5) + (zoom + 1) + this.points!.length;

      for (final neighbor in neighbors) {
        if (neighbor.zoom <= zoom) continue;
        neighbor.zoom =
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
        for (final neighbor in neighbors) {
          if (neighbor.zoom <= zoom) continue;
          neighbor.zoom = zoom;
          clusters.add(neighbor);
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
  // if (clusterOrMapPoint is Cluster<T>) {
  //   return clone
  //       ? extend({}, clusterOrMapPoint.data)
  //       : clusterOrMapPoint.data;
  // }
  // clusterOrMapPoint as MapPoint<T>;

  // final original = clusterOrMapPoint.originalPoint;
  // final result = extractClusterData!(original);
  // return clone && result == original ? extractClusterData!(original) : result;
}

// get index of the point from which the cluster originated
int _getOriginId(int clusterId) {
  return (clusterId - points!.length) >> 5;
}

Map<String, dynamic> extend(Map<String, dynamic> dest,
    Map<String, dynamic> src) {
  for (final id in src.keys) {
    dest[id] = src[id];
  }
  return dest;
}}
