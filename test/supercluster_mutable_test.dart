import 'dart:convert';

import 'package:supercluster/supercluster.dart';
import 'package:test/test.dart';

import 'fixtures/fixtures.dart';
import 'test_point.dart';

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

  test('clusters points', () {
    final index = supercluster(Fixtures.features);
    expect(pointCountsAtZooms(index), [
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

  test('removes existing points when calling load()', () {
    final index = supercluster(Fixtures.features);
    index.load([]);
    expect(numPointsAtZoom(index, index.maxZoom), 0);
  });

  test('clusters points with a minimum cluster size', () {
    final index = supercluster(Fixtures.features, minPoints: 5);
    expect(pointCountsAtZooms(index), [
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
    final index = supercluster(Fixtures.features);
    index.remove(Fixtures.features[10]);
    expect(pointCountsAtZooms(index), [
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

    for (int i = index.minZoom; i <= index.maxZoom; i++) {
      final numPoints = numPointsAtZoom(index, i);
      expect(
        numPoints,
        161,
        reason: 'Zoom $i contains $numPoints/161 points',
      );
    }
  });

  test('insertion', () {
    final index = supercluster(Fixtures.features);

    index.remove(Fixtures.features[10]);
    var pointsPerZoom = numPointsAtZooms(index);
    expect(Set.from(pointsPerZoom).single, 161);

    index.insert(Fixtures.features[10]);
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

    final pointsPerZoom = numPointsAtZooms(index).toSet();
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

    expect(numPointsAtZooms(index).toSet().single, 12);
  });

  test('multiple removals and insertions (with cluster data)', () {
    final index = supercluster(Fixtures.features,
        extractClusterData: (point) => TestClusterData(1));

    final start = Fixtures.features.length ~/ 3;
    final removalTotal = Fixtures.features.length ~/ 2;

    for (int i = start; i < start + removalTotal; i++) {
      index.remove(Fixtures.features[i]);
      expect(
        numPointsAtZooms(index).toSet().single,
        Fixtures.features.length - (i - start + 1),
      );
    }
    for (int i = start; i < start + removalTotal; i++) {
      index.insert(Fixtures.features[i]);
      expect(numPointsAtZooms(index).toSet().single,
          Fixtures.features.length - removalTotal + (i - start + 1));
    }
    index.remove(Fixtures.features[10]);
    expect(pointCountsAtZooms(index), [
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
      expect(index.contains(feature), isTrue);
    }

    var feature = Map<String, dynamic>.from(Fixtures.features.first);
    feature['properties']['name'] = 'Changed name';
    expect(index.contains(feature), isFalse);

    feature = Map<String, dynamic>.from(Fixtures.features.first);
    feature['geometry']['coordinates'][0] =
        feature['geometry']['coordinates'][0] + 1;
    expect(index.contains(feature), isFalse);
  });
}
