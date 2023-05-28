import 'package:rbush/rbush.dart';

import '../cluster_data_base.dart';
import '../util.dart' as util;
import 'mutable_layer.dart';
import 'mutable_layer_element.dart';

class LayerClusterer<T> {
  final int minPoints;
  final int radius;
  final int extent;
  final ClusterDataBase Function(T point)? extractClusterData;
  final String Function() generateUuid;

  LayerClusterer({
    required this.minPoints,
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

      final neighbors = previousLayer.search(RBushBox(
        minX: p.x - r,
        minY: p.y - r,
        maxX: p.x + r,
        maxY: p.y + r,
      ));

      final clusterableNeighbors = <MutableLayerElement<T>>[];

      var numPoints = p.numPoints;
      var wx = p.x * p.numPoints;
      var wy = p.y * p.numPoints;
      final potentialClusterUuid = generateUuid();

      for (final neighbor in neighbors) {
        var b = neighbor.data;
        // Filter out neighbors that are too far or already processed
        if (zoom < b.visitedAtZoom && util.distSq(p, b) <= r * r) {
          clusterableNeighbors.add(b);
          numPoints += b.numPoints;
        }
      }

      if (numPoints == p.numPoints || numPoints < minPoints) {
        // No neighbors, add a single point as cluster
        p.lowestZoom = zoom;
        clusters.add(p);
      } else {
        ClusterDataBase? clusterData;
        for (final clusterableNeighbor in clusterableNeighbors) {
          clusterableNeighbor.parentUuid = potentialClusterUuid;
          clusterableNeighbor.visitedAtZoom =
              zoom; // save the zoom (so it doesn't get processed twice)
          wx += clusterableNeighbor.x * clusterableNeighbor.numPoints;
          wy += clusterableNeighbor.y * clusterableNeighbor.numPoints;

          if (extractClusterData != null) {
            clusterData ??= _extractClusterData(p);
            clusterData =
                clusterData.combine(_extractClusterData(clusterableNeighbor));
          }
        }

        // form a cluster with neighbors
        p.parentUuid = potentialClusterUuid;
        final cluster = MutableLayerElement.initializeCluster<T>(
          uuid: potentialClusterUuid,
          x: wx / numPoints,
          y: wy / numPoints,
          originX: p.x,
          originY: p.y,
          childPointCount: numPoints,
          zoom: zoom,
          clusterData: clusterData,
        );

        clusters.add(cluster);
      }
    }

    return clusters;
  }

  ClusterDataBase _extractClusterData(MutableLayerElement<T> clusterOrPoint) {
    return clusterOrPoint.map(
        cluster: (cluster) => cluster.clusterData!,
        point: (mapPoint) => extractClusterData!(mapPoint.originalPoint));
  }
}
