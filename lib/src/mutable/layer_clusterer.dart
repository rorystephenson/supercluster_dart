import 'package:rbush/rbush.dart';
import 'package:supercluster/src/mutable/boundary_extensions.dart';

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

  List<RBushElement<MutableLayerElement<T>>> newClusterElements(
    RBushElement<MutableLayerElement<T>> layerPoint,
    MutableLayer<T> layer,
    MutableLayer<T> childLayer,
  ) {
    final r2 = layer.r2;
    final potentialClusterElements = childLayer
        .search(layerPoint.expandBy(layer.r))
        .where((element) =>
            _closeEnoughToCluster(layerPoint.data, element.data, r2))
        .toList();

    if (potentialClusterElements.fold(
            0, (acc, el) => acc + el.data.numPoints) >=
        minPoints) {
      return potentialClusterElements;
    }
    return [];
  }

  List<RBushElement<MutableLayerElement<T>>> cluster(
    Iterable<RBushElement<MutableLayerElement<T>>> points,
    int zoom,
    MutableLayer<T> layer,
    MutableLayer<T> previousLayer,
  ) {
    final clusters = <RBushElement<MutableLayerElement<T>>>[];

    for (final point in points) {
      final data = point.data;
      // If we've already visited the point at this zoom level, skip it.
      if (data.visitedAtZoom <= zoom) continue;
      data.visitedAtZoom = zoom;

      final neighbors = previousLayer.search(data.paddedBoundary(layer.r));

      final clusterableNeighbors = <MutableLayerElement<T>>[];

      var numPoints = data.numPoints;
      var wx = data.x * data.numPoints;
      var wy = data.y * data.numPoints;

      for (final neighbor in neighbors) {
        var b = neighbor.data;
        // Filter out neighbors that are too far or already processed
        if (zoom < b.visitedAtZoom &&
            _closeEnoughToCluster(data, b, layer.r2)) {
          clusterableNeighbors.add(b);
          numPoints += b.numPoints;
        }
      }

      if (numPoints == data.numPoints || numPoints < minPoints) {
        // No neighbors, add a single point as cluster
        data.lowestZoom = zoom;
        data.parentUuid = null;
        clusters.add(point);
      } else {
        final clusterId = generateUuid();
        ClusterDataBase? clusterData;
        for (final clusterableNeighbor in clusterableNeighbors) {
          clusterableNeighbor.parentUuid = clusterId;
          clusterableNeighbor.visitedAtZoom =
              zoom; // save the zoom (so it doesn't get processed twice)
          wx += clusterableNeighbor.x * clusterableNeighbor.numPoints;
          wy += clusterableNeighbor.y * clusterableNeighbor.numPoints;

          if (extractClusterData != null) {
            clusterData ??= _extractClusterData(data);
            clusterData =
                clusterData.combine(_extractClusterData(clusterableNeighbor));
          }
        }

        // form a cluster with neighbors
        data.parentUuid = clusterId;
        final cluster = MutableLayerElement.initializeCluster<T>(
          uuid: clusterId,
          x: wx / numPoints,
          y: wy / numPoints,
          originX: data.x,
          originY: data.y,
          childPointCount: numPoints,
          zoom: zoom,
          clusterData: clusterData,
        );

        clusters.add(cluster.indexRBushPoint());
      }
    }

    return clusters;
  }

  ClusterDataBase _extractClusterData(MutableLayerElement<T> clusterOrPoint) {
    return clusterOrPoint.map(
        cluster: (cluster) => cluster.clusterData!,
        point: (mapPoint) => extractClusterData!(mapPoint.originalPoint));
  }

  bool _closeEnoughToCluster(
    MutableLayerElement<T> a,
    MutableLayerElement<T> b,
    double r2,
  ) =>
      util.distSq(a, b) <= r2;
}
