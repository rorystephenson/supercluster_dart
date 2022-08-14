import 'dart:convert';
import 'dart:io';

import 'package:supercluster/src/supercluster_mutable.dart';
import 'package:test/test.dart';

void main() {
  dynamic loadFixture(String name) => jsonDecode(
        File('test/$name').readAsStringSync(),
      );

  final features = List.castFrom<dynamic, Map<String, dynamic>>(
      loadFixture('places-old.json')['features']);

  SuperclusterMutable<Map<String, dynamic>> supercluster(
    List<Map<String, dynamic>> points, {
    int? maxEntries,
    int? radius,
    int? extent,
    int? maxZoom,
  }) =>
      SuperclusterMutable<Map<String, dynamic>>(
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

  test('returns children of a cluster', () {
    final index = supercluster(features);
    final pointCountsAtZooms = index.trees.map((e) => e.size).toList();
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
    final pointCountsAtZooms = index.trees.map((e) => e.size).toList();
    expect(pointCountsAtZooms, [
      32,
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

    print(index.trees.map((e) => '${e.zoom}: ${e.numPoints}').join(', '));
    for (final tree in index.trees) {
      expect(
        tree.numPoints,
        161,
        reason: 'Zoom ${tree.zoom} contains ${tree.numPoints}/162 points',
      );
    }
  });

  test('insertion', () {
    final index = supercluster(features);
    index.remove(features[10]);
    var pointsPerZoom = index.trees.map((e) => e.allPoints()).toList();
    expect(Set.from(pointsPerZoom.map((e) => e.length)).single, 161);
    index.insert(features[10]);
    pointsPerZoom = index.trees.map((e) => e.allPoints()).toList();
    expect(Set.from(pointsPerZoom.map((e) => e.length)).single, 162);

    final featuresSorted = List.from(features)
      ..sort((a, b) => jsonEncode(a).compareTo(jsonEncode(b)));

    for (int i = 0; i < pointsPerZoom.length; i++) {
      expect(
        pointsPerZoom[i].length,
        features.length,
        reason: 'Points at zoom $i should match the original points',
      );

      final sortedPoints = List.from(pointsPerZoom[i])
        ..sort((a, b) => jsonEncode(a).compareTo(jsonEncode(b)));
      expect(
        sortedPoints,
        featuresSorted,
        reason: 'Points at zoom $i should match the original points',
      );
    }
  });

/*
  test('returns leaves of a cluster', () {
    final index = supercluster(features);

    final leafNames = index
        .getLeaves(164, limit: 10, offset: 5)
        .map((p) => features[p.index]['properties']['name'])
        .toList();
    expect(
      leafNames,
      equals(
        [
          'Niagara Falls',
          'Cape San Blas',
          'Cape Sable',
          'Cape Canaveral',
          'San  Salvador',
          'Cabo Gracias a Dios',
          'I. de Cozumel',
          'Grand Cayman',
          'Miquelon',
          'Cape Bauld',
        ],
      ),
    );
  });
  test('returns cluster expansion zoom', () {
    final index = supercluster(features);
    expect(index.getClusterExpansionZoom(164), 1);
    expect(index.getClusterExpansionZoom(196), 1);
    expect(index.getClusterExpansionZoom(581), 2);
    expect(index.getClusterExpansionZoom(1157), 2);
    expect(index.getClusterExpansionZoom(4134), 3);
  });

  test('returns cluster expansion zoom for maxZoom', () {
    final index = supercluster(
      features,
      radius: 60,
      extent: 256,
      maxZoom: 4,
    );

    expect(index.getClusterExpansionZoom(2504), 5);
  });

  test('returns clusters when query crosses international dateline', () {
    final index = supercluster([
      {
        'type': 'Feature',
        'properties': null,
        'geometry': {
          'type': 'Point',
          'coordinates': [-178.989, 0]
        }
      },
      {
        'type': 'Feature',
        'properties': null,
        'geometry': {
          'type': 'Point',
          'coordinates': [-178.990, 0]
        }
      },
      {
        'type': 'Feature',
        'properties': null,
        'geometry': {
          'type': 'Point',
          'coordinates': [-178.991, 0]
        }
      },
      {
        'type': 'Feature',
        'properties': null,
        'geometry': {
          'type': 'Point',
          'coordinates': [-178.992, 0]
        }
      },
    ]);

    final nonCrossing = index.getClustersAndPoints(-179, -10, -177, 10, 1);
    final crossing = index.getClustersAndPoints(179, -10, -177, 10, 1);

    expect(nonCrossing, isNotEmpty);
    expect(crossing, isNotEmpty);
    expect(nonCrossing.length, crossing.length);
  });

  test('does not crash on weird bbox values', () {
    final index = supercluster(features);
    expect(
        index
            .getClustersAndPoints(
                129.426390, -103.720017, -445.930843, 114.518236, 1)
            .length,
        26);
    expect(
        index
            .getClustersAndPoints(
                112.207836, -84.578666, -463.149397, 120.169159, 1)
            .length,
        27);
    expect(
        index
            .getClustersAndPoints(
                129.886277, -82.332680, -445.470956, 120.390930, 1)
            .length,
        26);
    expect(
        index
            .getClustersAndPoints(
                458.220043, -84.239039, -117.137190, 120.206585, 1)
            .length,
        25);
    expect(
        index
            .getClustersAndPoints(
                456.713058, -80.354196, -118.644175, 120.539148, 1)
            .length,
        25);
    expect(
        index
            .getClustersAndPoints(
                453.105328, -75.857422, -122.251904, 120.732760, 1)
            .length,
        25);
    expect(index.getClustersAndPoints(-180, -90, 180, 90, 1).length, 61);
  });

  test('makes sure same-location points are clustered', () {
    final index = supercluster([
      {
        'type': 'Feature',
        'geometry': {
          'type': 'Point',
          'coordinates': [-1.426798, 53.943034]
        }
      },
      {
        'type': 'Feature',
        'geometry': {
          'type': 'Point',
          'coordinates': [-1.426798, 53.943034]
        }
      }
    ], maxZoom: 20, extent: 8192, radius: 16);

    expect(index.trees[20]!.length, 1);
  });
  */
}
