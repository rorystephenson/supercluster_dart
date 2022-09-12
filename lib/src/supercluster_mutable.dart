import 'dart:math';

import 'package:rbush/rbush.dart';
import 'package:supercluster/src/layer.dart';
import 'package:supercluster/src/layer_clusterer.dart';

import './util.dart' as util;
import 'cluster_data_base.dart';
import 'layer_element.dart';
import 'layer_modification.dart';

class SuperclusterMutable<T> {
  final double Function(T) getX;
  final double Function(T) getY;
  final int maxEntries;

  final int minZoom;
  final int maxZoom;
  final int radius;
  final int extent;
  final int nodeSize;

  final ClusterDataBase Function(T point)? extractClusterData;

  final LayerClusterer<T> _layerClusterer;
  late final List<Layer<T>> trees;

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
        nodeSize = nodeSize ?? 64,
        _layerClusterer = LayerClusterer(
          radius: radius ?? 40,
          extent: extent ?? 512,
          extractClusterData: extractClusterData,
        ) {
    trees = List.generate(
      (maxZoom ?? 16) + 2,
      (i) => Layer<T>(
        zoom: i,
        searchRadius: util.searchRadius(radius ?? 40, extent ?? 512, i),
        maxPoints: maxEntries,
      ),
    );
  }

  void load(List<T> points) {
    // generate a cluster object for each point
    var clusters = points
        .map((point) => _initializePoint(point).positionRBushPoint())
        .toList();

    trees[maxZoom + 1].load(clusters);

    // cluster points on max zoom, then cluster the results on previous zoom, etc.;
    // results in a cluster hierarchy across zoom levels
    for (var z = maxZoom; z >= minZoom; z--) {
      clusters = _layerClusterer
          .cluster(clusters, z, trees[z + 1])
          .map((c) => c.positionRBushPoint())
          .toList(); // create a new set of clusters for the zoom
      trees[z].load(clusters); // index input points into an R-tree
    }
  }

  List<RBushElement<LayerElement<T>>> getClusters(List<double> bbox, int zoom) {
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
  }

  void remove(T point) {
    final layerModifications = <LayerModification<T>>[];
    layerModifications.add(trees[maxZoom + 1]
        .removePointWithoutClustering(_initializePoint(point)));
    if (layerModifications.single.removed.isEmpty) return;

    for (int z = maxZoom; z >= minZoom; z--) {
      layerModifications
          .add(trees[z].removeElementsAndAncestors(layerModifications.last));
    }

    layerModifications
        .expand<LayerElement<T>>((modification) =>
            List.from(modification.removed)..addAll(modification.orphaned))
        .forEach((element) {
      element.parentUuid = null;
    });

    for (int z = maxZoom; z >= minZoom; z--) {
      final layerRemoval = layerModifications[maxZoom + 1 - z];

      trees[z]
          .rebuildLayer(_layerClusterer, trees[z + 1], layerRemoval.removed);
    }
  }

  void insert(T point) {
    final layerPoint =
        trees[maxZoom + 1].addPointWithoutClustering(_initializePoint(point));

    int lowestZoomWhereInsertionDoesNotCluster = maxZoom + 1;
    List<LayerElement<T>> elementsToClusterWith = [];

    for (int z = maxZoom; z >= minZoom; z--) {
      elementsToClusterWith = trees[z].elementsToClusterWith(layerPoint);
      if (elementsToClusterWith.isEmpty) {
        lowestZoomWhereInsertionDoesNotCluster = z;
        trees[z].addPointWithoutClustering(layerPoint);
        continue;
      } else {
        break;
      }
    }

    final int firstClusteringZoom = lowestZoomWhereInsertionDoesNotCluster - 1;

    if (firstClusteringZoom < minZoom) return;

    final removalElements = elementsToClusterWith.length == 1 &&
            elementsToClusterWith.single is LayerCluster<T>
        ? trees[firstClusteringZoom + 1]
            .descendants(elementsToClusterWith.single as LayerCluster<T>)
        : elementsToClusterWith;

    final layerModifications = [
      trees[firstClusteringZoom].removeElementsAndAncestors(
        LayerModification(layer: trees[firstClusteringZoom + 1])
          ..recordRemovals(removalElements),
      )
    ];

    for (int z = firstClusteringZoom - 1; z >= minZoom; z--) {
      layerModifications
          .add(trees[z].removeElementsAndAncestors(layerModifications.last));
    }

    layerModifications
        .expand<LayerElement<T>>((modification) =>
            List.from(modification.removed)..addAll(modification.orphaned))
        .forEach((element) {
      element.parentUuid = null;
    });

    for (int z = firstClusteringZoom; z >= minZoom; z--) {
      final layerRemoval = layerModifications[firstClusteringZoom - z];

      trees[z]
          .rebuildLayer(_layerClusterer, trees[z + 1], layerRemoval.removed);
    }
  }

  List<LayerElement<T>> children(LayerCluster<T> cluster) {
    final r = util.searchRadius(radius, extent, cluster.zoom);

    return trees[cluster.lowestZoom + 1]
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

  LayerPoint<T> _initializePoint(T originalPoint) =>
      LayerElement.initializePoint(
        point: originalPoint,
        lon: getX(originalPoint),
        lat: getY(originalPoint),
        clusterData: extractClusterData?.call(originalPoint),
        zoom: maxZoom + 1,
      );
}
