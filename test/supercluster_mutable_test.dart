import 'dart:convert';

import 'package:compute/compute.dart';
import 'package:quiver/iterables.dart';
import 'package:supercluster/src/uuid_stub.dart';
import 'package:supercluster/supercluster.dart';
import 'package:test/test.dart';

import 'fixtures/fixtures.dart';
import 'fixtures/osm_dense_data.dart';
import 'test_point.dart';
import 'validate_mutable_supercluster.dart';

void main() {
  int compareFeatures(
          Map<String, dynamic> featureA, Map<String, dynamic> featureB) =>
      jsonEncode(featureA).compareTo(jsonEncode(featureB));

  List<MutableLayerElement<T>> layerElementsAtZoom<T>(
          SuperclusterMutable<T> index, int zoom) =>
      index.search(-180, -90, 180, 90, zoom).toList();

  List<List<MutableLayerElement<T>>> layerElementsAtZooms<T>(
      SuperclusterMutable<T> index) {
    final result = <List<MutableLayerElement<T>>>[];
    for (int i = index.minZoom; i <= index.maxZoom + 1; i++) {
      result.add(index.search(-180, -90, 180, 90, i).toList());
    }
    return result;
  }

  List<int> pointCountsAtZooms(SuperclusterMutable index) {
    final result = <int>[];
    for (int i = index.minZoom; i <= index.maxZoom + 1; i++) {
      result.add(layerElementsAtZoom(index, i).length);
    }
    return result;
  }

  int numPointsAtZoom(SuperclusterMutable index, int zoom) {
    return layerElementsAtZoom(index, zoom).fold(
      0,
      (previousValue, element) => previousValue + element.numPoints,
    );
  }

  List<int> numPointsAtZooms(SuperclusterMutable index) {
    final result = <int>[];
    for (int i = index.minZoom; i <= index.maxZoom + 1; i++) {
      result.add(numPointsAtZoom(index, i));
    }
    return result;
  }

  SuperclusterMutable<Map<String, dynamic>> supercluster(
    List<Map<String, dynamic>> points, {
    ClusterDataBase Function(Map<String, dynamic> point)? extractClusterData,
    int? minPoints,
    int? maxEntries,
    int? radius,
    int? extent,
    int? maxZoom,
  }) =>
      SuperclusterMutable<Map<String, dynamic>>(
        extractClusterData: extractClusterData,
        getX: (json) {
          return json['geometry']?['coordinates'][0].toDouble();
        },
        getY: (json) {
          return json['geometry']?['coordinates'][1].toDouble();
        },
        minPoints: minPoints,
        radius: radius,
        extent: extent,
        maxZoom: maxZoom,
      )..load(points);

  SuperclusterMutable<TestPoint> supercluster2(
    List<TestPoint> points, {
    int? minPoints,
    int? maxEntries,
    int? radius,
    int? extent,
    int? maxZoom,
  }) =>
      SuperclusterMutable<TestPoint>(
        getX: TestPoint.getX,
        getY: TestPoint.getY,
        minPoints: minPoints,
        radius: radius,
        extent: extent,
        maxZoom: maxZoom,
      )..load(points);

  SuperclusterMutable<TestPoint> supercluster3(
          SuperclusterArgs superclusterArgs) =>
      SuperclusterMutable<TestPoint>(
        getX: TestPoint.getX,
        getY: TestPoint.getY,
        minPoints: superclusterArgs.minPoints,
        radius: superclusterArgs.radius,
        extent: superclusterArgs.extent,
        maxZoom: superclusterArgs.maxZoom,
      )..load(superclusterArgs.points);

  test('clusters points', () {
    final index = supercluster(Fixtures.features);
    expect(pointCountsAtZooms(index), [
      32,
      61,
      100,
      137,
      149,
      159,
      162,
      162,
      162,
      162,
      162,
      162,
      162,
      162,
      162,
      162,
      162,
      162
    ]);
  });

  test('removes existing points when calling load()', () {
    final index = supercluster(Fixtures.features);
    index.load([]);
    expect(numPointsAtZoom(index, index.maxZoom), 0);

    validateMutableSupercluster(index);
  });

  test('replacePoints', () async {
    final testPoints = [
      TestPoint(longitude: 9.203368, latitude: 45.460982), // Milano
      TestPoint(longitude: 9.218777, latitude: 45.466276), // Milano east
      TestPoint(longitude: 9.507878, latitude: 45.303647), // Lodi
      TestPoint(longitude: 10.222456, latitude: 45.534990), // Brescia
      TestPoint(longitude: 10.419535, latitude: 45.511298), // Bedizzole
    ];
    final index =
        await compute(supercluster3, SuperclusterArgs(points: testPoints));
    expect(index.getLeaves().any(testPoints.contains), isFalse);
    index.replacePoints(testPoints);
    expect(index.getLeaves().any((e) => !testPoints.contains(e)), isFalse);

    for (int i = index.minZoom; i <= index.maxZoom + 1; i++) {
      final pointsAtZoom = layerElementsAtZoom(index, i)
          .whereType<MutableLayerPoint<TestPoint>>();
      expect(pointsAtZoom.any((e) => !testPoints.contains(e.originalPoint)),
          isFalse);
    }
    validateMutableSupercluster(index);
  });

  test('clusters points with a minimum cluster size', () {
    final index = supercluster(Fixtures.features, minPoints: 5);
    expect(pointCountsAtZooms(index), [
      47,
      117,
      145,
      151,
      162,
      162,
      162,
      162,
      162,
      162,
      162,
      162,
      162,
      162,
      162,
      162,
      162,
      162
    ]);
    validateMutableSupercluster(index);
  });

  test('removal', () {
    final index = supercluster(Fixtures.features);
    index.remove(Fixtures.features[10]);
    expect(pointCountsAtZooms(index), [
      34,
      61,
      99,
      136,
      148,
      158,
      161,
      161,
      161,
      161,
      161,
      161,
      161,
      161,
      161,
      161,
      161,
      161
    ]);

    for (int i = index.minZoom; i <= index.maxZoom; i++) {
      final numPoints = numPointsAtZoom(index, i);
      expect(
        numPoints,
        161,
        reason: 'Zoom $i contains $numPoints/161 points',
      );
    }

    validateMutableSupercluster(index);
  });

  test('add and remove point near a cluster', () {
    final points = [
      (53.3498, -6.2603),
      (53.3488, -6.2613),
    ];

    final index = SuperclusterMutable<(double, double)>(
      extractClusterData: (point) => TestClusterData(1),
      radius: 80,
      getX: (point) => point.$1,
      getY: (point) => point.$2,
    )..load(points);

    final thirdPoint = (53.347312, -6.24508);

    expect(numPointsAtZooms(index).toSet().single, 2);
    expect(layerElementsAtZoom(index, 15).length, 1);
    expect(layerElementsAtZoom(index, 14).length, 1);
    final originalCluster =
        layerElementsAtZoom(index, 14).single as MutableLayerCluster;
    expect(originalCluster.lowestZoom, 0);
    expect(originalCluster.highestZoom, 15);

    index.add(thirdPoint);
    expect(numPointsAtZooms(index).toSet().single, 3);
    expect(layerElementsAtZoom(index, 16).length, 3);
    expect(layerElementsAtZoom(index, 15).length, 2);
    expect(layerElementsAtZoom(index, 14).length, 2);
    expect(layerElementsAtZoom(index, 13).length, 2);
    expect(layerElementsAtZoom(index, 12).length, 2);
    expect(layerElementsAtZoom(index, 11).length, 1);
    final originalClusterB =
        layerElementsAtZoom(index, 14).whereType<MutableLayerCluster>().single;
    expect(originalClusterB.highestZoom, 15);
    expect(originalClusterB.lowestZoom, 12);

    index.remove(thirdPoint);
    expect(numPointsAtZooms(index).toSet().single, 2);
    expect(layerElementsAtZoom(index, 16).length, 2);
    expect(layerElementsAtZoom(index, 15).length, 1);
    expect(layerElementsAtZoom(index, 14).length, 1);
    final newCluster =
        layerElementsAtZoom(index, 14).single as MutableLayerCluster;
    expect(newCluster.lowestZoom, 0);
    expect(newCluster.highestZoom, 15);

    validateMutableSupercluster(index);
  });

  test('addition', () {
    final index = supercluster(Fixtures.features);

    index.remove(Fixtures.features[10]);
    var pointsPerZoom = numPointsAtZooms(index);
    expect(Set.from(pointsPerZoom).single, 161);

    index.add(Fixtures.features[10]);
    pointsPerZoom = numPointsAtZooms(index);
    expect(Set.from(pointsPerZoom).single, 162);

    final featuresSorted = List.from(Fixtures.features)
      ..sort((a, b) => jsonEncode(a).compareTo(jsonEncode(b)));

    for (int i = index.minZoom; i <= index.maxZoom; i++) {
      final numPoints = numPointsAtZoom(index, i);
      expect(
        numPoints,
        Fixtures.features.length,
        reason: 'Points at zoom $i should match the original points',
      );
    }

    final sortedPoints = List.from(layerElementsAtZoom(index, index.maxZoom + 1)
        .map((e) => (e as MutableLayerPoint).originalPoint))
      ..sort((a, b) => jsonEncode(a).compareTo(jsonEncode(b)));
    expect(
      sortedPoints,
      featuresSorted,
      reason: 'Points should match the original points',
    );

    validateMutableSupercluster(index);
  });

  test('nearby additions', () {
    final index = supercluster2([
      TestPoint(longitude: 9.203368, latitude: 45.460982), // Milano
      TestPoint(longitude: 9.218777, latitude: 45.466276), // Milano east
      TestPoint(longitude: 9.507878, latitude: 45.303647), // Lodi
      TestPoint(longitude: 10.222456, latitude: 45.534990), // Brescia
      TestPoint(longitude: 10.419535, latitude: 45.511298), // Bedizzole
    ]);

    index.add(TestPoint(latitude: 46.805213, longitude: 9.448094));
    validateMutableSupercluster(index);
    index.add(TestPoint(latitude: 46.775243, longitude: 9.711766));
    validateMutableSupercluster(index);
    index.add(TestPoint(latitude: 46.75637, longitude: 9.942479));
    validateMutableSupercluster(index);

    final pointsPerZoom = numPointsAtZooms(index).toSet();
    expect(pointsPerZoom.single, 8);
  });

  test('adds to existing cluster only, even if other points are nearby', () {
    final index = SuperclusterMutable<(double, double)>(
      getX: (point) => point.$2,
      getY: (point) => point.$1,
    );

    final additions = [
      (45.00324, 9.753136),
      (44.997413, 9.934411),
      (44.884685, 9.753136),
      (44.863244, 9.942651),
      (44.943066, 9.845233),
      (44.945982, 9.761462),
      (44.999401, 9.847979),
    ];

    for (final addition in additions) {
      index.add(addition);
      validateMutableSupercluster(index);
    }

    expect(numPointsAtZooms(index).toSet().single, 7);
  });

  test('modify point data', () {
    final testPoints = List<TestPoint2>.unmodifiable(
        Fixtures.features.map(TestPoint2.fromFeature).toList());

    final index = SuperclusterMutable<TestPoint2>(
      extractClusterData: (testPoint2) => TestClusterData(testPoint2.version),
      getX: (testPoint2) => testPoint2.longitude,
      getY: (testPoint2) => testPoint2.latitude,
    )..load(testPoints);

    final clusterDataPerLayer = layerElementsAtZooms(index)
        .map((e) =>
            e.map((e) => (e.clusterData as TestClusterData).sum).toList()
              ..sort())
        .toList();

    final expectedLayerElementCounts = [
      32,
      61,
      100,
      137,
      149,
      159,
      162,
      162,
      162,
      162,
      162,
      162,
      162,
      162,
      162,
      162,
      162,
      162
    ];

    expect(pointCountsAtZooms(index), expectedLayerElementCounts);

    final modifiedPoint = testPoints[10].copyWithVersion(2);
    index.modifyPointData(testPoints[10], modifiedPoint);
    final pointCountsAtZoomsAfter = pointCountsAtZooms(index);
    expect(pointCountsAtZoomsAfter, expectedLayerElementCounts);
    final clusterDataPerLayerAfterModification = layerElementsAtZooms(index)
        .map((e) =>
            e.map((e) => (e.clusterData as TestClusterData).sum).toList()
              ..sort())
        .toList();

    for (int i = clusterDataPerLayer.length - 1; i >= 0; i--) {
      int differences = 0;

      for (int j = 0; j < clusterDataPerLayer[i].length; j++) {
        final left = clusterDataPerLayer[i][j];
        final right = clusterDataPerLayerAfterModification[i][j];
        if (left == right) continue;
        expect(left, right - 1);
        differences++;
      }

      expect(differences, 1, reason: 'Expected 1 difference at zoom $i');
    }

    expect(pointCountsAtZooms(index), expectedLayerElementCounts);

    index.modifyPointData(modifiedPoint, modifiedPoint.copyWithVersion(1));
    final pointCountsAtZoomsAfter2 = pointCountsAtZooms(index);
    expect(pointCountsAtZoomsAfter2, expectedLayerElementCounts);
    final clusterDataPerLayerAfterModification2 = layerElementsAtZooms(index)
        .map((e) =>
            e.map((e) => (e.clusterData as TestClusterData).sum).toList()
              ..sort())
        .toList();

    expect(clusterDataPerLayer, equals(clusterDataPerLayerAfterModification2));
  });

  test('contains', () {
    final index = supercluster(Fixtures.features);
    for (final feature in Fixtures.features) {
      expect(index.containsPoint(feature), isTrue);
    }

    var feature = Map<String, dynamic>.from(Fixtures.features.first);
    feature['properties']['name'] = 'Changed name';
    expect(index.containsPoint(feature), isFalse);

    feature = Map<String, dynamic>.from(Fixtures.features.first);
    feature['geometry']['coordinates'][0] =
        feature['geometry']['coordinates'][0] + 1;
    expect(index.containsPoint(feature), isFalse);
  });

  test('one-by-one additions', () {
    final points = <(double, double)>[
      (45.44088, 12.328761),
      (45.440444, 12.337212),
      (45.440539, 12.337038),
      (45.438299, 12.323898),
      (45.437132, 12.32746),
    ];

    final index = SuperclusterMutable<(double, double)>(
      getX: (p) => p.$2,
      getY: (p) => p.$1,
      minZoom: 0,
      maxZoom: 20,
      radius: 120,
      extent: 512,
      nodeSize: 64,
      generateUuid: UuidStub.v4,
    );
    for (final point in points) {
      index.add(point);
      validateMutableSupercluster(index);
    }
  });

  test('one-by-one additions with minimum 3 points in cluster ', () {
    final points = <(double, double)>[
      (45.44088, 12.328761),
      (45.440444, 12.337212),
      (45.440539, 12.337038),
      (45.438299, 12.323898),
      (45.437132, 12.32746),
    ];

    final index = SuperclusterMutable<(double, double)>(
      getX: (p) => p.$2,
      getY: (p) => p.$1,
      minPoints: 3,
      minZoom: 0,
      maxZoom: 20,
      radius: 120,
      extent: 512,
      nodeSize: 64,
      generateUuid: UuidStub.v4,
    );
    for (final point in points) {
      index.add(point);
      validateMutableSupercluster(index);
    }
  });

  test('one-by-one additions, addition causes cluster split', () {
    final points = [
      (45.4369075, 12.3374054),
      (45.4368017, 12.3362103),
      (45.436185, 12.3375696),
      (45.436155, 12.3376235),
      (45.4361239, 12.3376788),
      (45.4368294, 12.3357726),
    ];

    final index = SuperclusterMutable<(double, double)>(
      getX: (p) => p.$2,
      getY: (p) => p.$1,
      minZoom: 0,
      maxZoom: 20,
      radius: 120,
      extent: 512,
      nodeSize: 64,
      generateUuid: UuidStub.v4,
    );
    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      index.add(point);
      validateMutableSupercluster(index);
    }
  });

  test('addition forms cluster at lowest zoom', () {
    final points = [
      (-43.5404025683706, 146.03379804609568),
      (-22.702080987505923, 150.81116783945873),
      (-14.163506768755923, 144.50660240977123),
    ];
    final supercluster = SuperclusterMutable<(double, double)>(
      getX: (p) => p.$2,
      getY: (p) => p.$1,
      generateUuid: UuidStub.v4,
    );

    for (final point in points) {
      supercluster.add(point);
      validateMutableSupercluster(supercluster);
    }
  });

  test('addition causes ancestor to cluster at a lower zoom', () {
    final points = <(double, double)>[
      (45.4408672, 12.3305263),
      (45.4402445, 12.3319059),
      (45.4409002, 12.3278475),
      (45.4405388, 12.327191),
    ];

    final index = SuperclusterMutable<(double, double)>(
      getX: (p) => p.$2,
      getY: (p) => p.$1,
      generateUuid: UuidStub.v4,
    );
    for (final point in points) {
      index.add(point);
      validateMutableSupercluster(index);
    }
  });

  test('many one-by-one addition of dense points with addAll', () {
    final supercluster = SuperclusterMutable<(double, double)>(
      getX: (p) => p.$2,
      getY: (p) => p.$1,
      generateUuid: UuidStub.v4,
    );

    supercluster.addAll(osmDenseData);
    validateMutableSupercluster(supercluster);
  });

  test('many one-by-one addition of dense points with grouped addAll', () {
    final supercluster = SuperclusterMutable<(double, double)>(
      getX: (p) => p.$2,
      getY: (p) => p.$1,
      generateUuid: UuidStub.v4,
    );

    final partitions = partition(osmDenseData, 100);

    int added = 0;
    for (final partition in partitions) {
      supercluster.addAll(partition);
      added += partition.length;
      validateMutableSupercluster(supercluster, expectedPoints: added);
    }
  });

  test('many one-by-one removals of dense points with grouped removeAll', () {
    final supercluster = SuperclusterMutable<(double, double)>(
      getX: (p) => p.$2,
      getY: (p) => p.$1,
      generateUuid: UuidStub.v4,
    )..load(osmDenseData);

    final partitions = partition(osmDenseData, 100);

    int removed = 0;
    for (final partition in partitions) {
      supercluster.removeAll(partition);
      removed += partition.length;
      validateMutableSupercluster(
        supercluster,
        expectedPoints: osmDenseData.length - removed,
      );
    }
  });

  test('many one-by-one additions with dense points', () {
    final supercluster = SuperclusterMutable<(double, double)>(
      getX: (p) => p.$2,
      getY: (p) => p.$1,
      generateUuid: UuidStub.v4,
    );

    for (final point in osmDenseData) {
      supercluster.add(point);
      validateMutableSupercluster(supercluster);
    }
  }, tags: 'slow');

  test('many one-by-one removals with dense points', () {
    final supercluster = SuperclusterMutable<(double, double)>(
      getX: (p) => p.$2,
      getY: (p) => p.$1,
      generateUuid: UuidStub.v4,
    )..load(osmDenseData);

    int removed = 0;
    for (final point in osmDenseData) {
      supercluster.remove(point);
      removed += 1;
      expect(
        numPointsAtZooms(supercluster).toSet().single,
        osmDenseData.length - removed,
      );
      validateMutableSupercluster(supercluster);
    }
  }, tags: 'slow');

  test(
      'dense points have a similar number of clusters if loaded or added one by one',
      () {
    final superclusterLoaded = SuperclusterMutable<(double, double)>(
      getX: (p) => p.$2,
      getY: (p) => p.$1,
      generateUuid: UuidStub.v4,
    )..load(osmDenseData);

    final superclusterAdded = SuperclusterMutable<(double, double)>(
      getX: (p) => p.$2,
      getY: (p) => p.$1,
      generateUuid: UuidStub.v4,
    );

    for (final point in osmDenseData) {
      superclusterAdded.add(point);
    }

    for (int z = superclusterLoaded.maxZoom;
        z >= superclusterLoaded.minZoom;
        z--) {}
    expect(
      layerElementsAtZooms(superclusterLoaded).map((e) => e.length),
      [
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        2,
        7,
        22,
        82,
        272,
        1481,
      ],
    );
    expect(
      layerElementsAtZooms(superclusterAdded).map((e) => e.length),
      [
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        2,
        7,
        26,
        91,
        282,
        1481,
      ],
    );
  }, tags: 'slow');

  test('multiple removals and additions (with cluster data)', () {
    final index = supercluster(
      Fixtures.features,
      extractClusterData: (point) => TestClusterData(1),
    );

    final start = Fixtures.features.length ~/ 3;
    final removalTotal = Fixtures.features.length ~/ 2;

    for (int i = start; i < start + removalTotal; i++) {
      index.remove(Fixtures.features[i]);
      expect(
        numPointsAtZooms(index).toSet().single,
        Fixtures.features.length - (i - start + 1),
      );
      validateMutableSupercluster(index);
    }
    for (int i = start; i < start + removalTotal; i++) {
      index.add(Fixtures.features[i]);
      expect(numPointsAtZooms(index).toSet().single,
          Fixtures.features.length - removalTotal + (i - start + 1));
      validateMutableSupercluster(index);
    }
    index.remove(Fixtures.features[10]);
    expect(pointCountsAtZooms(index), [
      31,
      59,
      98,
      136,
      148,
      158,
      161,
      161,
      161,
      161,
      161,
      161,
      161,
      161,
      161,
      161,
      161,
      161,
    ]);
    validateMutableSupercluster(index);

    for (int i = index.minZoom; i <= index.maxZoom + 1; i++) {
      final numPoints = numPointsAtZoom(index, i);
      expect(
        numPoints,
        161,
        reason: 'Zoom $i contains $numPoints/162 points',
      );
    }

    final featuresInIndex = index.points..sort(compareFeatures);
    final expectation = List<Map<String, dynamic>>.from(Fixtures.features)
      ..remove(Fixtures.features[10])
      ..sort(compareFeatures);
    expect(featuresInIndex, equals(expectation));

    for (int i = index.minZoom; i <= index.maxZoom + 1; i++) {
      for (final layerElement in layerElementsAtZoom(index, i)) {
        expect(
          layerElement.numPoints,
          (layerElement.clusterData as TestClusterData).sum,
        );
      }
    }
  }, tags: 'slow');
}

class SuperclusterArgs {
  final List<TestPoint> points;
  final int? minPoints;
  final int? maxEntries;
  final int? radius;
  final int? extent;
  final int? maxZoom;

  SuperclusterArgs({
    required this.points,
    this.minPoints,
    this.maxEntries,
    this.radius,
    this.extent,
    this.maxZoom,
  });
}
