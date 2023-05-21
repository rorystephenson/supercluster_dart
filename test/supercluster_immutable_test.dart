import 'package:compute/compute.dart';
import 'package:supercluster/supercluster.dart';
import 'package:test/test.dart';

import 'fixtures/fixtures.dart';
import 'test_point.dart';

void main() {
  SuperclusterImmutable<Map<String, dynamic>> supercluster(
    List<Map<String, dynamic>> points, {
    int? radius,
    int? extent,
    int? maxZoom,
  }) =>
      SuperclusterImmutable<Map<String, dynamic>>(
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

  SuperclusterImmutable<TestPoint> supercluster2(
          SuperclusterArgs superclusterArgs) =>
      SuperclusterImmutable<TestPoint>(
        getX: TestPoint.getX,
        getY: TestPoint.getY,
        minPoints: superclusterArgs.minPoints,
        radius: superclusterArgs.radius,
        extent: superclusterArgs.extent,
        maxZoom: superclusterArgs.maxZoom,
      )..load(superclusterArgs.points);

  List<ImmutableLayerElement<T>> layerElementsAtZoom<T>(
          SuperclusterImmutable<T> index, int zoom) =>
      index.search(-180, -90, 180, 90, zoom).toList();

  test('removes existing points when calling load()', () {
    final index = supercluster(Fixtures.features);
    index.load([]);
    expect(index.length, 0);
    expect(index.getLeaves(), isEmpty);
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
        await compute(supercluster2, SuperclusterArgs(points: testPoints));
    expect(index.getLeaves().any(testPoints.contains), isFalse);
    index.replacePoints(testPoints);
    expect(index.getLeaves().any((e) => !testPoints.contains(e)), isFalse);

    for (int i = index.minZoom; i <= index.maxZoom + 1; i++) {
      final pointsAtZoom = layerElementsAtZoom(index, i)
          .whereType<ImmutableLayerPoint<TestPoint>>();
      expect(pointsAtZoom.any((e) => !testPoints.contains(e.originalPoint)),
          isFalse);
    }
  });

  test('returns children of a cluster', () {
    final index = supercluster(Fixtures.features);
    final childCounts = index.childrenOf(163).map((p) => p.numPoints);
    expect(childCounts.toList(), equals([6, 7, 2, 1]));
  });

  test('returns leaves of a cluster', () {
    final index = supercluster(Fixtures.features);

    final leafNames = index
        .pointsWithin(163, limit: 10, offset: 5)
        .map((p) => Fixtures.features[p.index]['properties']['name'])
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
    final index = supercluster(Fixtures.features);
    expect(index.expansionZoomOf(163), 1);
    expect(index.expansionZoomOf(195), 1);
    expect(index.expansionZoomOf(580), 2);
    expect(index.expansionZoomOf(1156), 2);
    expect(index.expansionZoomOf(4133), 3);
  });

  test('returns cluster expansion zoom for maxZoom', () {
    final index = supercluster(
      Fixtures.features,
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
    final index = supercluster(Fixtures.features);
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

    expect(index.search(-180, -90, 180, 90, 20).length, 1);
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
