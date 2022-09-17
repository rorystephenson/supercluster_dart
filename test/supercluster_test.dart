import 'dart:math';

import 'package:supercluster/supercluster.dart';
import 'package:test/test.dart';
import 'package:timing/timing.dart';

import 'fixtures/fixtures.dart';
import 'test_point.dart';

void main() {
  SuperclusterImmutable<Map<String, dynamic>> supercluster(
          List<Map<String, dynamic>> points,
          {int? radius,
          int? extent,
          int? maxZoom}) =>
      SuperclusterImmutable<Map<String, dynamic>>(
        points: points,
        getX: (json) {
          return json['geometry']?['coordinates'][0].toDouble();
        },
        getY: (json) {
          return json['geometry']?['coordinates'][1].toDouble();
        },
        radius: radius,
        extent: extent,
        maxZoom: maxZoom,
      );

  test('returns children of a cluster', () {
    final index = supercluster(features);
    final childCounts = index.childrenOf(164).map((p) => p.numPoints);
    expect(childCounts.toList(), equals([6, 7, 2, 1]));
  });

  test('returns leaves of a cluster', () {
    final index = supercluster(features);

    final leafNames = index
        .pointsWithin(164, limit: 10, offset: 5)
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
    expect(index.expansionZoomOf(164), 1);
    expect(index.expansionZoomOf(196), 1);
    expect(index.expansionZoomOf(581), 2);
    expect(index.expansionZoomOf(1157), 2);
    expect(index.expansionZoomOf(4134), 3);
  });

  test('returns cluster expansion zoom for maxZoom', () {
    final index = supercluster(
      features,
      radius: 60,
      extent: 256,
      maxZoom: 4,
    );

    expect(index.expansionZoomOf(2504), 5);
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

    final nonCrossing = index.search(-179, -10, -177, 10, 1);
    final crossing = index.search(179, -10, -177, 10, 1);

    expect(nonCrossing, isNotEmpty);
    expect(crossing, isNotEmpty);
    expect(nonCrossing.length, crossing.length);
  });

  test('does not crash on weird bbox values', () {
    final index = supercluster(features);
    expect(
        index
            .search(129.426390, -103.720017, -445.930843, 114.518236, 1)
            .length,
        26);
    expect(
        index.search(112.207836, -84.578666, -463.149397, 120.169159, 1).length,
        27);
    expect(
        index.search(129.886277, -82.332680, -445.470956, 120.390930, 1).length,
        26);
    expect(
        index.search(458.220043, -84.239039, -117.137190, 120.206585, 1).length,
        25);
    expect(
        index.search(456.713058, -80.354196, -118.644175, 120.539148, 1).length,
        25);
    expect(
        index.search(453.105328, -75.857422, -122.251904, 120.732760, 1).length,
        25);
    expect(index.search(-180, -90, 180, 90, 1).length, 61);
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

  test('clustering many points', () {
    final random = Random(42);

    print('Generating test points');
    final testPoints = List<TestPoint>.generate(
      10000,
      (_) => TestPoint(
        longitude: (random.nextDouble() * 360) - 180,
        latitude: (random.nextDouble() * 180) - 90,
      ),
    );

    print('Building clusters');
    final tracker = SyncTimeTracker();
    tracker.track(
      () => SuperclusterImmutable(
        points: testPoints,
        getX: TestPoint.getX,
        getY: TestPoint.getY,
        minPoints: 1,
      ),
    );
    print('Clusters built, took: ${tracker.duration}');
  });
}
