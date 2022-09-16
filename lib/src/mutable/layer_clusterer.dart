import 'package:rbush/rbush.dart';

import '../cluster_data_base.dart';
import '../util.dart' as util;
import 'mutable_layer.dart';
import 'mutable_layer_element.dart';

class LayerClusterer<T> {
  final int radius;
  final int extent;
  final ClusterDataBase Function(T point)? extractClusterData;
  final String Function() generateUuid;

  LayerClusterer({
    required this.radius,
    required this.extent,
    required this.generateUuid,
    this.extractClusterData,
  });

  List<MutableLayerElement<T>> cluster(
      List<RBushElement<MutableLayerElement<T>>> points,
      int zoom,
      MutableLayer<T> previousLayer) {
    final clusters = <MutableLayerElement<T>>[];

    final r = util.searchRadius(radius, extent, zoom);

    // loop through each point
    for (var i = 0; i < points.length; i++) {
      var p = points[i].data;
      // if we've already visited the point at this zoom level, skip it
      if (p.visitedAtZoom <= zoom) continue;
      p.visitedAtZoom = zoom;

      final bboxNeighbors = previousLayer.search(RBushBox(
        minX: p.wX - r,
        minY: p.wY - r,
        maxX: p.wX + r,
        maxY: p.wY + r,
      ));

      var numPoints = p.numPoints;
      var wx = p.wX * numPoints;
      var wy = p.wY * numPoints;
      ClusterDataBase? clusterData;
      final potentialClusterUuid = generateUuid();

      for (var j = 0; j < bboxNeighbors.length; j++) {
        var b = bboxNeighbors[j].data;
        // filter out neighbors that are too far or already processed
        if (zoom < b.visitedAtZoom && util.distSq(p, b) <= r * r) {
          b.parentUuid = potentialClusterUuid;
          b.visitedAtZoom =
              zoom; // save the zoom (so it doesn't get processed twice)
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

      if (numPoints == p.numPoints) {
        p.lowestZoom = zoom;
        clusters.add(p); // no neighbors, add a single point as cluster
        continue;
      }

      // form a cluster with neighbors
      p.parentUuid = potentialClusterUuid;
      final cluster = MutableLayerElement.initializeCluster<T>(
        uuid: potentialClusterUuid,
        x: p.x,
        y: p.y,
        childPointCount: numPoints,
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

  ClusterDataBase _extractClusterData(MutableLayerElement<T> clusterOrPoint) {
    return clusterOrPoint.map(
        cluster: (cluster) => cluster.clusterData!,
        point: (mapPoint) => extractClusterData!(mapPoint.originalPoint));
  }
}
