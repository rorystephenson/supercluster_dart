import 'dart:convert';
import 'dart:io';

import 'package:supercluster/supercluster.dart';
import 'package:test/test.dart';

import 'test_point.dart';

void main() {
  dynamic loadFixture(String name) => jsonDecode(
        File('test/$name').readAsStringSync(),
      );

  final features = List.castFrom<dynamic, Map<String, dynamic>>(
      loadFixture('places-old.json')['features']);

  int _compareFeatures(
          Map<String, dynamic> featureA, Map<String, dynamic> featureB) =>
      jsonEncode(featureA).compareTo(jsonEncode(featureB));

  SuperclusterMutable<Map<String, dynamic>> supercluster(
    List<Map<String, dynamic>> points, {
    ClusterDataBase Function(Map<String, dynamic> point)? extractClusterData,
    int? maxEntries,
    int? radius,
    int? extent,
    int? maxZoom,
  }) =>
      SuperclusterMutable<Map<String, dynamic>>(
        extractClusterData: extractClusterData,
        maxEntries: maxEntries ?? points.length,
        getX: (json) {
          return json['geometry']?['coordinates'][0].toDouble();
        },
        getY: (json) {
          return json['geometry']?['coordinates'][1].toDouble();
        },
        radius: radius,
        extent: extent,
        maxZoom: maxZoom,
      )..load(points);

  SuperclusterMutable<TestPoint> supercluster2(
    List<TestPoint> points, {
    int? maxEntries,
    int? radius,
    int? extent,
    int? maxZoom,
  }) =>
      SuperclusterMutable<TestPoint>(
        maxEntries: maxEntries ?? points.length,
        getX: TestPoint.getX,
        getY: TestPoint.getY,
        radius: radius,
        extent: extent,
        maxZoom: maxZoom,
      )..load(points);

  test('returns children of a cluster', () {
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

    print(index.trees.map((e) => '${e.zoom}: ${e.numPoints}').join(', '));
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
          .map((e) => (e as LayerPoint).originalPoint))
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
      print("Performing removal number ${i - start + 1}");

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
      65,
      100,
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

    print(index.trees.map((e) => '${e.zoom}: ${e.numPoints}').join(', '));
    for (final tree in index.trees) {
      expect(
        tree.numPoints,
        161,
        reason: 'Zoom ${tree.zoom} contains ${tree.numPoints}/162 points',
      );
    }

    final featuresInIndex = index.trees.last
        .all()
        .map((e) => (e as LayerPoint<Map<String, dynamic>>).originalPoint)
        .toList()
      ..sort(_compareFeatures);
    final expectation = features
      ..remove(features[10])
      ..sort(_compareFeatures);
    expect(featuresInIndex, equals(expectation));

    for (final tree in index.trees) {
      for (final layerElement in tree.all()) {
        expect(layerElement.numPoints,
            (layerElement.clusterData as TestClusterData).numPoints);
      }
    }
  });
}

class TestClusterData extends ClusterDataBase {
  final int numPoints;

  TestClusterData(this.numPoints);

  @override
  ClusterDataBase combine(covariant TestClusterData data) =>
      TestClusterData(numPoints + data.numPoints);
}
