import 'dart:math';

import 'package:rbush/rbush.dart';
import 'package:supercluster/src/mutable/layer_clusterer.dart';
import 'package:supercluster/src/mutable/mutable_layer.dart';
import 'package:uuid/uuid.dart';

import '../../supercluster.dart';
import '../util.dart' as util;
import 'layer_element_modification.dart';

class SuperclusterMutable<T> extends Supercluster<T> {
  late final List<MutableLayer<T>> _trees;
  late final LayerClusterer<T> _layerClusterer;

  late final String Function() generateUuid;

  SuperclusterMutable({
    required super.getX,
    required super.getY,
    String Function()? generateUuid,
    super.minZoom,
    super.maxZoom,
    super.minPoints,
    super.radius,
    super.extent,
    super.nodeSize = 16,
    super.extractClusterData,
  })  : assert(minPoints == null || minPoints > 1),
        generateUuid = generateUuid ?? (() => Uuid().v4()) {
    _layerClusterer = LayerClusterer(
      minPoints: minPoints,
      radius: radius,
      extent: extent,
      extractClusterData: extractClusterData,
      generateUuid: generateUuid ?? () => Uuid().v4(),
    );

    _trees = List.generate(
      maxZoom + 2,
      (i) => MutableLayer<T>(
        nodeSize: nodeSize,
        zoom: i,
        searchRadius: util.searchRadius(radius, extent, i),
      ),
    );
  }

  List<T> get points => _trees[maxZoom + 1]
      .all()
      .map((e) => (e as MutableLayerPoint<T>).originalPoint)
      .toList();

  /// Replace any existing points with [points] and form clusters.
  @override
  void load(List<T> points) {
    // generate a cluster object for each point
    var clusters = points
        .map((point) => _initializePoint(point).positionRBushPoint())
        .toList();

    _trees[maxZoom + 1].load(clusters);

    // cluster points on max zoom, then cluster the results on previous zoom, etc.;
    // results in a cluster hierarchy across zoom levels
    for (var z = maxZoom; z >= minZoom; z--) {
      clusters = _layerClusterer
          .cluster(clusters, z, _trees[z + 1])
          .map((c) => c.positionRBushPoint())
          .toList(); // create a new set of clusters for the zoom
      _trees[z].load(clusters); // index input points into an R-tree
    }
  }

  @override
  List<MutableLayerElement<T>> search(
    double westLng,
    double southLat,
    double eastLng,
    double northLat,
    int zoom,
  ) {
    return _trees[_limitZoom(zoom)]
        .search(
          RBushBox(
            minX: util.lngX(westLng),
            minY: util.latY(northLat),
            maxX: util.lngX(eastLng),
            maxY: util.latY(southLat),
          ),
        )
        .map((e) => e.data)
        .toList();
  }

  @override
  Iterable<T> getLeaves() => _trees[maxZoom + 1]
      .all()
      .map((e) => (e as MutableLayerPoint<T>).originalPoint);

  /// An optimised function for changing a single point's data without changing
  /// the position of that point. Returns true if [oldPoint] is found and
  /// replaced.
  bool modifyPointData(T oldPoint, T newPoint,
      {bool updateParentClusters = true}) {
    assert(
        getX(oldPoint) == getX(newPoint) && getY(oldPoint) == getY(newPoint));

    final baseLayerModification = _trees[maxZoom + 1]
        .removePointWithoutClustering(_initializePoint(oldPoint));

    if (baseLayerModification.removed.isEmpty) return false;
    final oldLayerPoint =
        baseLayerModification.removed.single as MutableLayerPoint<T>;

    final newLayerPoint = oldLayerPoint.copyWith(
      originalPoint: newPoint,
      clusterData: extractClusterData?.call(newPoint),
    );
    _trees[maxZoom + 1].addPointWithoutClustering(
      newLayerPoint,
      updateZooms: false,
    );

    final layerElementModifications = <LayerElementModification<T>>[
      LayerElementModification(
        layer: _trees[maxZoom + 1],
        oldLayerElement: oldLayerPoint,
        newLayerElement: newLayerPoint,
      ),
    ];

    final stopAtZoom = updateParentClusters
        ? minZoom
        : layerElementModifications.last.oldLayerElement.lowestZoom;

    for (int z = maxZoom; z >= stopAtZoom; z--) {
      layerElementModifications.add(
        _trees[z].modifyElementAndAncestors(
          _layerClusterer,
          layerElementModifications.last,
        ),
      );
    }

    return true;
  }

  /// Remove [point]. Returns true if the specified point is found and removed.
  /// Note that this may cause clusters to be split/changed.
  bool remove(T point) {
    final layerModifications = <LayerModification<T>>[];
    layerModifications.add(_trees[maxZoom + 1]
        .removePointWithoutClustering(_initializePoint(point)));
    if (layerModifications.single.removed.isEmpty) return false;

    for (int z = maxZoom; z >= minZoom; z--) {
      layerModifications
          .add(_trees[z].removeElementsAndAncestors(layerModifications.last));
    }

    layerModifications
        .expand<MutableLayerElement<T>>((modification) =>
            List.from(modification.removed)..addAll(modification.orphaned))
        .forEach((element) {
      element.parentUuid = null;
    });

    for (int z = maxZoom; z >= minZoom; z--) {
      final layerRemoval = layerModifications[maxZoom + 1 - z];

      _trees[z]
          .rebuildLayer(_layerClusterer, _trees[z + 1], layerRemoval.removed);
    }

    return true;
  }

  /// Insert [point]. Note that this may cause clusters to be created/changed.
  void insert(T point) {
    final layerPoint = _initializePoint(point);
    _trees[maxZoom + 1].addPointWithoutClustering(layerPoint);

    int lowestZoomWhereInsertionDoesNotCluster = maxZoom + 1;
    List<MutableLayerElement<T>> elementsToClusterWith = [];

    for (int z = maxZoom; z >= minZoom; z--) {
      elementsToClusterWith = _trees[z].elementsToClusterWith(layerPoint);
      if (elementsToClusterWith.isEmpty) {
        lowestZoomWhereInsertionDoesNotCluster = z;
        _trees[z].addPointWithoutClustering(layerPoint);
        continue;
      } else {
        break;
      }
    }

    final int firstClusteringZoom = lowestZoomWhereInsertionDoesNotCluster - 1;

    if (firstClusteringZoom < minZoom) return;

    final removalElements = elementsToClusterWith.length == 1 &&
            elementsToClusterWith.single is MutableLayerCluster<T>
        ? _trees[firstClusteringZoom + 1]
            .descendants(elementsToClusterWith.single as MutableLayerCluster<T>)
        : elementsToClusterWith;

    final layerModifications = [
      _trees[firstClusteringZoom].removeElementsAndAncestors(
        LayerModification(layer: _trees[firstClusteringZoom + 1])
          ..recordRemovals(removalElements),
      )
    ];

    for (int z = firstClusteringZoom - 1; z >= minZoom; z--) {
      layerModifications
          .add(_trees[z].removeElementsAndAncestors(layerModifications.last));
    }

    layerModifications
        .expand<MutableLayerElement<T>>((modification) =>
            List.from(modification.removed)..addAll(modification.orphaned))
        .forEach((element) {
      element.parentUuid = null;
    });

    for (int z = firstClusteringZoom; z >= minZoom; z--) {
      final layerRemoval = layerModifications[firstClusteringZoom - z];

      _trees[z]
          .rebuildLayer(_layerClusterer, _trees[z + 1], layerRemoval.removed);
    }
  }

  List<MutableLayerElement<T>> childrenOf(MutableLayerCluster<T> cluster) {
    final r = util.searchRadius(radius, extent, cluster.highestZoom);

    return _trees[cluster.lowestZoom + 1]
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

  @override
  ClusterDataBase? aggregatedClusterData() {
    final topLevelClusterData = _trees[minZoom].all().map((e) => e.clusterData);

    return topLevelClusterData.isEmpty
        ? null
        : topLevelClusterData
            .reduce((value, element) => value?.combine(element!));
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
