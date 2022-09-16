import 'dart:math';

import 'package:rbush/rbush.dart';
import 'package:supercluster/src/mutable/layer_clusterer.dart';
import 'package:supercluster/src/mutable/mutable_layer.dart';
import 'package:uuid/uuid.dart';

import '../cluster_data_base.dart';
import '../supercluster.dart';
import '../util.dart' as util;
import 'layer_element_modification.dart';
import 'layer_modification.dart';
import 'mutable_layer_element.dart';

class SuperclusterMutable<T> extends Supercluster<T> {
  final double Function(T) getX;
  final double Function(T) getY;
  final int maxEntries;

  final int minZoom;
  final int maxZoom;
  final int radius;
  final int extent;
  final int nodeSize;

  late final String Function() generateUuid;

  final ClusterDataBase Function(T point)? extractClusterData;

  final LayerClusterer<T> _layerClusterer;
  late final List<MutableLayer<T>> trees;

  /// An optional function which will be called whenever the aggregated cluster
  /// data of all points changes. Note that this will only be calculated if the
  /// callback is provided.
  final void Function(ClusterDataBase? aggregatedClusterData)?
      onClusterDataChange;

  SuperclusterMutable({
    required this.getX,
    required this.getY,
    required this.maxEntries,
    String Function()? generateUuid,
    int? minZoom,
    int? maxZoom,
    int? radius,
    int? extent,
    int? nodeSize,
    this.extractClusterData,
    this.onClusterDataChange,
  })  : minZoom = minZoom ?? 0,
        maxZoom = maxZoom ?? 16,
        radius = radius ?? 40,
        extent = extent ?? 512,
        nodeSize = nodeSize ?? 64,
        _layerClusterer = LayerClusterer(
          radius: radius ?? 40,
          extent: extent ?? 512,
          extractClusterData: extractClusterData,
          generateUuid: generateUuid ?? () => Uuid().v4(),
        ),
        generateUuid = generateUuid ?? (() => Uuid().v4()) {
    trees = List.generate(
      (maxZoom ?? 16) + 2,
      (i) => MutableLayer<T>(
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
    _onPointsChanged();
  }

  @override
  Iterable<MutableLayerElement<T>> search(
    double westLng,
    double southLat,
    double eastLng,
    double northLat,
    int zoom,
  ) {
    return trees[_limitZoom(zoom)]
        .search(
          RBushBox(
            minX: util.lngX(westLng),
            minY: util.latY(northLat),
            maxX: util.lngX(eastLng),
            maxY: util.latY(southLat),
          ),
        )
        .map((e) => e.data);
  }

  @override
  Iterable<T> getLeaves() => trees[maxZoom + 1]
      .all()
      .map((e) => (e as MutableLayerPoint<T>).originalPoint);

  /// An optimised function for changing a single point's data without changing
  /// the position of that point.
  void modifyPointData(T oldPoint, T newPoint,
      {bool updateParentClusters = true}) {
    assert(
        getX(oldPoint) == getX(newPoint) && getY(oldPoint) == getY(newPoint));

    final baseLayerModification = trees[maxZoom + 1]
        .removePointWithoutClustering(_initializePoint(oldPoint));

    if (baseLayerModification.removed.isEmpty) return;
    final oldLayerPoint =
        baseLayerModification.removed.single as MutableLayerPoint<T>;

    final newLayerPoint = oldLayerPoint.copyWith(
      originalPoint: newPoint,
      clusterData: extractClusterData?.call(newPoint),
    );
    trees[maxZoom + 1].addPointWithoutClustering(
      newLayerPoint,
      updateZooms: false,
    );

    final layerElementModifications = <LayerElementModification<T>>[
      LayerElementModification(
        layer: trees[maxZoom + 1],
        oldLayerElement: oldLayerPoint,
        newLayerElement: newLayerPoint,
      ),
    ];

    final stopAtZoom = updateParentClusters
        ? minZoom
        : layerElementModifications.last.oldLayerElement.lowestZoom;

    for (int z = maxZoom; z >= stopAtZoom; z--) {
      layerElementModifications.add(
        trees[z].modifyElementAndAncestors(
          _layerClusterer,
          layerElementModifications.last,
        ),
      );
    }

    _onPointsChanged();
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
        .expand<MutableLayerElement<T>>((modification) =>
            List.from(modification.removed)..addAll(modification.orphaned))
        .forEach((element) {
      element.parentUuid = null;
    });

    for (int z = maxZoom; z >= minZoom; z--) {
      final layerRemoval = layerModifications[maxZoom + 1 - z];

      trees[z]
          .rebuildLayer(_layerClusterer, trees[z + 1], layerRemoval.removed);
    }

    _onPointsChanged();
  }

  void insert(T point) {
    final layerPoint = _initializePoint(point);
    trees[maxZoom + 1].addPointWithoutClustering(layerPoint);

    int lowestZoomWhereInsertionDoesNotCluster = maxZoom + 1;
    List<MutableLayerElement<T>> elementsToClusterWith = [];

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

    if (firstClusteringZoom < minZoom) {
      _onPointsChanged();
      return;
    }

    final removalElements = elementsToClusterWith.length == 1 &&
            elementsToClusterWith.single is MutableLayerCluster<T>
        ? trees[firstClusteringZoom + 1]
            .descendants(elementsToClusterWith.single as MutableLayerCluster<T>)
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
        .expand<MutableLayerElement<T>>((modification) =>
            List.from(modification.removed)..addAll(modification.orphaned))
        .forEach((element) {
      element.parentUuid = null;
    });

    for (int z = firstClusteringZoom; z >= minZoom; z--) {
      final layerRemoval = layerModifications[firstClusteringZoom - z];

      trees[z]
          .rebuildLayer(_layerClusterer, trees[z + 1], layerRemoval.removed);
    }

    _onPointsChanged();
  }

  List<MutableLayerElement<T>> childrenOf(MutableLayerCluster<T> cluster) {
    final r = util.searchRadius(radius, extent, cluster.highestZoom);

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

  void _onPointsChanged() {
    if (onClusterDataChange == null) return;

    final topLevelClusterData = trees[minZoom].all().map((e) => e.clusterData);

    final aggregatedData = topLevelClusterData.isEmpty
        ? null
        : topLevelClusterData
            .reduce((value, element) => value?.combine(element!));

    onClusterDataChange!.call(aggregatedData);
  }

  int _limitZoom(int zoom) {
    return max(minZoom, min(zoom, maxZoom + 1));
  }

  MutableLayerPoint<T> _initializePoint(T originalPoint) =>
      MutableLayerElement.initializePoint(
        uuid: generateUuid(),
        point: originalPoint,
        lon: getX(originalPoint),
        lat: getY(originalPoint),
        clusterData: extractClusterData?.call(originalPoint),
        zoom: maxZoom + 1,
      );
}
