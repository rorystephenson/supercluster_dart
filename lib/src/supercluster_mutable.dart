import 'dart:math';

import 'package:rbush/rbush.dart';
import 'package:supercluster/src/cluster_rbush.dart';
import 'package:uuid/uuid.dart';

import './util.dart' as util;
import 'cluster_data_base.dart';
import 'mutable_cluster_or_point.dart';

class SuperclusterMutable<T> {
  final double Function(T) getX;
  final double Function(T) getY;
  final int maxEntries;

  final int minZoom;
  final int maxZoom;
  final int radius;
  final int extent;
  final int nodeSize;

  final MutableClusterDataBase Function(T point)? extractClusterData;

  late final List<ClusterRBush<T>> trees;

  SuperclusterMutable({
    required this.getX,
    required this.getY,
    required this.maxEntries,
    int? minZoom,
    int? maxZoom,
    int? radius,
    int? extent,
    int? nodeSize,
    this.extractClusterData,
  })  : minZoom = minZoom ?? 0,
        maxZoom = maxZoom ?? 16,
        radius = radius ?? 40,
        extent = extent ?? 512,
        nodeSize = nodeSize ?? 64 {
    trees = List.generate(
      (maxZoom ?? 16) + 2,
      (i) => ClusterRBush<T>(
          zoom: i,
          extent: extent ?? 512,
          radius: radius ?? 40,
          getX: getX,
          getY: getY,
          maxPoints: maxEntries,
          childrenOf: (cluster) => children(cluster)),
    );
  }

  void load(List<T> points) {
    // generate a cluster object for each point
    var clusters = points
        .map(
          (point) => MutableClusterOrPoint.initializePoint(
            point: point,
            lon: getX(point),
            lat: getY(point),
            clusterData: extractClusterData?.call(point),
            zoom: maxZoom + 1,
          ).toRBushPoint(),
        )
        .toList();

    // cluster points on max zoom, then cluster the results on previous zoom, etc.;
    // results in a cluster hierarchy across zoom levels
    for (var z = maxZoom; z >= minZoom; z--) {
      trees[z + 1].load(clusters); // index input points into an R-tree
      clusters = _cluster(clusters, z)
          .map((c) => c.toRBushPoint())
          .toList(); // create a new set of clusters for the zoom

    }
    trees[minZoom].load(clusters); // index top-level clusters
  }

  List<RBushElement<MutableClusterOrPoint<T>>> getClusters(
      List<double> bbox, int zoom) {
    var projBBox = [
      util.lngX(bbox[0]),
      util.latY(bbox[3]),
      util.lngX(bbox[2]),
      util.latY(bbox[1])
    ];
    var clusters = trees[_limitZoom(zoom)].search(RBushBox(
      minX: projBBox[0],
      minY: projBBox[1],
      maxX: projBBox[2],
      maxY: projBBox[3],
    ));
    return clusters;
    //return clusters.map(getClusterJSON);
  }

  void remove(T point) {
    final mutablePoint = trees[maxZoom + 1].removePoint(point);
    if (mutablePoint == null) return;
    var rbushModification = RBushModification<T>(
      zoomCluster: trees[maxZoom + 1],
      removed: [mutablePoint],
      added: [],
    );

    for (int z = maxZoom; z >= minZoom; z--) {
      rbushModification = trees[z].recluster(rbushModification);
    }
  }

  void insert(T point) {
    trees[maxZoom + 1].addWithoutClustering(point);
    final x = util.lngX(getX(point));
    final y = util.latY(getY(point));

    for (int z = maxZoom; z >= minZoom; z--) {
      trees[z].update(trees[z + 1], x, y);
    }
  }

  List<MutableClusterOrPoint<T>> children(MutableCluster<T> cluster) {
    final r = radius / (extent * pow(2, cluster.zoom));

    return trees[cluster.zoom]
        .search(RBushBox(
          minX: cluster.x - r,
          minY: cluster.y - r,
          maxX: cluster.x + r,
          maxY: cluster.y + r,
        ))
        .where((element) => element.data.parentUuid == cluster.uuid)
        .map((e) => e.data)
        .toList();
  }

  int _limitZoom(int zoom) {
    return max(minZoom, min(zoom, maxZoom + 1));
  }

  List<MutableClusterOrPoint<T>> _cluster(
      List<RBushElement<MutableClusterOrPoint<T>>> points, int zoom) {
    final clusters = <MutableClusterOrPoint<T>>[];
    final r = radius / (extent * pow(2, zoom));

    // loop through each point
    for (var i = 0; i < points.length; i++) {
      var p = points[i].data;
      // if we've already visited the point at this zoom level, skip it
      if (p.zoom <= zoom) continue;
      p.zoom = zoom;

      final bboxNeighbors = trees[zoom + 1].search(RBushBox(
        minX: p.wX - r,
        minY: p.wY - r,
        maxX: p.wX + r,
        maxY: p.wY + r,
      ));

      final List<T> clusteredPoints = [];
      var numPoints = p.numPoints;
      var wx = p.wX * numPoints;
      var wy = p.wY * numPoints;
      MutableClusterDataBase? clusterData;
      final potentialClusterUuid = Uuid().v4();

      for (var j = 0; j < bboxNeighbors.length; j++) {
        var b = bboxNeighbors[j].data;
        // filter out neighbors that are too far or already processed
        if (zoom < b.zoom && util.distSq(p, b) <= r * r) {
          clusteredPoints.addAll(
            b.map(
              cluster: (cluster) => cluster.originalPoints,
              point: (point) => [point.originalPoint],
            ),
          );
          b.parentUuid = potentialClusterUuid;
          b.zoom = zoom; // save the zoom (so it doesn't get processed twice)
          wx += b.wX *
              b.numPoints; // accumulate coordinates for calculating weighted center
          wy += b.wY * b.numPoints;
          numPoints += b.numPoints;

          if (extractClusterData != null) {
            clusterData ??= _extractClusterData(p);
            clusterData = clusterData.combine(_extractClusterData(b));
          }
        }
      }

      if (clusteredPoints.isEmpty) {
        clusters.add(p); // no neighbors, add a single point as cluster
        p.lowestZoom = zoom;
        continue;
      }

      // form a cluster with neighbors
      p.parentUuid = potentialClusterUuid;
      final cluster = MutableClusterOrPoint.initializeCluster(
        uuid: potentialClusterUuid,
        x: p.x,
        y: p.y,
        points: clusteredPoints
          ..insertAll(
              0,
              p.map(
                  cluster: (cluster) => cluster.originalPoints,
                  point: (point) => [point.originalPoint])),
        zoom: zoom,
        clusterData: clusterData,
      );

      // save weighted cluster center for display
      cluster.wX = wx / numPoints;
      cluster.wY = wy / numPoints;

      clusters.add(cluster);
    }

    return clusters;
  }

  MutableClusterDataBase _extractClusterData(
      MutableClusterOrPoint<T> clusterOrPoint) {
    return clusterOrPoint.map(
        cluster: (cluster) => cluster.clusterData!,
        point: (mapPoint) => extractClusterData!(mapPoint.originalPoint));
  }
}
