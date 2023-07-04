import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rbush/rbush.dart';
import 'package:supercluster/src/mutable/layer_clusterer.dart';
import 'package:supercluster/src/mutable/mutable_layer.dart';
import 'package:supercluster/src/mutable/rbush_element_set.dart';
import 'package:supercluster/src/mutable/rbush_point.dart';
import 'package:uuid/uuid.dart';

import '../../supercluster.dart';
import '../util.dart' as util;
import 'layer_element_modification.dart';

class SuperclusterMutable<T> extends Supercluster<T> {
  late final Uuid _uuidInstance;
  late final List<MutableLayer<T>> _trees;
  late final LayerClusterer<T> _layerClusterer;

  late final String Function() generateUuid;
  int _cursor = 0;

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
  }) {
    if (generateUuid == null) {
      _uuidInstance = Uuid();
      this.generateUuid = () => _uuidInstance.v4();
    } else {
      this.generateUuid = generateUuid;
    }

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
        r: util.searchRadius(radius, extent, i),
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
    var elements = <RBushElement<MutableLayerElement<T>>>[];
    for (int i = 0; i < points.length; i++) {
      elements.add(_initializePointForAdding(points[i]).indexRBushPoint());
    }

    _trees[maxZoom + 1]
      ..clear()
      ..load(elements);

    // cluster points on max zoom, then cluster the results on previous zoom, etc.;
    // results in a cluster hierarchy across zoom levels
    for (var z = maxZoom; z >= minZoom; z--) {
      elements = _layerClusterer.cluster(elements, z, _trees[z], _trees[z + 1]);
      _trees[z].clear();
      _trees[z].load(elements);
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
  bool modifyPointData(
    T oldPoint,
    T newPoint, {
    bool updateParentClusters = true,
  }) {
    assert(
        getX(oldPoint) == getX(newPoint) && getY(oldPoint) == getY(newPoint));

    final oldLayerPoint = _trees[maxZoom + 1]
        .removePointWithoutClustering(_initializePointForMatching(oldPoint));

    if (oldLayerPoint == null) return false;

    final newLayerPoint = oldLayerPoint.data.copyWith(
      originalPoint: newPoint,
      clusterData: extractClusterData?.call(newPoint),
    );
    _trees[maxZoom + 1].addWithoutClustering(
      newLayerPoint.indexRBushPoint(),
      updateZooms: false,
    );

    final layerElementModifications = <LayerElementModification<T>>[
      LayerElementModification(
        layer: _trees[maxZoom + 1],
        oldLayerElement: oldLayerPoint.data,
        newLayerElement: newLayerPoint,
      ),
    ];

    final stopAtZoom = updateParentClusters
        ? minZoom
        : layerElementModifications.last.oldLayerElement.lowestZoom;

    for (int z = maxZoom; z >= stopAtZoom; z--) {
      layerElementModifications.add(
        _trees[z].modifyElementAndParents(layerElementModifications.last),
      );
    }

    return true;
  }

  @Deprecated(
    'Prefer `add`. '
    'This method has been changed to follow dart conventions. The implementation also now ensures full re-clustering, see the CHANGELOG for more information. '
    'This method is deprecated since v3.',
  )
  void insert(T point) => add(point);

  /// Add [point] to this supercluster. Note that this may cause clusters to be
  /// created/changed. If you have multiple points to add this may be slow, you
  /// should use [addAll] instead. Alternatively if you do not need to retain
  /// existing points use [load] which is faster than [addAll] but clears
  /// existing points.
  void add(T point) {
    final layerPoint = _initializePointForAdding(point).indexRBushPoint();
    _trees[maxZoom + 1].addWithoutClustering(layerPoint);

    // Add the point to each layer.
    for (int z = maxZoom; z >= minZoom; z--) {
      final newClusterElements = _layerClusterer.newClusterElements(
        layerPoint,
        _trees[z],
        _trees[z + 1],
      );
      if (newClusterElements.isNotEmpty) {
        // It clusters, stop looping and recreate the clusters.
        _recluster(z, newClusterElements);
        return;
      }

      // It doesn't cluster, just add.
      _trees[z].addWithoutClustering(layerPoint);
    }
  }

  /// Add [points] to this supercluster. This is much faster than [add] when
  /// adding many points but slower than [load]. If you do not need to retain
  /// existing points you should use [load] instead.
  void addAll(Iterable<T> points) {
    final layerPoints =
        points.map((p) => _initializePointForAdding(p).indexRBushPoint());
    final nonClusteringTree = _trees[maxZoom + 1];
    for (final point in layerPoints) {
      nonClusteringTree.addWithoutClustering(point);
    }

    _recluster(maxZoom, layerPoints);
  }

  /// Remove [point] from this supercluster. Returns true if the specified point
  /// is found and removed. Note that this may cause clusters to be
  /// split/changed. If you have multiple points to remove this may be slow, you
  /// should use [removeAll] instead. Alternatively if you want to remove all
  /// points the fastest way is to call [load] with an empty list.
  bool remove(T point) {
    final removed = _trees[maxZoom + 1]
        .removePointWithoutClustering(_initializePointForMatching(point));
    if (removed == null) return false;

    final ancestorRemovals = {
      for (var e in List.generate(
        _trees.length,
        (index) => (index, <RBushElement<MutableLayerElement<T>>>{}),
      ))
        e.$1: e.$2
    };
    ancestorRemovals[maxZoom + 1]!.add(removed);
    _removeAllAncestors(
      maxZoom,
      ancestorRemovals[maxZoom + 1]!,
      ancestorRemovals,
    );

    _recluster(maxZoom, [removed], ancestorRemovals: ancestorRemovals);

    return true;
  }

  /// Remove [points] from this supercluster. This is much faster than [remove]
  /// when removing many points. If you want to remove all points you should
  /// call [load] with an empty list as it is faster.
  bool removeAll(Iterable<T> points) {
    final removed = points
        .map((point) => _trees[maxZoom + 1]
            .removePointWithoutClustering(_initializePointForMatching(point)))
        .whereType<RBushElement<MutableLayerPoint<T>>>()
        .toList();
    if (removed.isEmpty) return false;

    final ancestorRemovals = {
      for (var e in List.generate(
        _trees.length,
        (index) => (index, <RBushElement<MutableLayerElement<T>>>{}),
      ))
        e.$1: e.$2
    };
    ancestorRemovals[maxZoom + 1]!.addAll(removed);
    _removeAllAncestors(
      maxZoom,
      ancestorRemovals[maxZoom + 1]!,
      ancestorRemovals,
    );

    _recluster(maxZoom, removed, ancestorRemovals: ancestorRemovals);

    return true;
  }

  void _recluster(
    int firstClusteringZoom,
    Iterable<RBushElement<MutableLayerElement<T>>> childLayerElements, {
    Map<int, Set<RBushElement<MutableLayerElement<T>>>>? ancestorRemovals,
  }) {
    ancestorRemovals ??= {
      for (var e in List.generate(
        _trees.length,
        (index) => (index, <RBushElement<MutableLayerElement<T>>>{}),
      ))
        e.$1: e.$2
    };

    var contiguousChildren = _trees[firstClusteringZoom + 1].visitContiguous(
      _trees[firstClusteringZoom].r,
      {...childLayerElements},
    );

    for (int z = firstClusteringZoom; z >= minZoom; z--) {
      final removed = _trees[z].removeAncestors(contiguousChildren);

      _removeAllAncestors(z - 1, removed, ancestorRemovals);

      final clustered = _layerClusterer.cluster(
        contiguousChildren,
        z,
        _trees[z],
        _trees[z + 1],
      );
      _trees[z].load(clustered);

      if (z > minZoom) {
        contiguousChildren = _trees[z].visitContiguous(
          _trees[z - 1].r,
          {
            ...ancestorRemovals[z]!,
            ...removed,
            ...clustered,
          },
        );
      }
    }
  }

  void _removeAllAncestors(
    int startZoom,
    RBushElementSet<T> descendants,
    Map<int, RBushElementSet<T>> removals,
  ) {
    for (int z = startZoom; z >= minZoom; z--) {
      if (descendants.isEmpty) break;
      descendants = _trees[z].removeAncestors(descendants);
      removals[z]!.addAll(descendants);
    }
  }

  @override
  bool containsPoint(T point) {
    return _trees[maxZoom + 1]
        .containsPoint(_initializePointForMatching(point));
  }

  @override
  MutableLayerCluster<T>? parentOf(LayerElement<T> element) {
    element as MutableLayerElement<T>;

    if (element.parentUuid == null) return null;

    final parentZoom = element.lowestZoom - 1;

    final parentTree = _trees[parentZoom];
    final searchRadius = parentTree.r;

    final potentialParents = _trees[parentZoom].search(
      RBushBox(
        minX: element.x - searchRadius,
        minY: element.y - searchRadius,
        maxX: element.x + searchRadius,
        maxY: element.y + searchRadius,
      ),
    );

    for (final potentialParent in potentialParents) {
      if (potentialParent.data.uuid == element.parentUuid) {
        return potentialParent.data as MutableLayerCluster<T>;
      }
    }

    return null;
  }

  @override
  MutableLayerPoint<T>? layerPointOf(T point) {
    return _trees[maxZoom + 1].layerPointOf(_initializePointForMatching(point));
  }

  @override
  List<MutableLayerElement<T>> childrenOf(LayerCluster<T> cluster) {
    cluster as MutableLayerCluster<T>;
    final r = _trees[cluster.highestZoom].r;

    return _trees[cluster.highestZoom + 1]
        .search(RBushBox(
          minX: cluster.originX - r,
          minY: cluster.originY - r,
          maxX: cluster.originX + r,
          maxY: cluster.originY + r,
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

  @override
  void replacePoints(List<T> newPoints) =>
      _trees[maxZoom + 1].replacePoints(newPoints);

  int _limitZoom(int zoom) {
    return max(minZoom, min(zoom, maxZoom + 1));
  }

  MutableLayerPoint<T> _initializePointForMatching(T originalPoint) =>
      MutableLayerElement.initializePoint(
        uuid: generateUuid(),
        point: originalPoint,
        index: -1,
        lon: getX(originalPoint),
        lat: getY(originalPoint),
        clusterData: extractClusterData?.call(originalPoint),
        zoom: maxZoom + 1,
      );

  MutableLayerPoint<T> _initializePointForAdding(T originalPoint) =>
      MutableLayerElement.initializePoint(
        uuid: generateUuid(),
        point: originalPoint,
        index: _cursor++,
        lon: getX(originalPoint),
        lat: getY(originalPoint),
        clusterData: extractClusterData?.call(originalPoint),
        zoom: maxZoom + 1,
      );

  @visibleForTesting
  MutableLayer<T> treeAt(int zoom) => _trees[zoom];
}

class ImmutableLayerRemoval {
  final bool isCluster;
  final String uuid;
  final String? parentUuid;
  final RBushPoint indexRBushPoint;

  ImmutableLayerRemoval.from(MutableLayerElement element)
      : isCluster = element is MutableLayerCluster,
        uuid = element.uuid,
        parentUuid = element.parentUuid,
        indexRBushPoint = element.indexRBushPoint();
}
