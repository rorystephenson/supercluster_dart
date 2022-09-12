import 'package:rbush/rbush.dart';

import 'cluster_data_base.dart';
import 'layer.dart';
import 'layer_element.dart';
import 'util.dart' as util;
import 'uuid_stub.dart';

class LayerClusterer<T> {
  final int radius;
  final int extent;
  final ClusterDataBase Function(T point)? extractClusterData;

  LayerClusterer({
    required this.radius,
    required this.extent,
    this.extractClusterData,
  });

  List<LayerElement<T>> cluster(List<RBushElement<LayerElement<T>>> points,
      int zoom, Layer<T> previousLayer) {
    final clusters = <LayerElement<T>>[];

    final r = util.searchRadius(radius, extent, zoom);

    // loop through each point
    for (var i = 0; i < points.length; i++) {
      var p = points[i].data;
      // if we've already visited the point at this zoom level, skip it
      if (p.zoom <= zoom) continue;
      p.zoom = zoom;

      final bboxNeighbors = previousLayer.search(RBushBox(
        minX: p.wX - r,
        minY: p.wY - r,
        maxX: p.wX + r,
        maxY: p.wY + r,
      ));

      final List<T> clusteredPoints = [];
      var numPoints = p.numPoints;
      var wx = p.wX * numPoints;
      var wy = p.wY * numPoints;
      ClusterDataBase? clusterData;
      final potentialClusterUuid = UuidStub.v4(); // TODO Uuid().v4();

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
        continue;
      }

      // form a cluster with neighbors
      p.parentUuid = potentialClusterUuid;
      final cluster = LayerElement.initializeCluster(
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

  ClusterDataBase _extractClusterData(LayerElement<T> clusterOrPoint) {
    return clusterOrPoint.map(
        cluster: (cluster) => cluster.clusterData!,
        point: (mapPoint) => extractClusterData!(mapPoint.originalPoint));
  }
}
