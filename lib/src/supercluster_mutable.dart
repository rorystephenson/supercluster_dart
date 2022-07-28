import 'dart:math';

import 'package:rbush/rbush.dart';
import 'package:supercluster/src/cluster_rbush.dart';
import 'package:supercluster/src/util.dart';

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

  final List<ClusterRBush<T>> trees;

  SuperclusterMutable({
    required this.getX,
    required this.getY,
    required this.maxEntries,
    int? minZoom,
    int? maxZoom,
    int? radius,
    int? extent,
    int? nodeSize,
  })  : minZoom = minZoom ?? 0,
        maxZoom = maxZoom ?? 16,
        radius = radius ?? 40,
        extent = extent ?? 512,
        nodeSize = nodeSize ?? 64,
        trees = List.generate(
          (maxZoom ?? 16) + 2,
          (_) => ClusterRBush<T>(
            getX: getX,
            getY: getY,
            maxPoints: maxEntries,
          ),
        );

  void load(List<T> points) {
    // generate a cluster object for each point
    var clusters = points
        .map((point) => _createRBushElement(_createMutablePoint(point)))
        .toList();

    // cluster points on max zoom, then cluster the results on previous zoom, etc.;
    // results in a cluster hierarchy across zoom levels
    for (var z = maxZoom; z >= minZoom; z--) {
      trees[z + 1].load(clusters); // index input points into an R-tree
      clusters = _cluster(clusters, z)
          .map(_createRBushElement)
          .toList(); // create a new set of clusters for the zoom

    }
    trees[minZoom].load(clusters); // index top-level clusters
  }

  RBushElement<MutableClusterOrPoint<T>> _createRBushElement(
          MutableClusterOrPoint<T> pointCluster) =>
      RBushElement(
        minX: pointCluster.x,
        minY: pointCluster.y,
        maxX: pointCluster.x,
        maxY: pointCluster.y,
        data: pointCluster,
      );

  List<RBushElement<MutableClusterOrPoint<T>>> getClusters(
      List<double> bbox, int zoom) {
    var projBBox = [
      _lngX(bbox[0]),
      _latY(bbox[3]),
      _lngX(bbox[2]),
      _latY(bbox[1])
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
    for (final tree in trees) {
      tree.remove(point);
    }
  }

  int _limitZoom(int zoom) {
    return max(minZoom, min(zoom, maxZoom + 1));
  }

  List<MutableClusterOrPoint<T>> _cluster(
      List<RBushElement<MutableClusterOrPoint<T>>> points, int zoom) {
    final clusters = <MutableClusterOrPoint<T>>[];
    final r = radius / (extent * pow(2, zoom));
    final bbox = <double>[0, 0, 0, 0];

    // loop through each point
    for (var i = 0; i < points.length; i++) {
      var p = points[i].data;
      // if we've already visited the point at this zoom level, skip it
      if (p.zoom <= zoom) continue;
      p.zoom = zoom;

      // find all nearby points with a bbox search
      bbox[0] = p.wX - r;
      bbox[1] = p.wY - r;
      bbox[2] = p.wX + r;
      bbox[3] = p.wY + r;
      var bboxNeighbors = trees[zoom + 1].search(RBushBox(
        minX: bbox[0],
        minY: bbox[1],
        maxX: bbox[2],
        maxY: bbox[3],
      ));

      final List<T> neighbors = [];
      var numPoints = p.numPoints;
      var wx = p.wX * numPoints;
      var wy = p.wY * numPoints;

      for (var j = 0; j < bboxNeighbors.length; j++) {
        var b = bboxNeighbors[j].data;
        // filter out neighbors that are too far or already processed
        if (zoom < b.zoom && _distSq(p, b) <= r * r) {
          neighbors.addAll(b.map(
              cluster: (cluster) => cluster.originalPoints,
              point: (point) => [point.originalPoint]));
          b.zoom = zoom; // save the zoom (so it doesn't get processed twice)
          wx += b.wX *
              b.numPoints; // accumulate coordinates for calculating weighted center
          wy += b.wY * b.numPoints;
          numPoints += b.numPoints;
        }
      }

      if (neighbors.isEmpty) {
        clusters.add(p); // no neighbors, add a single point as cluster
        continue;
      }

      // form a cluster with neighbors
      final cluster = _createMutableCluster(p.x, p.y, neighbors);

      // save weighted cluster center for display
      cluster.wX = wx / numPoints;
      cluster.wY = wy / numPoints;

      clusters.add(cluster);
    }

    return clusters;
  }

  MutableCluster<T> _createMutableCluster(double x, double y, List<T> points) {
    return MutableCluster<T>(
      x: x,
      y: y,
      wX: x,
      wY: y,
      // Max web-safe int
      zoom: 9007199254740991,
      originalPoints: points,
    );
  }

  MutablePoint<T> _createMutablePoint(T point) {
    final x = lngX(getX(point));
    final y = latY(getY(point));

    return MutablePoint(
      originalPoint: point,
      x: x,
      y: y,
      wX: x,
      wY: y,
    );
  }

//  void getClusterJSON(cluster) {
//    return cluster.point
//        ? cluster.point
//        : {
//            type: 'Feature',
//            properties: getClusterProperties(cluster),
//            geometry: {
//              type: 'Point',
//              coordinates: [xLng(cluster.wx), yLat(cluster.wy)]
//            }
//          };
//  }

//  void getClusterProperties(cluster) {
//    var count = cluster.numPoints;
//    var abbrev = count >= 10000
//        ? (count / 1000) + 'k'
//        : count >= 1000
//            ? ((count / 100) / 10) + 'k'
//            : count;
//    return {cluster: true, point_count: count, point_count_abbreviated: abbrev};
//  }

  // longitude/latitude to spherical mercator in [0..1] range
  double _lngX(double lng) {
    return lng / 360 + 0.5;
  }

  double _latY(double lat) {
    var sinVal = sin(lat * pi / 180),
        y = (0.5 - 0.25 * log((1 + sinVal) / (1 - sinVal)) / pi);
    return y < 0
        ? 0
        : y > 1
            ? 1
            : y;
  }

  // spherical mercator to longitude/latitude
  double _xLng(x) {
    return (x - 0.5) * 360;
  }

  double _yLat(y) {
    var y2 = (180 - y * 360) * pi / 180;
    return 360 * atan(exp(y2)) / pi - 90;
  }

  // squared distance between two points
  double _distSq(MutableClusterOrPoint<T> a, MutableClusterOrPoint<T> b) {
    var dx = a.wX - b.wX;
    var dy = a.wY - b.wY;
    return dx * dx + dy * dy;
  }
}
