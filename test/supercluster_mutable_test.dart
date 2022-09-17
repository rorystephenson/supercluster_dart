import 'dart:convert';

import 'package:supercluster/supercluster.dart';
import 'package:test/test.dart';

import 'fixtures/fixtures.dart';
import 'test_point.dart';

void main() {
  int compareFeatures(
          Map<String, dynamic> featureA, Map<String, dynamic> featureB) =>
      jsonEncode(featureA).compareTo(jsonEncode(featureB));

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
        points: points,
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
      );

  SuperclusterMutable<TestPoint> supercluster2(
    List<TestPoint> points, {
    int? minPoints,
    int? maxEntries,
    int? radius,
    int? extent,
    int? maxZoom,
  }) =>
      SuperclusterMutable<TestPoint>(
        points: points,
        getX: TestPoint.getX,
        getY: TestPoint.getY,
        minPoints: minPoints,
        radius: radius,
        extent: extent,
        maxZoom: maxZoom,
      );

  test('clusters points', () {
    final index = supercluster(features);
    final pointCountsAtZooms = index.trees.map((e) => e.all().length).toList();
    expect(pointCountsAtZooms, [
      32,
      62,
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

  test('clusters points with a minimum cluster size', () {
    final index = supercluster(features, minPoints: 5);
    final pointCountsAtZooms = index.trees.map((e) => e.all().length).toList();
    expect(pointCountsAtZooms, [
      50,
      117,
      147,
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
  });

  test('removal', () {
    final index = supercluster(features);
    index.remove(features[10]);
    final pointCountsAtZooms = index.trees.map((e) => e.all().length).toList();
    expect(pointCountsAtZooms, [
      32,
      62,
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

    for (final tree in index.trees) {
      expect(
        tree.numPoints,
        161,
        reason: 'Zoom ${tree.zoom} contains ${tree.numPoints}/161 points',
      );
    }
  });

  test('insertion', () {
    final index = supercluster(features);
    index.remove(features[10]);
    var pointsPerZoom = index.trees.map((e) => e.numPoints).toList();
    expect(Set.from(pointsPerZoom).single, 161);
    index.insert(features[10]);
    pointsPerZoom = index.trees.map((e) => e.numPoints).toList();
    expect(Set.from(pointsPerZoom).single, 162);

    final featuresSorted = List.from(features)
      ..sort((a, b) => jsonEncode(a).compareTo(jsonEncode(b)));

    for (int i = 0; i < index.trees.length; i++) {
      expect(
        index.trees[i].numPoints,
        features.length,
        reason: 'Points at zoom $i should match the original points',
      );

      final sortedPoints = List.from(index.trees[index.maxZoom + 1]
          .all()
          .map((e) => (e as MutableLayerPoint).originalPoint))
        ..sort((a, b) => jsonEncode(a).compareTo(jsonEncode(b)));
      expect(
        sortedPoints,
        featuresSorted,
        reason: 'Points at zoom $i should match the original points',
      );
    }
  });

  test('nearby insertions', () {
    final index = supercluster2([
      TestPoint(longitude: 9.203368, latitude: 45.460982), // Milano
      TestPoint(longitude: 9.218777, latitude: 45.466276), // Milano east
      TestPoint(longitude: 9.507878, latitude: 45.303647), // Lodi
      TestPoint(longitude: 10.222456, latitude: 45.534990), // Brescia
      TestPoint(longitude: 10.419535, latitude: 45.511298), // Bedizzole
    ]);

    index.insert(TestPoint(latitude: 46.805213, longitude: 9.448094));
    index.insert(TestPoint(latitude: 46.775243, longitude: 9.711766));
    index.insert(TestPoint(latitude: 46.75637, longitude: 9.942479));

    final pointsPerZoom = index.trees.map((e) => e.numPoints).toSet();
    expect(pointsPerZoom.single, 8);
  });

  test('adds to existing cluster only, even if other points are nearby', () {
    final index = supercluster2([
      TestPoint(longitude: 9.203368, latitude: 45.460982), // Milano
      TestPoint(longitude: 9.218777, latitude: 45.466276), // Milano east
      TestPoint(longitude: 9.507878, latitude: 45.303647), // Lodi
      TestPoint(longitude: 10.222456, latitude: 45.534990), // Brescia
      TestPoint(longitude: 10.419535, latitude: 45.511298), // Bedizzole
    ]);

    index.insert(TestPoint(latitude: 45.00324, longitude: 9.753136));
    index.insert(TestPoint(latitude: 44.997413, longitude: 9.934411));
    index.insert(TestPoint(latitude: 44.884685, longitude: 9.753136));
    index.insert(TestPoint(latitude: 44.863244, longitude: 9.942651));
    index.insert(TestPoint(latitude: 44.943066, longitude: 9.845233));
    index.insert(TestPoint(latitude: 44.945982, longitude: 9.761462));
    index.insert(TestPoint(latitude: 44.999401, longitude: 9.847979));

    expect(index.trees.map((e) => e.numPoints).toSet().single, 12);
  });

  test('multiple removals and insertions (with cluster data)', () {
    final index = supercluster(features,
        extractClusterData: (point) => TestClusterData(1));

    final start = features.length ~/ 3;
    final removalTotal = features.length ~/ 2;

    for (int i = start; i < start + removalTotal; i++) {
      index.remove(features[i]);
      expect(
        index.trees.map((e) => e.numPoints).toSet().single,
        features.length - (i - start + 1),
      );
    }
    for (int i = start; i < start + removalTotal; i++) {
      index.insert(features[i]);
      expect(index.trees.map((e) => e.numPoints).toSet().single,
          features.length - removalTotal + (i - start + 1));
    }
    index.remove(features[10]);
    final pointCountsAtZooms = index.trees.map((e) => e.all().length).toList();
    expect(pointCountsAtZooms, [
      40,
      64,
      101,
      137,
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

    for (final tree in index.trees) {
      expect(
        tree.numPoints,
        161,
        reason: 'Zoom ${tree.zoom} contains ${tree.numPoints}/162 points',
      );
    }

    final featuresInIndex = index.trees.last
        .all()
        .map(
            (e) => (e as MutableLayerPoint<Map<String, dynamic>>).originalPoint)
        .toList()
      ..sort(compareFeatures);
    final expectation = List<Map<String, dynamic>>.from(features)
      ..remove(features[10])
      ..sort(compareFeatures);
    expect(featuresInIndex, equals(expectation));

    for (final tree in index.trees) {
      for (final layerElement in tree.all()) {
        expect(layerElement.numPoints,
            (layerElement.clusterData as TestClusterData).sum);
      }
    }
  });

  test('modify point data', () {
    final testPoints = List<TestPoint2>.unmodifiable(
        features.map(TestPoint2.fromFeature).toList());

    final index = SuperclusterMutable<TestPoint2>(
      points: testPoints,
      extractClusterData: (testPoint2) => TestClusterData(testPoint2.version),
      getX: (testPoint2) => testPoint2.longitude,
      getY: (testPoint2) => testPoint2.latitude,
    );

    final clusterDataPerLayer = index.trees
        .map((e) =>
            e.all().map((e) => (e.clusterData as TestClusterData).sum).toList()
              ..sort())
        .toList();

    final expectedLayerElementCounts = [
      32,
      62,
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

    final pointCountsAtZooms = index.trees.map((e) => e.all().length).toList();
    expect(pointCountsAtZooms, expectedLayerElementCounts);

    final modifiedPoint = testPoints[10].copyWithVersion(2);
    index.modifyPointData(testPoints[10], modifiedPoint);
    final pointCountsAtZoomsAfter =
        index.trees.map((e) => e.all().length).toList();
    expect(pointCountsAtZoomsAfter, expectedLayerElementCounts);
    final clusterDataPerLayerAfterModification = index.trees
        .map((e) =>
            e.all().map((e) => (e.clusterData as TestClusterData).sum).toList()
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

    expect(pointCountsAtZooms, expectedLayerElementCounts);

    index.modifyPointData(modifiedPoint, modifiedPoint.copyWithVersion(1));
    final pointCountsAtZoomsAfter2 =
        index.trees.map((e) => e.all().length).toList();
    expect(pointCountsAtZoomsAfter2, expectedLayerElementCounts);
    final clusterDataPerLayerAfterModification2 = index.trees
        .map((e) =>
            e.all().map((e) => (e.clusterData as TestClusterData).sum).toList()
              ..sort())
        .toList();

    expect(clusterDataPerLayer, equals(clusterDataPerLayerAfterModification2));
  });
}
